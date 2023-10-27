import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../constants/string_constants.dart';

class CustomButtonLogin extends StatelessWidget {
  String buttonName;

  Color? backgroundColor;
  CustomButtonLogin({Key? key, required this.buttonName, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: Get.height * 0.060,
      width: Get.width,
      decoration:  BoxDecoration(
          color: backgroundColor ??AppColors.buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        buttonName,
        style: TextStyle(
            fontSize: Get.height * 0.018,
            color: Colors.white,
            fontFamily: StringConstants.poppinsRegular,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
