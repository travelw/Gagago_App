import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/invite_content_response_model.dart';
import 'package:gagagonew/model/total_refferal_response_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/common_functions.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({Key? key}) : super(key: key);

  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  bool isLoading = false;
  String referralCode = "", totalRefferal = "", inviteContent = "";
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    isLoading == true;
    init().then((value) {
      isLoading = false;
      setState(() {});
    });
    getInviteContent();
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    //userId =  int.parse(prefs!.getString('userId').toString());
    //notificationEnabled = int.parse(prefs!.getString('notificationEnabled').toString());
    referralCode = prefs!.getString("refferalCode")!;
    debugPrint("refferalcode$referralCode");
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TotalRefferalResponseModel model = await CallService().getTotalUserRefferal();
      setState(() {
        isLoading = false;
        totalRefferal = int.parse(model.total.toString()).toString();
        debugPrint("totalRefferal$totalRefferal");
      });
    });
  }

  getInviteContent() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      InviteContentResponseModel model = await CallService().getInviteContent();
      setState(() {
        isLoading = false;
        if (model.inviteFriendText != null) {
          inviteContent = model.inviteFriendText!.contentEnglish ?? "";
        }
        debugPrint("Invite Content $inviteContent");
      });
    });
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
                padding: EdgeInsets.only(top:Get.width * 0.14, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CommonBackButton(
                        name: 'Invite a Friend'.tr,
                      ),
                      SizedBox(
                        height: Get.height * 0.08,
                      ),
                      Image.asset(
                        'assets/images/png/add_friend.png',
                        width: Get.width * 0.45,
                        height: Get.width * 0.45,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: Get.height * 0.03, left: Get.width * 0.08, right: Get.width * 0.08),
                          child: Text(CommonFunctions.parseHtmlString(inviteContent),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular))),
                      Container(
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        child: Text('This is your invite code'.tr,
                            style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.021 : Get.height * 0.026, color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsBold)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01, horizontal: Get.width * 0.1),
                        decoration: const BoxDecoration(color: AppColors.referalCodeColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        child: Text(referralCode,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.023 : Get.height * 0.030, color: AppColors.blueColor, fontFamily: StringConstants.poppinsBold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(referralCode).then((value) => CommonDialog.showToastMessage('Referral Code Copied!'.tr));
                                },
                                child: Text('Copy'.tr, style: TextStyle(fontSize: Get.height * 0.020, color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsRegular)),
                              ),
                              SizedBox(
                                width: Get.width * 0.03,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    FlutterClipboard.copy(referralCode).then((value) => CommonDialog.showToastMessage('Referral Code Copied!'.tr));
                                  },
                                  child: Image.asset('assets/images/png/copy.png'))
                            ],
                          ),
                          Container(
                            height: Get.height * 0.04,
                            width: 1,
                            color: Colors.black38,
                            margin: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Share.share(
                                      "${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr} ${"https://gagagoapp.com"}${" "}${"Your Referral Code is:".tr} $referralCode",
                                      subject: "Let’s go with Gagago!");
                                },
                                child: Text('Share'.tr, style: TextStyle(fontSize: Get.height * 0.020, color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsRegular)),
                              ),
                              SizedBox(
                                width: Get.width * 0.03,
                              ),
                              GestureDetector(
                                child: Image.asset('assets/images/png/share.png'),
                                onTap: () {
                                  Share.share("${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr} ${"https://gagagoapp.com"}${" "}${"Your Referral Code is:".tr} $referralCode",
                                      subject: "Let’s go with Gagago!".tr);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        height: 2,
                        width: Get.width * 0.8,
                        color: Colors.black12,
                        margin: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, top: Get.height * 0.035),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Get.height * 0.03),
                        child:
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //       child:
                            Text("${'Total Referred : '.tr}$totalRefferal",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.023 : Get.height * 0.032, color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsBold)),
                      ),
                      //     Text(totalRefferal,
                      //         style: TextStyle(
                      //             fontSize: Get.height * 0.032,
                      //             color: AppColors.defaultBlack,
                      //             fontFamily: StringConstants.poppinsBold)),
                      //   ],
                      // ),
                      // ),
                    ],
                  ),
                )));
  }
}
