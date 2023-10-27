import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/feedback_response_model.dart';
import 'package:get/get.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../utils/progress_bar.dart';

class FeedBackScreen extends StatefulWidget {

  const FeedBackScreen({Key? key}) : super(key: key);


  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  double flexibleRating=0;
  double positiveRating=1;
  double senseHumourRating=1;
  double respectfulRating=1;
  double honestRating=1;
  double openMindRating=1;
  bool showAboutMe = true;
  String counterText = '500 ';

  TextEditingController experienceText= TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top:Get.width * 0.14,
            left: Get.width * 0.055,
            right: Get.width * 0.055),
        child: Column(
          children: [
            CommonBackButton(
              name: "Send Feedback".tr,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.030,
                    ),
                    Text(
                      "Rate your experience".tr,
                      style: TextStyle(
                          fontSize: Get.height*0.022,
                          fontWeight: FontWeight.w400,
                          fontFamily: StringConstants.poppinsRegular),
                    ),
                    SizedBox(
                      height: Get.height * 0.010,
                    ),
                    RatingBar(
                        initialRating: flexibleRating,
                        minRating: 1,
                        itemSize: Get.height*0.035,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                        ratingWidget: RatingWidget(
                          full: _image('assets/images/svg/star.svg'),
                          half: _image('assets/images/svg/star.svg'),
                          empty: _image('assets/images/svg/unselectstar.svg'),
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            flexibleRating = rating;
                          });
                        }
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),

                    Container(
                      width: Get.width * 0.9,
                      height: 1,
                      color: AppColors.dividerColor,
                      margin: EdgeInsets.only(top: Get.height * 0.010),
                    ),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    Text(
                      "What can we do to make Gagago even better?".tr,
                      style: TextStyle(
                          fontSize: Get.height*0.020,
                          fontWeight: FontWeight.w600,
                          fontFamily: StringConstants.poppinsRegular),
                    ),
                    getMultilineField('Write here..'.tr, 'assets/images/svg/about_me.svg',
                        experienceText, false,experienceText),
                    SizedBox(
                      height: Get.height * 0.020,
                    ),
                    InkWell(
                        onTap: () async {
                          //SharedPreferences prefs = await SharedPreferences.getInstance();
                          var map = <String, dynamic>{};
                          map['ratings'] = flexibleRating.toInt();
                          map['message'] = experienceText.text;
                          SubmitFeedBackResponseModel submit= await CallService().submitFeedback(map);
                          if(submit.status==true){
                            // CommonDialog.showToastMessage(submit.message.toString().tr);
                            CommonDialog.showToastMessage('Thanks for your feedback'.tr);
                            Get.back();
                            //Get.offAndToNamed(RouteHelper.getReviewsPage(widget.userId.toString()));
                          }
                          else{
                            CommonDialog.showToastMessage(submit.message.toString().tr);
                          }
                        },
                        child: CustomButtonLogin(buttonName: "Submit".tr,)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMultilineField(String name, String image,
      TextEditingController controller, bool obscuretext, TextEditingController text) {
    //TextEditingController controller = new TextEditingController(text: text.toString());
    return  Container(
      margin:
      EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration:  BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border:  Border.all(
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
              setState(() {
              });
            },
            controller: controller,
            maxLines: 12,
            obscureText: obscuretext,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
            decoration:  InputDecoration(
              counterText: counterText,
              counterStyle: TextStyle(
                  color: AppColors.grayColorNormal,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.016),
              hintText: name,
              prefixIcon: text.text.isEmpty?
    Container(
    margin:  EdgeInsets.only(top:0),
    // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
    child:   Padding(
                padding: EdgeInsets.only(
                    right: Get.width * 0.015, bottom: Get.height * 0.24),
                child: SvgPicture.asset(image),
    )   ):null,
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

