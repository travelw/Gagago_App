import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/common_back_button.dart';
import 'package:gagagonew/CommonWidgets/common_no_data_found.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/block_list_response_model.dart';
import 'package:gagagonew/model/match_profile_response_model.dart';
import 'package:gagagonew/model/user_like_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';

class MatchUserListScreen extends StatefulWidget {
  const MatchUserListScreen({Key? key}) : super(key: key);

  @override
  State<MatchUserListScreen> createState() => _MatchUserListScreenPageState();
}

class _MatchUserListScreenPageState extends State<MatchUserListScreen> {
  List<Matches> matchUserData = [];
  List<BlockPersonDetail> blockUserList = [];
  String accessToken = "", userName = "";
  int? id;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MatchUserResponseModel model = await CallService().getMatchUserDetails();
      setState(() {
        isLoading = false;
        matchUserData = model.matches!;
        debugPrint("matchUserData $matchUserData");
      });
    });
  }

  updateList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MatchUserResponseModel model = await CallService().getMatchUserDetails();
      setState(() {
        matchUserData = model.matches!;
        debugPrint("matchUserData $matchUserData");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  name: "Matched Users",
                ),
                SizedBox(
                  height: Get.height * 0.030,
                ),
                isLoading == true
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ))
                    : Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: matchUserData.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: matchUserData.length,
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
                                          Padding(
                                            //this padding will be you border size
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors
                                                        .inputFieldBorderColor,
                                                    width: 1),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.white,
                                              ),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: NetworkImage(
                                                    matchUserData[index]
                                                        .image!),
                                                /* backgroundImage: AssetImage(
                                              connectionList[index].image),*/
                                              ),
                                            ),
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
                                                  Text(
                                                    "${matchUserData[index].name!},",
                                                    /*connectionList[index].name,*/
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.020,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .gagagoLogoColor,
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular),
                                                  ),
                                                  Text(
                                                    matchUserData[index]
                                                        .age
                                                        .toString(),
                                                    /*connectionList[index].name,*/
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.020,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .gagagoLogoColor,
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.010,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                matchUserData[index].address ??
                                                    "",
                                                /*connectionList[index].name,*/
                                                style: TextStyle(
                                                    fontSize:
                                                        Get.height * 0.015,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .gagagoLogoColor,
                                                    fontFamily: StringConstants
                                                        .poppinsRegular),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showAlertDialog(
                                              context,
                                              matchUserData[index]
                                                  .id
                                                  .toString(),
                                              matchUserData[index]
                                                  .name
                                                  .toString());
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/svg/colorGlobe.svg",
                                          height: Get.height * 0.055,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          )
                        : const NoDataFoundScreen(),
                  ),
                )
              ],
            ),
          ),
          /*  Align(
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
    );
  }

  showAlertDialog(BuildContext context, String id, String name) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel".tr),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: const Text("Yes"),
        onPressed: () async {
          Get.back();
          int status = 0;
          var map = <String, dynamic>{};
          map['liked_to'] = id;
          map['status'] = status;
          LikeResponseModel userLike = await CallService().getLikeUser(map);
          if (userLike.status == true) {
            setState(() {
              updateList().then((value) {
                CommonDialog.showToastMessage(
                    "You Has Been Unmatched $name.");
              });
            });
          } else {
            CommonDialog.showToastMessage(userLike.message.toString());
          }

          /*UserLogOutResponseModel stateUpdate =
          await CallService().getUerLogOut(map);
          if (stateUpdate.success == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pop(context);
            Get.offAllNamed(RouteHelper.getLoginPage());
            //Navigator.pop(context);
          } else {
            CommonDialog.showToastMessage(
                stateUpdate.message.toString());
          }*/
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Alert"),
      content: Text("Do You want to Unmatch $name?"),
      actions: [
        cancelButton,
        continueButton,
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
}
