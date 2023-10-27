import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/string_constants.dart';

class CustomTextField extends StatelessWidget {
  String hintText;
  String prefixIcon;
  Widget? suffixIcon;
  TextInputType keyboardType;
  TextEditingController? controller;
  bool? obscureText=false;
  String? validateText;
  CustomTextField({Key? key,required this.hintText,required this.prefixIcon,this.suffixIcon,required this.keyboardType,this.controller,this.obscureText=false,this.validateText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        autofocus: false,
        obscureText: obscureText!,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return validateText;
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            BorderSide(color: AppColors.borderTextFiledColor,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            BorderSide(color: AppColors.borderTextFiledColor,),
          ),

          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w400,
              fontSize: Get.height * 0.018,
              color: AppColors.loginHintTextFiledColor),
          suffixIcon: suffixIcon,
          prefixIcon: Container(
              margin: EdgeInsets.only(
                  left: Get.width * 0.055, right: Get.width * 0.025),
              child: SvgPicture.asset(
                  StringConstants.svgPath + prefixIcon)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
