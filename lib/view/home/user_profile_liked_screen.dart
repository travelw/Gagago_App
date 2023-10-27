import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/common_back_button.dart';
import 'package:gagagonew/CommonWidgets/common_no_data_found.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/block_list_response_model.dart';
import 'package:gagagonew/model/connection_remove_model.dart';
import 'package:gagagonew/model/connection_response_model.dart';
import 'package:gagagonew/model/unblock_response_model.dart';
import 'package:gagagonew/model/user_liked_list_response_model.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/home/setting_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLikedListScreen extends StatefulWidget {
  const UserLikedListScreen({Key? key}) : super(key: key);

  @override
  State<UserLikedListScreen> createState() => _UserLikedListScreenPageState();
}

class _UserLikedListScreenPageState extends State<UserLikedListScreen> {
  bool isLoading = false;
  List<Likelist> likeUserData = [];
  String accessToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LikeListResponseModel model = await CallService().getLikedUserProfile();
      setState(() {
        isLoading = false;
        likeUserData = model.likelist!;
        print("likeUserData $likeUserData");
      });
    });
  }

  updateList(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LikeListResponseModel model = await CallService().getLikedUserProfile();
      setState(() {
        //isLoading = false;
        likeUserData = model.likelist!;
        print("likeUserData $likeUserData");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
        child: CircularProgressIndicator(
          color: Colors.transparent,
        ))
        : RefreshIndicator(
         onRefresh: resfreshEventList,
          child: Scaffold(
      body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.080,
                  right: Get.width * 0.050,
                  left: Get.width * 0.050,
                  bottom: Get.height * 0.010),
              child: Column(
                children: [
                  CommonBackButton(
                    name: "Liked Me",
                  ),
                  SizedBox(
                    height: Get.height * 0.030,
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: likeUserData.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: likeUserData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  //this padding will be you border size
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .inputFieldBorderColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Colors.white,
                                                    ),
                                                    child: InkWell(
                                                      onTap:(){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SettingPage(likeUserData[index]
                                                                      .likedBy!.id.toString())),
                                                        );
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 18,
                                                        backgroundImage: NetworkImage(
                                                            likeUserData[index]
                                                                .likedBy!
                                                                .profilePicture!),
                                                        /* backgroundImage: AssetImage(
                                                      connectionList[index].image),*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                 Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: SvgPicture.asset(
                                                    "assets/images/svg/liked.svg",
                                                    height: Get.height * 0.030,width: Get.width*0.030,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.015,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap:(){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SettingPage(likeUserData[index]
                                                                      .likedBy!.id.toString())),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${likeUserData[index].likedBy!.firstName ?? ""}",
                                                            style: TextStyle(
                                                                fontSize: Get.height * 0.020,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.gagagoLogoColor,
                                                                fontFamily:
                                                                StringConstants.poppinsRegular),
                                                          ),
                                                          Text(
                                                            "${likeUserData[index].likedBy!.lastName ?? "" + ','},"
                                                                " " +
                                                                likeUserData[index]
                                                                    .likedBy!.age.toString(),
                                                            style: TextStyle(
                                                                fontSize: Get.height * 0.020,
                                                                fontWeight: FontWeight.w600,
                                                                color: AppColors.gagagoLogoColor,
                                                                fontFamily:
                                                                StringConstants.poppinsRegular),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.010,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        /*Icon(
                                    Icons.more_vert,
                                    size: Get.height * 0.040,
                                  ),*/
                                      ],
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.010,
                                    )
                                  ],
                                );
                              },
                            )
                          : NoDataFoundScreen(),
                    ),
                  )
                ],
              ),
            ),
            /* Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.010),
                child: SvgPicture.asset(
                  StringConstants.svgPath + "bottomLogin.svg",
                  height: Get.height * 0.070,
                ),
              ),
            ),*/
          ],
      ),
    ),
        );
  }

  Future<void> resfreshEventList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      updateList();
    });
    return null;
  }
}
