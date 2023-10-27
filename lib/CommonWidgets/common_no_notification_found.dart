import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/notification_response_model.dart';
import 'package:get/get.dart';

class NoNotificationFoundScreen extends StatefulWidget {
  const NoNotificationFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoNotificationFoundScreen> createState() => _NoNotificationFoundScreenScreenState();
}

class _NoNotificationFoundScreenScreenState extends State<NoNotificationFoundScreen> {
  bool isLoading = false;
  List<Data> notificationsList = [];

  Future updateList() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationResponseModel responseModel = await CallService().getNotificationsList(0, false);
      setState(() {
        isLoading = false;
        notificationsList = responseModel.data!;
        debugPrint("NotificationsList $notificationsList");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.08),
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset("assets/images/svg/nonotification.svg"),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.015, top: Get.height * 0.01),
                child: Text(
                  "No Notification Yet!".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Get.locale! == StringConstants.LOCALE_SPANISH || Get.locale! == StringConstants.LOCALE_FRENCH ? Get.height * 0.020 : Get.height * 0.030,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                      color: AppColors.resetPasswordColor,
                      fontFamily: StringConstants.poppinsBold),
                ),
              ),
              InkWell(
                onTap: () {
                  updateList();
                },
                child: Text(
                  "Refresh!".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Get.height * 0.016,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      color: AppColors.forgotPasswordColor,
                      fontFamily: StringConstants.poppinsRegular),
                ),
              ),
            ],
          ),

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
    );
  }
}
