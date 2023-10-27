// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gagagonew/Service/call_service.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../constants/color_constants.dart';
// import '../constants/string_constants.dart';
// import '../model/terms_and_condition_response_model.dart';
// import '../utils/progress_bar.dart';
// import 'package:flutter_html/flutter_html.dart';
//
//
// class AppWebViewScreen extends StatefulWidget {
//   const AppWebViewScreen({Key? key, /*this.url,*/ this.title, this.apiKey, this.isAuth}) : super(key: key);
//   // final String? url;
//   final String? title;
//   final String? apiKey;
//   final bool? isAuth;
//
//   @override
//   State<AppWebViewScreen> createState() => _AppWebViewScreenState();
// }
//
// class _AppWebViewScreenState extends State<AppWebViewScreen> {
//   final Completer<WebViewController> _controller = Completer<WebViewController>();
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   Future<void> onLoadHtmlStringExample(WebViewController controller, BuildContext context, String strHtml) async {
//     await controller.loadHtmlString(strHtml);
//   }
//   init() {
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//
//
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (widget.apiKey != null) {
//         if (widget.apiKey == "terms-and-conditions") {
//           getTermsAndConditions();
//
//         }
//       } else {
//         CommonDialog.showLoading();
//       }
//     });
//   }
//
//   Future getTermsAndConditions() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       CommonDialog.showLoading();
//       TermsAndConditionResponseModel model = await CallService().getTermsAndConditions(widget.isAuth??false);
//       CommonDialog.hideLoading();
//       if (model.success != null) {
//         if (model.success == true) {
//           // onLoadHtmlStringExample(_controller.t, context, model.termsAndCondition.contentEnglish);
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                   child: InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: SizedBox(
//                       width: Get.width * 0.080,
//                       child: SvgPicture.asset(
//                         "${StringConstants.svgPath}backIcon.svg",
//                         height: Get.height * 0.035,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       widget.title ?? "",
//                       maxLines: 1,
//                       style: TextStyle(
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: Get.height * 0.025,
//                           color: AppColors.backTextColor,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: StringConstants.poppinsRegular),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 30,
//                 )
//               ],
//             ),
//             Expanded(
//               child: WebView(
//                 initialUrl: widget.url,
//                 javascriptMode: JavascriptMode.unrestricted,
//                 onWebViewCreated: (WebViewController webViewController) {
//                   _controller.complete(webViewController);
//                   CommonDialog.hideLoading();
//
//                   // setState(() {
//                   //   isLoading = false;
//                   // });
//                 },
//                 onProgress: (int progress) {
//                   debugPrint('WebView is loading (progress : $progress%)');
//                   // setState(() {
//                   //   isLoading = true;
//                   // });
//                 },
//                 javascriptChannels: <JavascriptChannel>{
//                   toasterJavascriptChannel(context),
//                 },
//                 navigationDelegate: (NavigationRequest request) {
//                   if (request.url.startsWith('https://www.youtube.com/')) {
//                     debugPrint('blocking navigation to $request}');
//                     return NavigationDecision.navigate;
//                   }
//                   debugPrint('allowing navigation to $request');
//                   return NavigationDecision.navigate;
//                 },
//                 onPageStarted: (String url) {
//                   debugPrint('Page started loading: $url');
//                 },
//                 onPageFinished: (String url) {
//                   debugPrint('Page finished loading: $url');
//                 },
//                 gestureNavigationEnabled: true,
//                 backgroundColor: const Color(0x00000000),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   JavascriptChannel toasterJavascriptChannel(BuildContext context) {
//     return JavascriptChannel(
//         name: 'Toaster',
//         onMessageReceived: (JavascriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         });
//   }
// }
