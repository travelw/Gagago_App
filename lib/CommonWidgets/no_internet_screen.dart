import 'package:flutter/material.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset("assets/images/png/no_internet_image.png",width:Get.width * 0.3 ,height:Get.height * 0.3 ,),
          ),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015,top: Get.height* 0.01),
            child: Text("No Internet Connection".tr,
              textAlign: TextAlign.center,style: TextStyle(
                  fontSize: Get.height * 0.030,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                  color: AppColors.resetPasswordColor,
                  fontFamily: StringConstants.poppinsBold),),
          ),
        ],
      ),
    );
  }
}
