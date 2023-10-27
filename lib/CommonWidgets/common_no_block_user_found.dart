import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';

class NoBlockUserFoundScreen extends StatefulWidget {
  const NoBlockUserFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoBlockUserFoundScreen> createState() => _NoBlockUserFoundScreenState();
}

class _NoBlockUserFoundScreenState extends State<NoBlockUserFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        /*crossAxisAlignment: CrossAxisAlignment.center,*/
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.05,right: Get.width * 0.05),
            alignment: Alignment.center,
            child: SvgPicture.asset("assets/images/svg/blockUser.svg"),
          ),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015),
            child: Text('You haven’t blocked any user'.tr,
              textAlign: TextAlign.center,style: TextStyle(
                  fontSize: Get.height * 0.022,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  color: AppColors.resetPasswordColor,
                  fontFamily: StringConstants.poppinsBold),),
          ),
        ],
      ),
    );
  }
}