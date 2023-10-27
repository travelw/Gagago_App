import 'package:flutter/material.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'common_back_button.dart';

class CommonWebView extends StatefulWidget {
  String? userId;
  int? planId;

  CommonWebView(this.userId, this.planId, {Key? key}) : super(key: key);

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  String userId = "";
  String planId = "";



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
              name: "",
            ),
            // Expanded(
            //   child: WebView(
            //     javascriptMode: JavascriptMode.unrestricted,
            //     // initialUrl: 'https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/charge/${widget.userId.toString()}/${widget.planId.toString()}',
            //     initialUrl: 'https://api.gagagoapp.com/api/charge/${widget.userId.toString()}/${widget.planId.toString()}',
            //     allowsInlineMediaPlayback: true,
            //     initialMediaPlaybackPolicy:
            //     AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
            //     onPageStarted: (String url) {
            //       debugPrint('Page started loading: $url');
            //       if (url.contains("success")) {
            //         Get.toNamed(RouteHelper.getPaymentSuccess());
            //         /* Get.back(result: 'success');*/
            //
            //         //Get.back();
            //
            //       }
            //     },
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CommonWebViewSubscription extends StatefulWidget {
  String? userId;
  String? productId;

  CommonWebViewSubscription(this.userId, this.productId, {Key? key}) : super(key: key);

  @override
  State<CommonWebViewSubscription> createState() => _CommonWebViewSubscriptionState();
}

class _CommonWebViewSubscriptionState extends State<CommonWebViewSubscription> {
  String userId = "";
  String planId = "";



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
              name: "",
            ),
            // Expanded(
            //   child: WebView(
            //     javascriptMode: JavascriptMode.unrestricted,
            //     // initialUrl: 'https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/charge/${widget.userId.toString()}/${widget.planId.toString()}',
            //     initialUrl: 'https://api.gagagoapp.com/api/charge/${widget.userId.toString()}/${widget.productId.toString()}',
            //     allowsInlineMediaPlayback: true,
            //     initialMediaPlaybackPolicy:
            //     AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
            //     onPageStarted: (String url) {
            //       debugPrint('Page started loading: $url');
            //       if (url.contains("success")) {
            //         Get.toNamed(RouteHelper.getPaymentSuccess());
            //         /* Get.back(result: 'success');*/
            //
            //         //Get.back();
            //
            //       }
            //     },
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
