import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../RouteHelper/route_helper.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/profile_verification_model.dart';
import '../../model/reset_password_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/progress_bar.dart';

class VerifyYourProfile extends StatefulWidget {
  String email;
  String countryCode;
  VerifyYourProfile({Key? key, required this.email,required this.countryCode }) : super(key: key);
  @override
  State<VerifyYourProfile> createState() => _VerifyYourProfileState();
}

class _VerifyYourProfileState extends State<VerifyYourProfile> {
  final String requiredNumber = "1234";
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Image.asset(
          "${StringConstants.pngPath}verify.png",

          fit: BoxFit.fitWidth,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.1,
                  left: Get.width * 0.080,
                  right: Get.width * 0.080),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonBackButton(
                      name: /*widget.isForgotPassword?*/ "Verify OTP".tr/*: "Verify Your Profile".tr*/,
                      ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.1,
                            ),
                            SvgPicture.asset(
                              "${StringConstants.svgPath}messageVerifyScreen.svg",
                              height: Get.height * 0.13,
                            ),
                            SizedBox(
                              height: Get.height * 0.060,
                            ),
                            Text(
                              'Please enter the 4 digit code you received.'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Get.height*0.020,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grayColorNormal,
                                  fontFamily: StringConstants.poppinsRegular),
                            ),

                            SizedBox(
                              height: Get.height * 0.030,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: Get.width * 0.055,
                                  left: Get.width * 0.055,
                                  top: 15),
                              child: PinCodeTextField(
                                controller: pinController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter verification code'.tr;
                                  }
                                  return null;
                                },
                                appContext: context,
                                length: 4,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  debugPrint(value.toString());
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: Get.height * 0.072,
                                  fieldWidth: Get.width * 0.13,
                                  inactiveColor: Colors.grey,
                                  activeColor: Colors.grey,
                                  selectedColor: Colors.grey,
                                ),
                                onCompleted: (value) {
                                  if (value == requiredNumber) {
                                    debugPrint("valid pin");
                                  } else {
                                    debugPrint("invalid pin");
                                  }
                                },
                              ),
                            ),
                            // CustomTextField(
                            //   hintText: "Phone number or email",
                            //   prefixIcon: "loginMessage.svg",
                            //   suffixIcon: "",
                            //   keyboardType: TextInputType.text,
                            // ),
                            SizedBox(
                              height: Get.height * 0.030,
                            ),
                            InkWell(
                              onTap: ()async{
                                if (_formKey.currentState!.validate()) {
                                  var map = <String, dynamic>{};
                                  map['email'] = widget.email;
                                  map['token'] = pinController.text;
                                  if(widget.countryCode.isNotEmpty){
                                    map['country_code'] = widget.countryCode;
                                  }
                                  var isConnect= await checkConnectivity();
                                  if (isConnect == ConnectivityResult.mobile) {
                                    ProfileVerificationModel
                                    profileVerificationModel =
                                    await CallService().profileVerification(map);
                                    if (profileVerificationModel.success!) {
                                      CommonDialog.showToastMessage(
                                          profileVerificationModel.message
                                              .toString());
                                      Get.offAllNamed(
                                          RouteHelper.getCreateNewPasswordPage(widget.email,pinController.text,widget.countryCode));
                                    }
                                    else{
                                      CommonDialog.showToastMessage(profileVerificationModel.message.toString());

                                    }
                                  }else if (isConnect == ConnectivityResult.wifi){
                                    ProfileVerificationModel
                                    profileVerificationModel =
                                    await CallService().profileVerification(map);
                                    if (profileVerificationModel.success!) {
                                      CommonDialog.showToastMessage(
                                          profileVerificationModel.message
                                              .toString());
                                      Get.offAllNamed(
                                          RouteHelper.getCreateNewPasswordPage(widget.email,pinController.text,widget.countryCode));
                                    }
                                    else{
                                      CommonDialog.showToastMessage(profileVerificationModel.message.toString());

                                    }
                                  }else{
                                    CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
                                  }
                                }
                              },
                              child: CustomButtonLogin(
                                buttonName: "Verify".tr,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.012,
                            ),
                            InkWell(
                              onTap: () async {
                                var map = <String, dynamic>{};
                                map['email'] = widget.email;
                                var langId = await CommonFunctions().getIdFromDeviceLang();

                                map['langId'] = langId;
                                ResetPasswordModel forgetPassModel= await CallService().resendCode(map);
                                if(forgetPassModel.success!){
                                  CommonDialog.showToastMessage(forgetPassModel.message.toString());
                                }
                                else{
                                  CommonDialog.showToastMessage(forgetPassModel.message.toString());
                                }
                              },
                              child: Text(
                                "Resend Code".tr,
                                style: TextStyle(
                                  fontSize: Get.height*0.020,
                                  color: AppColors.forgotPasswordColor,
                                    fontFamily: StringConstants.poppinsRegular,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.040, right: Get.width * 0.060),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}verifyTopImage.svg",
                  height: Get.height * 0.070,
                ),
              ),
            ),
          ],
        ));
  }
}
