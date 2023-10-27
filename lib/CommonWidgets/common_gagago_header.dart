import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/view/chat/chat_page.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/string_constants.dart';
import '../model/carousel_model.dart';

class GagagoHeader extends StatefulWidget {
   bool showNewOption;
   bool menuIcon;
   bool verticalMenu;

   GagagoHeader({Key? key, required this.showNewOption, required this.menuIcon,required this.verticalMenu})
      : super(key: key);

  @override
  State<GagagoHeader> createState() => _GagagoHeaderState();
}

class _GagagoHeaderState extends State<GagagoHeader> {
  int carouselCount = 0;
  List<CarouselModel> carouselImage = [
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
    CarouselModel(
      image: 'assets/images/png/profile.png',
    ),
  ];

  void bottomSheet() {
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
                 SizedBox(height: Get.height*0.020,),
                  Text(
                    "Share Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height*0.018,
                        color: Colors.black),
                  ),
                  Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: (){
                      //Get.toNamed(RouteHelper.getWriteReviewPage());
                    },
                    child: Text(
                      "Write Review",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height*0.018,
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
                        fontSize: Get.height*0.018,
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
                        fontSize: Get.height*0.018,
                        color: AppColors.redTextColor),
                  ),
                  SizedBox(height: Get.height*0.020,),
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
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)),
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
                        fontSize: Get.height*0.018,
                        color: Colors.black),
              )),
            ),
          ],
        ),
      ),
    );
  }

  void openPersonalInfoPage(){
   // Get.toNamed(RouteHelper.getMyProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    onTap: (){
                      Get.toNamed(RouteHelper.getConnectionsPage());
                    },
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/images/svg/homePageWorld.svg",
                          height: Get.height * 0.055,
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: Get.height * 0.020,
                            width: Get.width * 0.040,
                            decoration: BoxDecoration(
                                color: AppColors.notfRedColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(100))),
                            child: Center(
                                child: Text(
                              "0",
                              style: TextStyle(color: Colors.white,fontSize: Get.height*0.015),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.035,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatPage()),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                            height: Get.height * 0.070,
                            width: Get.width * 0.075,
                            child: SvgPicture.asset(
                              "assets/images/svg/go.svg",
                              height: Get.height * 0.055,
                            )),
                        Positioned(
                          right: -1,
                          top: Get.height*0.006,
                          child: Container(
                            height: Get.height * 0.020,
                            width: Get.width * 0.040,
                            decoration: const BoxDecoration(
                                color: AppColors.notfRedColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                            child: Center(
                                child: Text(
                                  "0",
                                  style: TextStyle(color: Colors.white,fontSize: Get.height*0.015),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.020,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.015,
        ),
        Padding(
          padding: EdgeInsets.only(
              right: Get.width * 0.040, left: Get.width * 0.040),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF74EE15),
                            Color(0xFF4DEEEA),
                            Color(0xFF4DEEEA),
                            Color(0xFFFFE700),
                            Color(0xFFFFE700),
                            Color(0xFFFFAE1D),
                            Color(0xFFFE9D00),
                            Color(0xFFEB7535),
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                        ),
                        shape: BoxShape.circle),
                    child: Padding(
                      //this padding will be you border size
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                AssetImage('assets/images/png/profilepic.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.015,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: Get.height * 0.020,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gagagoLogoColor,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          ),
                          (widget.showNewOption == true)
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(5)),
                                      color: AppColors.buttonColor),
                                  height: Get.height * 0.024,
                                  width: Get.width * 0.1,
                                  child: Center(
                                      child: Text(
                                    "New",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Get.height * 0.018),
                                  )),
                                )
                              : Container()
                        ],
                      ),
                      Text(
                        "Del Mar, California",
                        style: TextStyle(
                            fontSize: Get.height * 0.016,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gagagoLogoColor,
                            fontFamily: StringConstants.poppinsRegular),
                      )
                    ],
                  ),
                ],
              ),
              (widget.menuIcon == true)
                  ? InkWell(
                      onTap: () {
                        if(widget.verticalMenu){
                          bottomSheet();
                        }else{
                          openPersonalInfoPage();
                        }
                      },
                      child: Icon(
                        widget.verticalMenu?Icons.more_vert:Icons.more_horiz,
                        size: Get.height * 0.040,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.015,
        ),
        Stack(
          children: [
            CarouselSlider(
              items: carouselImage.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: Get.width,
                        decoration: const BoxDecoration(color: Colors.amber),
                        child: Image.asset(
                          i.image,
                          fit: BoxFit.fill,
                        ));
                  },
                );
              }).toList(),
              options: CarouselOptions(
                  height: Get.height * 0.49,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      carouselCount = index;
                    });
                  }),
            ),
            Positioned(
              bottom: Get.height * 0.040,
              child: SizedBox(
                width: Get.width,
                child: Align(
                  alignment: Alignment.center,
                  child: CarouselIndicator(
                    height: 1,
                    width: Get.width * 0.080,
                    color: Colors.white,
                    count: carouselImage.length,
                    index: carouselCount,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
