import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';

class NoConnectionFoundScreen extends StatefulWidget {
  const NoConnectionFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoConnectionFoundScreen> createState() =>
      _NoConnectionFoundScreenState();
}

class _NoConnectionFoundScreenState
    extends State<NoConnectionFoundScreen> {



  @override
  void initState() {
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    // await CommonFunctions().getIdFromDeviceLang() == 2;
    return Center(
      child: Container(
        //color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: SvgPicture.asset("assets/images/svg/connectionsicon.svg"),
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.015,top: Get.height* 0.01),
              child: Text("You are new here!\n No connections yet.".tr,
                textAlign: TextAlign.center,style: TextStyle(
                    fontSize:  Get.locale! == StringConstants.LOCALE_SPANISH || Get.locale! == StringConstants.LOCALE_FRENCH ? Get.height * 0.020: Get.height * 0.030,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    color: AppColors.resetPasswordColor,
                    fontFamily: StringConstants.poppinsBold),),
            ),
            Text("Tap the globe icon near the bio to like a profile and make new connections.".tr,textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Get.height * 0.016,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                  color: AppColors.rememberMeColor,
                  fontFamily: StringConstants.poppinsRegular),),
            // Text("When you get connections, you can chat here.".tr,textAlign: TextAlign.center,
            //   style: TextStyle(
            //       fontSize: Get.height * 0.016,
            //       decoration: TextDecoration.none,
            //       fontWeight: FontWeight.w400,
            //       color: AppColors.rememberMeColor,
            //       fontFamily: StringConstants.poppinsRegular),),

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
      ),
    );
  }
}
