import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/web_view_class.dart';
import '../../Service/call_service.dart';
import '../../Service/life_cycle_handler.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/register_controller.dart';
import '../../model/interests_model.dart';
import '../../model/subscription_Response_Model.dart';
import '../../utils/app_network_image.dart';
import '../../utils/progress_bar.dart';

class MeetNow extends StatefulWidget {
  String? subscribe;
  MeetNow({Key? key, this.subscribe}) : super(key: key);

  @override
  State<MeetNow> createState() => _MeetNowState();
}

class _MeetNowState extends State<MeetNow> with WidgetsBindingObserver {
  List<Data> categories = [];
  RegisterController c = Get.find();
  List<Interest>? selectedInterests = [];
  String? planPrice = "", planDuration = "";
  List<Message>? planList = [];
  SharedPreferences? prefs;
  int? isSubscribe;
  int? planId;
  int? userId;
  String oldLanguageCode = "";

  @override
  void initState() {
    oldLanguageCode = Platform.localeName.split('_')[0];
    initLifeCycler();

    init();
    super.initState();
  }

  initLifeCycler() {
    String oldLanguageCode = Platform.localeName.split('_')[0];
    oldLanguageCode = Platform.localeName.split('_')[0];

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        String languageCode = Platform.localeName.split('_')[0];

        print(
            "oldLanguageCode  $oldLanguageCode --> languageCode $languageCode");

        if (oldLanguageCode != languageCode) {
          String? accessToken;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          accessToken = prefs.getString('userToken');
          oldLanguageCode = languageCode;
          if (accessToken == null) {
            init();
          }
        }
      },
      suspendingCallBack: () async {},
    ));
  }

  int? selectedIndex;

  showSubscriptionDialog(BuildContext context) async {
    setState(() {});
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Premium'.tr,
                    style: TextStyle(
                        fontSize: Get.height * 0.022,
                        fontWeight: FontWeight.w600,
                        fontFamily: StringConstants.poppinsRegular,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Text(
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections"
                        .tr,
                    style: TextStyle(
                        fontSize: Get.height * 0.020,
                        fontWeight: FontWeight.w500,
                        fontFamily: StringConstants.poppinsRegular,
                        color: AppColors.popupSmallTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: Get.width * 0.030,
                        children: List<Widget>.generate(planList!.length,
                            (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                planId = planList![index].id;
                                prefs!.setString('planId', planId!.toString());
                                debugPrint("GagagoPlanId $planId");
                              });
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 5,
                                      color: (index == selectedIndex)
                                          ? Colors.blue
                                          : Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color:
                                      AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    planList![index].planDuration!,
                                    style: TextStyle(
                                        fontSize: Get.height * 0.025,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    int.parse(planList![index].planDuration!) >
                                            1
                                        ? 'months'.tr
                                        : "month".tr,
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '\$${planList![index].planPrice!}',
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: AppColors.desColor),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  InkWell(
                      onTap: () async {
                        /*    _launchUrl(CallService().payPalUrl + userId.toString() + "/" + planId.toString());
                        debugPrint("planId $planId");*/
                        var isConnect = await checkConnectivity();
                        if (isConnect == ConnectivityResult.mobile) {
                          await Get.to(CommonWebView(userId.toString(), planId!));
                          setState(() {
                            isSubscribe = 1;
                          });
                        } else if (isConnect == ConnectivityResult.wifi) {
                          await Get.to(CommonWebView(userId.toString(), planId!));
                          setState(() {
                            isSubscribe = 1;
                          });
                        } else {
                          CommonDialog.showToastMessage(
                              "No Internet Available!!!!!".tr);
                        }
                        //debugPrint("Print Url ${launchUrl(CallService().payPalUrl + '/' + userId.toString() + "/" + planId.toString()}");
                        //Get.back();
                      },
                      child: CustomButtonLogin(
                        buttonName: "Continue".tr,
                      )),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "No Thanks".tr,
                      style: TextStyle(
                          fontSize: Get.height * 0.020,
                          fontWeight: FontWeight.w600,
                          fontFamily: StringConstants.poppinsRegular,
                          color: AppColors.desColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  init() async {
    if (widget.subscribe == 'Register') {
      isSubscribe = 2;
    } else {
      prefs = await SharedPreferences.getInstance();
      userId = int.parse(prefs!.getString('userId').toString());
      isSubscribe = int.parse(widget.subscribe.toString());
    }
    selectedInterests = c.interests;
    var isConnect = await checkConnectivity();
    if (isConnect == ConnectivityResult.mobile) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        InterestsModel model = await CallService().getInterests();
        setState(() {
          categories = model.data!;
        });
      });
    } else if (isConnect == ConnectivityResult.wifi) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        InterestsModel model = await CallService().getInterests();
        setState(() {
          categories = model.data!;
        });
      });
    } else {
      CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
    }
    prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs!.getString('userToken');
    if (accessToken != null) {
      // For Subscription
      if (isConnect == ConnectivityResult.mobile) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          SubscriptionResponseModel model =
              await CallService().getSubscriptionList(isShowLoader: false);
          setState(() {
            planList = model.message;
            planPrice = planList![0].planPrice;
            planDuration = planList![0].planDuration;
          });
        });
      } else if (isConnect == ConnectivityResult.wifi) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          SubscriptionResponseModel model =
              await CallService().getSubscriptionList(isShowLoader: false);
          setState(() {
            planList = model.message;
            planPrice = planList![0].planPrice;
            planDuration = planList![0].planDuration;
          });
        });
      } else {
        //CommonDialog.showToastMessage("No Internet Available!!!!!");
      }
    }
  }

  @override
  void dispose() {
    c.interests = selectedInterests;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
          top: Get.width * 0.14,
          left: Get.width * 0.060,
          right: Get.width * 0.060,
          bottom: Get.height * 0.020),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonBackButton(
              name: 'Meet Now'.tr,
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            /* SizedBox(
              child: TextFormField(
                autofocus: false,
                style: TextStyle(
                    fontFamily: StringConstants.poppinsRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: Get.height * 0.016,
                    color: AppColors.meetNowHintColor),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: AppColors.grayColorNormal, width: 0.0),
                  ),
                  hintText: 'What do you love to do? Choose 3',
                  hintStyle: TextStyle(
                      fontFamily: StringConstants.poppinsRegular,
                      fontWeight: FontWeight.w400,
                      fontSize: Get.height * 0.016,
                      color: AppColors.meetNowHintColor),
                  prefixIcon: Container(
                      margin: EdgeInsets.only(
                          left: Get.width * 0.045, right: Get.width * 0.020),
                      child: SvgPicture.asset('assets/images/svg/globe.svg')),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),*/
            Container(
              padding: EdgeInsets.all(Get.width * 0.035),
              width: Get.width * 0.9,
              margin: EdgeInsets.only(
                  top: Get.height * 0.011, bottom: Get.height * 0.011),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: AppColors.inputFieldBorderColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/globe.svg',
                    width: Get.width * 0.07,
                    height: Get.width * 0.07,
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  selectedInterests!.isEmpty
                      ? Flexible(
                          child: Text('What do you want to do?'.tr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Get.height * 0.016,
                                  fontFamily: 'PoppinsRegular')),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              children: List<Widget>.generate(
                                selectedInterests!.length,
                                (int idx) {
                                  return Stack(
                                    children: [
                                      /*Container(
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color:
                                    AppColors.blueColor.withOpacity(0.08),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                    border: new Border.all(
                                      color: AppColors.blueColor,
                                      width: 1.0,
                                    ),
                                  ),
                                padding: EdgeInsets.only(top: Get.height * 0.012, bottom: Get.height * 0.005, left: Get.width * 0.03, right: Get.width * 0.03),
                                margin: EdgeInsets.only(right: Get.height * 0.030,top: Get.height*0.01,),
                                  child: Text(
                                    selectedInterests![idx]
                                        .name
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily:
                                      StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: Get.height * 0.016,
                                    ),
                                  ),
                                ),*/
                                      InkWell(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: Get.width * 0.02),
                                          child: Chip(
                                            avatar:
                                            // AppNetworkImage(
                                            //   imageUrl: selectedInterests![idx]
                                            //       .image
                                            //       .toString(),
                                            //   height: Get.width,
                                            //   width: Get.width,
                                            //   boxFit: BoxFit.contain,
                                            //   loaderThickness: 1.0,
                                            // ),

                                            Image.network(
                                                selectedInterests![idx]
                                                    .image
                                                    .toString()),
                                            backgroundColor: /*categories[index]
                          .interest![idx]
                          .selected
                          ? AppColors.blueColor
                          .withOpacity(0.08)
                          :*/
                                                Colors.white,
                                            shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: AppColors
                                                        .grayColorNormal)),
                                            label: Text(
                                              selectedInterests![idx]
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: StringConstants
                                                    .poppinsRegular,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: Get.height * 0.018,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          if (isSubscribe == 2) {
                                            setState(() {
                                              selectedInterests!.removeAt(idx);
                                            });
                                          } else {
                                            if (selectedInterests![idx]
                                                    .interestId ==
                                                0) {
                                              setState(() {
                                                selectedInterests!
                                                    .removeAt(idx);
                                              });
                                            } else {
                                              // var map = new Map<String, dynamic>();
                                              // map['id'] = selectedInterests![idx].id;
                                              // DeleteImageModel login= await CallService().removeInterst(map);
                                              // if(login.success == true){
                                              setState(() {
                                                selectedInterests!
                                                    .removeAt(idx);
                                              });
                                              // }
                                              // else{
                                              //   CommonDialog.showToastMessage(login.message.toString());
                                              // }
                                            }
                                          }
                                        },
                                      ),
                                      /* Positioned(
                                  child: IconButton(onPressed: () async {
                                    if(isSubscribe==2){
                                      setState(() {
                                        selectedInterests!.removeAt(idx);
                                      });
                                    }else{
                                      if(selectedInterests![idx].interestId==0){
                                        setState(() {
                                          selectedInterests!.removeAt(idx);
                                        });
                                      }else{
                                        var map = new Map<String, dynamic>();
                                        map['id'] = selectedInterests![idx].id;
                                        DeleteImageModel login= await CallService().removeInterst(map);
                                        if(login.success == true){
                                          setState(() {
                                            selectedInterests!.removeAt(idx);
                                          });
                                        }
                                        else{
                                          CommonDialog.showToastMessage(login.message.toString());
                                        }
                                      }
                                    }
                                  }, icon: Icon(Icons.cancel_outlined)),
                                  right: -Get.width*0.020,
                                  bottom: Get.height*0.020,
                                )*/
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Visibility(
              visible: selectedInterests!.length <= 4,
              child: Text(
                  selectedInterests!.length < 4
                      ? 'Choose 4 interests'.tr
                      : 'You have chosen all 4 interests. Remove any to change.'
                          .tr,
                  style: TextStyle(
                      color: AppColors.grayColorNormal,
                      fontSize: Get.height * 0.018,
                      fontFamily: 'PoppinsRegular')),
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return getSelectCategoryWidget(index);
                },
                itemCount: categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget getSelectCategoryWidget(int index) {
    return Container(
      margin:
          EdgeInsets.only(top: Get.height * 0.03, bottom: Get.height * 0.030),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categories[index].name.toString(),
            style: TextStyle(
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: Get.height * 0.025,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Wrap(
            children: List<Widget>.generate(
              categories[index].interest!.length,
              (int idx) {
                return GestureDetector(
                  onTap: () async {
                    /*if (categories[index].interest![idx]
                        .selected) {
                     */ /* setState(() {
                        categories[index].interest![idx]
                            .selected = false;
                        selectedInterests!.remove(categories[index].interest![idx]);
                      });*/ /*
                    } else {

                    }*/
                    if (selectedInterests!.length < 4) {
                      for (int i = 0; i < selectedInterests!.length; i++) {
                        if (selectedInterests![i].name ==
                            categories[index].interest![idx].name) {
                          return;
                        }
                      }
                      setState(() {
                        categories[index].interest![idx].selected = true;
                        selectedInterests
                            ?.add(categories[index].interest![idx]);
                      });
                    } else {
                      /* if(isSubscribe == 0){
                          showSubscriptionDialog(context);
                        }else{

                        }*/
                      bool? canVibrate = await Vibration.hasVibrator();
                      if (canVibrate!) {
                        Vibration.vibrate(duration: 300);
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Get.width * 0.02),
                    child: Chip(
                      avatar:
                      // AppNetworkImage(
                      //   imageUrl:
                      //       categories[index].interest![idx].image.toString(),
                      //   height: Get.width,
                      //   width: Get.width,
                      //   boxFit: BoxFit.contain,
                      //   loaderThickness: 1,
                      // ),

                      Image.network(
                          categories[index].interest![idx].image.toString()),
                      backgroundColor: /*categories[index]
                          .interest![idx]
                          .selected
                          ? AppColors.blueColor
                          .withOpacity(0.08)
                          :*/
                          Colors.white,
                      shape: const StadiumBorder(
                          side: BorderSide(color: AppColors.grayColorNormal)),
                      label: Text(
                        categories[index].interest![idx].name.toString(),
                        style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: Get.height * 0.018,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
