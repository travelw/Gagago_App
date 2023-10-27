import 'package:fluttertoast/fluttertoast.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../view/dialogs/common_alert_dialog.dart';

class CommonDialog {
  static bool isShowLoader = false;
  static showLoading({String? title}) {
    if (isShowLoader) {
      return;
    }
    // Get.dialog(
    //   barrierDismissible: false,
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: Dimensions.width20,
                  ),
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(
                    width: Dimensions.width20,
                  ),
                  Text(
                    title ?? "Loading...".tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    isShowLoader = true;
  }

  static hideLoading() {
    if (isShowLoader) {
      isShowLoader = false;
      Get.back();
    }
  }

  static showErrorDialog(
      {String title = "Oops Error",
      String description = "Something went wrong "}) {
    Get.dialog(
      CommonAlertDialog(
        description: description,
        callback: () {
          if (Get.isDialogOpen!) Get.back();
        },
      ),
      // Dialog(
      //   shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text(
      //           title,
      //           style: const TextStyle(
      //               fontSize: 15,
      //               color: Colors.red,
      //               fontWeight: FontWeight.w600),
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         Text(
      //           description,
      //           style: const TextStyle(fontSize: 14),
      //         ),
      //         SizedBox(height: 10),
      //         Divider(height: 1,),
      //         GestureDetector(
      //             behavior: HitTestBehavior.translucent,
      //             onTap: () {
      //               if (Get.isDialogOpen!) Get.back();
      //             },
      //             child: Padding(
      //               padding: const EdgeInsets.only(top: 10.0),
      //               child: Text(
      //                 "Ok".tr,
      //                 style: const TextStyle(fontWeight: FontWeight.w700),
      //               ),
      //             )),
      //       ],
      //     ),
      //   ),
      // ),
      barrierDismissible: false,
    );
  }

  static showToastMessage(String text,
      {ToastGravity toastPosition = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastPosition,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
