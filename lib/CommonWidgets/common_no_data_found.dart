import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';

class NoDataFoundScreen extends StatefulWidget {
  const NoDataFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoDataFoundScreen> createState() => _NoDataFoundScreenState();
}

class _NoDataFoundScreenState extends State<NoDataFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset("assets/images/svg/nodata.svg"),
          ),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015,top: Get.height* 0.01),
            child: Text("No Data",
              textAlign: TextAlign.center,style: TextStyle(
                  fontSize: Get.height * 0.030,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                  color: AppColors.resetPasswordColor,
                  fontFamily: StringConstants.poppinsBold),),
          ),
          Text("No Data. Please try again later",style: TextStyle(
              fontSize: Get.height * 0.016,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w400,
              color: AppColors.rememberMeColor,
              fontFamily: StringConstants.poppinsRegular),),

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