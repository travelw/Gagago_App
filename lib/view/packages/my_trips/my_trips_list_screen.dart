import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/view/packages/controllers/my_trips_controller.dart';
import 'package:gagagonew/view/packages/my_trips/my_trips_details_screen.dart';
import 'package:get/get.dart';

import '../../../constants/string_constants.dart';
import '../../../utils/dimensions.dart';

class MyTripsListScreen extends StatefulWidget {
  const MyTripsListScreen({Key? key}) : super(key: key);

  @override
  State<MyTripsListScreen> createState() => _MyTripsListScreenState();
}

class _MyTripsListScreenState extends State<MyTripsListScreen> {
  MyTripsController controller = Get.put(MyTripsController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.myTripeApi(type: 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.14, bottom: Get.width * 0.06, left: Get.width * 0.055, right: Get.width * 0.055),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _appBar(),
            SizedBox(
              height: Get.height * 0.034,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _tabTitle(name: "Ongoing", index: 0, isSelected: controller.selectedTab.value == 0),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
                        _tabTitle(name: "Upcoming", index: 1, isSelected: controller.selectedTab.value == 1),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
                        _tabTitle(name: "Cancelled", index: 2, isSelected: controller.selectedTab.value == 2),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
                        _tabTitle(name: "Completed", index: 3, isSelected: controller.selectedTab.value == 3),
                      ],
                    ),
                  );
                }),
                Expanded(
                  child: MyTripsTabScreen(controller: controller),
                )
              ],
            )),
            // SizedBox(
            //   height: Get.height * 0.034,
            // ),
            // Image.asset(
            //   "assets/images/png/dummy_ads.png",
            //   width: double.infinity,
            //   height: Get.height * 0.1,
            //   fit: BoxFit.fill,
            // )
          ])),
    );
  }

  _tabTitle({required String name, required int index, required bool isSelected}) {
    return InkWell(
      onTap: () {
        controller.selectedTab.value = index;
        controller.myTripeApi(type: index);
      },
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: Dimensions.font16,
                color: isSelected ? AppColors.defaultBlack : AppColors.alreadyHaveColor,
                fontWeight: FontWeight.w500,
                fontFamily: StringConstants.poppinsRegular),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 2,
            width: 30,
            decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.transparent),
          )
        ],
      ),
    );
  }

  _appBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            //Get.back();
            //Get.toNamed(click);
            Navigator.pop(context, true);
          },
          child: SizedBox(
              width: Get.width * 0.090,
              child: SvgPicture.asset(
                "${StringConstants.svgPath}backIcon.svg",
                height: Get.height * 0.035,
              )),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            "My Trips".tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: Dimensions.font20, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
          ),
        ),
        SizedBox(
          width: Get.width * 0.095,
        )
      ],
    );
  }
}

class MyTripsTabScreen extends StatelessWidget {
  final MyTripsController controller;

  const MyTripsTabScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          itemCount: controller.listData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final model = controller.listData[index]; //MyTripsModel
            return InkWell(
              onTap: () {
                Get.to(MyTripDetailsScreen(
                  myTripsModel: model,
                  type: controller.selectedTab.value,
                ))!
                    .then((value) {
                  if (value != null) {
                    controller.myTripeApi(type: controller.selectedTab.value);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: Get.width * 0.02),
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015, vertical: Get.width * 0.015),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: AppColors.packageBgLightGrey),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: CachedNetworkImage(
                        height: Get.height * 0.095,
                        width: Get.width * 0.23,
                        fit: BoxFit.cover,
                        imageUrl: model.package?.images?[0].image ?? "",
                        maxHeightDiskCache: 300,
                        maxWidthDiskCache: 300,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => Center(
                          child: Image.asset(
                            "assets/images/png/dummy_img_package.png",
                            fit: BoxFit.cover,
                            height: Get.height * 0.095,
                            width: Get.width * 0.23,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.package?.title ?? "",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis, fontSize: Dimensions.font16, color: AppColors.defaultBlack, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                        ),
                        _rowIconText(
                            icon: "assets/images/png/ic_calender.png",
                            text: "${CommonFunctions.getDate(model.package?.startDate, opFormat: "dd")}-${CommonFunctions.getDate(model.package?.endDate, opFormat: "dd MMM yyyy")}", //12-20 Aug 2023
                            innerPadded: Get.width * 0.008,
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular))
                      ],
                    )),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )
                  ],
                ),
              ),
            );
          });
    });
  }

  _rowIconText({required String icon, required String text, double? iconSize, double? innerPadded, TextStyle? textStyle}) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: iconSize ?? Get.height * 0.019,
          width: iconSize ?? Get.height * 0.019,
        ),
        SizedBox(
          width: innerPadded ?? Get.width * 0.014,
        ),
        Text(
          text,
          // " 12-20 Aug 2023",
          style: textStyle ?? TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        )
      ],
    );
  }
}
