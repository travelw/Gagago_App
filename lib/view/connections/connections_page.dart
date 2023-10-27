import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/no_connection_found_screen.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/connection_remove_model.dart';
import 'package:gagagonew/model/connection_response_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/chat/chat_message_screen.dart';
import 'package:gagagonew/view/home/setting_page.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../CommonWidgets/common_back_button.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../model/readNotificationResponse.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({Key? key}) : super(key: key);

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  bool isLoading = false;
  List<Travel> travelUserList = [];
  List<MeetMatch> meetMatchList = [];
  List<MeetMatch> meetNewMatchList = [];
  List<Userdestinations> destinationList = [];
  List<Interest> interestList = [];
  List<UserProfile> userImageList = [];
  int? travelCount, meetCount;
  int meetNewCount = 0;

  String accessToken = "";
  String latitude = "";
  String longitude = "";
  String userId = "";
  AppStreamController appStreamController = AppStreamController.instance;

  bool IsVisble = false;

  @override
  void initState() {
    super.initState();
    appStreamController.updateBadgesCount.add(BadgesCountModel(likeCount: 0));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // hitReadConnectionApi(type: 'like', showLoader:false);
    });
    init();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // setState(() {
    //   askToPermission();
    // });
    // });
  }

  void hitReadConnectionApi({required String type, bool showLoader = true}) async {
    print("hitReadConnectionApi -->");
    ReadNotification model = await CallService().readNotification(context, type: type, showLoader: showLoader);
    print("Model ${model.status}");
    if (model.status = true) {
      appStreamController.updateBadgesCount.add(BadgesCountModel(likeCount: 0));
    }
  }

  initSocket() async {
    io.Socket? socket;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    socket = io.io(
      CallService.socketUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      },
    );
    socket.connect();
    socket.emit('getNewConnectionNotification', {'login_user_id': userId});
  }

  init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      hitReadConnectionApi(type: 'like', showLoader: false);

      ConnectionsResponseModel model = await CallService().getConnectionsList();
      setState(() {
        isLoading = false;
        travelUserList = model.travel!;
        travelCount = model.travelCount;
        meetMatchList = model.meetMatch!;
        meetCount = model.meetCount;

        meetNewMatchList = meetMatchList;
        meetNewCount = meetCount!;

        debugPrint("TravelCount $travelCount");
        debugPrint("MeetCount $meetCount");
      });
      getNewCurrentLocation(meetMatchList, meetCount!, true, showLoader: false);
    });
  }

  void getCurrentLocation(List<MeetMatch> meetMatchList, int meetCount, {bool showLoader = false}) async {
    if (await Permission.location.isGranted) {
      var position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      setState(() {
        debugPrint("HomePage lat=====>${position.latitude}");
        debugPrint("HomePage long=====>${position.longitude}");
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
        setState(() {
          selectTab = false;
          meetNewMatchList = meetMatchList;
          meetNewCount = meetCount;
        });
        if (latitude.isNotEmpty && longitude.isNotEmpty) {
          var map = <String, dynamic>{};
          map['lat'] = latitude;
          map['lng'] = longitude;
          debugPrint("updateLocation map $map");
          CallService().updateLocation(map, showLoader: showLoader);
        }
      });
    } else {
      await [
        Permission.location,
      ].request();
      getCurrentLocation(meetMatchList, meetCount);
    }
  }

  void getNewCurrentLocation(List<MeetMatch> meetMatchList, int meetCount, bool select, {bool showLoader = true}) async {
    if (await Permission.location.isGranted) {
      if (showLoader) {
        CommonDialog.showLoading();
      }
      var position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      setState(() {
        debugPrint("HomePage lat=====>${position.latitude}");
        debugPrint("HomePage long=====>${position.longitude}");
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
        selectTab = select;
        meetNewMatchList = meetMatchList;
        meetNewCount = meetCount;
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        if (latitude.isNotEmpty && longitude.isNotEmpty) {
          var map = <String, dynamic>{};
          map['lat'] = latitude;
          map['lng'] = longitude;
          debugPrint("updateLocation map $map");

          CallService().updateLocation(map, showLoader: showLoader);
        }
      });
    }
  }

  bool selectTab = true;

  void bottomSheet(param0, int index, {required String commonInterest}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
        margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
        height: Get.height * 0.4,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
              width: Get.width,
              height: Get.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Get.height * 0.015,
                  ),
                  Column(
                    children: [
                      selectTab == true
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              backgroundImage: travelUserList[index].userProfile!.isNotEmpty
                                  ? (NetworkImage(travelUserList[index].userProfile![0].imageName.toString()))
                                  : Image.asset(
                                      'assets/images/png/dummypic.png',
                                    ).image,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              backgroundImage: meetNewMatchList[index].userProfile!.isNotEmpty
                                  ? (NetworkImage(meetNewMatchList[index].userProfile![0].imageName.toString()))
                                  : Image.asset(
                                      'assets/images/png/dummypic.png',
                                    ).image,
                            ),
                      SizedBox(
                        height: Get.height * 0.010,
                      ),
                      Text(
                        selectTab == true ? "${travelUserList[index].firstName!} ${travelUserList[index].lastName!}" : "${meetNewMatchList[index].firstName!} ${meetNewMatchList[index].lastName!}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                      ),
                    ],
                  ),
                  if (selectTab == true ? !travelUserList[index].isBlocked! : !meetNewMatchList[index].isBlocked!)
                    const Divider(
                      color: AppColors.dividerColor,
                    ),
                  if (selectTab == true ? !travelUserList[index].isBlocked! : !meetNewMatchList[index].isBlocked!)
                    InkWell(
                      onTap: () {
                        print("travelUserList --> ${travelUserList.length}");

                        int? chat_match;
                        chat_match = selectTab == true ? travelUserList[index].chatMatch! : meetNewMatchList[index].chatMatch!;
                        if (chat_match == 0) {
                          Get.back();
                        } else {
                          String commonInterestValue = "";

                          if (selectTab == true) {
                            if (travelUserList[index].commonDest.toString() != "destination") {
                              commonInterestValue = 'Gagagoing to '.tr + travelUserList[index].commonDest.toString();
                            }
                          } else {
                            if (meetNewMatchList[index].commonInterest.toString() == "hobby") {
                              commonInterestValue = "Gagago Meet Now";
                            } else {
                              commonInterestValue = 'Gagago ${meetNewMatchList[index].commonInterest}';
                            }
                          }
                          /*selectTab == true
                              ? travelUserList[index].commonDest.toString() == "destination"
                                  ? ""
                                  : 'Gagagoing to '.tr + travelUserList[index].commonDest.toString()
                              : meetNewMatchList[index].commonInterest.toString() == "hobby"
                                  ? "Gagago Meet Now"
                                  : 'Gagago ${meetNewMatchList[index].commonInterest}';*/
                          Get.back();
                          Navigator.of(
                            context,
                          )
                              .push(
                            MaterialPageRoute(
                              builder: (context) => ChatMessageScreen(
                                  receiverId: selectTab == true ? travelUserList[index].id!.toString() : meetNewMatchList[index].id!.toString(),
                                  isShown: false,
                                  connectionType: selectTab == true ? 'travell' : 'meet_now',
                                  commonInterest: commonInterestValue,
                                  isMeBlocked: 'false'),
                            ),
                          )
                              .then((value) {
                            appStreamController.handleBottomTab.add(true);
                          });
                          /* Get.toNamed(RouteHelper.getChatMessageScreen(selectTab== true?travelUserList[index].id!.toString()
                            :meetNewMatchList[index].id!.toString()));*/
                        }

                        // Get.toNamed(RouteHelper.getWriteReviewPage());
                      },
                      child: Text(
                        "Message".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                      ),
                    ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      /*
                      debugPrint("My User Id ${userId}");
                      var map = new Map<String, dynamic>();
                      map['removed_to'] = param0;
                      map['removed_by'] = userId;
                      map['removed_from'] = selectTab== true?"travel":"meet_now";
                      ConnectionRemoveModel connectionRemove= await CallService().removeConnection(map);
                      if(connectionRemove.status! == true){
                        init();
                      }
                      else{
                        CommonDialog.showToastMessage(connectionRemove.message.toString());
                      }*/

                      var map = <String, dynamic>{};
                      map['removed_to'] = param0;
                      // map['removed_by'] = userId;
                      ConnectionRemoveModel connectionRemove = await CallService().removeConnectionChat(map);
                      if (connectionRemove.status! == true) {
                        init();
                        // Get.back();
                        // Navigator.pop(context, {'removeConnection': true});
                      } else {
                        CommonDialog.showToastMessage(connectionRemove.message.toString());
                      }
                    },
                    child: Text(
                      "Remove".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.redTextColor),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: Get.width,
              height: Get.height * 0.016,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
                width: Get.width,
                height: Get.height * 0.070,
                child: Center(
                    child: Text(
                  "Cancel".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshEventList,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.width * 0.14, right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
                child: travelUserList.isNotEmpty || meetMatchList.isNotEmpty
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              debugPrint("DataPrint---->");
                              Navigator.pop(context, true);
                            },
                            child: CommonBackButton(
                              name: "Connections".tr,
                            ),
                          ),
                          isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.transparent,
                                ))
                              : Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.020,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectTab = true;
                                                });
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${travelCount.toString()} ${travelCount != null ? travelCount! <= 1 ? "Travel".tr : "Travels".tr : "Travel".tr}",
                                                    style: TextStyle(
                                                        color: (selectTab == true) ? AppColors.blueColor : AppColors.headerGrayColor,
                                                        fontFamily: StringConstants.poppinsRegular,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: Get.locale! == StringConstants.LOCALE_ENGLISH ? Get.height * 0.020 : Get.height * 0.015),
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.005,
                                                  ),
                                                  Container(
                                                    height: (selectTab == true) ? 3 : 2,
                                                    width: Get.width * 0.45,
                                                    color: (selectTab == true) ? AppColors.blueColor : AppColors.headerGrayColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (latitude.isNotEmpty && longitude.isNotEmpty) {
                                                  setState(() {
                                                    selectTab = false;
                                                  });
                                                } else {
                                                  getCurrentLocation(meetMatchList, meetCount!);
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${meetNewCount.toString()} ${"Meet Now".tr}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        // overflow: TextOverflow.ellipsis,
                                                        color: (selectTab == false) ? AppColors.blueColor : AppColors.headerGrayColor,
                                                        fontFamily: StringConstants.poppinsRegular,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: Get.locale! == StringConstants.LOCALE_ENGLISH ? Get.height * 0.020 : Get.height * 0.015),
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.005,
                                                  ),
                                                  Container(
                                                    height: (selectTab == false) ? 3 : 2,
                                                    width: Get.width * 0.45,
                                                    color: (selectTab == false) ? AppColors.blueColor : AppColors.headerGrayColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.015,
                                      ),
                                      Expanded(
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: selectTab == true ? travelUserList.length : meetNewMatchList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return _listItem(context, index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : isLoading
                        ? SizedBox()
                        : Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  debugPrint("DataPrint---->");
                                  Navigator.pop(context);
                                },
                                child: CommonBackButton(
                                  name: "Connections".tr,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.020,
                              ),
                              Expanded(child: NoConnectionFoundScreen()),
                            ],
                          ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.010),
                  child: SvgPicture.asset(
                    "${StringConstants.svgPath}bottomLogin.svg",
                    height: Get.height * 0.070,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listItem(context, index) {
    String commonInterest = "";

    if (selectTab == true) {
      if (travelUserList[index].connectionType == "travell" && travelUserList[index].commonDest != "destination") {
        commonInterest = "${"Gagagoing to ".tr}${travelUserList[index].commonDest ?? ""}";
      }
    } else {
      if (meetNewMatchList[index].connectionType == "meetnow" && meetNewMatchList[index].commonInterest != "hobby") {
        commonInterest = "Gagago ${meetNewMatchList[index].commonInterest ?? ""}";
      }
    }

    /*  selectTab == true
        ? (travelUserList[index].connectionType == "travell" && travelUserList[index].commonDest != "destination"
            ? "${"Gagagoing to ".tr}${travelUserList[index].commonDest ?? ""}" */ /*:travelUserList[index].connectionType == "meetnow" &&  travelUserList[index].commonInterest != "hobby"?
                                                                    "Gagago ${travelUserList[index].commonInterest ?? ""}"*/ /*
            : "")
        : (*/ /*meetNewMatchList[index].connectionType == "travell" &&  meetNewMatchList[index].commonDest == "destination"?
                                                  "${"Gagagoing to ".tr}${meetNewMatchList[index].commonDest ?? ""}":*/ /*
            meetNewMatchList[index].connectionType == "meetnow" && meetNewMatchList[index].commonInterest != "hobby" ? "Gagago ${meetNewMatchList[index].commonInterest ?? ""}" : "");*/
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage(selectTab == true ? travelUserList[index].id!.toString() : meetNewMatchList[index].id.toString())),
                );
              },
              child: Row(
                children: [
                  Padding(
                    //this padding will be you border size
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.inputFieldBorderColor, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingPage(selectTab == true ? travelUserList[index].id!.toString() : meetNewMatchList[index].id.toString())),
                          );
                        },
                        child: selectTab == true
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                backgroundImage: travelUserList[index].userProfile!.isNotEmpty
                                    ? (NetworkImage(travelUserList[index].userProfile![0].imageName.toString()))
                                    : Image.asset(
                                        'assets/images/png/dummypic.png',
                                      ).image,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                backgroundImage: meetNewMatchList[index].userProfile!.isNotEmpty
                                    ? (NetworkImage(meetNewMatchList[index].userProfile![0].imageName.toString()))
                                    : Image.asset(
                                        'assets/images/png/dummypic.png',
                                      ).image,
                              ),
                        /*  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                  radius: 18,
                                  backgroundImage: NetworkImage(selectTab == true
                                  ? travelUserList[index].userProfile!.isEmpty
                                  ? ""
                                      : travelUserList[index].userProfile![0].imageName.toString()
                                      : meetNewMatchList[index].userProfile!.isEmpty
                                  ? ""
                                      : meetNewMatchList[index].userProfile![0].imageName.toString())
                                  */ /* backgroundImage: AssetImage(
                                                          connectionList[index].image),*/ /*
                                  ),*/
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.015,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingPage(selectTab == true ? travelUserList[index].id!.toString() : meetNewMatchList[index].id.toString())),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectTab == true
                                  ? "${travelUserList[index].firstName!} ${travelUserList[index].lastName!}"
                                  : "${meetNewMatchList[index].firstName!} ${meetNewMatchList[index].lastName!}",
                              /*connectionList[index].name,*/
                              style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                            ),
                            SizedBox(
                              width: Get.width * 0.010,
                            ),
                            if ((selectTab == true && travelUserList[index].isNew!) || (selectTab == false && meetNewMatchList[index].isNew!))
                              Container(
                                margin: EdgeInsets.only(left: Get.width * 0.003),
                                alignment: Alignment.topCenter,
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.buttonColor),
                                height: Get.height * 0.029,
                                width: Get.width * 0.12,
                                child: Center(
                                    child: Text(
                                  "New",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: Get.height * 0.018),
                                )),
                              )
                          ],
                        ),
                        Text(
                          commonInterest,
                          style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, color: AppColors.lightText, fontFamily: StringConstants.poppinsRegular),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                bottomSheet(selectTab == true ? travelUserList[index].id! : meetNewMatchList[index].id!, index, commonInterest: commonInterest);
              },
              child: Icon(
                Icons.more_vert,
                size: Get.height * 0.040,
              ),
            ),
          ],
        ),
        SizedBox(
          height: Get.height * 0.010,
        )
      ],
    );
  }

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      init();
    });
    return;
  }

  // void askToPermission() async {
  //   var status = await Permission.location.request();
  //   setState(() {
  //     if (status.isDenied) {
  //       // We didn't ask for permission yet or the permission has been denied before but not permanently.
  //       print("Permission is denined.");
  //       Permission.location.request();
  //     }else if(status.isGranted){
  //       //permission is already granted.
  //       print("Permission is already granted.");
  //       init();
  //
  //     }else if(status.isPermanentlyDenied) {
  //       //permission is permanently denied.
  //       IsVisble=false;
  //       setState(() {
  //         openAppBox(context);
  //       });
  //
  //       print("Permission is permanently denied");
  //     }else if(status.isRestricted){
  //       //permission is OS restricted.
  //       print("Permission is OS restricted.");
  //     }
  //   });
  //
  // }

  // void openAppBox(context) {
  //   showDialog(
  //       context: context,
  //     barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius:
  //               BorderRadius.circular(20.0)), //this right here
  //           child: Container(
  //             height: 200,
  //             child: Padding(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                    Container(
  //                        alignment: Alignment.center,
  //                        child: const Text('Permission is permanently denied, Please allow your location ',style: TextStyle(fontSize: 16),textAlign: TextAlign.center,)),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     margin: const EdgeInsets.only(top: 15),
  //                     child: TextButton(
  //                       onPressed: () {
  //                         openAppSettings();
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text(
  //                         "Ok",
  //                         style: TextStyle(color: Colors.black,fontSize: 14),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
