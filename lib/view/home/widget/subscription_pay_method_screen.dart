import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/view/home/controller/subscription_payment_controller.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

import '../../../CommonWidgets/custom_button_login.dart';
import '../../../constants/color_constants.dart';
import '../../../utils/dimensions.dart';

class SubscriptionPayMethodScreen extends StatefulWidget {
  SubscriptionPayMethodScreen({Key? key, required this.onPay}) : super(key: key);

  Function(int) onPay;

  @override
  State<SubscriptionPayMethodScreen> createState() => _SubscriptionPayMethodScreenState();
}

class _SubscriptionPayMethodScreenState extends State<SubscriptionPayMethodScreen> {
  SubscriptionPaymentController controller = Get.put(SubscriptionPaymentController());

  int selectedMode = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.030),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
              padding: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010, top: Get.height * 0.020),
              // height: Get.height * 0.6,
              child: Column(
                children: [
                  Text(
                    "Choose payment method",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: Dimensions.font20, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                  ),
                  SizedBox(
                    height: Get.height * 0.030,
                  ),
                  Row(
                    children: [
                      modeWidget(
                          index: 0,
                          isSelected: selectedMode == 0,
                          imagePath: 'ic_paypal.png',
                          callBack: (value) async {
                            selectedMode = value;
                            setState(() {});
                          }),
                      if (Platform.isAndroid)
                        gPayWidget((value) {
                          selectedMode = value;
                          setState(() {});
                        }),
                      if (Platform.isIOS)
                        applePayWidget((value) {
                          selectedMode = value;
                          setState(() {});
                        }),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.030,
                  ),
                ],
              )),
          SizedBox(
            height: Get.height * 0.030,
          ),
          InkWell(
              onTap: () {
                Get.back();
                widget.onPay(selectedMode);
              },
              child: Container(
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.blueColor),
                child: CustomButtonLogin(
                  buttonName: "Pay".tr,
                ),
              ))
        ],
      ),
    );
  }

  gPayWidget(Function(int) callback) {
    return FutureBuilder<bool>(
      future: controller.payClient.userCanPay(PayProvider.google_pay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Padding(padding: EdgeInsets.only(left: Get.width * 0.03), child: modeWidget(index: 1, isSelected: selectedMode == 1, imagePath: 'ic_g_pay.png', callBack: callback));
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  applePayWidget(Function(int) callback) {
    return FutureBuilder<bool>(
      future: controller.payClient.userCanPay(PayProvider.apple_pay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("snapshot.data --? apple ${snapshot.data}");
          if (snapshot.data == true) {
            return Padding(padding: EdgeInsets.only(left: Get.width * 0.03), child: modeWidget(index: 2, isSelected: selectedMode == 2, imagePath: 'ic_apple_pay.png', callBack: callback));
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  modeWidget({required int index, required isSelected, required String? imagePath, required Function(int) callBack}) {
    if (isSelected) {
      return Container(
        height: Get.width / 5.5,
        width: Get.width / 3.7,
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: AppColors.extraLightBlue),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 5),
              child: DottedBorder(
                color: AppColors.blueColor,
                borderType: BorderType.RRect,
                dashPattern: [5, 4],
                strokeWidth: 1,
                radius: Radius.circular(15),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.009, horizontal: Get.width * 0.000),
                  child: Image.asset(
                    "${StringConstants.pngPath}$imagePath",
                    height: Get.width / 7.5,
                    width: Get.width / 5.7,
                  ),
                )),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                "${StringConstants.pngPath}ic_green_check_circle.png",
                fit: BoxFit.fill,
                height: 20,
                width: 20,
              ),
            )
          ],
          //
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callBack(index);
        },
        child: Container(
          height: Get.width / 5.5,
          width: Get.width / 3.7,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderTextFiledColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
          child: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.009, horizontal: Get.width * 0.000),
            child: Image.asset(
              "${StringConstants.pngPath}$imagePath",
              height: Get.width / 7.5,
              width: Get.width / 5.7,
            ),
          )),
        ),
      );
    }
  }
}
