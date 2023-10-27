import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/user_dashboard_response_model.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/view/chat/chat_page.dart';
import 'package:gagagonew/view/connections/connections_page.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../constants/string_constants.dart';
import '../model/carousel_model.dart';
import '../utils/stream_controller.dart';
import '../view/home/notifications_page.dart';

class GagagoHomeHeader extends StatefulWidget {
  bool showNewOption;
  bool menuIcon;
  int connectionCount = 0;
  int chatCount = 0;
  int likeCount = 0;
  int notificationCount = 0;
  Function()? callBackConnectionCount;
  Function()? callBackChatCount;
  Function()? callBackNotificationCountCount;

  GagagoHomeHeader(
      {Key? key,
      required this.showNewOption,
      required this.menuIcon,
      this.connectionCount = 0,
      this.chatCount = 0,
      this.likeCount = 0,
      this.notificationCount = 0,
      required this.callBackConnectionCount,
      required this.callBackChatCount,
      required this.callBackNotificationCountCount})
      : super(key: key);

  @override
  State<GagagoHomeHeader> createState() => _GagagoHomeHeaderState();
}

class _GagagoHomeHeaderState extends State<GagagoHomeHeader> {
  AppStreamController appStreamController = AppStreamController.instance;

  int? userMode;
  int? likeCount = 0;
  int? chatCount = 0;
  bool showNewOption = false;
  List<User> userList = [];
  int carouselCount = 0;
  // List<CarouselModel> carouselImage = [
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  //   CarouselModel(
  //     image: 'assets/images/png/profile.png',
  //   ),
  // ];

  Future updateList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User_dashboard_response_model model =
          await CallService().getUsersList(1, true);
      setState(() {
        userList = model.user!;
        userMode = model.userMode!;
        likeCount = model.likeCount;
        chatCount = model.chatCount;
        debugPrint("userMode $userMode");
      });
    });
  }

  bottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.010),
        height: Get.height * 0.4,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                  Text(
                    "Share Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height * 0.018,
                        color: Colors.black),
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () {
                      //Get.toNamed(RouteHelper.getWriteReviewPage());
                    },
                    child: Text(
                      "Write Review",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                  Divider(
                    color: AppColors.dividerColor,
                  ),
                  Text(
                    "Remove",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height * 0.018,
                        color: AppColors.redTextColor),
                  ),
                  Divider(
                    color: AppColors.dividerColor,
                  ),
                  Text(
                    "Block & Report".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height * 0.018,
                        color: AppColors.redTextColor),
                  ),
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: Get.width,
              height: Get.height * 0.016,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.radius15)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.070,
              child: Center(
                  child: Text(
                "Cancel".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: StringConstants.poppinsRegular,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height * 0.018,
                    color: Colors.black),
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: Get.width * 0.040, left: Get.width * 0.040),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "GagaGo",
                      style: TextStyle(
                          fontSize: Get.height * 0.050,
                          fontWeight: FontWeight.w400,
                          color: AppColors.gagagoLogoColor,
                          fontFamily: StringConstants.kaushanScriptRegular),
                    ),
                    SizedBox(
                      width: Get.width * 0.015,
                    ),
                    SvgPicture.asset(
                      "assets/images/svg/homePagePlaneIcon.svg",
                      height: Get.height * 0.042,
                    )
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Notifications(),
                            )).then((value) {
                          appStreamController.handleBottomTab.add(true);
                          if (value != null) {
                            debugPrint("Under then callBackChatCount");
                            widget.callBackNotificationCountCount!();
                          }
                        });
                      },
                      child: Container(
                        height: Get.height * 0.050,
                        width: Get.height * 0.050,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/png/bell.png",
                                height: Get.height * 0.035,
                              ),
                            ),
                            if (widget.notificationCount > 0)
                              Positioned(
                                right: 1,
                                top: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: (widget.notificationCount
                                              .toString()
                                              .length >
                                          2)
                                      ? Get.width * 0.05
                                      : Get.width * 0.040,
                                  width: (widget.notificationCount
                                              .toString()
                                              .length >
                                          2)
                                      ? Get.width * 0.05
                                      : Get.width * 0.040,
                                  decoration: BoxDecoration(
                                      color: AppColors.notfRedColor,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    (widget.notificationCount
                                                .toString()
                                                .length >
                                            2)
                                        ? "99+"
                                        : widget.notificationCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (widget.notificationCount
                                                    .toString()
                                                    .length >
                                                2)
                                            ? Get.height * 0.011
                                            : Get.height * 0.015),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.015,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConnectionsPage()),
                        ).then((value) {
                          if (value != null) {
                            widget.callBackConnectionCount!();
                          }
                        });
                        //Get.toNamed(RouteHelper.getConnectionsPage());
                      },
                      child: Container(
                        height: Get.height * 0.050,
                        width: Get.height * 0.050,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/images/svg/homePageWorld.svg",
                              // height: Get.height * 0.050,
                            ),
                            if (widget.connectionCount > 0)
                              Positioned(
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: (widget.connectionCount
                                              .toString()
                                              .length >
                                          2)
                                      ? Get.width * 0.05
                                      : Get.width * 0.040,
                                  width: (widget.connectionCount
                                              .toString()
                                              .length >
                                          2)
                                      ? Get.width * 0.05
                                      : Get.width * 0.040,
                                  decoration: BoxDecoration(
                                      color: AppColors.notfRedColor,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    (widget.connectionCount.toString().length >
                                            2)
                                        ? "99+"
                                        : widget.connectionCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (widget.connectionCount
                                                    .toString()
                                                    .length >
                                                2)
                                            ? Get.height * 0.011
                                            : Get.height * 0.015),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.015,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage()),
                        ).then((value) {
                          if (value != null) {
                            debugPrint("Under then callBackChatCount");
                            widget.callBackChatCount!();
                          }
                        });
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage()),
                        );*/
                      },
                      child: Container(
                        height: Get.height * 0.050,
                        width: Get.height * 0.050,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin:
                                      EdgeInsets.only(right: Get.width * 0.001),
                                  child: SvgPicture.asset(
                                    "assets/images/svg/go.svg",
                                    height: Get.height * 0.040,
                                  )),
                            ),
                            if (widget.chatCount > 0)
                              Positioned(
                                right: Get.width * 0.00,
                                top: Get.height * 0.001,
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      (widget.chatCount.toString().length > 2)
                                          ? Get.width * 0.05
                                          : Get.width * 0.040,
                                  width:
                                      (widget.chatCount.toString().length > 2)
                                          ? Get.width * 0.05
                                          : Get.width * 0.040,
                                  decoration: BoxDecoration(
                                      color: AppColors.notfRedColor,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    (widget.chatCount.toString().length > 2)
                                        ? "99+"
                                        : widget.chatCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (widget.chatCount
                                                    .toString()
                                                    .length >
                                                2)
                                            ? Get.height * 0.011
                                            : Get.height * 0.015),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.010,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
        ],
      ),
    );
  }
}
