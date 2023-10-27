import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/custom_text_field.dart';
import '../../RouteHelper/route_helper.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/reset_password_model.dart';
import '../../utils/progress_bar.dart';

class CreateNewPasswordPage extends StatefulWidget {
  String? email;
  String? token;
  String? countryCode;
  CreateNewPasswordPage({Key? key, this.email, this.token,this.countryCode}) : super(key: key);

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirmPassword = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  bool obscureText=true;
  bool confirmObscureText=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.026,left: Get.width * 0.080,
              right: Get.width * 0.080 ),
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
              padding: EdgeInsets.only(
                  top: Get.height * 0.090,
                  left: Get.width * 0.080,
                  right: Get.width * 0.080),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonBackButton(name: "Create New Password".tr,),
                  Expanded(
                    child:  SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.080,
                            ),
                            SvgPicture.asset( "${StringConstants.svgPath}lockPassword.svg",height: Get.height*0.13,),
                            SizedBox(
                              height: Get.height * 0.035,
                            ),
                            Text(
                              'Your new password must be different\n from previously used password'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Get.height * 0.019,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grayColorNormal,
                                  fontFamily: StringConstants.poppinsRegular),
                            ),
                            SizedBox(
                              height: Get.height * 0.025,
                            ),
                            CustomTextField(
                              obscureText: obscureText,
                              controller: password,
                              hintText: "New Password".tr,
                              prefixIcon: "loginPassword.svg",
                              suffixIcon: InkWell(
                                onTap: (){
                                  setState(() {
                                    obscureText=!obscureText;
                                  });
                                },
                                child: SvgPicture.asset(StringConstants.svgPath + (obscureText?'eyeIcon.svg':'eyeShow.svg'),
                                    fit: BoxFit.scaleDown),
                              ),
                              validateText: 'Please enter New Password'.tr,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Must be at least 8 characters".tr,textAlign: TextAlign.start,style: TextStyle(
                                  fontSize: Get.height * 0.014,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grayColorNormal,
                                  fontFamily: StringConstants.poppinsRegular),),
                            ),
                            SizedBox(
                              height: Get.height * 0.025,
                            ),
                            CustomTextField(
                              obscureText: confirmObscureText,
                              controller: confirmPassword,
                              hintText: "confirm Password".tr,
                              prefixIcon: "loginPassword.svg",
                              suffixIcon: InkWell(
                                onTap: (){
                                  setState(() {
                                    confirmObscureText=!confirmObscureText;
                                  });
                                },
                                child: SvgPicture.asset(StringConstants.svgPath + (confirmObscureText?'eyeIcon.svg':'eyeShow.svg'),
                                    fit: BoxFit.scaleDown),
                              ),
                              validateText: 'Please enter Confirm Password'.tr,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("Both password must match".tr,style: TextStyle(
                                    fontSize: Get.height * 0.014,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grayColorNormal,
                                    fontFamily: StringConstants.poppinsRegular),)),
                            SizedBox(
                              height: Get.height * 0.025,
                            ),
                            InkWell(
                              onTap: ()async{
                                if (_formKey.currentState!.validate()) {
                                  var map = <String, dynamic>{};
                                  map['email'] = widget.email;
                                  map['token'] = widget.token;
                                  map['password'] = password.text;
                                  map['password_confirmation'] =
                                      confirmPassword.text;
                                  if(widget.countryCode!.isNotEmpty){
                                    map['country_code'] = widget.countryCode;
                                  }
                                  var isConnect= await checkConnectivity();
                                  if (isConnect == ConnectivityResult.mobile) {
                                    ResetPasswordModel resetPasswordModel =
                                    await CallService().resetPassword(map);
                                    if (resetPasswordModel.success!) {
                                      CommonDialog.showToastMessage('Password changed successfully. Please login'.tr);

                                      // CommonDialog.showToastMessage(
                                      //     resetPasswordModel.message.toString());
                                      Get.offAllNamed(RouteHelper
                                          .getPasswordResetAndRegisterSuccessfully(
                                          0));
                                    }
                                    else{
                                      CommonDialog.showToastMessage(resetPasswordModel.message.toString());

                                    }
                                  }else if(isConnect == ConnectivityResult.wifi){
                                    ResetPasswordModel resetPasswordModel =
                                    await CallService().resetPassword(map);
                                    if (resetPasswordModel.success!) {
                                      CommonDialog.showToastMessage(
                                          resetPasswordModel.message.toString());
                                      Get.offAllNamed(RouteHelper
                                          .getPasswordResetAndRegisterSuccessfully(
                                          0));
                                    }
                                    else{
                                      CommonDialog.showToastMessage(resetPasswordModel.message.toString());

                                    }
                                  }else{
                                    CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
                                  }
                                }
                                },
                              child: CustomButtonLogin(
                                buttonName: "Save".tr,
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
