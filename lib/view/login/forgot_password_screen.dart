import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/common_back_button.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:get/get.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/forget_password_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/progress_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email=TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  String selectedCountryCode = '+1';
  bool isPhoneNumber=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.026,left: Get.width * 0.080,
              right: Get.width * 0.080 ),
          child: SvgPicture.asset(
            "${StringConstants.svgPath}bottomLogin.svg",
            height: Get.height * 0.19,
            fit: BoxFit.fitWidth,
          ),
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
                  CommonBackButton(name: "Forgot Password?".tr, click: RouteHelper.getLoginPage()),
                 Expanded(
                   child:  SingleChildScrollView(
                     child: Form(
                       key: _formKey,
                       child: Column(
                         children: [
                           SizedBox(
                             height: Get.height * 0.1,
                           ),
                           SvgPicture.asset( "${StringConstants.svgPath}forgotPasswordCenter.svg",height: Get.height*0.13,),
                           SizedBox(
                             height: Get.height * 0.060,
                           ),
                           Text(
                             'Enter your email. You will receive a 4 digits verification code.'.tr,
                             style: TextStyle(
                                 fontSize: Get.height*0.020,
                                 fontWeight: FontWeight.w400,
                                 color: AppColors.grayColorNormal,
                                 fontFamily: StringConstants.poppinsRegular),
                           ),
                           SizedBox(
                             height: Get.height * 0.025,
                           ),
                          /* CustomTextField(
                             hintText: "Phone number or email",
                             prefixIcon: "loginMessage.svg",
                             suffixIcon: "",
                             controller: email,
                             validateText: 'Please enter Phone number or email',
                             keyboardType: TextInputType.text,
                           ),*/
                           SizedBox(
                             child: TextFormField(
                               autofocus: false,
                               controller: email,
                               onChanged: (text){
                                 setState(() {
                                   isPhoneNumber=text.isNumericOnly;
                                 });
                               },
                               validator: (value) {
                                 if (value!.isEmpty) {
                                   return 'Please enter email'.tr;
                                 }
                                 return null;
                               },
                               decoration: InputDecoration(
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide:
                                   const BorderSide(color: AppColors.borderTextFiledColor, width: 0.0),
                                 ),
                                 hintText: "Please enter email".tr,
                                 hintStyle: TextStyle(
                                     fontFamily: StringConstants.poppinsRegular,
                                     fontWeight: FontWeight.w400,
                                     fontSize: Get.height * 0.018,
                                     color: AppColors.loginHintTextFiledColor),
                                 suffixIcon: SvgPicture.asset(StringConstants.svgPath,
                                     fit: BoxFit.scaleDown),
                                 prefixIcon: isPhoneNumber?Container(
                                     width: Get.width*0.15,
                                     alignment: Alignment.centerLeft,
                                     margin: EdgeInsets.only(
                                         left: Get.width * 0.055, right: Get.width * 0.025),
                                     child: !isPhoneNumber?SvgPicture.asset(
                                         '${StringConstants.svgPath}loginMessage.svg'):GestureDetector(
                                       onTap: () {
                                         showCountryPicker(
                                           context: context,
                                           showPhoneCode: true,
                                           // optional. Shows phone code before the country name.
                                           onSelect: (Country country) {
                                             setState(() {
                                               selectedCountryCode = '+${country.phoneCode}';
                                             });
                                           },
                                         );
                                       },
                                       child: Container(
                                         margin: EdgeInsets.only(
                                           left: Get.width * 0.010,
                                           right: Get.width * 0.010,
                                         ),
                                         child: Text(selectedCountryCode,
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontFamily: StringConstants.poppinsRegular,
                                                 fontSize: Get.height * 0.020)),
                                       ),
                                     )):
                                 Container(
                                     margin: EdgeInsets.only(
                                         left: Get.width * 0.055, right: Get.width * 0.025),
                                     child: SvgPicture.asset(
                                         '${StringConstants.svgPath}loginMessage.svg')),
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                               ),
                               keyboardType: TextInputType.text,
                               textInputAction: TextInputAction.done,
                             ),
                           ),
                           SizedBox(
                             height: Get.height * 0.038,
                           ),
                           InkWell(
                             onTap: ()async{

                               if (_formKey.currentState!.validate()) {
                                 var map = <String, dynamic>{};
                                 map['email'] = email.text;

                                 var langId = await CommonFunctions().getIdFromDeviceLang();

                                 map['langId'] = langId;

                                 if(isPhoneNumber){
                                   map['country_code']=selectedCountryCode.replaceFirst('+', '');
                                 }
                                 var isConnect= await checkConnectivity();
                                 if (isConnect == ConnectivityResult.mobile) {
                                   ForgetPasswordModel forgetPassModel= await CallService().forgetPassword(map);
                                   if(forgetPassModel.success!){
                                     CommonDialog.showToastMessage(forgetPassModel.message.toString());
                                     Get.toNamed(RouteHelper.getVerifyYourCodePage(email.text,isPhoneNumber?selectedCountryCode.replaceFirst('+', ''):""));
                                   }
                                   else{
                                     CommonDialog.showToastMessage(forgetPassModel.message.toString());

                                   }
                                 }else if (isConnect == ConnectivityResult.wifi) {

                                   ForgetPasswordModel forgetPassModel= await CallService().forgetPassword(map);
                                   if(forgetPassModel.success!){
                                     CommonDialog.showToastMessage(forgetPassModel.message.toString());
                                     Get.toNamed(RouteHelper.getVerifyYourCodePage(email.text,isPhoneNumber?selectedCountryCode.replaceFirst('+', ''):""));
                                   }
                                   else{
                                     CommonDialog.showToastMessage(forgetPassModel.message.toString());
                                   }
                                 }else{
                                   CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
                                 }

                               }


                             },
                             child: CustomButtonLogin(
                               buttonName: "Send".tr,
                             ),
                           ),
                           SizedBox(
                             height: Get.height * 0.012,
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
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.040),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}forgotPasswordBag.svg",
                  height: Get.height * 0.1,
                ),
              ),
            ),
          ],
        ));
  }
}
