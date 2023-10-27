import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../CommonWidgets/common_gagago_header.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/more_model.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  List<MoreModel> more=[
    MoreModel(name: "Yoga", image: "assets/images/svg/yogaMore.svg"),
    MoreModel(name: "Photography", image: "assets/images/svg/PhotographyHome.svg"),
    MoreModel(name: "Coffee", image: "assets/images/svg/coffeeHome.svg"),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            GagagoHeader(showNewOption: true,menuIcon: true,verticalMenu: true,),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: Get.width * 0.040,
                left: Get.width * 0.040,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 15,
                    children: List<Widget>.generate(
                        more.length,
                            (int index) {
                            return    Container(
                              height: Get.height * 0.086,
                              width: Get.width * 0.20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: AppColors.inputFieldBorderColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    more[index].image,
                                    height: Get.height * 0.038,
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.005,
                                  ),
                                  Text(
                                    more[index].name,
                                    style: TextStyle(
                                        fontFamily: StringConstants.poppinsRegular,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Get.height * 0.012,
                                        color: AppColors.gagagoLogoColor),
                                  )
                                ],
                              ),
                            );
                            } ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.018,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: Get.width * 0.040,
                left: Get.width * 0.040,
              ),
              child: Column(

                children: [
                  const Divider(
                    //color: Colors.red,
                    color: AppColors.dividerColor,
                    height: 3,
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/homePageWorld.svg",
                            height: Get.height * 0.055,
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          ),
                          SizedBox(
                            width: Get.width * 0.64,
                            child: Text(
                              "Donec laoreet eros id interdum Quisque interdum sapien eget.. more",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Get.height * 0.018,
                                  color: AppColors.gagagoLogoColor,
                                  fontFamily: StringConstants.poppinsRegular),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/borderStar.svg",
                            height: Get.height * 0.020,
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          ),
                          Text(
                            "4.9",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.height * 0.015,
                                color: AppColors.gagagoLogoColor,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),

    );
  }
}
