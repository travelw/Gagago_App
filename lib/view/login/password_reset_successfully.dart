import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../RouteHelper/route_helper.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';

class PasswordResetAndRegisterSuccessfully extends StatefulWidget {
  int checkResetAndRegPage;
  PasswordResetAndRegisterSuccessfully({Key? key, required this.checkResetAndRegPage}) : super(key: key);

  @override
  State<PasswordResetAndRegisterSuccessfully> createState() => _PasswordResetAndRegisterSuccessfullyState();
}

class _PasswordResetAndRegisterSuccessfullyState extends State<PasswordResetAndRegisterSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RouteHelper.getLoginPage());
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: Get.height * 0.026, left: Get.width * 0.080, right: Get.width * 0.080),
            child: SvgPicture.asset(
              "${StringConstants.svgPath}bottomLogin.svg",
              height: Get.height * 0.18,
              fit: BoxFit.fitWidth,
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.090, left: Get.width * 0.075, right: Get.width * 0.075),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/gif/check.gif",
                      height: Get.height * 0.35,
                    ),
                    //  SvgPicture.asset( StringConstants.svgPath+ "forgotPasswordCenter.svg",height: Get.height*0.13,),
                    SizedBox(
                      height: Get.height * 0.035,
                    ),
                    Text(
                      (widget.checkResetAndRegPage == 0) ? 'Password Reset\n Successfully.'.tr : "Account has been successfully registered".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Get.height * 0.025, fontWeight: FontWeight.w600, color: AppColors.resetPasswordColor, fontFamily: StringConstants.poppinsRegular),
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Text(
                      (widget.checkResetAndRegPage == 0)
                          ? 'You have successfully reset your password.\n Please use your new password when logging in.'.tr
                          : "Please check your email for verification.".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular),
                    ),
                    SizedBox(
                      height: Get.height * 0.030,
                    ),

                    InkWell(
                      onTap: () {
                        (widget.checkResetAndRegPage == 0) ? Get.offAllNamed(RouteHelper.getLoginPage()) : Get.offAllNamed(RouteHelper.getLoginPage());
                        // );
                      },
                      child: CustomButtonLogin(
                        buttonName: (widget.checkResetAndRegPage == 0) ? "Back To Login".tr : "Get Started".tr,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.012,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.040),
                  child: SvgPicture.asset(
                    (widget.checkResetAndRegPage == 0) ? "${StringConstants.svgPath}forgotPasswordBag.svg" : "",
                    height: Get.height * 0.1,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
