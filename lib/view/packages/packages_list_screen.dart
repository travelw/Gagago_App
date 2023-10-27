import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/view/home/notifications_page.dart';
import 'package:gagagonew/view/packages/controllers/package_list_controller.dart';
import 'package:gagagonew/view/packages/package_details_screen.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PackagesListScreen extends StatefulWidget {
  const PackagesListScreen({Key? key}) : super(key: key);

  @override
  State<PackagesListScreen> createState() => _PackagesListScreenState();
}

class _PackagesListScreenState extends State<PackagesListScreen> with WidgetsBindingObserver {
  final PackageListController _controller = Get.put(PackageListController());

  @override
  void initState() {
    debugPrint("initState: initState");
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.searchController.value.text = "";
      _controller.callPackageListApi();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed() {
    _controller.searchController.value.text = "";
  }

  void onPaused() {
    // TODO: implement onPaused
  }
  void onInactive() {
    // TODO: implement onInactive
  }
  void onDetached() {
    // TODO: implement onDetached
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              /// App Bar
              _appBar(),
              SizedBox(
                height: Get.width * 0.02,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _controller.refreshPackageList,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.040, vertical: Get.width * 0.020),
                    child: Column(
                      children: [
                        /// Search Field
                        _searchField(),

                        /// Packages List
                        _packagesList()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                width: Get.width * 0.040,
                height: double.infinity,
                color: Colors.white,
              )),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: Get.width * 0.040,
                height: double.infinity,
                color: Colors.white,
              ))
        ],
      ),
    ));
  }

  _packagesList() {
    return Obx(() {
      return _controller.packageListItems.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
              child: Text(
                "No package available",
                style: TextStyle(fontSize: Get.height * 0.025, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _packageItem,
              itemCount: _controller.packageListItems.length,
            );
    });
  }

  Widget _packageItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Get.to(PackageDetailsScreen(packageData: _controller.packageListItems[index]))!.then((value) {
          if (value != null) {
            _controller.callPackageListApi();
          }
        });
      },
      child: Container(
        decoration: const BoxDecoration(color: AppColors.packageBgLightGrey, borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: EdgeInsets.only(top: Get.width * 0.03, bottom: Get.width * 0.02),
        child: Column(
          children: [
            _packageImages(context, index),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Get.width * 0.03,
                horizontal: Get.width * 0.030,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        _controller.packageListItems[index].title ?? "",
                        // "Penida Island, Indonasia",
                        style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/borderStar.svg",
                            height: Get.height * 0.019,
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          ),
                          Text(
                            "${_controller.packageListItems[index].averageRating ?? 0}",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.0050,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/png/ic_calender.png",
                        height: Get.height * 0.019,
                      ),
                      Text(
                        " ${CommonFunctions.convertDateToDDMMMYYY(
                          _controller.packageListItems[index].startDate,
                        )} - ${CommonFunctions.convertDateToDDMMMYYY(
                          _controller.packageListItems[index].endDate,
                        )}",
                        // " 12-20 Aug 2023",
                        style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.0050,
                  ),
                  Text(
                    "\$${CommonFunctions.formatPriceWithComma(_controller.packageListItems[index].totalPrice.toString())}",
                    style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _emptyImage() {
    return Container(
        height: Get.width - (Get.width * 0.25),
        width: Get.width - (Get.width * 0.040),
        alignment: Alignment.center,
        child: SizedBox(
          height: Get.width - (Get.width * 0.7),
          width: Get.width - (Get.width * 0.7),
          child: Image.asset(
            // 'assets/images/png/dummy_img_package.png',
            'assets/images/png/splash_icon.png',
            fit: BoxFit.contain,
          ),
        ));
  }

  _packageImages(BuildContext context, int index) {
    var indicatorController = PageController(viewportFraction: 1, keepPage: true);
    if (_controller.packageListItems[index].images == null) {
      return _emptyImage();
    }
    if (_controller.packageListItems[index].images != null) {
      if (_controller.packageListItems[index].images!.isEmpty) {
        return _emptyImage();
      }

    }
    return SizedBox(
      height: Get.width - (Get.width * 0.25),
      width: Get.width - (Get.width * 0.040),
      child: Stack(
        children: [
          PageView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _controller.packageListItems[index].images!.length,
              pageSnapping: true,
              clipBehavior: Clip.none,
              controller: indicatorController,
              onPageChanged: (page) {
                print("page  -> $page");
                // _controller.packageList[index].currentIndex = page;
                // if (page >= _controller.packageListItems[index].images!.length) {
                //   // _controller.indicatorController.value.animateToPage(0,
                //   //     duration: const Duration(milliseconds: 500),
                //   //     curve: Curves.easeInToLinear);
                //   indicatorController.jumpToPage(0);
                // } else {
                //   _controller.currentPage.value = page;
                // }
              },
              itemBuilder: (context, pagePosition) {
                return SizedBox();
              }),
          CarouselSlider(
              // carouselController: indicatorController,
              items: _controller.packageListItems[index].images!.map((i) {
                // print("CheckIn Image ${ i.imageName.toString()}");

                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: Get.width,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: Get.width,
                          imageUrl: i.image ?? "",
                          maxHeightDiskCache: 1300,
                          maxWidthDiskCache: 1300,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => Center(
                            child: Image.asset(
                              // 'assets/images/png/dummy_img_package.png',
                              'assets/images/png/splash_icon.png',
                              fit: BoxFit.fitHeight,
                              height: Get.width - (Get.width * 0.65),
                              width: Get.width - (Get.width * 0.10),
                            ),
                          ),
                        ));
                  },
                );
              }).toList(),
              options: CarouselOptions(
                  height: Get.height * 0.57,
                  viewportFraction: 1,
                  onPageChanged: (innerIndex, reason) {
                    _controller.packageList[index].currentIndex = innerIndex;
                    // setState(() {
                    //   carouselCount = index;
                    // });
                    // indicatorController.jumpToPage(index);
                    indicatorController.animateToPage(innerIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  })),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: indicatorController,
                  count: _controller.packageListItems[index].images!.length,
                  axisDirection: Axis.horizontal,
                  effect: ScrollingDotsEffect(
                      fixedCenter: true,
                      activeStrokeWidth: 1.5,
                      activeDotScale: 1.6,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 10,
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.white.withOpacity(0.5),
                      activeDotColor: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  _searchField() {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.005, bottom: Get.height * 0.005),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.026),
        child: SizedBox(
          child: TextField(
            controller: _controller.searchController.value,
            onChanged: (v) {
              _controller.callPackageListApi(showLoader: false);
            },
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              hintText: "${'Where to'.tr}?",
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: Get.width * 0.015),
                child: SvgPicture.asset(
                  'assets/images/svg/ic_search.svg',
                  color: Colors.black,
                ),
              ),
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
              hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(right: _controller.notificationCount > 0 ? Get.width * 0.040 : Get.width * 0.0230, left: Get.width * 0.040),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "GagaGo",
                  style: TextStyle(fontSize: Get.height * 0.050, fontWeight: FontWeight.w400, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.kaushanScriptRegular),
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
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    )).then((value) {
                  // appStreamController.handleBottomTab.add(true);
                  // if (value != null) {
                  //   debugPrint("Under then callBackChatCount");
                  //   widget.callBackNotificationCountCount!();
                  // }
                });
              },
              child: SizedBox(
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
                    if (_controller.notificationCount > 0)
                      Positioned(
                        right: 1,
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: (_controller.notificationCount.toString().length > 2) ? Get.width * 0.05 : Get.width * 0.040,
                          width: (_controller.notificationCount.toString().length > 2) ? Get.width * 0.05 : Get.width * 0.040,
                          decoration: const BoxDecoration(color: AppColors.notfRedColor, shape: BoxShape.circle),
                          child: Text(
                            (_controller.notificationCount.toString().length > 2) ? "99+" : _controller.notificationCount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: (_controller.notificationCount.toString().length > 2) ? Get.height * 0.011 : Get.height * 0.015),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
