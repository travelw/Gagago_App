import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/package/package_list_model.dart';

class PackageReviewsListScreen extends StatefulWidget {
  PackageReviewsListScreen({Key? key, required this.reviews}) : super(key: key);

  List<Reviews> reviews;
  @override
  State<PackageReviewsListScreen> createState() => _PackageReviewsListScreenState();
}

class _PackageReviewsListScreenState extends State<PackageReviewsListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.14, bottom: Get.width * 0.06, left: Get.width * 0.055, right: Get.width * 0.055),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _appBar(),
            SizedBox(
              height: Get.height * 0.034,
            ),
            Expanded(
              child: widget.reviews.isEmpty
                  ? Center(
                      child: Text(
                        "No any review",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      ),
                    )
                  : Align(
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.reviews.length,
                          itemBuilder: (context, index) {
                            return _ratingsAndReviewsItems(index);
                          }),
                    ),
            )
          ])),
    ));
  }

  _ratingsAndReviewsItems(index) {
    double height = Get.height / 6;
    return Container(
      // height: height,
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.021),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: AppColors.packageBgLightGrey, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                      imageUrl: widget.reviews[index].user?.profilePicture ?? "",
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
                        '${widget.reviews[index].user?.firstName}',
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      ),
                      Text(
                        '${widget.reviews[index].reviewDate}',
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                      ),
                    ],
                  ),
                ],
              ),
              RatingBar(
                  initialRating: double.parse(widget.reviews[index].rating ?? "1"),
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
            '${widget.reviews[index].review}',
            // maxLines: 2,
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
            "Reviews".tr,
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
