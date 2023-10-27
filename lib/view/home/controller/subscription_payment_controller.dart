import 'dart:convert';
import 'dart:developer';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/package/google_pay_response_model.dart';
import 'package:gagagonew/model/simple_api_response.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/home/widget/subscription_pay_method_screen.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import '../../../CommonWidgets/web_view_class.dart';
import 'package:gagagonew/view/packages/controllers/payment_configurations.dart' as payment_configurations;

class SubscriptionPaymentController extends GetxController {
  var selectedMode = 0.obs;
  int? planId;
  String? planAmount;
  String userId = "";
  int? isSubscribe;
  int? autoRenewNotificationEnabled = 0;

  late final Pay payClient;
  bool isInitialized = false;

  var paymentItems = <PaymentItem>[];

  init() {
    if (isInitialized == false) {
      payClient = Pay({
        PayProvider.google_pay: PaymentConfiguration.fromJsonString(payment_configurations.defaultGooglePay),
        PayProvider.apple_pay: PaymentConfiguration.fromJsonString(payment_configurations.applePayLiveConfig),
      });
      isInitialized = true;
    }
  }

  callSubscriptionApi(dynamic body, {required Function() callback}) async {
    log("body --> $body");
    // body["coupon_code"] = packageData!.appliedCouponCode;

    if (await CommonFunctions.checkInternet()) {
      SimpleApiResponse simpleApiResponse = await CallService().hitSubscriptionApi(body);
      if (simpleApiResponse.success ?? false) {
        Get.toNamed(RouteHelper.getPaymentSuccess())!.then((value) {
          if (value != null) {
            Get.back(result: true);
          }
        });

        // Get.to(PackagePaymentStatusScreen(
        //   onBack: () {
        //     Get.back(result: true);
        //   },
        // ));
      } else {
        CommonDialog.showToastMessage(simpleApiResponse.message.toString());
      }
    }
  }

  void onGooglePayPressed({required Function() callback}) async {
    try {
      paymentItems.clear();
      paymentItems.add(PaymentItem(
        label: 'Total',
        amount: planAmount ?? "0",
        status: PaymentItemStatus.final_price,
      ));

      final result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      print("data --> ${json.encode(result)}");
      GooglePayResponseModel response = GooglePayResponseModel.fromJson(result);
      var map = {
        "user_id": userId,
        "plan_id": planId,
        "transaction_id": "",
        "paid_by": "google",
        "payment_response": json.encode(result),
        "auto_renewal": autoRenewNotificationEnabled
        // "coupon_id": ""
      };

      callSubscriptionApi(map, callback: callback);
    } catch (e) {
      log("onGooglePayPressed error--> $e");
    }

    // Send the resulting Google Pay token to your server / PSP
  }

  void onApplePayPressed({required Function() callback}) async {
    paymentItems.clear();
    paymentItems.add(PaymentItem(
      label: 'Total',
      amount: planAmount ?? "0",
      status: PaymentItemStatus.final_price,
    ));

    final result = await payClient.showPaymentSelector(
      PayProvider.apple_pay,
      paymentItems,
    );
    print(result.toString());

    print("data --> ${json.encode(result)}");
    GooglePayResponseModel response = GooglePayResponseModel.fromJson(result);
    if (response.paymentMethodData != null) {
      var map = {
        "user_id": userId,
        "plan_id": planId,
        "transaction_id": response.paymentMethodData!.tokenizationData != null ? response.paymentMethodData!.tokenizationData!.token ?? "" : "",
        "paid_by": "apple",
        "payment_response": json.encode(result),
        "auto_renewal": autoRenewNotificationEnabled
      };

      callSubscriptionApi(map, callback: callback);
    }
    // Send the resulting Google Pay token to your server / PSP
  }

  showPaymentMethodSheet({required Function() callback}) {
    Get.bottomSheet(SubscriptionPayMethodScreen(onPay: (type) async {
      if (type == 0) {
        await Get.to(CommonWebView(userId, planId!));
        isSubscribe = 1;
        callback();
      } else if (type == 1) {
        onGooglePayPressed(callback: callback);
      } else if (type == 2) {
        // apple pay
        onApplePayPressed(callback: callback);
      }
    }));
  }
}
