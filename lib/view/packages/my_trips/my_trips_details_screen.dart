import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/model/package/my_trips_model.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/view/packages/controllers/my_trips_controller.dart';
import 'package:get/get.dart';

import '../../../CommonWidgets/custom_button_login.dart';
import '../../../constants/string_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/progress_bar.dart';
import '../dialog/add_bank_details_dialog.dart';
import '../package_details_screen.dart';

class MyTripDetailsScreen extends StatefulWidget {
  final MyTripsModel myTripsModel;
  final int type;

  const MyTripDetailsScreen({Key? key, required this.myTripsModel, required this.type}) : super(key: key);

  @override
  State<MyTripDetailsScreen> createState() => _MyTripDetailsScreenState();
}

class _MyTripDetailsScreenState extends State<MyTripDetailsScreen> {
  MyTripsController controller = Get.put(MyTripsController());

  double tripRating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.14, bottom: Get.width * 0.06, left: Get.width * 0.055, right: Get.width * 0.055),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _appBar(),
                    SizedBox(
                      height: Get.height * 0.034,
                    ),
                    Text(
                      "Hope you had a blast!",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: Dimensions.font16, color: AppColors.defaultBlack, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                    ),
                    Text(
                      "Share your experience with us",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: Dimensions.font16, color: AppColors.alreadyHaveColor, fontWeight: FontWeight.w500, fontFamily: StringConstants.poppinsRegular),
                    ),
                    SizedBox(
                      height: Get.height * 0.025,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.02, top: Get.width * 0.02, bottom: Get.width * 0.02),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.loginHintTextFiledColor), borderRadius: const BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "${widget.myTripsModel.package?.title}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: Dimensions.font20, color: AppColors.defaultBlack, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                              )),
                              SizedBox(
                                width: Get.width * 0.09,
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: CachedNetworkImage(
                                  height: Get.height * 0.095,
                                  width: Get.width * 0.23,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.myTripsModel.package?.images?[0].image ?? "",
                                  maxHeightDiskCache: 300,
                                  maxWidthDiskCache: 300,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  errorWidget: (context, url, error) => Center(
                                    child: Image.asset(
                                      "assets/images/png/dummy_img_package.png",
                                      fit: BoxFit.cover,
                                      height: Get.height * 0.095,
                                      width: Get.width * 0.23,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(margin: EdgeInsets.symmetric(vertical: Get.height * 0.02), height: 1, color: AppColors.loginHintTextFiledColor),
                          Row(
                            children: [
                              Expanded(child: _tripDates(title: 'Trip Start', date: CommonFunctions.getDate(widget.myTripsModel.package?.startDate, opFormat: "dd MMM yyyy"))),
                              Expanded(child: _tripDates(title: 'Trip End', date: CommonFunctions.getDate(widget.myTripsModel.package?.endDate, opFormat: "dd MMM yyyy"))),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.034,
                    ),
                    if (widget.type == 3) _rateYourTrip(),
                    if (widget.type == 3) _reviewWidget(),
                    if (widget.type == 3) _buttonsWidget(),
                    if (widget.type == 1)
                      SizedBox(
                        height: Get.height * 0.020,
                      ),
                    if (widget.type == 1)
                      InkWell(
                          onTap: () async {
                            if (widget.myTripsModel.isRefundable == 1) {
                              showAlertDialog(context);
                            } else {
                              cancelTripDialog();
                            }
                          },
                          child: CustomButtonLogin(
                            buttonName: "Cancel Trip".tr,
                            backgroundColor: AppColors.headerGrayColor,
                          )),
                    if (widget.type != 2)
                      SizedBox(
                        height: Get.height * 0.020,
                      ),
                    if (widget.type != 2)
                      InkWell(
                          onTap: () async {
                            Get.to(PackageDetailsScreen(
                              packageData: null,
                              packageId: widget.myTripsModel.packageId!,
                            ))!
                                .then((value) {});
                          },
                          child: CustomButtonLogin(
                            buttonName: "View Package Details".tr,
                            backgroundColor: AppColors.blueColor,
                          )),
                  ]),
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
          )),
    );
  }

  cancelTripDialog() {
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
        style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
        child: Text(
          "Yes".tr,
          style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
        ),
        onPressed: () async {
          Get.back();
          controller.cancelMyTripeApi(
              packageId: widget.myTripsModel.packageId!,
              callback: () {
                Get.back(result: true);
              });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Cancel Trip".tr,
        style: TextStyle(color: Colors.red, fontSize: Get.height * 0.028, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular),
      ),
      content: Text(
        "Are your sure you want to cancel this trip?".tr,
        style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      actions: [
        Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBankDetailsDialog(
          title: "Bank details",
          description: 'Add bank details for refunds',
          callback: (name, number, routingNumber, accountType, bankName) {
            // _controller.cancellationPolicyModel

            controller.cancelMyTripeApi(
                packageId: widget.myTripsModel.packageId!,
                callback: () {
                  Get.back(result: true);
                });
          },
        );
      },
    );
  }

  _reviewWidget() {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.030,
        ),
        getMultilineField(
          'How was your experience?'.tr,
          'assets/images/svg/about_me.svg',
          false,
        ),
      ],
    );
  }

  _rateYourTrip() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.03,
        vertical: Get.width * 0.04,
      ),
      decoration: const BoxDecoration(color: AppColors.packageBgLightGrey, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Rate Your Trip",
              // " 12-20 Aug 2023",
              style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
            ),
          ),
          RatingBar(
              initialRating: 2,
              minRating: 1,
              itemSize: Get.height * 0.027,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              ratingWidget: RatingWidget(full: getStarIcon(Icons.star), half: getStarIcon(Icons.star_half), empty: getStarIcon(Icons.star_outline)),
              onRatingUpdate: (rating) {
                tripRating = rating;
              }),
        ],
      ),
    );
  }

  _buttonsWidget() {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.020,
        ),
        InkWell(
            onTap: () async {
              if (controller.inputFieldController.value.text.trim().isEmpty) {
                CommonDialog.showToastMessage("Please write your experience");
              } else {
                controller.giveTripRateApi({"package_id": widget.myTripsModel.packageId, "rating": tripRating, "review": controller.inputFieldController.value.text.trim()});
              }
            },
            child: CustomButtonLogin(
              buttonName: "Send Review".tr,
            )),
      ],
    );
  }

  Widget getStarIcon(IconData icon) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Icon(
        icon,
        color: const Color(0xFFFFB803),
        size: 34,
      ),
    );
  }

  Widget getMultilineField(
    String name,
    String image,
    bool obscuretext,
  ) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: AppColors.inputFieldBorderColor,
            width: 1.0,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(left: Get.width * 0.026),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.inputFieldController.value.text.isEmpty)
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
                margin: EdgeInsets.only(left: controller.inputFieldController.value.text.isEmpty ? Get.width * 0.01 : Get.width * 0.026),
                child: SizedBox(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLength: 500,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (value) {
                      debugPrint("text length=====>>>>${controller.inputFieldController.value.text.length}");
                      if (controller.inputFieldController.value.text.isEmpty) {
                        controller.counterText.value = '500 ';
                      } else {
                        controller.counterText.value = '${500 - controller.inputFieldController.value.text.length} ';
                        debugPrint('counterTxet ${controller.counterText.value}');
                      }
                    },
                    controller: controller.inputFieldController.value,
                    maxLines: 12,
                    obscureText: obscuretext,
                    style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                    decoration: InputDecoration(
                      counterText: controller.counterText.value,
                      counterStyle: TextStyle(color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
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
                      prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080),
                      hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }

  _tripDates({required String title, required String date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        ),
        _rowIconText(
            icon: "assets/images/png/ic_calender.png",
            text: date,
            innerPadded: Get.width * 0.008,
            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular))
      ],
    );
  }

  _rowIconText({required String icon, required String text, double? iconSize, double? innerPadded, TextStyle? textStyle}) {
    return Row(
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
          style: textStyle ?? TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        )
      ],
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
          child: Text(
            "Trip".tr,
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
