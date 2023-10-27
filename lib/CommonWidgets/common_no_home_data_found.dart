import 'package:flutter/material.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/user_dashboard_response_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoHomeDataFoundScreen extends StatefulWidget {
  NoHomeDataFoundScreen({Key? key, required this.callback}) : super(key: key);
  Function()? callback;

  @override
  State<NoHomeDataFoundScreen> createState() => _NoHomeDataFoundScreenState();
}

class _NoHomeDataFoundScreenState extends State<NoHomeDataFoundScreen> {
  bool isLoading = false;
  List<User> userList = [];
  int? userMode;

  Future updateList() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userFName = prefs.getString('userFirstName')!;
    String userLName = prefs.getString('userLastName')!;
    //userName = userFName + " " + userLName;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User_dashboard_response_model model = await CallService().getUsersList(1, true);
      setState(() {
        isLoading = false;
        userList = model.user!;
        userMode = model.userMode!;
        debugPrint("userFName $userFName");
        debugPrint("userLName $userLName");
        debugPrint("userMode $userMode");
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
          /*  Container(
            alignment: Alignment.center,
            child: SvgPicture.asset("assets/images/svg/nodata.svg"),
          ),*/
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.015, top: Get.height * 0.01),
            child: Text(
              "Welcome to Gagago".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Get.height * 0.038, fontWeight: FontWeight.w400, decoration: TextDecoration.none, color: AppColors.resetPasswordColor, fontFamily: StringConstants.poppinsBold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.07, right: Get.width * 0.07),
            child: Column(
              children: [
                Text(
                  "When you select common travel destinations and interests, you will see suggested connections here.".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Get.height * 0.017,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      color: AppColors.rememberMeColor,
                      fontFamily: StringConstants.poppinsRegular),
                ),
                InkWell(
                  onTap: () {
                    widget.callback!();
                    // updateList();
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
