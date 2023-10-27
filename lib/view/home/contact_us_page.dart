import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/contact_us_response_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/common_back_button.dart';
import '../../../CommonWidgets/custom_button_login.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/string_constants.dart';

class ContactUs extends StatefulWidget {
  String? userName;
  String? email;

  ContactUs({Key? key, this.userName, this.email}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController name = TextEditingController(text: '');
  TextEditingController email = TextEditingController(text: '');
  TextEditingController comment = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  bool showAboutMe = true;
  String counterText = '500 ';
  @override
  void initState() {
    super.initState();
    name.text = widget.userName ?? "";
    email.text = widget.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Get.width * 0.14, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CommonBackButton(
                  name: 'Contact Us'.tr,
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                getInputField('Name'.tr, 'assets/images/svg/name.svg', name, false),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                getInputField1('Email'.tr, 'assets/images/svg/email.svg', email, false),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                getMultilineField('Comment'.tr, 'assets/images/svg/about_me.svg', comment, false, comment),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                InkWell(
                  onTap: () async {
                    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email.text);
                    if (name.text.isEmpty) {
                      CommonDialog.showToastMessage('Please enter name'.tr);
                    } else if (email.text.isEmpty) {
                      CommonDialog.showToastMessage('Please enter email'.tr);
                    } else if (emailValid == false) {
                      CommonDialog.showToastMessage('Please enter valid email'.tr);
                    } else if (comment.text.isEmpty) {
                      CommonDialog.showToastMessage('Please enter comment'.tr);
                    } else {
                      var map = <String, dynamic>{};
                      map['name'] = name.text.trim();
                      map['email'] = email.text.trim();
                      //map['phone_number'] = phone.text;
                      map['message'] = comment.text;
                      ContactUsResponseModel login = await CallService().contactUs(map);
                      if (login.status == 200) {
                        //Get.toNamed(RouteHelper.getThankYou());
                        Get.offAllNamed(RouteHelper.getThankYou());
                      } else {
                        CommonDialog.showToastMessage(login.message.toString());
                      }
                    }
                  },
                  child: CustomButtonLogin(
                    buttonName: "Submit".tr,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getInputField(String name, String image, TextEditingController controller, bool obscureText) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.026),
        child: SizedBox(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              hintText: name,
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: Get.width * 0.015),
                child: SvgPicture.asset(image),
              ),
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
              hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget getInputField1(String name, String image, TextEditingController controller, bool obscureText) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.026),
        child: SizedBox(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              hintText: name,
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: Get.width * 0.015),
                child: SvgPicture.asset(image),
              ),
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
              hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget getMultilineField(String name, String image, TextEditingController controller, bool obscureText, TextEditingController text) {
    //TextEditingController controller =  TextEditingController(text: text.toString());
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.026),
        child: SizedBox(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLength: 500,
            /*   buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) {
              int utf8Length = utf8.encode(text.text).length;
              debugPrint("UtfLength---->$utf8Length");
              return Text(
                '$utf8Length/$maxLength',
                style: Theme.of(context).textTheme.caption,
              );
            },
             inputFormatters: [
              //LengthLimitingTextInputFormatter(500)
               _Utf8LengthLimitingTextInputFormatter(text.text.length),
            ],*/
            onChanged: (value) {
              debugPrint("text length=====>>>>${text.text.length}");
              if (text.text.isEmpty) {
                showAboutMe = true;
                counterText = '500 ';
              } else {
                showAboutMe = false;
                counterText = '${500 - text.text.length} ';
                debugPrint('counterTxet $counterText');
              }
              setState(() {});
            },
            maxLines: 12,
            obscureText: obscureText,
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              counterText: counterText,
              counterStyle: TextStyle(color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
              hintText: name,
              prefixIcon: text.text.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 0),
                      // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
                      child: Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.015, bottom: Get.height * 0.24),
                        child: SvgPicture.asset(image),
                      ),
                    )
                  : null,
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080),
              hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _Utf8LengthLimitingTextInputFormatter extends TextInputFormatter {
  _Utf8LengthLimitingTextInputFormatter(this.maxLength) : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength > 0 && bytesLength(newValue.text) > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old value.
      if (bytesLength(oldValue.text) == maxLength) {
        return oldValue;
      }
      return truncate(newValue, maxLength);
    }
    return newValue;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    var newValue = '';
    if (bytesLength(value.text) > maxLength) {
      var length = 0;

      value.text.characters.takeWhile((char) {
        var nbBytes = bytesLength(char);
        if (length + nbBytes <= maxLength) {
          newValue += char;
          length += nbBytes;
          return true;
        }
        return false;
      });
    }
    return TextEditingValue(
      text: newValue,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, newValue.length),
        extentOffset: min(value.selection.end, newValue.length),
      ),
      composing: TextRange.empty,
    );
  }

  static int bytesLength(String value) {
    return utf8.encode(value).length;
  }
}
