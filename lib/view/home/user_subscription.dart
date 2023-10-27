import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/enable_subscription_response_model.dart';
import 'package:gagagonew/model/subscription_Response_Model.dart';
import 'package:gagagonew/model/user_subscription_model_response.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pay/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/web_view_class.dart';
import '../../Service/call_service.dart';
import '../../utils/progress_bar.dart';
import 'package:gagagonew/view/packages/controllers/payment_configurations.dart' as payment_configurations;

import 'controller/subscription_payment_controller.dart';

class UserSubscriptionScreen extends StatefulWidget {
  const UserSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<UserSubscriptionScreen> createState() => _UserSubscriptionScreenState();
}

class _UserSubscriptionScreenState extends State<UserSubscriptionScreen> {
  SubscriptionPaymentController subscriptionPaymentController = Get.put(SubscriptionPaymentController());
  bool isLoading = false;
  Plan? plan;
  String planName = "", planDuration = "", amount = "", dateOfPurchase = "", dateOfEnd = "", renewalDate = "", status = "", planID = "";
  String planPrice = "";
  List<Message>? planList = [];

  SharedPreferences? prefs;
  int? showNotifications;
  int selectedMode = 0;

  @override
  void initState() {
    super.initState();
    subscriptionPaymentController.init();
    getSharedPref();
  }

  void getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    isLoading = true;
    subscriptionPaymentController.userId = prefs!.getString('userId') ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserSubscriptionResponseModel model = await CallService().getUserSubscriptionDetails();
      isLoading = false;
      if (model.plan != null) {
        plan = model.plan;
        planID = plan!.planId!;
        planName = plan?.planName ?? "";
        planDuration = plan?.planDuration.toString() ?? "";
        amount = plan?.planPrice.toString() ?? "";
        subscriptionPaymentController.autoRenewNotificationEnabled = plan?.autoRenewal;
        // dateOfPurchase = Jiffy(plan?.startAt.toString() ?? "").yMMMd;
        // renewalDate = Jiffy(plan?.endAt.toString() ?? "").yMMMd;
        setState(() {});
        subscriptionMethod();

        debugPrint("SubcriptionDetails$plan");
      } else {
        Get.back(result: false);
      }
    });
  }

  subscriptionMethod() {
    // For Subscription
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SubscriptionResponseModel model = await CallService().getSubscriptionList();
      setState(() {
        planList = model.message;
        /*plan_price = planList![0].planPrice;
        plan_duration = planList![0].planDuration;*/
      });
    });
  }

  int? selectedIndex;
  showSubscriptionDialog() async {
    setState(() {});
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Premium'.tr,
                    style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Text(
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections".tr,
                    style: TextStyle(
                        fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.020,
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
                        children: List<Widget>.generate(planList!.length, (int index) {
                          return InkWell(
                            onTap: () async {
                              prefs = await SharedPreferences.getInstance();
                              setState(() {
                                selectedIndex = index;
                                subscriptionPaymentController.planId = planList![index].id;
                                subscriptionPaymentController.planAmount = planList![index].planPrice;
                                prefs!.setString('planId', subscriptionPaymentController.planId!.toString());
                              });
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 5, color: (index == selectedIndex) ? Colors.blue : Colors.white),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    planList![index].planDuration!,
                                    style: TextStyle(fontSize: Get.height * 0.025, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),
                                  Text(
                                    int.parse(planList![index].planDuration!) > 1 ? 'months'.tr : "month".tr,
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),
                                  Text(
                                    '\$${planList![index].planPrice!}',
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: AppColors.desColor),
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

                        if (subscriptionPaymentController.planId == null) {
                          CommonDialog.showToastMessage('Please select any plan.'.tr);
                        } else {
                          Get.back();
                          if (int.parse(planID) == subscriptionPaymentController.planId) {
                            CommonDialog.showToastMessage('You have already purchased this plan.'.tr);
                          } else {
                            subscriptionPaymentController.showPaymentMethodSheet(callback: () {
                              setState(() {});
                            });
                          }
                        }

                        ///
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
                      style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: AppColors.desColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.transparent,
            ))
          : Padding(
              padding: EdgeInsets.only(top: Get.height * 0.070, left: Get.width * 0.055, right: Get.width * 0.055),
              child: Column(
                children: [
                  CommonBackButton(
                    name: "Subscription".tr,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.030,
                          ),
                          SvgPicture.asset(
                            "${StringConstants.svgPath}subscriptionicon.svg",
                            height: Get.height * 0.10,
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Text(
                            "My Active Plan".tr,
                            style: TextStyle(fontSize: Get.height * 0.030, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Container(
                            width: Get.width * 0.9,
                            height: 1,
                            color: AppColors.dividerColor,
                            margin: EdgeInsets.only(top: Get.height * 0.010),
                          ),
                          SizedBox(
                            height: Get.height * 0.030,
                          ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Plan Name",
                                    style: TextStyle(
                                        color: AppColors.planColor,
                                        fontSize: Get.height * 0.016,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(
                                            fontSize: Get.height * 0.020,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                                StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          planName,
                                          style: TextStyle(
                                              fontSize: Get.height * 0.016,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: StringConstants
                                                  .poppinsRegular),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Auto Renewal".tr,
                                    style: TextStyle(color: AppColors.planColor, fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: 35,
                                          child: FittedBox(
                                            child: CupertinoSwitch(
                                              trackColor: Colors.grey,
                                              activeColor: subscriptionPaymentController.isSubscribe == 0 ? Colors.grey : Colors.blue,
                                              value: subscriptionPaymentController.autoRenewNotificationEnabled == 1 ? true : false,
                                              onChanged: (newValue) async {
                                                debugPrint("DataValue$newValue");
                                                setState(() {
                                                  if (newValue == true) {
                                                    showNotifications = 1;
                                                    subscriptionPaymentController.autoRenewNotificationEnabled = 1;
                                                  } else {
                                                    showNotifications = 0;
                                                    subscriptionPaymentController.autoRenewNotificationEnabled = 0;
                                                  }
                                                  //showNotifications=newValue?1:0;
                                                });
                                                var map = <String, dynamic>{};
                                                map['status'] = subscriptionPaymentController.autoRenewNotificationEnabled;
                                                map['planId'] = planID;
                                                EnableSubscriptionResponseModel submit = await CallService().getRenewSubscription(map);
                                                if (submit.status!) {
                                                  if (newValue == true) {
                                                    CommonDialog.showToastMessage('Auto Renewal Enabled'.tr);
                                                  } else {
                                                    CommonDialog.showToastMessage('Auto Renewal Disabled'.tr);
                                                  }
                                                } else {
                                                  CommonDialog.showToastMessage(submit.message.toString());
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                      /*Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              fontSize: Get.height * 0.016,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: StringConstants
                                                  .poppinsRegular),
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Duration".tr,
                                    style: TextStyle(color: AppColors.planColor, fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: planDuration == "1"
                                            ? Text(
                                                "$planDuration ${"month".tr}",
                                                style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                              )
                                            : Text(
                                                "$planDuration ${"months".tr}",
                                                style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Amount".tr,
                                    style: TextStyle(color: AppColors.planColor, fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "\$$amount",
                                          style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Date of Purchase".tr,
                                    style: TextStyle(color: AppColors.planColor, fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          dateOfPurchase,
                                          style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    "Renewal Date".tr,
                                    style: TextStyle(color: AppColors.planColor, fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          renewalDate,
                                          style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.2,
                          ),
                          InkWell(
                              onTap: () {
                                showSubscriptionDialog();
                              },
                              child: CustomButtonLogin(
                                buttonName: "Change Plan".tr,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

Widget image(String asset) {
  return SvgPicture.asset(
    asset,
    height: Get.height * 0.001,
    width: Get.width * 0.001,
  );
}
