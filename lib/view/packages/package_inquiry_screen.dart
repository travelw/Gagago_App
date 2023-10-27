import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../utils/dimensions.dart';
import '../../utils/progress_bar.dart';
import 'controllers/package_inquiry_controller.dart';

class PackageInquiryScreen extends StatefulWidget {
  const PackageInquiryScreen(
      {Key? key, required this.packageId, required this.packageName, required this.dates})
      : super(key: key);

  final int packageId;
  final String packageName;
  final String dates;

  @override
  State<PackageInquiryScreen> createState() => _PackageInquiryScreenState();
}

class _PackageInquiryScreenState extends State<PackageInquiryScreen> {
  final PackageInquiryController _controller =
      Get.put(PackageInquiryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: Get.width * 0.14,
            left: Get.width * 0.055,
            right: Get.width * 0.055),
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.030,
                    ),
                    getMultilineField(
                      'Write here..'.tr,
                      'assets/images/svg/about_me.svg',
                      false,
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    InkWell(
                        onTap: () async {

                          if(_controller.inputFieldController.value.text.trim().isNotEmpty) {
                            //SharedPreferences prefs = await SharedPreferences.getInstance();
                            var map = <String, dynamic>{};
                            map['package_id'] = widget.packageId;
                            map['message'] =
                                _controller.inputFieldController.value.text;
                            final submit =
                                await CallService().packageInquiry(map);
                            if (submit.status == 200) {
                              CommonDialog.showToastMessage(
                                  submit.message.toString());
                              Get.back();
                            } else {
                              CommonDialog.showToastMessage(
                                  'Something went wrong'.tr);
                            }
                          }
                        },
                        child: CustomButtonLogin(
                          buttonName: "Submit".tr,
                        )),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: Get.height * 0.034,
            // ),
            // Image.asset(
            //   "assets/images/png/dummy_ads.png",
            //   width: double.infinity,
            //   height: Get.height * 0.1,
            //   fit: BoxFit.fill,
            // )
          ],
        ),
      ),
    );
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
          child: SizedBox(
              width: Get.width * 0.090,
              child: SvgPicture.asset(
                "${StringConstants.svgPath}backIcon.svg",
                height: Get.height * 0.035,
              )),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                widget.packageName,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: Dimensions.font20,
                    color: AppColors.backTextColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: StringConstants.poppinsRegular),
              ),
              _rowIconText(
                  icon: "assets/images/png/ic_calender.png",
                  text: widget.dates,
                  innerPadded: Get.width * 0.008,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Get.height * 0.018,
                      color: AppColors.gagagoLogoColor,
                      fontFamily: StringConstants.poppinsRegular))
            ],
          ),
        ),
        SizedBox(
          width: Get.width * 0.095,
        )
      ],
    );
  }

  Widget getMultilineField(
    String name,
    String image,
    bool obscureText,
  ) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(
            top: Get.height * 0.010, bottom: Get.height * 0.010),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: AppColors.inputFieldBorderColor,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.inputFieldController.value.text.isEmpty)
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: Get.width * 0.026),
                  // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Get.height * 0.02,
                      right: Get.width * 0.015,
                    ),
                    child: SvgPicture.asset(image),
                  )),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: _controller.inputFieldController.value.text.isEmpty
                        ? Get.width * 0.01
                        : Get.width * 0.026),
                child: SizedBox(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLength: 500,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (value) {
                      debugPrint(
                          "text length=====>>>>${_controller.inputFieldController.value.text.length}");
                      if (_controller.inputFieldController.value.text.isEmpty) {
                        _controller.counterText.value = '500 ';
                      } else {
                        _controller.counterText.value =
                            '${500 - _controller.inputFieldController.value.text.length} ';
                        debugPrint(
                            'counterText ${_controller.counterText.value}');
                      }
                    },
                    controller: _controller.inputFieldController.value,
                    maxLines: 12,
                    obscureText: obscureText,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: StringConstants.poppinsRegular,
                        fontSize: Get.height * 0.016),
                    decoration: InputDecoration(
                      counterText: _controller.counterText.value,
                      counterStyle: TextStyle(
                          color: AppColors.grayColorNormal,
                          fontFamily: StringConstants.poppinsRegular,
                          fontSize: Get.height * 0.016),
                      hintText: name,
                      // prefixIcon: _controller.inputFieldController.value.text.isEmpty
                      //     ? Align(
                      //         alignment: Alignment.topCenter,
                      //         child: Column(
                      //           children: [
                      //             Container(
                      //                 alignment: Alignment.topCenter,
                      //                 margin: const EdgeInsets.only(top: 0),
                      //                 // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.only(
                      //                     top: Get.height * 0.015,
                      //                     right: Get.width * 0.015,
                      //                   ),
                      //                   child: SvgPicture.asset(image),
                      //                 )),
                      //           ],
                      //         ),
                      //       )
                      //     : null,
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: Get.width * 0.080),
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: StringConstants.poppinsRegular,
                          fontSize: Get.height * 0.016),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _rowIconText(
      {required String icon,
      required String text,
      double? iconSize,
      double? innerPadded,
      TextStyle? textStyle,
      MainAxisAlignment? mainAxisAlignment}) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Image.asset(
          icon,
          height: iconSize ?? Get.height * 0.019,
          width: iconSize ?? Get.height * 0.019,
        ),
        SizedBox(
          width: innerPadded ?? Get.width * 0.014,
        ),
        Text(
          text,
          // " 12-20 Aug 2023",
          style: textStyle ??
              TextStyle(
                  fontSize: Get.height * 0.021,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gagagoLogoColor,
                  fontFamily: StringConstants.poppinsRegular),
        )
      ],
    );
  }
}
