import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/package/package_list_model.dart';
import 'package:gagagonew/view/app_html_view_screen.dart';
import 'package:gagagonew/view/packages/controllers/package_details_controller.dart';
import 'package:gagagonew/view/packages/package_inquiry_screen.dart';
import 'package:gagagonew/view/packages/package_payment_mode_screen.dart';
import 'package:gagagonew/view/packages/package_reviews_list_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/common_functions.dart';
import 'dialog/add_bank_details_dialog.dart';

class PackageDetailsScreen extends StatefulWidget {
  const PackageDetailsScreen({super.key, required this.packageData, this.packageId});

  final PackageListModelData? packageData;
  final int? packageId;

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  final PackageDetailsController _controller = Get.put(PackageDetailsController());

  @override
  void initState() {
    _controller.resetData();

    if (widget.packageId != null) {
      _controller.packageData.value.id = widget.packageId;
    }
    if (widget.packageData != null) {
      _controller.packageData.value = widget.packageData!;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _controller.createIcons(context);
    });

    // _controller.mapMarker.addAll(_controller.mapMarkersList);
    _controller.callPackageDetailsApi(id: _controller.packageData.value.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  // do not remove this
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Packages Images

                      _packageImages(),

                      Padding(
                          padding: EdgeInsets.all(Get.height * 0.025),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Basic Info
                              _packageBasicInfo(),

                              if (_controller.packageData.value.activities != null)
                                if (_controller.packageData.value.activities!.isNotEmpty)
                                  Divider(
                                    height: Get.height * 0.055,
                                  ),

                              /// Trip Activities
                              if (_controller.packageData.value.activities != null)
                                if (_controller.packageData.value.activities!.isNotEmpty) _tripActivities(),

                              if (_controller.packageData.value.inclusions != null)
                                if (_controller.packageData.value.inclusions!.isNotEmpty)
                                  Divider(
                                    height: Get.height * 0.055,
                                  ),

                              /// Trip Inclusions
                              if (_controller.packageData.value.inclusions != null)
                                if (_controller.packageData.value.inclusions!.isNotEmpty) _tripInclusions(),

                              if (_controller.packageData.value.exclusions != null)
                                if (_controller.packageData.value.exclusions!.isNotEmpty)
                                  Divider(
                                    height: Get.height * 0.055,
                                  ),

                              /// Trip Exclusions
                              if (_controller.packageData.value.exclusions != null)
                                if (_controller.packageData.value.exclusions!.isNotEmpty) _tripExclusions(),

                              Divider(
                                height: Get.height * 0.055,
                              ),

                              /// Trip Itinerary
                              _tripItinerary(),

                              Divider(
                                height: Get.height * 0.055,
                              ),

                              _contactForInquiryButton(),

                              /// Ratings and Reviews
                              _ratingsAndReviewsWidget(),

                              /// Price Details
                              // _priceDetails(),

                              // Divider(
                              //   height: Get.height * 0.055,
                              // ),

                              /// Coupon Field
                              if (_controller.packageData.value.isFirstPaymentDone != 1 || _controller.packageData.value.isSecondPaymentDone != 1)
                                if (_controller.packageData.value.isCouponApplied == 0) _couponField(),

                              // Divider(
                              //   height: Get.height * 0.055,
                              // ),
                              const SizedBox(
                                height: 10,
                              ),

                              /// Total Price Widget
                              _totalPriceWidget(),

                              Divider(
                                height: Get.height * 0.055,
                              ),

                              /// Cancellation Policy
                              _cancellationPolicyWidget(),
                              if ((_controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 0) ||
                                  (_controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 1))
                                Divider(
                                  height: Get.height * 0.055,
                                ),
                              if (((_controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 0) ||
                                  (_controller.packageData.value.isFirstPaymentDone == 1 &&
                                      _controller.packageData.value.isSecondPaymentDone == 1)) /*&& _controller.packageData.value.isCancellable == 1*/)
                                InkWell(
                                  onTap: () {
                                    if (_controller.packageData.value.isRefundable == 1) {
                                      showAlertDialog(context);
                                    } else {
                                      cancelTripDialog();
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    // width: Get.width / 2.9,
                                    padding: EdgeInsets.only(top: Get.height * 0.014, bottom: Get.height * 0.014, left: Get.width * 0.04, right: Get.width * 0.04),
                                    decoration: const BoxDecoration(color: AppColors.headerGrayColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Text(
                                      // _controller.packageData.value.isAlreadyBooked == 1 && _controller.packageData.value.isAlreadyBooked == 0?
                                      // "Book My Trip".tr:
                                      "Cancel Trip".tr,
                                      style: const TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                            ],
                          )),
                    ],
                  );
                }),
              ),
            ),
            _bookMyTripWidgets(),
          ],
        ),
      ),
    );
  }

  cancelTripDialog() {
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
        style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
        child: Text(
          "Yes".tr,
          style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
        ),
        onPressed: () async {
          Get.back();

          var map = {"package_id": _controller.packageData.value.id!};
          _controller.cancelMyTripeApi(
              map: map,
              callback: () {
                Get.back(result: true);
              });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Cancel Trip".tr,
        style: TextStyle(color: Colors.red, fontSize: Get.height * 0.028, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular),
      ),
      content: Text(
        "Are your sure you want to cancel this trip?".tr,
        style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      actions: [
        Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBankDetailsDialog(
          title: "Bank details",
          description: 'Add bank details for refunds',
          callback: (name, number, routingNumber, accountType, bankName) {
            var map = {
              "package_id": _controller.packageData.value.id!,
              "account_name": name,
              "account_number": number,
              "routing_number": routingNumber,
              "account_type": accountType,
              "bank_name": bankName,
            };
            _controller.cancelMyTripeApi(
                map: map,
                callback: () {
                  Get.back(result: true);
                });
          },
        );
      },
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

  _packageImages() {
    if (_controller.packageData.value.images == null) {
      return _emptyImage();
    }
    if (_controller.packageData.value.images != null) {
      if (_controller.packageData.value.images!.isEmpty) {
        return _emptyImage();
      }
    }

    return SizedBox(
      height: Get.width - (Get.width * 0.25),
      child: Stack(
        children: [
          //
          _pagerView(),

          CarouselSlider(
              // carouselController: indicatorController,
              items: _controller.packageData.value.images!.map((i) {
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
                  onPageChanged: (index, reason) {
                    _controller.currentPage.value = index;

                    // setState(() {
                    //   carouselCount = index;
                    // });
                    // indicatorController.jumpToPage(index);
                    _controller.indicatorController.value.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  })),

          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller.indicatorController.value,
                  count: _controller.packageData.value.images!.length,
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
              )),
          Positioned(
            top: 15,
            left: 15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                "assets/images/png/ic_back_white.png",
                height: Get.width * 0.07,
                width: Get.width * 0.07,
              ),
            ),
          ),
          Positioned(
              top: 15,
              right: 15,
              child: InkWell(
                onTap: () {
                  shareApp("Gagago");
                },
                child: Image.asset(
                  "assets/images/png/ic_share_white.png",
                  height: Get.width * 0.07,
                  width: Get.width * 0.07,
                ),
              ))
        ],
      ),
    );
  }

  _pagerView() {
    return PageView.builder(
        itemCount: _controller.packageData.value.images!.length,
        pageSnapping: true,
        clipBehavior: Clip.none,
        controller: _controller.indicatorController.value,
        onPageChanged: (page) {
          print("page --> ${page}");
        },
        itemBuilder: (context, pagePosition) {
          debugPrint("ScrollImagePage: $pagePosition");
          return const SizedBox();
        });
  }

  void shareApp(String urlsLink) async {
    // final box = context.findRenderObject() as RenderBox?;
    final data = await rootBundle.load("assets/images/png/splash_icon.png");
    final buffer = data.buffer;
    await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'assets/images/png/splash_icon.png',
          mimeType: 'image/png',
        ),
      ],
      text: "${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr}}",
      subject: "Let’s go with Gagago!".tr,
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _packageBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _controller.packageData.value.title ?? "",
          style: TextStyle(fontSize: Get.height * 0.025, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        ),
        SizedBox(
          height: Get.height * 0.002,
        ),

        /// My Ratings
        InkWell(
          onTap: () {
            if (_controller.packageData.value.reviews != null) {
              if (_controller.packageData.value.reviews!.isNotEmpty) {
                Get.to(PackageReviewsListScreen(
                  reviews: _controller.packageData.value.reviews ?? [],
                ));
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/svg/borderStar.svg",
                height: Get.height * 0.019,
              ),
              SizedBox(
                width: Get.width * 0.005,
              ),
              Text(
                "${_controller.packageData.value.averageRating ?? 0}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
              ),
              SizedBox(
                width: Get.width * 0.015,
              ),
              Container(
                height: Get.width * 0.02,
                width: 1,
                color: AppColors.inputFieldBorderColor,
              ),
              SizedBox(
                width: Get.width * 0.015,
              ),
              Text(
                '${_controller.packageData.value.reviewsCount ?? 0} reviews',
                style: TextStyle(
                    decoration: TextDecoration.underline, fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.022,
        ),

        _rowIconText(
          icon: "assets/images/png/ic_calender.png",
          iconColor: AppColors.orangeColor,
          textColor: AppColors.planColor,
          text: "${CommonFunctions.convertDateToDDMMMYYY(
            _controller.packageData.value.startDate,
          )} - ${CommonFunctions.convertDateToDDMMMYYY(
            _controller.packageData.value.endDate,
          )}",
        ),

        SizedBox(
          height: Get.height * 0.012,
        ),
        _rowIconText(
            icon: "assets/images/png/ic_calender.png",
            iconColor: AppColors.orangeColor,
            textColor: AppColors.planColor,
            text: "Duration: ${CommonFunctions.calculateDatesDifference(_controller.packageData.value.startDate, _controller.packageData.value.endDate)} days"),

        SizedBox(
          height: Get.height * 0.012,
        ),

        _rowIconText(icon: "assets/images/png/ic_group.png", iconColor: AppColors.orangeColor, textColor: AppColors.planColor, text: "Group size: ${_controller.packageData.value.groupSize} spots"),

        SizedBox(
          height: Get.height * 0.012,
        ),

        if (_controller.packageData.value.mapMarkers != null)
          _rowIconText(
              icon: "assets/images/png/ic_address_marker.png",
              iconColor: AppColors.orangeColor,
              textColor: AppColors.planColor,
              text: "Places: ${_controller.packageData.value.mapMarkers?.length ?? 0} ${_controller.packageData.value.mapMarkers!.length > 1 ? "cities" : "city"}"),

        SizedBox(
          height: Get.height * 0.012,
        ),

        _rowIconText(
            icon: "assets/images/png/ic_activities.png",
            iconColor: AppColors.orangeColor,
            textColor: AppColors.planColor,
            text: "Activities: ${_controller.packageData.value.activities?.length ?? 0} included"),

        SizedBox(
          height: Get.height * 0.012,
        ),

        _rowIconText(
            icon: "assets/images/png/ic_meals.png", iconColor: AppColors.orangeColor, isExpandText: true, textColor: AppColors.planColor, text: "Meals: ${_controller.packageData.value.meals}"),

        SizedBox(
          height: Get.height * 0.03,
        ),

        HtmlWidget(
          _controller.packageData.value.description ?? "",
          textStyle: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        )

        /* Text(
          _controller.packageData.value.description ?? "",
          // " 12-20 Aug 2023",
          style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        )*/
      ],
    );
  }

  _tripActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel('Trip Activities'.tr),
        SizedBox(
          height: Get.height * 0.005,
        ),
        Wrap(
          children: [
            for (var item in _controller.packageData.value.activities!) _activityItem(image: "assets/images/png/ic_check_blue.png", text: item.title ?? ""),
          ],
        )
      ],
    );
  }

  _activityItem({required String image, required String text, double? width}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      width: width ?? (Get.width * 0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Get.width * 0.037,
            width: Get.width * 0.037,
            margin: EdgeInsets.only(right: 5, top: Get.height * 0.003),
            child: Image.asset(image),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
            ),
          ),
        ],
      ),
    );
  }

  _tripInclusions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel('Trip Inclusions'.tr),
        SizedBox(
          height: Get.height * 0.005,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.packageData.value.inclusions!.length,
            itemBuilder: (context, index) {
              return _activityItem(image: "assets/images/png/ic_check_green.png", text: _controller.packageData.value.inclusions![index].title ?? "", width: double.infinity);
            })
      ],
    );
  }

  _tripExclusions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel('Trip Exclusions'.tr),
        SizedBox(
          height: Get.height * 0.005,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.packageData.value.exclusions!.length,
            itemBuilder: (context, index) {
              return _activityItem(image: "assets/images/png/ic_cross_orange.png", text: _controller.packageData.value.exclusions![index].title ?? "", width: double.infinity);
            })
      ],
    );
  }

  _tripItinerary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel('Trip Itinerary'.tr),
        SizedBox(
          height: Get.height * 0.005,
        ),
        Obx(() {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: SizedBox(
              height: Get.height * 0.28,
              child: GoogleMap(
                // on below line setting camera position
                initialCameraPosition: _controller.kGoogle.value,
                gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
                // on below line specifying map type.
                mapType: MapType.normal,

                // on below line setting user location enabled.
                myLocationEnabled: true,
                // on below line setting compass enabled.
                compassEnabled: true,
                markers: Set.from(_controller.mapMarker),

                // on below line specifying controller on map complete.
                onMapCreated: (GoogleMapController controller) {
                  // _controller.mapController.complete(controller);
                  _controller.mapController = controller;
                },
              ),
            ),
            /*Image.asset(
                "assets/images/png/dummy_trip_map.png",
                height: Get.height * 0.28,
                fit: BoxFit.cover,
              ),*/
          );
        }),
        /* HtmlWidget(
          _controller.packageData.value.description ?? "",
          textStyle: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w500, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        )*/
        SizedBox(
          height: Get.height * 0.025,
        ),
        if (_controller.packageData.value.itineraries != null)
          if (_controller.packageData.value.itineraries!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _daysListItem,
              itemCount: !_controller.isReadMoreDays.value ? 1 : _controller.packageData.value.itineraries!.length,
            ),

/* trimCollapsedText: '...more',
                            trimExpandedText: '',*/ /*

        )
*/
      ],
    );
  }

  Widget _daysListItem(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _controller.packageData.value.itineraries![index].title ?? "",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.orangeColor, fontFamily: StringConstants.poppinsRegular),
        ),
        SizedBox(
          height: Get.height * 0.005,
        ),
        Text(_controller.packageData.value.itineraries![index].description ?? "",
            maxLines: !_controller.isReadMoreDays.value ? 2 : 500,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.gagagoLogoColor,
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w500,
              fontSize: Get.height * 0.018,
            )),
        /*ReadMoreText(
          _controller.packageData.value.itineraries![index].description ?? "",
          trimLines: 2,
          preDataTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018),
          style: TextStyle(
            color: AppColors.gagagoLogoColor,
            fontFamily: StringConstants.poppinsRegular,
            fontWeight: FontWeight.w500,
            fontSize: Get.height * 0.018,
          ),
          colorClickableText: Colors.black,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more'.tr,
          trimExpandedTextStyle: TextStyle(
            color: AppColors.gagagoLogoColor,
            fontFamily: StringConstants.poppinsRegular,
            fontWeight: FontWeight.w600,
            fontSize: Get.height * 0.018,
            decoration: TextDecoration.underline,
          ),
          onTap: () {
            _controller.isReadMoreDays.value = true;
          },
          readMore: _controller.isReadMoreDays.value,
        ),*/

        if (!_controller.isReadMoreDays.value)
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                _controller.isReadMoreDays.value = true;
              },
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.01),
                child: Text("Show more",
                    style: TextStyle(
                      color: AppColors.gagagoLogoColor,
                      fontFamily: StringConstants.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.height * 0.018,
                      decoration: TextDecoration.underline,
                    )),
              ),
            ),
          ),
        if (_controller.isReadMoreDays.value)
          if (index < _controller.packageData.value.itineraries!.length - 1)
            SizedBox(
              height: Get.height * 0.018,
            ),
      ],
    );
  }

  _contactForInquiryButton() {
    return InkWell(
      onTap: () {
        if (_controller.packageData.value.id != null) {
          Get.to(PackageInquiryScreen(
            packageId: _controller.packageData.value.id!,
            packageName: "${_controller.packageData.value.title}",
            dates:"${CommonFunctions.convertDateToDDMMMYYY(
              _controller.packageData.value.startDate,
            )} - ${CommonFunctions.convertDateToDDMMMYYY(
              _controller.packageData.value.endDate,
            )}"
          ));
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: Get.width,
        padding: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.02),
        decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          "Contact For Inquiry".tr,
          style: const TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _ratingsAndReviewsWidget() {
    return InkWell(
      onTap: () {
        if (_controller.packageData.value.reviews != null) {
          if (_controller.packageData.value.reviews!.isNotEmpty) {
            Get.to(PackageReviewsListScreen(
              reviews: _controller.packageData.value.reviews ?? [],
            ));
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: Get.height * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/svg/borderStar.svg",
                  height: Get.height * 0.019,
                ),
                SizedBox(
                  width: Get.width * 0.005,
                ),
                Text(
                  '${_controller.packageData.value.averageRating ?? 0}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                ),
                SizedBox(
                  width: Get.width * 0.0150,
                ),
                Container(
                  height: Get.height * 0.015,
                  width: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: Get.width * 0.0150,
                ),
                Text(
                  '${_controller.packageData.value.reviewsCount} reviews  ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                ),
              ],
            ),
            SizedBox(
              height: Get.width * 0.0150,
            ),
            if (_controller.packageData.value.reviews != null)
              if (_controller.packageData.value.reviews!.isNotEmpty)
                SizedBox(
                  height: Get.height / 6,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.packageData.value.reviews!.length,
                      itemBuilder: (context, index) {
                        return _ratingsAndReviewsItems(index);
                      }),
                ),
            Divider(
              height: Get.height * 0.055,
            ),
          ],
        ),
      ),
    );
  }

  _ratingsAndReviewsItems(index) {
    double height = Get.height / 6;
    debugPrint("_controller.packageData.value.reviews![index]: ${jsonEncode(_controller.packageData.value.reviews![index])}");
    return Container(
      height: height,
      width: Get.width / 1.4,
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.021),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: AppColors.packageBgLightGrey, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /*Image.asset(
                    "assets/images/png/dummy_user.png",
                    height: height / 3,
                  ),*/
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular((height / 3) / 2)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: height / 3,
                      width: height / 3,
                      imageUrl: _controller.packageData.value.reviews![index].user?.profilePicture ?? "",
                      maxHeightDiskCache: 300,
                      maxWidthDiskCache: 300,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                          'assets/images/png/splash_icon.png',
                          fit: BoxFit.fitHeight,
                          height: height / 3,
                          width: height / 3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.0150,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_controller.packageData.value.reviews![index].user?.firstName}',
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      ),
                      Text(
                        '${_controller.packageData.value.reviews![index].reviewDate}',
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      ),
                    ],
                  ),
                ],
              ),
              RatingBar(
                  initialRating: double.parse(_controller.packageData.value.reviews![index].rating ?? "1"),
                  minRating: 1,
                  itemSize: Get.height * 0.017,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  ratingWidget: RatingWidget(full: getStarIcon(Icons.star), half: getStarIcon(Icons.star_half), empty: getStarIcon(Icons.star_outline)),
                  onRatingUpdate: (rating) {}),
            ],
          ),
          Text(
            '${_controller.packageData.value.reviews![index].review}',
            maxLines: 2,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
          ),
        ],
      ),
    );
  }

  Widget getStarIcon(IconData icon) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Icon(
        icon,
        color: const Color(0xFFFFB803),
        size: 34,
      ),
    );
  }

  /*_priceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel('Price Details'.tr),
        SizedBox(
          height: Get.height * 0.009,
        ),
        _priceDetailsItems(
            title: "\$250.00 x 7 nights", trailing: "\$1,750.00"),
        _priceDetailsItems(
            title: "Weekly stay discount",
            trailing: "-\$175.00",
            trailingStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Get.height * 0.021,
                color: Colors.green,
                fontFamily: StringConstants.poppinsRegular)),
        _priceDetailsItems(title: "Cleaning fee", trailing: "\$150.00"),
        _priceDetailsItems(title: "GagaGo service fee", trailing: "\$243.53"),
        // _priceDetailsItems(title: "Taxes", trailing: "\$200.53"),
      ],
    );
  }*/

  _couponField() {
    return Column(
      children: [
        if (_controller.packageData.value.services != null)
          SizedBox(
            height: Get.height * 0.012,
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: Get.height * 0.07,
                alignment: Alignment.center,
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
                      controller: _controller.couponController,
                      onChanged: (v) {},
                      style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                      decoration: InputDecoration(
                        hintText: "Add Discount Code".tr,
                        // suffixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.40, maxHeight: Get.width * 0.04),
                        hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_controller.couponController.text.trim().isNotEmpty) {
                  _controller.callApplyCoupon(id: _controller.packageData.value.id);
                }
              },
              child: Container(
                height: Get.height * 0.07,
                // margin: EdgeInsets.,
                padding: EdgeInsets.only(
                  right: Get.width * 0.045,
                  left: Get.width * 0.045,
                ),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: AppColors.headerGrayColor),
                child: Text(
                  "Apply".tr,
                  style: TextStyle(height: 1, fontWeight: FontWeight.w600, fontSize: Get.height * 0.019, color: Colors.white, fontFamily: StringConstants.poppinsRegular),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _cancellationPolicyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemLabel("Cancellation Policy".tr),
        SizedBox(
          height: Get.height * 0.005,
        ),

        Text(_controller.cancellationPolicyModel.value.description ?? "",
            style: TextStyle(
              color: AppColors.gagagoLogoColor,
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w500,
              fontSize: Get.height * 0.018,
            )),

        // if( !_controller.isReadMore.value)
        /* ReadMoreText(
            "Free cancellation for 48 hours. Cancel before Aug 1 for a partial refund. If cancellation is made day of you will receive a credit to reschedule at a later date. Credit must be used within 90 days.",
            trimLines: 2,
            preDataTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018),
            style: TextStyle(
              color: AppColors.gagagoLogoColor,
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w500,
              fontSize: Get.height * 0.018,
            ),
            colorClickableText: Colors.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more'.tr,
            trimExpandedTextStyle: TextStyle(
              color: AppColors.gagagoLogoColor,
              fontFamily: StringConstants.poppinsRegular,
              fontWeight: FontWeight.w600,
              fontSize: Get.height * 0.018,
              decoration: TextDecoration.underline,
            ),
            onTap: () {
              _controller.isReadMore.value = true;
            },
            readMore: _controller.isReadMore.value,
            */ /* trimCollapsedText: '...more',
                                trimExpandedText: '',*/ /*
          ),*/
        // if( _controller.isReadMore.value)
        // HtmlWidget(
        //   cancellationPolicyHtml,
        // ),

        SizedBox(
          height: Get.height * 0.013,
        ),

        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "For our full cancellation policy, read our ".tr,
                style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular)),
            TextSpan(
                text: "User Agreement".tr,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Get.toNamed(RouteHelper.getHtmlScreen(
                    //   apiKey: "terms-and-conditions",
                    //   title: "Terms and Conditions",
                    // ));
                    Get.to(const AppHtmlViewScreen(apiKey: "terms-and-conditions", title: "User Agreement", isAuth: false));
                  },
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: Get.height * 0.018, fontWeight: FontWeight.w500, fontFamily: StringConstants.poppinsRegular, color: AppColors.forgotPasswordColor)),
            TextSpan(text: " & ".tr, style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular)),
            TextSpan(
                text: "Cancellation Policy".tr,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(const AppHtmlViewScreen(apiKey: "cancellation-policy", title: "Cancellation Policy", isAuth: false));
                    // Get.to(AppHtmlViewScreen(strHtml: _controller.cancellationPolicyModel.value.fullDescription, title: "Cancellation Policy", isAuth: false));
                  },
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: Get.height * 0.018, fontWeight: FontWeight.w500, fontFamily: StringConstants.poppinsRegular, color: AppColors.forgotPasswordColor)),
          ]),
        ),
      ],
    );
  }

  _totalPrice() {
    String data = _controller.packageData.value.getTotalCalculate();
    if (_controller.couponDiscount.value > 0.0) {
      data = "${double.parse(_controller.packageData.value.getTotalCalculate()) - (_controller.couponDiscount.value)}";
    }
    return data;
  }

  _bookMyTripWidgets() {
    return Obx(() {
      return Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child:           Container(
            height: 10,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              offset: Offset(0,0),
              color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      )),
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              // boxShadow: [
              //   BoxShadow(
              //       offset: Offset(0,0),
              //       color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              // ],
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.020, vertical: Get.height * 0.020),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _handleAmountWidget()),
                  const SizedBox(
                    width: 10,
                  ),
                  _controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 1
                      ? Text(
                          // _controller.packageData.value.isAlreadyBooked == 1 && _controller.packageData.value.isAlreadyBooked == 0?
                          // "Book My Trip".tr:
                          "Trip Booked".tr,
                          style: const TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w700),
                        )
                      : InkWell(
                          onTap: () {
                            Get.to(PackagePaymentModeScreen(packageData: _controller.packageData.value));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            // width: Get.width / 2.9,
                            padding: EdgeInsets.only(top: Get.height * 0.014, bottom: Get.height * 0.014, left: Get.width * 0.04, right: Get.width * 0.04),
                            decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              _controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 0 ? "Pay Balance".tr : "Book My Trip".tr,
                              style: const TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  _handleAmountWidget() {
    if (_controller.packageData.value.isFirstPaymentDone == 0 && _controller.packageData.value.isSecondPaymentDone == 0) {
      return _showAmountDropDown();
    } else if (_controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("\$${CommonFunctions.formatPriceWithComma(_controller.getPayAbleAmount().toString())}" /*"\$${_totalPrice()}"*/,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular)),
          SizedBox(
            height: Get.width * 0.001,
          ),
          Text("Remaining balance", style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular)),
        ],
      );
    } else {
      return Text("\$${CommonFunctions.formatPriceWithComma(_controller.getTotalAmount().toString())}" /*"\$${_totalPrice()}"*/,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular));
    }
  }

  _showAmountDropDown() {
    return Row(
      children: [
        Text("\$${CommonFunctions.formatPriceWithComma(_controller.getPayAbleAmount().toString())}" /*"\$${_totalPrice()}"*/,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular)),
        const Spacer(),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            // padding: const EdgeInsets.symmetric(horizontal: 3.0),
            // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.all(Radius.circular(20))),
            child: DropdownButton(
              // underline: SizedBox(),
              // Initial Value
              value: _controller.selectedPaymentItem.value,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: _controller.partialPaymentItems.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                _controller.selectedPaymentItem.value = newValue!;
                _controller.selectedPaymentItemIndex.value = _controller.partialPaymentItems.indexWhere((element) => element == newValue);

                if (_controller.selectedPaymentItemIndex.value == 0) {
                  _controller.payableAmount.value = _controller.packageData.value.firstPaymentAmount ?? 0;
                } else {
                  _controller.payableAmount.value = _controller.packageData.value.totalPrice ?? 0;
                }
              },
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  _addOns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _itemLabel("Add-ons"),
            InkWell(
                onTap: () {
                  _controller.isAddOnExpanded.value = !_controller.isAddOnExpanded.value;
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3, bottom: 3),
                  child: Image.asset(
                    "assets/images/png/ic_drop_down.png",
                    height: Get.height * 0.016,
                    width: Get.height * 0.016,
                  ),
                ))
          ],
        ),
        SizedBox(
          height: Get.height * 0.008,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.packageData.value.services!.length,
            itemBuilder: (context, index) {
              if (_controller.packageData.value.services![index].service == null) {
                return const SizedBox();
              }
              if (_controller.packageData.value.services![index].isApplied == 1) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_controller.packageData.value.services![index].service?.title}",
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                    ),
                    InkWell(
                      onTap: () {
                        if (_controller.packageData.value.services![index].isApplied == 0) {
                          bool isSelected = _controller.packageData.value.services![index].service!.isSelected;

                          _controller.packageData.value.services![index].service!.isSelected = !_controller.packageData.value.services![index].service!.isSelected;
                          _controller.addons.value = 0;

                          for (var element in _controller.packageData.value.services!) {
                            if (element.service != null) {
                              if (element.service!.isSelected) {
                                _controller.addons.value = _controller.addons.value + (element.service!.price ?? 0);
                              }
                            }
                          }
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: _controller.packageData.value.services![index].service!.isSelected || _controller.packageData.value.services![index].isApplied == 1 ? Colors.black : Colors.white),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: Get.height * 0.015,
                          )
                          /* Image.asset(
                          _controller.packageData.value.services![index].service!.isSelected || _controller.packageData.value.services![index].isApplied == 1
                              ? "assets/images/png/ic_checked.png"
                              : "assets/images/png/ic_unchecked.png",
                          height: Get.height * 0.021,
                          width: Get.height * 0.021,
                        ),*/
                          ),
                    )
                  ],
                ),
              );
            })
      ],
    );
  }

  _totalPriceWidget() {
    // final addonsPrice = _controller.packageData.value.getAddonCalculate();
    return Column(
      children: [
        /*if (_controller.packageData.value.services != null)
          for (int i = 0;
              i < _controller.packageData.value.services!.length;
              i++)
            if (_controller.packageData.value.services![i].service != null)
              if (_controller
                  .packageData.value.services![i].service!.isSelected)
                _priceDetailsItems(
                    title:
                        "${_controller.packageData.value.services![i].service?.title}",
                    trailing:
                        "\$${_controller.packageData.value.services![i].service?.price}"),*/
        if (_controller.addons.value > 0 || _controller.couponDiscount.value > 0) _priceDetailsItems(title: "Subtotal", trailing: "\$${_controller.packageData.value.totalPrice}"),
        if (_controller.addons.value > 0) _priceDetailsItems(title: "Add-ons", trailing: "\$${_controller.addons.value}"),
        if (_controller.packageData.value.isFirstPaymentDone == 1 && _controller.packageData.value.isSecondPaymentDone == 0)
          _priceDetailsItems(title: "Already Paid (20%)", trailing: "\$${_controller.packageData.value.paidAmount}"),
        if (_controller.couponDiscount.value > 0) _priceDetailsItems(title: "Coupon Discount", trailing: "-\$${_controller.couponDiscount.value}"),
        _priceDetailsItems(
          title: "Total (USD)",
          trailing: "\$${CommonFunctions.formatPriceWithComma(_controller.getUiTotalAmount().toString())}" /* "\$${_totalPrice()}"*/,
          titleStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
          trailingStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        ),
      ],
    );
  }

  _priceDetailsItems({
    required String title,
    required String trailing,
    TextStyle? titleStyle,
    TextStyle? trailingStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.005,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 2,
            style: titleStyle ?? TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
          ),
          Text(
            trailing,
            maxLines: 2,
            style: trailingStyle ?? TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
          ),
        ],
      ),
    );
  }

  _rowIconText({required String icon, required String text, Color? iconColor, double? iconSize, double? innerPadded, Color? textColor, TextStyle? textStyle, bool isExpandText = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Get.height * 0.0051),
          child: Image.asset(icon, height: iconSize ?? Get.height * 0.019, width: iconSize ?? Get.height * 0.019, color: iconColor),
        ),
        SizedBox(
          width: innerPadded ?? Get.width * 0.014,
        ),
        isExpandText
            ? Expanded(
                child: Text(
                  text,
                  // " 12-20 Aug 2023",
                  style: textStyle ?? TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: textColor ?? AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                ),
              )
            : Text(
                text,
                // " 12-20 Aug 2023",
                style: textStyle ?? TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w500, color: textColor ?? AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
              ),
      ],
    );
  }

  _itemLabel(String text) {
    return Text(
      text.tr,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
    );
  }
}
