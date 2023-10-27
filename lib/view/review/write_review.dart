import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/submit_review_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../controller/review_controller.dart';
import '../../utils/progress_bar.dart';

class WriteReviewPage extends StatefulWidget {
  String? userId;
  String? userName;
  WriteReviewPage({Key? key, this.userId, this.userName}) : super(key: key);

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double flexibleRating = 0.0;
  double positiveRating = 0.0;
  double senseHumourRating = 0.0;
  double respectfulRating = 0.0;
  double honestRating = 0.0;
  double openMindRating = 0.0;
  bool showAboutMe = true;
  String counterText = '500 ';
  ReviewController c = Get.find();

  TextEditingController experienceText = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    if (c.review!.isNotEmpty) {
      flexibleRating = c.review![0].flexibilityRate!.toDouble();
      positiveRating = c.review![0].positivityRate!.toDouble();
      senseHumourRating = c.review![0].senseOfHumorRate!.toDouble();
      respectfulRating = c.review![0].respectfulRate!.toDouble();
      honestRating = c.review![0].honestyRate!.toDouble();
      openMindRating = c.review![0].openMindRate!.toDouble();
      experienceText.text = c.review![0].comment.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: Get.height * 0.070,
            left: Get.width * 0.055,
            right: Get.width * 0.055),
        child: Column(
          children: [
            CommonBackButton(
              name: "Write Review".tr,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.030,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Flexible".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: flexibleRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                flexibleRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Positive".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: positiveRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              debugPrint("rating $rating");
                              setState(() {
                                positiveRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sense of Humor".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: senseHumourRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                senseHumourRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Respectful".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: respectfulRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                respectfulRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reliable".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: honestRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                honestRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Open Mind".tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w400,
                              fontFamily: StringConstants.poppinsRegular),
                        ),
                        RatingBar(
                            initialRating: openMindRating,
                            minRating: 1,
                            itemSize: Get.height * 0.035,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            ratingWidget: RatingWidget(
                              full: _image('assets/images/svg/star.svg'),
                              half: _image('assets/images/svg/star.svg'),
                              empty:
                                  _image('assets/images/svg/unselectstar.svg'),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                openMindRating = rating;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    getMultilineField(
                        "${"Have you met".tr} ${widget.userName!.trim()}?",
                        'assets/images/svg/about_me.svg',
                        experienceText,
                        false,
                        experienceText),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    InkWell(
                        onTap: () async {
                          if (flexibleRating.toInt() == 0 &&
                              positiveRating.toInt() == 0 &&
                              senseHumourRating.toInt() == 0 &&
                              respectfulRating.toInt() == 0 &&
                              honestRating.toInt() == 0 &&
                              openMindRating.toInt() == 0) {
                            CommonDialog.showToastMessage(
                                "Please review first".tr);
                          } else if (experienceText.text.isEmpty) {
                            CommonDialog.showToastMessage(
                                "Please leave a comment".tr);
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var map = <String, dynamic>{};
                            map['reported_by'] = prefs.getString('userId');
                            map['reported_to'] = widget.userId;
                            map['flexibility_rate'] = flexibleRating.round();
                            map['positivity_rate'] = positiveRating.round();
                            map['sense_of_humour_rate'] =
                                senseHumourRating.round();
                            map['respectful_rate'] = respectfulRating.round();
                            map['honesty_rate'] = honestRating.round();
                            map['open_mind_rate'] = openMindRating.round();
                            map['comment'] = experienceText.text;
                            if (c.review!.isNotEmpty) {
                              map['review_id'] = c.review![0].id;
                            }

                            if (c.review!.isNotEmpty) {
                              SubmitReviewModel submit =
                                  await CallService().editReview(map);
                              if (submit.success!) {
                                CommonDialog.showToastMessage(
                                    "Review updated successfully".tr);

                                Get.offAndToNamed(RouteHelper.getReviewsPage(
                                    widget.userId.toString()));
                              } else {
                                CommonDialog.showToastMessage(
                                    submit.message.toString());
                              }
                            } else {
                              SubmitReviewModel submit =
                                  await CallService().submitReview(map);
                              if (submit.success!) {
                                CommonDialog.showToastMessage(
                                    "Review submitted successfully".tr);
                                Get.offAndToNamed(RouteHelper.getReviewsPage(
                                    widget.userId.toString()));
                              } else {
                                CommonDialog.showToastMessage(
                                    submit.message.toString());
                              }
                            }
                          }
                        },
                        child: CustomButtonLogin(
                          buttonName: "Save & Exit".tr,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMultilineField(
      String name,
      String image,
      TextEditingController controller,
      bool obscuretext,
      TextEditingController text) {
    //TextEditingController controller = new TextEditingController(text: text.toString());
    return Container(
      margin:
          EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
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
        child: SizedBox(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLength: 500,
            onChanged: (value) {
              debugPrint("text length=====>>>>${text.text.length}");
              if (text.text.isEmpty) {
                showAboutMe = true;
                counterText = '500 ';
              } else {
                showAboutMe = false;
                counterText = '${500 - text.text.length} ';
                debugPrint('counterTxet $counterText');
              }
              setState(() {});
            },
            controller: controller,
            maxLines: 12,
            obscureText: obscuretext,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              counterText: counterText,
              counterStyle: TextStyle(
                  color: AppColors.grayColorNormal,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.016),
              hintText: name,
              prefixIcon: text.text.isEmpty
                  ? Container(
                      margin:  EdgeInsets.only(top: 0),
                      // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: Get.width * 0.015,
                            bottom: Get.height * 0.24),
                        child: SvgPicture.asset(image),
                      ),
                    )
                  : null,
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
    );
  }
}

Widget _image(String asset) {
  return SvgPicture.asset(
    asset,
    height: Get.height * 0.001,
    width: Get.width * 0.001,
  );
}
