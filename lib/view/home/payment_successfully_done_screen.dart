import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/custom_button_login.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';


class PaymentSuccessFullyDoneScreen extends StatefulWidget {
  const PaymentSuccessFullyDoneScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessFullyDoneScreen> createState() => _PaymentSuccessFullyDoneScreenState();
}

class _PaymentSuccessFullyDoneScreenState extends State<PaymentSuccessFullyDoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.026,left: Get.width * 0.080,
              right: Get.width * 0.080 ),
          child: SvgPicture.asset(
            "${StringConstants.svgPath}bottomLogin.svg",
            height: Get.height * 0.18,
            fit: BoxFit.fitWidth,
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.090,
                  left: Get.width * 0.075,
                  right: Get.width * 0.075),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/gif/check.gif",height: Get.height*0.35,),
                  //  SvgPicture.asset( StringConstants.svgPath+ "forgotPasswordCenter.svg",height: Get.height*0.13,),
                  SizedBox(
                    height: Get.height * 0.035,
                  ),
                  Text(
                    'Payment Successfully Completed'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Get.height * 0.025,
                        fontWeight: FontWeight.w600,
                        color: AppColors.resetPasswordColor,
                        fontFamily: StringConstants.poppinsRegular),
                  ),
                  SizedBox(height: Get.height*0.015,),
                  SizedBox(
                    height: Get.height * 0.030,
                  ),

                  InkWell(
                    onTap: (){
                      Get.offAllNamed(RouteHelper.getBottomSheetPage());
                      /*Navigator.pop(context);*/
                      // );
                    },
                    child: CustomButtonLogin(
                      buttonName:"Back".tr,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.012,
                  )
                ],
              ),
            ),

           /* Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.040),
                child: SvgPicture.asset(
                  StringConstants.svgPath + "forgotPasswordBag.svg",
                  height: Get.height * 0.1,
                ),
              ),
            ),*/
          ],
        ));
  }
}
