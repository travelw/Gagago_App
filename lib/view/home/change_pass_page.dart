import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/model/change_password_response_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/custom_text_field.dart';
import '../../RouteHelper/route_helper.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/progress_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  String? email;
  String? token;

  ChangePasswordPage({Key? key, this.email, this.token}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool obscureText = true;
  bool obscureText1 = true;
  bool obscureText2 = true;
  TextEditingController currentPassword = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirmPassword = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.026, left: Get.width * 0.080, right: Get.width * 0.080),
          child: SvgPicture.asset(
            "${StringConstants.svgPath}bottomLogin.svg",
            height: Get.height * 0.16,
            fit: BoxFit.fill,
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top:Get.width * 0.14, left: Get.width * 0.080, right: Get.width * 0.080),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonBackButton(
                    name: "Change Password".tr,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.080,
                            ),
                            SvgPicture.asset(
                              "${StringConstants.svgPath}lockPassword.svg",
                              height: Get.height * 0.13,
                            ),
                            SizedBox(
                              height: Get.height * 0.035,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: CustomTextField(
                                obscureText: obscureText,
                                controller: currentPassword,
                                hintText: "Current Password".tr,
                                prefixIcon: "loginPassword.svg",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: SvgPicture.asset(StringConstants.svgPath + (obscureText ? 'eyeIcon.svg' : 'eyeShow.svg'), fit: BoxFit.scaleDown),
                                ),
                                validateText: 'Please enter current Password'.tr,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: CustomTextField(
                                obscureText: obscureText1,
                                controller: password,
                                hintText: "New Password".tr,
                                prefixIcon: "loginPassword.svg",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obscureText1 = !obscureText1;
                                    });
                                  },
                                  child: SvgPicture.asset(StringConstants.svgPath + (obscureText1 ? 'eyeIcon.svg' : 'eyeShow.svg'), fit: BoxFit.scaleDown),
                                ),
                                validateText: 'Please enter New Password'.tr,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Must be at least 8 characters".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w400, color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: CustomTextField(
                                obscureText: obscureText2,
                                controller: confirmPassword,
                                hintText: "Confirm Password".tr,
                                prefixIcon: "loginPassword.svg",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obscureText2 = !obscureText2;
                                    });
                                  },
                                  child: SvgPicture.asset(StringConstants.svgPath + (obscureText2 ? 'eyeIcon.svg' : 'eyeShow.svg'), fit: BoxFit.scaleDown),
                                ),
                                validateText: 'Please enter Confirm Password'.tr,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Both passwords must match".tr,
                                  style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w400, color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular),
                                )),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  var map = <String, dynamic>{};
                                  map['current_password'] = currentPassword.text;
                                  map['new_password'] = password.text;
                                  map['confirm_new_password'] = confirmPassword.text;
                                  ChangePasswordResponseModel changePasswordModel = await CallService().getPasswordChange(map);
                                  if (changePasswordModel.status == true) {
                                    CommonDialog.showToastMessage('Password changed successfully. Please login'.tr);
                                    // CommonDialog.showToastMessage(
                                    //     changePasswordModel.message.toString());
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.clear();
                                    Get.offAllNamed(RouteHelper.getLoginPage());
                                  } else {
                                    CommonDialog.showToastMessage(changePasswordModel.message.toString());
                                  }
                                }
                              },
                              child: CustomButtonLogin(
                                buttonName: "Update Password".tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.010),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}createNewPassBag.svg",
                  height: Get.height * 0.070,
                ),
              ),
            ),
          ],
        ));
  }
}
