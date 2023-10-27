import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/view/packages/controllers/package_payment_controller.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

import '../../CommonWidgets/custom_button_login.dart';
import '../../constants/string_constants.dart';
import '../../utils/dimensions.dart';
import '../../utils/progress_bar.dart';
import '../app_html_view_screen.dart';
import 'controllers/package_details_controller.dart';
import 'package:gagagonew/model/package/package_details_model.dart';
import 'package:gagagonew/model/package/package_list_model.dart';

class PackagePaymentModeScreen extends StatefulWidget {
   PackagePaymentModeScreen({
    Key? key,
    required this.packageData
  }) : super(key: key);

  PackageListModelData packageData;

  @override
  State<PackagePaymentModeScreen> createState() => _PackagePaymentModeScreenState();
}

class _PackagePaymentModeScreenState extends State<PackagePaymentModeScreen> {
  PackagePaymentController controller = Get.put(PackagePaymentController());

  @override
  void initState() {
    controller.init();
    controller.packageData = widget.packageData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.11, bottom: Get.width * 0.06, left: Get.width * 0.055, right: Get.width * 0.055),
          child: Column(children: [
            _appBar(),
            SizedBox(
              height: Get.height * 0.044,
            ),
            Expanded(
                child: Column(
              children: [
                Obx(() {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _modeWidget(index: 0, isSelected: controller.selectedMode.value == 0, imagePath: 'ic_paypal.png'),
                      if (Platform.isAndroid) _gPayWidget(),
                      if (Platform.isIOS) _applePayWidget(),
                    ],
                  );
                }),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                _agreePolicy()
              ],
            )),
            InkWell(
                onTap: () async {
                  if (controller.readTerms.value) {
                    controller.handleOnPaymentClick();
                  } else {
                    CommonDialog.showToastMessage("Please accept User Agreement and Cancellation Policy");
                  }
                },
                child: CustomButtonLogin(
                  buttonName: "Next".tr,
                )),
          ])),
    );
  }

  _gPayWidget() {
    return FutureBuilder<bool>(
      future: controller.payClient.userCanPay(PayProvider.google_pay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Padding(padding: EdgeInsets.only(left: Get.width * 0.03), child: _modeWidget(index: 1, isSelected: controller.selectedMode.value == 1, imagePath: 'ic_g_pay.png'));
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _applePayWidget() {
    return FutureBuilder<bool>(
      future: controller.payClient.userCanPay(PayProvider.apple_pay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          print("snapshot.data --? apple ${snapshot.data}");
          if (snapshot.data == true) {
            return Padding(padding: EdgeInsets.only(left: Get.width * 0.03), child: _modeWidget(index: 2, isSelected: controller.selectedMode.value == 2, imagePath: 'ic_apple_pay.png'));
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _modeWidget({double? height, double? width, required int index, required isSelected, required String? imagePath}) {
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
          controller.selectedMode.value = index;
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

  _agreePolicy() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.only(top: 1),
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(vertical: -4),
                value: controller.readTerms.value,
                side: const BorderSide(width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onChanged: (value) {
                  if (value != null) {
                    controller.readTerms.value = value;
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            //  By clicking Agree & Join, you agree to Gagago Terms & Conditions and Privacy Policy.
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "By clicking Agree & Join, you agree to our ".tr,
                      style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular)),
                  TextSpan(
                      text: "Terms & Conditions".tr,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Get.toNamed(RouteHelper.getHtmlScreen(
                          //   apiKey: "terms-and-conditions",
                          //   title: "Terms and Conditions",
                          // ));
                          Get.to(const AppHtmlViewScreen(apiKey: "terms-and-conditions", title: "Terms & Conditions", isAuth: false));
                        },
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: Get.height * 0.018,
                          fontWeight: FontWeight.w500,
                          fontFamily: StringConstants.poppinsRegular,
                          color: AppColors.forgotPasswordColor)),
                  TextSpan(text: " and ".tr, style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular)),
                  TextSpan(
                      text: "Cancellation Policy".tr,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(const AppHtmlViewScreen(apiKey: "cancellation-policy", title: "Cancellation Policy", isAuth: false));

                          // Get.to(const AppHtmlViewScreen(apiKey: "terms-and-conditions", title: "Cancellation Policy", isAuth: false));
                        },
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: Get.height * 0.018,
                          fontWeight: FontWeight.w500,
                          fontFamily: StringConstants.poppinsRegular,
                          color: AppColors.forgotPasswordColor)),
                  TextSpan(
                      text: " and understand that my deposit is non-refundable when my spot is confirmed.".tr,
                      style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular)),
                ]),
              ),

              //   Text(
              //       'I have read and agree with the above terms and conditions'.tr,
              //       style: TextStyle(
              //           fontSize: Get.height * 0.015,
              //           fontWeight: FontWeight.w400,
              //           color: Colors.black,
              //           fontFamily:
              //           StringConstants.poppinsRegular)),
            )
          ],
        ),
      );
    });
  }

  _appBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            //Get.back();
            //Get.toNamed(click);
            Navigator.pop(context, true);
          },
          child: Container(
              width: Get.width * 0.090,
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                "${StringConstants.svgPath}backIcon.svg",
                height: Get.height * 0.035,
              )),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            "Payment Mode".tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: Dimensions.font20, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
          ),
        ),
        SizedBox(
          width: Get.width * 0.095,
        )
      ],
    );
  }
}
