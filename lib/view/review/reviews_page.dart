import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/review_list_model.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import '../../CommonWidgets/common_back_button.dart';

class ReviewsPage extends StatefulWidget {
  String? userId;
  ReviewsPage({Key? key, this.userId}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<AverageRateListing> averageListing = [];
  List<ReviewListing> reviewListing = [];
  List<UserProfile> userProfileImage = [];
  num? overAllRating;
  int? totalReview;
  bool isLoading = false;
  String profilePic = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ReviewListModel model = await CallService().getReviewList(widget.userId.toString());
      setState(() {
        isLoading = false;
        averageListing = model.averageRateListing!;
        overAllRating = model.overallAverageRating;
        reviewListing = model.reviewListing!;
        totalReview = model.toalReviews!;
        debugPrint("AverageListing $averageListing");
        debugPrint("OverAll $overAllRating");
        debugPrint("Total Review $totalReview");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshEventList,
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.070, left: Get.width * 0.055, right: Get.width * 0.055),
          child: Column(
            children: <Widget>[
              CommonBackButton(
                name: "Reviews".tr,
              ),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ))
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/images/svg/star.svg"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    overAllRating.toString(),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  " -${reviewListing.length} ${reviewListing.isNotEmpty ? reviewListing.length > 1 ? "Reviews".tr : "Review".tr : "Reviews".tr}",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height15,
                            ),
                            SizedBox(
                              height: Get.height * 0.3,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeLeft: true,
                                removeRight: true,
                                removeTop: true,
                                child: ListView.builder(
                                    itemCount: averageListing.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            averageListing[index].text.toString().toLowerCase() == "honesty" ? "Reliable".tr : averageListing[index].text.toString().tr,
                                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                height: 4,
                                                child: LinearProgressIndicator(
                                                  value: averageListing[index].rate == null ? 0.0 : double.parse(averageListing[index].rate.toString()) / 5,
                                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                                                  backgroundColor: const Color(0xffD6D6D6),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.020,
                                              ),
                                              Text(
                                                //data[index]['name'] ?? ''
                                                averageListing[index].rate == null ? '0.0' : averageListing[index].rate.toString(),
                                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.050,
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            // reviewListing.isEmpty
                            //     ?
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                //physics: AlwaysScrollableScrollPhysics(),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviewListing.length,
                                itemBuilder: (BuildContext context, int index) {
                                  debugPrint("ListLength ${reviewListing.length}");
                                  return reviewListing[index].reportedBy == null ? Container() : _buildReviewModelList(reviewListing[index], index);
                                }),
                            // : const NoDataFoundScreen(),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewModelList(ReviewListing reviewListing, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: reviewListing.reportedBy!.userProfile!.isEmpty
                    ? Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/png/profilespic.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                    : SizedBox(
                        height: 55.0,
                        width: 55.0,
                        /*decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          reviewListing.reportedBy!.userProfile![0].imageName.toString()),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),*/
                        child: CachedNetworkImage(
                          imageUrl: reviewListing.reportedBy!.userProfile![0].imageName.toString(),
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Icon(Icons.error),
                                Image.asset(
                                  'assets/images/png/profilespic.png',
                                  fit: BoxFit.fill,
                                  height: Get.height * 0.03,
                                ),
                              ],
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 18,
                            backgroundImage: imageProvider,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    "${reviewListing.reportedBy!.firstName!} ${reviewListing.reportedBy!.lastName!}",
                    style: const TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 30, top: 3.0),
                //   child: Text(
                //     Jiffy(reviewListing.createdAt.toString()).yMMMd,
                //     style: const TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                //   ),
                // ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          reviewListing.comment ?? "No Comment Available.".tr,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: StringConstants.poppinsRegular, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      init();
    });
    return;
  }
}
