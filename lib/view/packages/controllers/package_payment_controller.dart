import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/package/google_pay_response_model.dart';
import 'package:gagagonew/model/simple_api_response.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/packages/controllers/package_details_controller.dart';
import 'package:gagagonew/view/packages/package_payment_status_screen.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import '../../../model/package/package_list_model.dart';
import 'payment_configurations.dart' as payment_configurations;

class PackagePaymentController extends GetxController {
  PackageDetailsController packageController = Get.put(PackageDetailsController());
  var selectedMode = 0.obs;
  var showAboutMe = true.obs;
  var readTerms = false.obs;
  var counterText = '500 '.obs;
  PackageListModelData? packageData;

  var inputFieldController = TextEditingController(text: "").obs;
  late final Pay payClient;

  var paymentItems = <PaymentItem>[];

  init() {
    payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(payment_configurations.defaultGooglePay),
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(payment_configurations.applePayLiveConfig),
    });
  }

  callBookMyTripApi(dynamic body) async {
    log("body --> $body");
    if (packageData!.appliedCouponCode != null) {
      body["coupon_code"] = packageData!.appliedCouponCode;
    }

    body["is_second_payment"] = packageController.packageData.value.isFirstPaymentDone;
    if (await CommonFunctions.checkInternet()) {
      SimpleApiResponse simpleApiResponse = await CallService().hitBookMyTripeApi(body);
      if (simpleApiResponse.status == 200) {
        Get.to( PackagePaymentStatusScreen());
      } else {
        CommonDialog.showToastMessage(simpleApiResponse.message.toString());
      }
    }
  }

  handleOnPaymentClick() {
    if (selectedMode.value == 0) {
      onPaypalClick();
    } else if (selectedMode.value == 1) {
      onGooglePayPressed();
    } else {
      onApplePayPressed();
    }
  }

  onPaypalClick() {
    Navigator.of(Get.overlayContext!).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            // Testing details
            /*  clientId: "AaKJduWA56dZQa8hv0Gjrg2yGUxRKzvj0xBAnpmZTpqlIORlAGoBxRqdzeb6T2LotBUjtd1ITZuo39Vr",
            secretKey: "EIFDCD7WSd4J11_g-DqPOINsLzx2hBZ02Qb4nPWbJUBfvIk-5NFVRjJGyAlbEpi-UufFydDMk8FsV3Rw",*/
            // Client Details
            clientId: "AW5IDNDlv22nMp6QJpcB037KmKWSCRbpHQvOLApGuyUIJo9VIa7m2D3_sk1agkCU0OAp6ptj6D4mwCY9",
            secretKey: "EFAaAcxM0EAA4pp-B-bA2_qXvHLC6NLRiOwln62XbOU9_Im8JAx-9O1PtGjHcNF4b3gGyUMs10W364Au",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": packageController.getPayAbleAmount(), // packageData!.getTotalCalculate(), // '10.12',
                  "currency": "USD",
                  "details": {"subtotal": packageController.getPayAbleAmount(), /* packageData!.getTotalCalculate(),*/ "shipping": '0', "shipping_discount": 0}
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {"name": packageData!.title ?? "", "quantity": 1, "price": packageController.getPayAbleAmount(), /* packageData!.getTotalCalculate(),*/ "currency": "USD"}
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              log("onSuccess: $params");
              // "package_id,
              // add_ons[],
              // transaction_id,
              // paid_amount,
              // payment_status,
              // payment_mode(paypal/gpay/applypay)
              // payment_response(optional)"

              var map = {
                "package_id": packageData!.id,
                "transaction_id": "",
                "payment_mode": "paypal",
                "paid_amount": packageController.getPayAbleAmount(), // packageData!.getTotalCalculate(),
                "total_amount": packageController.getUiTotalAmount(), //packageData!.getTotalCalculate(),
                "payment_status": "success",
                "payment_response": json.encode(params),
                // "coupon_id": ""
              };

              var mapData = getAdons(map);

              callBookMyTripApi(mapData);
            },
            onError: (error) {
              log("onError: $error");
            },
            onCancel: (params) {
              log('cancelled: $params');
            }),
      ),
    );
  }

  void onGooglePayPressed() async {
    try {
      paymentItems.clear();
      paymentItems.add(PaymentItem(
        label: 'Gagago Inc.',
        amount: packageController.getPayAbleAmount().toString(), // packageData!.getTotalCalculate(),
        status: PaymentItemStatus.final_price,
      ));

      final result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      print("data --> ${json.encode(result)}");
      GooglePayResponseModel response = GooglePayResponseModel.fromJson(result);
      var map = {
        "package_id": packageData!.id,
        "transaction_id": "",
        "payment_mode": "gpay",
        "paid_amount": packageController.getPayAbleAmount(), //packageData!.getTotalCalculate(),
        "total_amount": packageController.getUiTotalAmount(), //packageData!.getTotalCalculate(),
        "payment_status": "success",
        "payment_response": json.encode(result),
        // "coupon_id": ""
      };

      var mapData = getAdons(map);

      callBookMyTripApi(mapData);
    } catch (e) {
      log("onGooglePayPressed error--> $e");
    }

    // Send the resulting Google Pay token to your server / PSP
  }

  void onApplePayPressed() async {
    paymentItems.clear();
    paymentItems.add(PaymentItem(
      label: 'Gagago Inc.',
      amount: packageController.getPayAbleAmount().toString(), // packageData!.getTotalCalculate(),
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
        "package_id": packageData!.id,
        "transaction_id": response.paymentMethodData!.tokenizationData != null ? response.paymentMethodData!.tokenizationData!.token ?? "" : "",
        "payment_mode": "applepay",
        "paid_amount": packageController.getPayAbleAmount(), //packageData!.getTotalCalculate(),
        "total_amount": packageController.getUiTotalAmount(), //packageData!.getTotalCalculate(),
        "payment_status": "success",
        "payment_response": json.encode(result),
        // "coupon_id": ""
      };

      var mapData = getAdons(map);

      callBookMyTripApi(mapData);
    }
    // Send the resulting Google Pay token to your server / PSP
  }

  Map getAdons(Map map) {
    double addOnPrice = 0;
    if (packageData!.services != null) {
      var count = 0;
      List addons = [];
      for (int i = 0; i < packageData!.services!.length; i++) {
        if (packageData!.services![i].service != null) {
          if (packageData!.services![i].service!.isSelected) {
            map["add_ons[$count]"] = packageData!.services![i].service!.id;
            count = count + 1;
            addons.add(packageData!.services![i].service!.id);

            addOnPrice = addOnPrice + packageData!.services![i].service!.price!;
          }
        }
      }

      map["add_ons"] = addons;
    }
    return map;
  }
}
