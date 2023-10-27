import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/chat_list_model.dart';
import 'package:get/get.dart';

class NoMessageFoundScreen extends StatefulWidget {
  const NoMessageFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoMessageFoundScreen> createState() => _NoMessageFoundScreenState();
}

class _NoMessageFoundScreenState extends State<NoMessageFoundScreen> {
  bool isLoading = false;
  List<Data>? chats = [];

  updateList() {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ChatListModel model = await CallService().getChatList(false, 0,0);
      setState(() {
        isLoading = false;
        chats = model.data!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refreshEvenList,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/images/svg/messageicon.svg"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.015, top: Get.height * 0.01),
                    child: Text(
                      "You are new here!".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Get.height * 0.030,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                          color: AppColors.resetPasswordColor,
                          fontFamily: StringConstants.poppinsBold),
                    ),
                  ),
                  Text(
                    'Tap the globe icon near the bio to like a profile. After people have liked your profile back, you can then start chatting with each other. Don\'t worry if you don\'t immediately start chatting with everyone you like – just keep putting your best foot forward with a great profile and keep an eye out for those mutual globe likes!'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Get.height * 0.016,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        color: AppColors.rememberMeColor,
                        fontFamily: StringConstants.poppinsRegular),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshEvenList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      updateList();
    });
    return;
  }
}
