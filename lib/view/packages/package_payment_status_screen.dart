import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/custom_button_login.dart';
import '../../constants/string_constants.dart';
import '../../utils/dimensions.dart';

class PackagePaymentStatusScreen extends StatefulWidget {
  PackagePaymentStatusScreen({Key? key, this.onBack}) : super(key: key);

  Function()? onBack;

  @override
  State<PackagePaymentStatusScreen> createState() => _PackagePaymentStatusScreenState();
}

class _PackagePaymentStatusScreenState extends State<PackagePaymentStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onBack != null) {
          widget.onBack!();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.09, left: Get.width * 0.1, right: Get.width * 0.1),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    "assets/gif/check.gif",
                    height: Get.height * 0.25,
                  ),
                  //  SvgPicture.asset( StringConstants.svgPath+ "forgotPasswordCenter.svg",height: Get.height*0.13,),
                  SizedBox(
                    height: Get.height * 0.035,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                    child: Text(
                      "Payment Successfully Completed".tr,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(fontSize: Dimensions.font26, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.044,
                  ),
                  InkWell(
                      onTap: () async {
                        if (widget.onBack != null) {
                          Get.back();
                          widget.onBack!();
                        } else {
                          Get.back();
                          Get.back();
                          Get.back(result: true);
                        }
                      },
                      child: CustomButtonLogin(
                        buttonName: "Back".tr,
                      )),
                ])),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.016, left: Get.width * 0.080, right: Get.width * 0.080),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}bottomLogin.svg",
                  height: Get.height * 0.15,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
