import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/status_update.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_mode_response_model.dart';
import '../../utils/stream_controller.dart';
import '../dialogs/common_alert_dialog.dart';
import '../home/bottom_nav_page.dart';

class DrawerPage extends StatefulWidget {
  DrawerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  AppStreamController appStreamController = AppStreamController.instance;

  final bool radioValue = false;
  int checkRadio = 1;
  int travelMode = 1;
  int meetNowMode = 2;

  SharedPreferences? prefs;

  @override
  void initState() {
    /*   setMode();*/
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();

      setState(() {
        userMode = prefs!.getInt('userMode') ?? 0;
      });

      UserModeResponseModel model = await CallService().getUserMode();

      if (mounted) {
        setState(() {
          userMode = model.userMode!;
          debugPrint("userMode $userMode");
          prefs!.setInt('userMode', userMode ?? 0);
        });
      }
    });
  }

  void askPermission({required Function(bool) callBack}) async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denined.");
      await Permission.location.request();
    } else if (status.isGranted) {
      //permission is already granted.
      callBack(true);
      //  scrollController = widget.scrollController;
    } else if (status.isPermanentlyDenied) {
      //permission is permanently denied.
      // callBack(true);
      openAppBox(context);
      //   print("Permission is permanently denied");
    } else if (status.isRestricted) {
      //permission is OS restricted.
      // callBack(true);
      openAppBox(context);
    }
  }

  bool isDialogShowing = false;

  void openAppBox(context) {
    if (isDialogShowing) {
      return;
    }
    isDialogShowing = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            description:
                'Please allow location access to use the app. Your location is used to determine Travel and Meet Now mode connections',
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
        });
  }

  void getCurrentLocation() async {
    // if (await Permission.location.isGranted) {
    if (latitude.isEmpty && longitude.isEmpty) {
      var position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);
      debugPrint("HomePage lat=====>${position.latitude}");
      debugPrint("HomePage long=====>${position.longitude}");
      latitude = "${position.latitude}";
      longitude = "${position.longitude}";
    }
    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      var map = <String, dynamic>{};
      map['lat'] = latitude;
      map['lng'] = longitude;
      debugPrint("updateLocation map $map");
      CallService().updateLocation(
        map,
      );

      setState(() {
        userMode = 2;
        prefs!.setInt('userMode', userMode ?? 0);
      });
      var userModeMap = new Map<String, dynamic>();
      userModeMap['status'] = 2;
      StatusUpdateResponseModel stateUpdate =
          await CallService().getMode(userModeMap, showLoading: false);
      if (stateUpdate.status == true) {
        appStreamController.handleRefreshHomeScreen.add(true);

        //initState();
        // Get.offAllNamed(RouteHelper.getBottomSheetPage());
        scaffoldKey.currentState!.openEndDrawer();

        //Navigator.pop(context);
      } else {
        CommonDialog.showToastMessage(stateUpdate.message.toString());
      }
    }
    CommonDialog.hideLoading();
    // } else {
    //   CommonDialog.hideLoading();
    //
    //   await [
    //     Permission.location,
    //   ].request();
    //   getCurrentLocation();
    // }
  }

  /*setMode() async {
   */ /* SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkRadio=prefs.getInt('mode')!;
    });*/ /*

  }*/

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: Get.width * 0.75,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
              top: Get.width * 0.14,
              right: Get.width * 0.050,
              left: Get.width * 0.050,
              bottom: Get.height * 0.010),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a mode".tr,
                style: TextStyle(
                    fontFamily: StringConstants.poppinsRegular,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height * 0.022,
                    color: AppColors.gagagoLogoColor),
              ),
              SizedBox(
                height: Get.height * 0.020,
              ),
              InkWell(
                onTap: () async {
                  // scaffoldKey.currentState!.openEndDrawer();
                  var map = <String, dynamic>{};
                  map['status'] = 1;
                  StatusUpdateResponseModel stateUpdate =
                      await CallService().getMode(map);
                  if (stateUpdate.status == true) {
                    appStreamController.rebuildRefreshHomeScreenStream();
                    appStreamController.handleRefreshHomeScreen.add(true);

                    //initState();
                    setState(() {
                      userMode = 1;
                      prefs!.setInt('userMode', userMode ?? 0);
                    });
                    // Get.offAllNamed(RouteHelper.getBottomSheetPage());
                    //Navigator.pop(context);
                    scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    CommonDialog.showToastMessage(
                        stateUpdate.message.toString());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5.0,
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/location.svg",
                            width: Get.width * 0.067,
                            height: Get.width * 0.090,
                          ),
                          SizedBox(
                            width: Get.width * 0.025,
                          ),
                          Text(
                            "Travel".tr,
                            style: TextStyle(
                                fontFamily: StringConstants.poppinsRegular,
                                fontWeight: FontWeight.w600,
                                fontSize: Get.height * 0.020,
                                color: AppColors.gagagoLogoColor),
                          ),
                        ],
                      ),
                      /*  InkWell(
                          onTap: () async {
                            // scaffoldKey.currentState!.openEndDrawer();
                            var map = <String, dynamic>{};
                            map['status'] = 1;
                            StatusUpdateResponseModel stateUpdate = await CallService().getMode(map);
                            if (stateUpdate.status == true) {
                              //initState();
                              setState(() {
                                userMode = 1;
                                prefs!.setInt('userMode', userMode ?? 0);

                              });
                              // Get.offAllNamed(RouteHelper.getBottomSheetPage());
                              //Navigator.pop(context);
                              scaffoldKey.currentState!.openEndDrawer();
                            } else {
                              CommonDialog.showToastMessage(stateUpdate.message.toString());
                            }
                          },
                          child:*/
                      userMode == null
                          ? SvgPicture.asset("assets/images/svg/blueTick.svg")
                          : SvgPicture.asset((userMode == 1)
                              ? "assets/images/svg/blueTick.svg"
                              : "assets/images/svg/grayEmpty.svg")
                      // Radio(
                      //   value: 1,
                      //   groupValue: _radioValue,
                      //   onChanged: (value){
                      //   setState(() {
                      //     _radioValue=value;
                      //   });
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.020,
              ),
              InkWell(
                onTap: () async {
                  /*_radioValue = true;*/
                  // scaffoldKey.currentState!.openEndDrawer();

                  askPermission(callBack: (bool) {
                    CommonDialog.showLoading();

                    getCurrentLocation();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5.0,
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row(
                      //   children: [
                      SvgPicture.asset(
                        "assets/images/svg/globe.svg",
                        width: Get.width * 0.067,
                        height: Get.width * 0.090,
                      ),
                      SizedBox(
                        width: Get.width * 0.025,
                      ),
                      Expanded(
                        child: Text(
                          "Meet Now".tr,
                          style: TextStyle(
                              fontFamily: StringConstants.poppinsRegular,
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height * 0.020,
                              color: AppColors.gagagoLogoColor),
                        ),
                      ),
                      //   ],
                      // ),
                      /*InkWell(
                          onTap: () async {
                            */ /*_radioValue = true;*/ /*
                            CommonDialog.showLoading();
                            // scaffoldKey.currentState!.openEndDrawer();

                            getCurrentLocation();
                          },
                          child:*/
                      SvgPicture.asset((userMode == 2)
                          ? "assets/images/svg/blueTick.svg"
                          : "assets/images/svg/grayEmpty.svg")
                      //)
                      // Radio(
                      //   value: 1,
                      //   groupValue: _radioValue,
                      //   onChanged: (value){
                      //   setState(() {
                      //     _radioValue=value;
                      //   });
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
              /*Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/svg/globe.svg",
                        ),
                        SizedBox(
                          width: Get.width * 0.015,
                        ),
                        Text(
                          "Meet Now",
                          style: TextStyle(
                              fontFamily: StringConstants.poppinsRegular,
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height * 0.020,
                              color: AppColors.gagagoLogoColor),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () async {
                          */ /*_radioValue = true;*/ /*
                          setState(() {
                            userMode = 2;
                          });
                          var map = new Map<String, dynamic>();
                          map['status'] = 2;
                          StatusUpdateResponseModel stateUpdate =
                          await CallService().getMode(map);
                          if (stateUpdate.status == true) {
                            //initState();
                            Get.offAllNamed(RouteHelper.getBottomSheetPage());

                            //Navigator.pop(context);
                          } else {
                            CommonDialog.showToastMessage(
                                stateUpdate.message.toString());
                          }
                        },
                        child: SvgPicture.asset((userMode == 2)
                            ? "assets/images/svg/blueTick.svg"
                            : "assets/images/svg/grayEmpty.svg"))

                    // Radio(
                    //   value: 2,
                    //   groupValue: _radioValue,
                    //   onChanged: (value){
                    //     setState(() {
                    //       _radioValue=value;
                    //     });
                    //   },
                    // )
                  ],
                ),
              )*/
            ],
          ),
        ));
  }
}
