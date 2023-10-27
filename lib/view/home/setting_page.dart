import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/common_gagago_home_header.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/block_user_model.dart';
import 'package:gagagonew/model/carousel_model.dart';
import 'package:gagagonew/model/connection_remove_model.dart';
import 'package:gagagonew/model/more_model.dart';
import 'package:gagagonew/model/other_user_profile_response_model.dart';
import 'package:gagagonew/model/user_like_model.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/chat/chat_message_screen.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/review_controller.dart';
import '../../utils/stream_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../chat/chat_page.dart';

class SettingPage extends StatefulWidget {
  final String id;
  final bool isFromDashboard;

  const SettingPage(this.id, {Key? key, this.isFromDashboard = true}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppStreamController appStreamController = AppStreamController.instance;
  ReviewController c = Get.find();

  dynamic data;
  bool isLoading = false;
  OtherUser? userList;
  String? loginUserId = "";
  String accessToken = "";
  String profilePic = "";
  int carouselCount = 0;
  String image = "assets/images/svg/colorGlobe.svg", image1 = "assets/images/svg/homePageWorld.svg";
  List<String> listBehave = [];
  List<Userdestinations> travel = [];
  List<Userinterest> interestList = [];
  List<Userimages> userImageList = [];
  String userName = "";
  String age = "";
  String bio = "", rating = "", isLikedCount = "";
  String currentAddress = "", chatMatch = "", refferalCode = "";
  String gender = "", sexOrientation = "", ethnicity = "", tripStyle = "", tripTimeLine = "";
  int likeCount = 0;
  int chatCount = 0;
  int notificationCount = 0;

  List<MoreModel> more = [
    MoreModel(name: "Yoga", image: "assets/images/svg/yogaMore.svg"),
    MoreModel(name: "Photography", image: "assets/images/svg/PhotographyHome.svg"),
    MoreModel(name: "Coffee", image: "assets/images/svg/coffeeHome.svg"),
  ];
  List<MoreModel> travel1 = [
    MoreModel(name: "Paris", image: "assets/images/svg/flag1.svg"),
    MoreModel(name: "London", image: "assets/images/svg/londonFlag.svg"),
    MoreModel(name: "Venice", image: "assets/images/svg/veniceFlag.svg"),
  ];

  List<String> listBehave1 = <String>["Female", "Straight", "White", "Backpacking", "1-3 month"];

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

  getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    refferalCode = prefs.getString('refferalCode')!;

    loginUserId = prefs.getString('userId') ?? "";
    print("loginUserId --> $loginUserId");
    debugPrint("ReferralCode is $refferalCode");
  }

  @override
  void initState() {
    /*getSharedPrefs();*/
    super.initState();
    debugPrint("Under Setting page ${widget.isFromDashboard} ->>> ${Get.currentRoute}");
    if (!widget.isFromDashboard) {
      appStreamController.rebuildHandleBottomTabStream();
      appStreamController.handleBottomTab.add(true);
    }
    data = Get.arguments;
    debugPrint('data========>$data');
    getSharedPrefs();
    init();
  }

  bool? isMeBlocked = false;

  init() async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginUserId = prefs.getString('userId') ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OtherUserResponseModel model = await CallService().getOtherUserProfile(widget.id);
      handleDate(model);
      initializeSocket();
    });
  }

  handleDate(OtherUserResponseModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = false;
      userList = model.otherUser;
      isMeBlocked = model.isMeBlocked;
      gender = userList!.gender == null ? '' : userList!.gender!;
      // userId = userList!.id.toString();
      isLikedCount = userList!.isLikedCount.toString();
      //chatCount = userList!.chatCountCount!;

      age = userList!.age.toString();
      debugPrint("age ::::::::$age");
      travel = userList!.userdestinations!;
      interestList = userList!.userinterest!;
      userName = userList?.firstName ?? " ${userList?.lastName ?? ""}";
      currentAddress = userList?.currentAddress ?? "";
      userImageList = userList!.userimages!;
      if (userImageList.isEmpty) {
        profilePic = '';
      } else {
        profilePic = userImageList[0].imageName!;
      }
      bio = userList!.bio!;
      rating = userList?.avgRating.toString() ?? "";
      debugPrint("DataRating$rating");
      chatMatch = userList!.chatMatch.toString();

      if (gender == "1") {
        gender = "Male".tr;
      } else if (gender == "2") {
        gender = "Female".tr;
      } else if (gender == "3") {
        gender = "Other".tr;
      } else if (gender == "4") {
        gender = "Prefer not to say".tr;
      } else if (gender.isEmpty) {
        gender = "NA".tr;
      }

      sexOrientation = userList?.sexualOrientation ?? "";
      if (sexOrientation == "1") {
        sexOrientation = "Straight".tr;
      } else if (sexOrientation == "2") {
        sexOrientation = "Bisexual".tr;
      } else if (sexOrientation == "3") {
        sexOrientation = "Lesbian".tr;
      } else if (sexOrientation == "4") {
        sexOrientation = "Gay".tr;
      } else if (sexOrientation == "5") {
        sexOrientation = "Prefer not to say".tr;
      } else if (sexOrientation.isEmpty) {
        sexOrientation = "NA".tr;
      }
      ethnicity = userList?.ethinicity ?? "";
      if (ethnicity == "1") {
        ethnicity = "White".tr;
      } else if (ethnicity == "2") {
        ethnicity = "Hispanic or Latino".tr;
      } else if (ethnicity == "3") {
        ethnicity = "Asian".tr;
      } else if (ethnicity == "4") {
        ethnicity = "Black or African".tr;
      } else if (ethnicity == "5") {
        ethnicity = "Other".tr;
      } else if (ethnicity == "6") {
        ethnicity = "Prefer not to say".tr;
      } else if (ethnicity.isEmpty) {
        ethnicity = "NA".tr;
      }
      tripStyle = userList?.tripStyle ?? "";
      if (tripStyle == "1") {
        tripStyle = "Backpacking".tr;
      } else if (tripStyle == "2") {
        tripStyle = "Mid-range".tr;
      } else if (tripStyle == "3") {
        tripStyle = "Luxury".tr;
      } else if (tripStyle.isEmpty) {
        tripStyle = "NA".tr;
      }
      tripTimeLine = userList?.tripTimeline ?? "";
      if (tripTimeLine == "1") {
        tripTimeLine = "1-3 Months".tr;
      } else if (tripTimeLine == "2") {
        tripTimeLine = "3-6 Months".tr;
      } else if (tripTimeLine == "3") {
        tripTimeLine = "6-12 Months".tr;
      } else if (tripTimeLine.isEmpty) {
        tripTimeLine = "NA".tr;
      }

      if (userList?.isShowGender == "No") {
        if (userList?.isShowSexualOrientation == "No") {
          if (userList?.isShowEthinicity == "No") {
            listBehave = [gender, sexOrientation, ethnicity, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          } else {
            listBehave = [gender, sexOrientation, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          }
        } else {
          if (userList?.isShowEthinicity == "No") {
            listBehave = [gender, ethnicity, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          } else {
            listBehave = [gender, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          }
        }
      } else {
        if (userList?.isShowSexualOrientation == "No") {
          if (userList?.isShowEthinicity == "No") {
            listBehave = [sexOrientation, ethnicity, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          } else {
            listBehave = [sexOrientation, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          }
        } else {
          if (userList?.isShowEthinicity == "No") {
            listBehave = [ethnicity, tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          } else {
            listBehave = [tripStyle, tripTimeLine];
            debugPrint("User_Profile_Details ${listBehave.length}");
          }
        }
      }

      loginUserId = prefs.getString('userId') ?? "";
      // if(widget.id == loginUserId)
      chatCount = model.chatCount ?? 0;
      likeCount = model.likeCount ?? 0;
      notificationCount = model.notificationCount ?? 0;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
    });
  }

  io.Socket? socket;
  initializeSocket() {
    try {
      socket = io.io(
        CallService.socketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'forceNew': true
        },
      );
      socket!.connect();
      socket!.onConnect((data) async {
        debugPrint('Connected: $data');
        socket!.on('newnotification', (data) async {
          debugPrint("under settings_page newNotification data $data");
          if (data is List) {
            if (data[0]['receiver_id'].toString() == loginUserId) {
              updateChatCount(data[0]['count']);
            }
          }
          debugPrint('data == $data');
        });

        socket!.on('connectionCount', (data) async {
          debugPrint("under home_page connectionCount data $data userId --> $loginUserId");
          if (loginUserId!.isEmpty) {
            return;
          }

          if (data['login_user_id'][0]['login_user_id'].toString() == loginUserId) {
            updateLikeCount(data['login_user_id'][0]['count']);
          }

          if (data['other_user_id'][0]['other_user_id'].toString() == loginUserId) {
            updateLikeCount(data['other_user_id'][0]['count']);
          }
        });

        socket!.on('connectionCount', (data) async {
          debugPrint("under home_page connectionCount data $data");
          if (loginUserId!.isEmpty) {
            return;
          }

          print("CheckValues  ::: Home   ${(data['notification_count_login_user_id'][0]['login_user_id'].toString())} useriddddd --> $loginUserId");

          if (data['notification_count_login_user_id'][0]['login_user_id'].toString() == loginUserId) {
            updateNotificationCount(data['notification_count_login_user_id'][0]['count']);
          }
          if (data['notification_count_other_user_id'][0]['other_user_id'].toString() == loginUserId) {
            updateNotificationCount(data['notification_count_other_user_id'][0]['count']);
          }
        });
        /*  SharedPr
          SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('userId')!;
        socket!.emit('getNotification', {
          'my_id': userId,
        });*/
      });

      socket!.onConnectError((data) {
        debugPrint('Error: $data');
      });
    } catch (e) {
      debugPrint('Error$e');
    }
  }

  updateLikeCount(int count) {
    if (likeCount != count) {
      likeCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(likeCount: likeCount));
      setState(() {});
    }
  }

  updateChatCount(int count) {
    if (chatCount != count) {
      chatCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(
        chatCount: chatCount,
      ));
      setState(() {});
    }
  }

  updateNotificationCount(int count) {
    print("Under settings updateNotificationCount $count");
    if (notificationCount != count) {
      notificationCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(
        notificationCount: notificationCount,
      ));
      setState(() {});
    }
  }

  updateList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OtherUserResponseModel model = await CallService().getOtherUserProfile(widget.id);

      handleDate(model);
/*
      setState(() {
        isLoading = false;
        userList = model.otherUser;
        gender = userList!.gender == null ? '' : userList!.gender!;
        // userId = userList!.id.toString();
        isLikedCount = userList!.isLikedCount.toString();

        chatCount = model.chatCount ?? 0;
        likeCount = model.likeCount ?? 0;
        notificationCount = model.notificationCount ?? 0;

        age = userList!.age.toString();

        travel = userList!.userdestinations!;
        interestList = userList!.userinterest!;
        userName = userList?.firstName ?? " ${userList?.lastName ?? ""}";
        currentAddress = userList?.currentAddress ?? "";
        userImageList = userList!.userimages!;
        if (userImageList.isEmpty) {
          profilePic = '';
        } else {
          profilePic = userImageList[0].imageName!;
        }
        bio = userList!.bio!;
        rating = userList?.avgRating.toString() ?? "";
        debugPrint("DataRating$rating");
        chatMatch = userList!.chatMatch.toString();

        if (gender == "1") {
          gender = "Male";
        } else if (gender == "2") {
          gender = "Female";
        } else if (gender == "3") {
          gender = "Other";
        } else if (gender.isEmpty) {
          gender = "NA";
        }

        sexOrientation = userList?.sexualOrientation ?? "";
        if (sexOrientation == "1") {
          sexOrientation = "Straight";
        } else if (sexOrientation == "2") {
          sexOrientation = "Bisexual";
        } else if (sexOrientation == "3") {
          sexOrientation = "Lesbian";
        } else if (sexOrientation == "4") {
          sexOrientation = "Gay";
        } else if (sexOrientation.isEmpty) {
          sexOrientation = "NA";
        }
        ethnicity = userList?.ethinicity ?? "";
        if (ethnicity == "1") {
          ethnicity = "White";
        } else if (ethnicity == "2") {
          ethnicity = "Hispanic or Latino";
        } else if (ethnicity == "3") {
          ethnicity = "Asian";
        } else if (ethnicity == "4") {
          ethnicity = "Black or African";
        } else if (ethnicity == "5") {
          ethnicity = "Other";
        } else if (ethnicity.isEmpty) {
          ethnicity = "NA";
        }
        tripStyle = userList?.tripStyle ?? "";
        if (tripStyle == "1") {
          tripStyle = "Backpacking";
        } else if (tripStyle == "2") {
          tripStyle = "Mid-range";
        } else if (tripStyle == "3") {
          tripStyle = "Luxury";
        } else if (tripStyle.isEmpty) {
          tripStyle = "NA";
        }
        tripTimeLine = userList?.tripTimeline ?? "";
        if (tripTimeLine == "1") {
          tripTimeLine = "1-3 Months";
        } else if (tripTimeLine == "2") {
          tripTimeLine = "3-6 Months";
        } else if (tripTimeLine == "3") {
          tripTimeLine = "6-12 Months";
        } else if (tripTimeLine.isEmpty) {
          tripTimeLine = "NA";
        }

        if (userList?.isShowGender == "No") {
          if (userList?.isShowSexualOrientation == "No") {
            if (userList?.isShowEthinicity == "No") {
              listBehave = [
                gender,
                sexOrientation,
                ethnicity,
                tripStyle,
                tripTimeLine
              ];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [gender, sexOrientation, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          } else {
            if (userList?.isShowEthinicity == "No") {
              listBehave = [gender, ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [gender, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          }
        } else {
          if (userList?.isShowSexualOrientation == "No") {
            if (userList?.isShowEthinicity == "No") {
              listBehave = [sexOrientation, ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [sexOrientation, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          } else {
            if (userList?.isShowEthinicity == "No") {
              listBehave = [ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          }
        }
        // Old COdd
*/
/*
        if (userList?.isShowGender == "Yes") {
          if (userList?.isShowSexualOrientation == "Yes") {
            if (userList?.isShowEthinicity == "Yes") {
              listBehave = [
                gender,
                sexOrientation,
                ethnicity,
                tripStyle,
                tripTimeLine
              ];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [gender, sexOrientation, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          } else {
            if (userList?.isShowEthinicity == "Yes") {
              listBehave = [gender, ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [gender, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          }
        } else {
          if (userList?.isShowSexualOrientation == "Yes") {
            if (userList?.isShowEthinicity == "Yes") {
              listBehave = [sexOrientation, ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [sexOrientation, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          } else {
            if (userList?.isShowEthinicity == "Yes") {
              listBehave = [ethnicity, tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            } else {
              listBehave = [tripStyle, tripTimeLine];
              debugPrint("User_Profile_Details ${listBehave.length}");
            }
          }
        }*/ /*

      });
*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.transparent,
          ))
        : WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, true);
              return true;
            },
            child: Scaffold(
              body: RefreshIndicator(
                onRefresh: refreshEventList,
                child: SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /*GagagoHeader(showNewOption: false,menuIcon: true,verticalMenu: true,),*/

                      StreamBuilder<BadgesCountModel>(
                          stream: appStreamController.updateBadgesCountAction,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<BadgesCountModel> snapshot,
                          ) {
                            if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  if (snapshot.data!.likeCount != null) {
                                    likeCount = snapshot.data!.likeCount ?? 0;
                                    debugPrint("under setting_page stream data!.likeCount  ${snapshot.data!.likeCount ?? 0} ");
                                  }
                                  if (snapshot.data!.chatCount != null) {
                                    chatCount = snapshot.data!.chatCount ?? 0;
                                    debugPrint("under setting_page stream data!.chatCount  ${snapshot.data!.chatCount ?? 0} ");
                                  }
                                  if (snapshot.data!.notificationCount != null) {
                                    notificationCount = snapshot.data!.notificationCount ?? 0;
                                    debugPrint("under setting_page stream data!.notificationCount  ${snapshot.data!.notificationCount ?? 0} ");
                                  }
                                }
                              }
                            }
                            debugPrint("under setting_page stream chatCount $chatCount likeCount $likeCount notificationCount $notificationCount");

                            return GagagoHomeHeader(
                              showNewOption: false,
                              menuIcon: true,
                              connectionCount: likeCount,
                              chatCount: chatCount,
                              notificationCount: notificationCount,
                              callBackConnectionCount: () {
                                debugPrint("under callBackLikeCount ");
                                FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
                                appStreamController.rebuildupdateBadgesCountStream();
                                appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
                                init();
                              },
                              callBackNotificationCountCount: () {
                                debugPrint("under callBackLikeCount ");
                                FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
                                appStreamController.rebuildupdateBadgesCountStream();
                                appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
                              },
                              callBackChatCount: () {
                                debugPrint("under callBackLikeCount");
                                // setState(() {
                                //   chatCount = 0;
                                // });
                                FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
                                appStreamController.rebuildupdateBadgesCountStream();
                                appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
                              },
                            );
                          }),
                      Padding(
                        padding: EdgeInsets.only(
                          right: Get.width * 0.040,
                          left: Get.width * 0.040,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profilePic.isNotEmpty
                                ? Row(
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
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                            child: CachedNetworkImage(
                                              imageUrl: profilePic,
                                              fit: BoxFit.cover,
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
                                            /*CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundImage:
                                                  NetworkImage(profilePic),
                                              */ /* AssetImage('assets/images/png/profilepic.png'),*/ /*
                                            ),
                                          ),*/
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.015,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          userList?.isShowAge == "No"
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      "$userName, $age",
                                                      style: TextStyle(
                                                          fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.010,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      userName,
                                                      style: TextStyle(
                                                          fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.010,
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            currentAddress.isNotEmpty ? currentAddress : "No Address".tr,
                                            style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Row(
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
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                            child: const CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage:
                                                    //NetworkImage(profilePic),
                                                    AssetImage('assets/images/png/dummypic.png'),
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
                                          userList?.isShowAge == "No"
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      "$userName, $age",
                                                      style: TextStyle(
                                                          fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.010,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      userName,
                                                      style: TextStyle(
                                                          fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.010,
                                                    ),
                                                  ],
                                                ),
                                          Text(
                                            currentAddress.isEmpty ? "User's Address Not Available".tr : currentAddress,
                                            style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
                                    margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
                                    height: Get.height * 0.4,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
                                          width: Get.width,
                                          height: Get.height * 0.3,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: Get.height * 0.020,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  Share.share(
                                                      "${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr} ${userList!.shareProfileLink!}+ ${"Your Referral Code is:".tr + " $refferalCode".tr}",
                                                      subject: "Let’s go with Gagago!".tr);
                                                },
                                                child: Text(
                                                  "Share Profile".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                                                ),
                                              ),
                                              const Divider(
                                                color: AppColors.dividerColor,
                                              ),
                                              (!userList!.checkAlreadyReviewStatus!)
                                                  ? InkWell(
                                                      onTap: () async {
                                                        print("userList!.chatMatch  ${userList!.chatMatch}");
                                                        if (userList!.chatMatch != null) {
                                                          if (userList!.chatMatch == 1) {
                                                            Get.back();
                                                            c.review = userList!.viewReviewStatus;
                                                            await Get.toNamed(RouteHelper.getWriteReviewPage(userList!.id.toString(), userName));
                                                            updateList();
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        "Write Review".tr,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: StringConstants.poppinsRegular,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Get.height * 0.018,
                                                            color: userList!.chatMatch == null
                                                                ? Colors.grey[300]
                                                                : (userList!.chatMatch == 1)
                                                                    ? Colors.black
                                                                    : Colors.grey[300]),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () async {
                                                        // if (userList!
                                                        //         .chatMatch !=
                                                        //     null) {
                                                        //   if (userList!
                                                        //           .chatMatch ==
                                                        //       1) {
                                                        Get.back();
                                                        c.review = userList!.viewReviewStatus;
                                                        await Get.toNamed(RouteHelper.getWriteReviewPage(userList!.id.toString(), userName));
                                                        updateList();
                                                        // }
                                                        // }
                                                      },
                                                      child: Text(
                                                        "Edit Review".tr,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: StringConstants.poppinsRegular,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Get.height * 0.018,
                                                            color: Colors
                                                                .black /*userList!
                                                                        .chatMatch ==
                                                                    null
                                                                ? Colors
                                                                    .grey[300]
                                                                : (userList!.chatMatch ==
                                                                        1)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        300]*/
                                                            ),
                                                      ),
                                                    ),
                                              const Divider(
                                                color: AppColors.dividerColor,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Get.back();
                                                  //int remove_from = 2;
                                                  var map = <String, dynamic>{};
                                                  map['removed_to'] = userList!.id.toString();
                                                  // map['removed_by'] = userId;
                                                  //map['removed_from'] = remove_from;
                                                  ConnectionRemoveModel connectionRemove = await CallService().removeConnection(map);
                                                  if (connectionRemove.status! == true) {
                                                    Get.offAllNamed(RouteHelper.getBottomSheetPage());
                                                    //Get.back();
                                                    //updateList();
                                                    updateList().then((value) {
                                                      //CommonDialog.showToastMessage("User Has Been Removed.");
                                                    });
                                                  } else {
                                                    CommonDialog.showToastMessage(connectionRemove.message.toString());
                                                  }
                                                },
                                                child: Text(
                                                  userList!.chatMatch == null
                                                      ? "Remove".tr
                                                      : userList!.chatMatch == 1
                                                          ? "Remove".tr
                                                          : "Hide".tr,
                                                  // "Remove".tr,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.redTextColor),
                                                ),
                                              ),
                                              const Divider(
                                                color: AppColors.dividerColor,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Get.back();
                                                  _displayTextInputDialog(context, (reasonText) async {
                                                    Get.back();
                                                    String id = userList!.id.toString();
                                                    var map = <String, dynamic>{};
                                                    //map['blocked_by'] = userId;
                                                    map['blocked_to'] = id;
                                                    map['reason_and_comment_report'] = reasonText;

                                                    BlockUserModel userBlock = await CallService().blockUser(map);
                                                    if (userBlock.success! == true) {
                                                      Get.offAllNamed(RouteHelper.getBottomSheetPage());
                                                      updateList().then((value) {
                                                        CommonDialog.showToastMessage("${("${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight()} ${"has been blocked.".tr}");
                                                      });
                                                      /*  Get.back();*/
                                                      //updateList();
                                                    } else {
                                                      CommonDialog.showToastMessage(userBlock.message.toString());
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  "Block & Report".tr,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.redTextColor),
                                                ),
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
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)), color: Colors.white),
                                            width: Get.width,
                                            height: Get.height * 0.070,
                                            child: Center(
                                                child: Text(
                                              "Cancel".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.more_vert,
                                size: Get.height * 0.040,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      userImageList.isNotEmpty
                          ? Stack(
                              children: [
                                CarouselSlider(
                                  items: userImageList.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: Get.width,
                                          /* decoration:
                                            BoxDecoration(color: Colors.amber),*/
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: Get.width,
                                            imageUrl: i.imageName!,
                                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                            errorWidget: (context, url, error) => Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  //Icon(Icons.error),
                                                  Image.asset(
                                                    'assets/images/png/galleryicon.png',
                                                    fit: BoxFit.cover,
                                                    height: Get.height * 0.06,
                                                  ),
                                                  //Text("Error! to Load Image"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: userImageList.length > 1
                                      ? CarouselOptions(
                                          height: Get.height * 0.57,
                                          viewportFraction: 1,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              carouselCount = index;
                                            });
                                          })
                                      : CarouselOptions(
                                          height: Get.height * 0.57,
                                          viewportFraction: 1,
                                          scrollPhysics: const NeverScrollableScrollPhysics(),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              //corrousalCount = index;
                                            });
                                          }),
                                ),
                                Positioned(
                                  bottom: Get.width * 0.05,
                                  child: SizedBox(
                                    width: Get.width,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: userImageList.length > 1
                                          ? /*CarouselIndicator(
                                              height: 1,
                                              width: Get.width * 0.080,
                                        space: Get.width*0.02,
                                              //activeColor: AppColors.forgotPasswordColor,
                                              color: Colors.white,
                                              count: userImageList.length > 5 ? 5 : userImageList.length,
                                              index: carouselCount > 4 ?4 :carouselCount,
                                            )*/
                                          Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: indicators(userImageList.length >= 5 ? 5 : userImageList.length, carouselCount >= 4 ? 4 : carouselCount))
                                          : Container(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: Get.width,
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Text("No Image Available".tr),
                            ),
                      /*SizedBox(
                    height: Get.height * 0.015,
                  ),*/
                      Padding(
                        padding: EdgeInsets.only(
                          right: Get.width * 0.040,
                          left: Get.width * 0.040,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.015,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                chatMatch == "1"
                                    ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          isLikedCount == "1"
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (userList!.isBlocked!) {
                                                      //CommonDialog.showToastMessage('You are blocked by  ${userList!.firstName!}  ${userList!.lastName ?? ""}' );
                                                    } else {
                                                      int status = 0;
                                                      var map = <String, dynamic>{};
                                                      map['liked_to'] = userList!.id;
                                                      map['status'] = status;
                                                      LikeResponseModel userLike = await CallService().getLikeUser(map);
                                                      if (userLike.status! == true) {
                                                        if (userLike.connestionStatus != null) {
                                                          if (userLike.connestionStatus == 1) {
                                                            userList!.chatMatch = 1;
                                                          } else {
                                                            userList!.chatMatch = 0;
                                                          }
                                                        }
                                                        socket!.emit('getNewConnectionNotification', {'other_user_id': userList!.id, 'login_user_id': loginUserId});
                                                        setState(() {
                                                          /* updateList().then((value) {
                                                            //CommonDialog.showToastMessage("User Has Been Disliked Profile.");
                                                          });*/
                                                          updateList();
                                                        });
                                                      } else {
                                                        CommonDialog.showToastMessage(userLike.message.toString());
                                                      }
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    image,
                                                    height: Get.width * 0.12,
                                                    width: Get.width * 0.12,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    if (userList!.isBlocked!) {
                                                      // CommonDialog.showToastMessage('You are blocked by  ${userList!.firstName!}  ${userList!.lastName ?? ""}' );
                                                    } else {
                                                      int status = 1;
                                                      var map = <String, dynamic>{};
                                                      map['liked_to'] = userList!.id;
                                                      map['status'] = status;
                                                      LikeResponseModel userLike = await CallService().getLikeUser(map);
                                                      if (userLike.status! == true) {
                                                        if (userLike.connestionStatus != null) {
                                                          if (userLike.connestionStatus == 1) {
                                                            userList!.chatMatch = 1;
                                                          } else {
                                                            userList!.chatMatch = 0;
                                                          }
                                                        }

                                                        if (userLike.notificationType == 'match_notification') {
                                                          if (await CommonFunctions().getIdFromDeviceLang() == 2) {
                                                            // CommonDialog.showToastMessage(("¡${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                                          } else if (await CommonFunctions().getIdFromDeviceLang() == 7) {
                                                            // CommonDialog.showToastMessage(("${' is now a connection!'.tr}${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight());
                                                          } else {
                                                            // CommonDialog.showToastMessage(("${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                                          }
                                                        }
                                                        socket!.emit('getNewConnectionNotification', {'other_user_id': userList!.id, 'login_user_id': loginUserId});
                                                        setState(() {
                                                          updateList().then((value) {
                                                            //CommonDialog.showToastMessage("User Has Been Liked Profile.");
                                                          });
                                                        });
                                                      } else {
                                                        CommonDialog.showToastMessage(userLike.message.toString());
                                                      }
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    image1,
                                                    height: Get.width * 0.12,
                                                    width: Get.width * 0.12,
                                                  ),
                                                ),
                                          InkWell(
                                            onTap: () {
                                              if (userList!.isBlocked!) {
                                                //CommonDialog.showToastMessage('You are blocked by  ${userList!.firstName!} ${userList!.lastName ?? ""}');
                                              } else {
                                                Navigator.of(
                                                  context,
                                                )
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) => ChatMessageScreen(
                                                      receiverId: userList!.id.toString(),
                                                      isMeBlocked: isMeBlocked.toString(),
                                                      isShown: false,
                                                      connectionType: userList!.connectionType,
                                                      commonInterest: userList!.connectionType == 'travell'
                                                          ? userList!.commonDest == "destination"
                                                              ? ""
                                                              : 'Gagagoing to '.tr + userList!.commonDest.toString()
                                                          : userList!.commonInterest == "hobby"
                                                              ? ""
                                                              : 'Gagago ${userList!.commonInterest}',
                                                      image: userList!.profilePicture,
                                                      name: "${userList!.firstName!}  ${userList!.lastName!}",
                                                    ),
                                                  ),
                                                )
                                                    .then((value) {
                                                  appStreamController.handleBottomTab.add(true);
                                                  if (value != null) {
                                                    if ((value as Map)['removeConnection']) {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const ChatPage()),
                                                      );
                                                    }
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                                width: Get.width * 0.6,
                                                padding: EdgeInsets.all(Get.width * 0.02),
                                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.blueColor),
                                                child: Center(
                                                  child: Text(
                                                    "Message".tr,
                                                    style: TextStyle(color: Colors.white, fontSize: Get.width * 0.03, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.005,
                                          ),
                                          InkWell(
                                            onTap: userList?.avgRating == 0
                                                ? () {}
                                                : () {
                                                    Get.toNamed(RouteHelper.getReviewsPage(widget.id
                                                        /*loginUserId
                                                                .toString()*/
                                                        ));
                                                  },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: userList!.avgRating == 0
                                                      ? () {}
                                                      : () {
                                                          Get.toNamed(RouteHelper.getReviewsPage(widget.id
                                                              /*loginUserId
                                                                          .toString()*/
                                                              ));
                                                        },
                                                  child: SvgPicture.asset(
                                                    "assets/images/svg/borderStar.svg",
                                                    height: Get.width * 0.05,
                                                    width: Get.width * 0.05,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.010,
                                                ),
                                                InkWell(
                                                  onTap: userList!.avgRating == 0
                                                      ? () {}
                                                      : () {
                                                          Get.toNamed(RouteHelper.getReviewsPage(widget.id
/*                                                                      loginUserId
                                                                          .toString()*/
                                                              ));
                                                        },
                                                  child: Text(
                                                    rating.isEmpty ? "NA".tr : rating,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500, fontSize: Get.width * 0.04, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          userList!.isLikedCount == 1
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (userList!.isBlocked!) {
                                                      //CommonDialog.showToastMessage('You are blocked by  ${userList!.firstName!} ${userList!.lastName ?? ""}');
                                                    } else {
                                                      int status = 0;
                                                      var map = <String, dynamic>{};
                                                      map['liked_to'] = userList!.id;
                                                      map['status'] = status;
                                                      LikeResponseModel userLike = await CallService().getLikeUser(map);
                                                      if (userLike.status == true) {
                                                        if (userLike.connestionStatus != null) {
                                                          if (userLike.connestionStatus == 1) {
                                                            userList!.chatMatch = 1;
                                                          } else {
                                                            userList!.chatMatch = 0;
                                                          }
                                                        }

                                                        socket!.emit('getNewConnectionNotification', {'other_user_id': userList!.id, 'login_user_id': loginUserId});
                                                        setState(() {
                                                          updateList();
                                                          // .then((value) {
                                                          //CommonDialog.showToastMessage("User Has Been Disliked Profile.");
                                                          // });
                                                        });
                                                      } else {
                                                        CommonDialog.showToastMessage(userLike.message.toString());
                                                      }
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    image,
                                                    height: Get.width * 0.12,
                                                    width: Get.width * 0.12,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    print("${userList!.id} ${loginUserId}");
                                                    if (userList!.isBlocked!) {
                                                      //CommonDialog.showToastMessage('You are blocked by ${userList!.firstName!} ${userList!.lastName ?? ""}' );
                                                    } else {
                                                      int status = 1;
                                                      var map = <String, dynamic>{};
                                                      map['liked_to'] = userList!.id;
                                                      map['status'] = status;
                                                      LikeResponseModel userLike = await CallService().getLikeUser(map);
                                                      if (userLike.status! == true) {
                                                        if (userLike.connestionStatus != null) {
                                                          if (userLike.connestionStatus == 1) {
                                                            userList!.chatMatch = 1;
                                                          } else {
                                                            userList!.chatMatch = 0;
                                                          }
                                                        }

                                                        if (userLike.notificationType == 'match_notification') {
                                                          if (await CommonFunctions().getIdFromDeviceLang() == 2) {
                                                            //CommonDialog.showToastMessage(("¡${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                                          } else if (await CommonFunctions().getIdFromDeviceLang() == 7) {
                                                            //CommonDialog.showToastMessage(("${' is now a connection!'.tr}${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight());
                                                          } else {
                                                            //  CommonDialog.showToastMessage(("${userList!.firstName!} ${userList!.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                                          }
                                                        }
                                                        socket!.emit('getNewConnectionNotification', {'other_user_id': userList!.id, 'login_user_id': loginUserId});

                                                        if (mounted) {
                                                          setState(() {
                                                            /*       updateList().then((value) {
                                                              if(value!=null){

                                                              }
                                                              //CommonDialog.showToastMessage("User Has Been Liked Profile.");
                                                            });*/
                                                            updateList();
                                                          });
                                                        }
                                                      } else {
                                                        CommonDialog.showToastMessage(userLike.message.toString());
                                                      }
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    image1,
                                                    height: Get.width * 0.11,
                                                    width: Get.width * 0.11,
                                                  ),
                                                ),
                                          Container(
                                              width: Get.width * 0.6,
                                              padding: EdgeInsets.all(Get.width * 0.02),
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.editProfileColor),
                                              child: Center(
                                                child: Text(
                                                  "Message".tr,
                                                  style: TextStyle(color: Colors.black, fontSize: Get.width * 0.03, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                                                ),
                                              )),
                                          SizedBox(
                                            width: Get.width * 0.01,
                                          ),
                                          InkWell(
                                            onTap: userList?.avgRating == 0
                                                ? () {}
                                                : () {
                                                    Get.toNamed(RouteHelper.getReviewsPage(widget.id
                                                        /*loginUserId
                                                                .toString()*/
                                                        ));
                                                  },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: userList!.avgRating == 0
                                                      ? () {}
                                                      : () {
                                                          Get.toNamed(RouteHelper.getReviewsPage(widget.id
                                                              /*loginUserId
                                                                          .toString()*/
                                                              ));
                                                        },
                                                  child: SvgPicture.asset(
                                                    "assets/images/svg/borderStar.svg",
                                                    height: Get.width * 0.05,
                                                    width: Get.width * 0.05,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.010,
                                                ),
                                                InkWell(
                                                  onTap: userList!.avgRating == 0
                                                      ? () {}
                                                      : () {
                                                          Get.toNamed(RouteHelper.getReviewsPage(widget.id
                                                              /*loginUserId
                                                                          .toString()*/
                                                              ));
                                                        },
                                                  child: Text(
                                                    rating.isEmpty ? "NA".tr : rating,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500, fontSize: Get.width * 0.04, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                SizedBox(
                                  height: Get.height * 0.010,
                                ),
                                const Divider(
                                  //color: Colors.red,
                                  color: AppColors.dividerColor,
                                  height: 3,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            listBehave.isNotEmpty
                                ? SizedBox(
                                    height: Get.width * 0.050,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: listBehave.length,
                                      itemBuilder: (context, index) {
                                        print("listBehave --> length ${listBehave.length}");
                                        return listBehave[index].isEmpty
                                            ? SizedBox()
                                            // Text(
                                            //         "NA",
                                            //         style: TextStyle(
                                            //             fontSize: Get.width * 0.03, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                                            //       )
                                            : Text(
                                                listBehave[index],
                                                style:
                                                    TextStyle(fontSize: Get.width * 0.025, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                                              );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const VerticalDivider(
                                          color: AppColors.dividerColor,
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: Get.width * 0.050,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: listBehave1.length,
                                      itemBuilder: (context, index) {
                                        return Text(
                                          listBehave1[index].toString(),
                                          style: TextStyle(fontSize: Get.width * 0.025, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const VerticalDivider(
                                          color: AppColors.dividerColor,
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(
                              height: Get.height * 0.010,
                            ),
                            Text(
                              bio.isNotEmpty ? bio : "No Text Available".tr,
                              style: TextStyle(color: AppColors.desColor, fontSize: Get.width * 0.03, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            Text(
                              "Travel".tr,
                              style: TextStyle(color: AppColors.gagagoLogoColor, fontSize: Get.height * 0.018, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            /* travel.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: travel.length < 4 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.085,
                                        child: travel.isNotEmpty
                                            ? ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                //physics: AlwaysScrollableScrollPhysics(),
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: travel.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  debugPrint("ListLength ${travel.length}");
                                                  return _buildUserDestinationModelList(travel[index], index);
                                                })
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Destination is Not Available!".tr),
                                                ],
                                              ),
                                      ),
                                      */
                            /* Wrap(
                                      spacing: 12,
                                      children: List<Widget>.generate(
                                          travel.length, (int index) {
                                        return Container(
                                          height: Get.height * 0.088,
                                          width: Get.width * 0.20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors
                                                      .inputFieldBorderColor),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                //color: Colors.red,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: Get.height * 0.045,
                                                  width: Get.width*0.12,
                                                 */
                            /* */
                            /* fit: BoxFit.contain,
                                                  height: Get.height * 0.04,*/
                            /* */
                            /*
                                                  imageUrl: travel[index]
                                                      .destImage
                                                      .toString(),
                                                  progressIndicatorBuilder: (context,
                                                          url, downloadProgress) =>
                                                      Center(
                                                          child: CircularProgressIndicator(
                                                              value:
                                                                  downloadProgress
                                                                      .progress)),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              //Icon(Icons.error),
                                                              Image.asset('assets/images/png/galleryicon.png',fit: BoxFit.cover,
                                                                height: Get.height * 0.06,),
                                                              //Text("Error! to Load Image"),
                                                            ],
                                                          ),),
                                                ),
                                              ),
                                              */
                            /* */
                            /*Image.network(
                                                travel[index].destImage.toString(),
                                                width: Get.width * 0.20,
                                                height: Get.height * 0.055,
                                                fit: BoxFit.contain,
                                              ),*/ /* */ /*
                                              SizedBox(
                                                height: Get.height * 0.005,
                                              ),
                                              Text(
                                                travel[index].destName.toString(),textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: StringConstants
                                                        .poppinsRegular,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Get.height * 0.012,
                                                    color: AppColors
                                                        .gagagoLogoColor),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    ),*/ /*
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination is not Available!".tr,
                                        style: TextStyle(
                                          fontFamily: StringConstants.poppinsRegular,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Get.height * 0.014,
                                          color: AppColors.desColor,
                                        ),
                                      )
                                    ],
                                  ),*/

                            travel.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: travel.length == 4 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                    children: List<Widget>.generate(travel.length, (index) {
                                      return _buildUserDestinationModelList(travel[index], index, travel.length < 4);
                                    }))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Destination is Not Available!".tr),
                                    ],
                                  ),

                            /*     travel.isNotEmpty
                                ? Row(
                              mainAxisAlignment: travel.length < 4 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                              height: Get.height * 0.085,
                              child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    //physics: AlwaysScrollableScrollPhysics(),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: travel.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildUserDestinationModelList(travel[index], index);
                                    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width:Get.width * 0.02); },),
                            ),
                                  ],
                                ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Destination is not Available!".tr,
                                  style: TextStyle(
                                    fontFamily: StringConstants.poppinsRegular,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Get.height * 0.014,
                                    color: AppColors.desColor,
                                  ),
                                )
                              ],
                            ),*/
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            Text(
                              "Meet Now".tr,
                              style: TextStyle(color: AppColors.gagagoLogoColor, fontSize: Get.height * 0.018, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                            interestList.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: interestList.length == 4 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                    children: List<Widget>.generate(interestList.length, (index) {
                                      return _buildUserInterestModelList(interestList[index], index, interestList.length < 4);
                                    }))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Meet Now is Not Available!!!!!".tr),
                                    ],
                                  ),
                            /* interestList.isNotEmpty
                                ? Row(
                              mainAxisAlignment: interestList.length < 4 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                              height: Get.height * 0.085,
                              child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    //physics: AlwaysScrollableScrollPhysics(),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: interestList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildUserInterestModelList(interestList[index], index);
                                    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width:Get.width * 0.02); },),
                            ),
                                  ],
                                ): Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Meet Now is Not Available!!!!!".tr),
                              ],
                            ),*/
                            SizedBox(
                              height: Get.height * 0.020,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
  }

  Future<void> _displayTextInputDialog(BuildContext context, Function(String) callbackPositive) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Block & Report'.tr,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.021, fontFamily: StringConstants.poppinsRegular),
            ),
            content: TextField(
              controller: textFieldController,
              minLines: 4,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Share your reason".tr,
                hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xffF02E65)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 66, 125, 145)),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.060,
                          decoration: const BoxDecoration(color: AppColors.cancelButtonColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Cancel'.tr,
                            style: TextStyle(fontSize: Get.height * 0.016, color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        if (textFieldController.text.trim().isEmpty) {
                          CommonDialog.showToastMessage("Share your reason".tr);
                        } else {
                          callbackPositive(textFieldController.text.trim());
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * 0.060,
                        decoration: const BoxDecoration(color: AppColors.buttonColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          'Submit'.tr,
                          style: TextStyle(fontSize: Get.height * 0.016, color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          );
        });
  }

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      updateList();
    });
    return;
  }

  Widget _buildUserDestinationModelList(Userdestinations userDestinations, int index, bool isRightMargin) {
    return Container(
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),
      /*height: Get.height * 0.090,
      width: Get.width * 0.21,*/
      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.inputFieldBorderColor), borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.white),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            fit: BoxFit.fill,
            height: Get.height * 0.045,
            width: Get.width * 0.12,
            /* fit: BoxFit.fitHeight,
            height: Get.height * 0.040,
            width: Get.width*0.08,*/
            imageUrl: userDestinations.destImage!,
            progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/png/galleryicon.png',
                    fit: BoxFit.cover,
                    height: Get.height * 0.06,
                  ),
                  /*  Icon(Icons.error),
                   */
                ],
              ),
            ),
          ),
          /*Image.network(
            userDestinations.destImage!,
            fit: BoxFit.fill,
            height: Get.height * 0.040,
          ),*/
          /*SvgPicture.asset(
            "assets/images/svg/flag.svg",
            height: Get.height * 0.040,
          ),*/
          SizedBox(
            height: Get.width * 0.0005,
          ),
          Flexible(
            child: Text(
              userDestinations.destName!,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500, fontSize: Get.height * 0.012, color: AppColors.gagagoLogoColor),
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInterestModelList(Userinterest userInterest, int index, bool isRightMargin) {
    return Container(
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.inputFieldBorderColor), borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.white),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02),
            child: CachedNetworkImage(
              /* fit: BoxFit.fitWidth,
              height: Get.height * 0.035,
              width: Get.width*0.12,*/
              fit: BoxFit.contain,
              height: Get.height * 0.045,
              width: Get.width * 0.12,
              imageUrl: userInterest.interestImage!,
              progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/galleryicon.png',
                      fit: BoxFit.cover,
                      height: Get.height * 0.06,
                    ),
                    /* Icon(Icons.error),
                      */
                  ],
                ),
              ),
            ),
          ),
          /* Image.network(
            userinterest.interestImage!,
            fit: BoxFit.fill,
            height: Get.height * 0.040,
          ),*/
          /*SvgPicture.asset(
            "assets/images/svg/flag.svg",
            height: Get.height * 0.040,
          ),*/
          SizedBox(
            height: Get.width * 0.0005,
          ),
          Flexible(
            child: Text(
              userInterest.interestName!,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500, fontSize: Get.height * 0.012, color: AppColors.gagagoLogoColor),
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
        ],
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(Get.width * 0.01),
        height: Get.width * 0.005,
        width: Get.width * 0.080,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.white : Colors.white,
        ),
      );
    });
  }
}
