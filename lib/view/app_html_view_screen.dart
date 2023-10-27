import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/package/cancellation_policy_response.dart';
import 'package:gagagonew/model/privacy_policy_response_model.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/string_constants.dart';
import '../model/terms_and_condition_response_model.dart';

class AppHtmlViewScreen extends StatefulWidget {
  const AppHtmlViewScreen({Key? key, this.apiKey, this.strHtml, this.title, required this.isAuth}) : super(key: key);
  final String? apiKey;
  final String? strHtml;
  final String? title;
  final bool? isAuth;

  @override
  State<AppHtmlViewScreen> createState() => _AppHtmlViewScreenState();
}

class _AppHtmlViewScreenState extends State<AppHtmlViewScreen> with WidgetsBindingObserver {
  String? strHtml;
  String title = "";
  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        init();
        // widget.title.toString();
        print("$state");
      });
    } else if (state == AppLifecycleState.paused) {
      setState(() {
        init();
        // widget.title.toString();
        print("$state");
      });
    } else if (state == AppLifecycleState.inactive) {
      setState(() {
        init();
        // widget.title.toString().tr;
        print("$state");
      });
    } else {
      print(state.toString());
    }
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint("widget.apiKey ${widget.apiKey}");
      if (widget.strHtml != null) {
        strHtml = widget.strHtml;
        setState(() {});
      } else if (widget.apiKey != null) {
        if (widget.apiKey == "terms-and-conditions") {
          getTermsAndConditions();
        } else if (widget.apiKey == "privacy-policy") {
          getPrivacyPolicy();
        } else if (widget.apiKey == "cancellation-policy") {
          getCancellationPolicy();
        }
      } else {
        // CommanDialog.showLoading();
      }
    });
  }

  Future getTermsAndConditions() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // CommanDialog.showLoading();
      TermsAndConditionResponseModel model = await CallService().getTermsAndConditions(widget.isAuth ?? false);
      // CommanDialog.hideLoading();
      if (model.success != null) {
        if (model.success == true) {
          // _onLoadHtmlStringExample(_controller, context, model.termsAndCondition.contentEnglish);
          if (model.termsAndCondition != null) {
            strHtml = model.termsAndCondition!.contentEnglish ?? "";
            setState(() {});
          }
        }
      }
    });
  }

  Future getPrivacyPolicy() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // CommanDialog.showLoading();
      PrivacyPolicyResponseModel model = await CallService().getPrivacyPolicy();
      // CommanDialog.hideLoading();
      if (model.success != null) {
        if (model.success == true) {
          // _onLoadHtmlStringExample(_controller, context, model.termsAndCondition.contentEnglish);
          if (model.privacyAndPolicy != null) {
            strHtml = model.privacyAndPolicy!.contentEnglish ?? "";
            title = model.privacyAndPolicy!.title ?? "";
            debugPrint(title);

            setState(() {});
          }
        }
      }
    });
  }

  Future getCancellationPolicy() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // CommanDialog.showLoading();
      CancellationPolicyResponse model = await CallService().getCancellationPolicy();
      // CommanDialog.hideLoading();
      if (model.status != null) {
        if (model.status == 200) {
          // _onLoadHtmlStringExample(_controller, context, model.termsAndCondition.contentEnglish);
          if (model.data != null) {
            strHtml = model.data!.fullDescription ?? "";
            title = "Cancellation Policy";
            debugPrint(title);

            print("strHtml  -> $strHtml");

            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("title $title title.tr  ${title.tr}");
    title = widget.title!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.width * 0.14, left: Get.width * 0.050, right: Get.width * 0.050),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: Get.width * 0.080,
                    child: SvgPicture.asset(
                      "${StringConstants.svgPath}backIcon.svg",
                      height: Get.height * 0.035,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title.tr,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: Get.height * 0.025, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.050,
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: Get.width * 0.04, bottom: Get.width * 0.04, left: Get.width * 0.050, right: Get.width * 0.050),
              child: HtmlWidget(
                strHtml ?? "",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }
}
