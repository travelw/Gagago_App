import 'package:flutter/material.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/package/my_trips_model.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';

class MyTripsController extends GetxController {
  var selectedTab = 0.obs;

  var inputFieldController = TextEditingController(text: "").obs;
  var counterText = ''.obs;

  RxList<MyTripsModel> listData = <MyTripsModel>[].obs;

  //hit api for get tripe list
  myTripeApi({required int type}) async {
    if (await CommonFunctions.checkInternet()) {
      final packageListModel = await CallService().hitMyTripApi(type, showLoader: true);
      if (packageListModel.status == 200) {
        if (packageListModel.data != null) {
          listData.value = packageListModel.data!;
        }
      } else {
        CommonDialog.showToastMessage(packageListModel.message.toString());
      }
    }
  }

  //hit api for get tripe list
  cancelMyTripeApi({required int packageId, Function? callback}) async {
    if (await CommonFunctions.checkInternet()) {
      var map = {"package_id": packageId};
      final responseModel = await CallService().cancelTrip(
        map,
      );
      if (responseModel.status == 200) {
        CommonDialog.showToastMessage(responseModel.message.toString());
        if(callback != null){
          callback();
        }
      } else {
        CommonDialog.showToastMessage(responseModel.message.toString());
      }
    }
  }

  //hit api for rating of tripe
  giveTripRateApi(dynamic body) async {
    if (await CommonFunctions.checkInternet()) {
      final simpleApi = await CallService().giveTripRateApi(body);
      if (simpleApi.status == 200) {
        Get.back();
      } else {
        CommonDialog.showToastMessage(simpleApi.message.toString());
      }
    }
  }
}
