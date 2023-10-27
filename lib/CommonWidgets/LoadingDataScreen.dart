import 'package:flutter/material.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';


class LoadingDataScreen extends StatefulWidget {
  const LoadingDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*  Container(
            alignment: Alignment.center,
            child: SvgPicture.asset("assets/images/svg/nodata.svg"),
          ),*/
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015, top: Get.height * 0.01),
            child: Text(
              "Welcome to Gagago".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Get.height * 0.038, fontWeight: FontWeight.w400, decoration: TextDecoration.none, color: AppColors.resetPasswordColor, fontFamily: StringConstants.poppinsBold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.07, right: Get.width * 0.07),
            child: Column(
              children: [
                Text(
                  "Loading...".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Get.height * 0.020,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      color: AppColors.rememberMeColor,
                      fontFamily: StringConstants.poppinsRegular),
                ),
              ],
            ),
          ),

          /*Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015,top: Get.height* 0.01),
            child: Text("Back",style: TextStyle(
                fontSize: Get.height * 0.016,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
                color: AppColors.forgotPasswordColor,
                fontFamily: StringConstants.poppinsRegular),),
          ),*/
        ],
      ),
    );
  }
}
