import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:gagagonew/CommonWidgets/common_gagago_home_header.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/user_profile_model.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/home/personal_info.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonWidgets/no_internet_screen.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/more_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'bottom_nav_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, this.callBack}) : super(key: key);

  final Function(String)? callBack;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<User> userList = [];
  String? userId = "";
  String accessToken = "";
  String profilePic = "";
  int corrousalCount = 0;
  String loginType = "1";
  String userName = "";
  String email = "";
  String phoneNumber = "";
  String bio = "";
  String currentAddress = "";
  String isSubscribe = "";
  List<String> listBehav = [];
  List<Userdestinations> travel = [];
  List<Userinterest> interestList = [];
  List<Userimages> userImageList = [];
  AppStreamController appStreamController = AppStreamController.instance;
  bool? isShown;
  String gender = "",
      sexOrientation = "",
      ethnicity = "",
      tripStyle = "",
      tripTimeLine = "",
      avgRating = "",
      userAge = "",
      countryCode = "",
      isShowAge = "",
      dateOfBirth = "";

  bool isLoading = false;
  int likeCount = 0;
  int chatCount = 0;
  int notificationCount = 0;

  String currentUserAddress = "";
  String latitude = "";
  String longitude = "";
  loc.Location location = loc.Location();

  /*List<String> listBehav1 = <String>["NA", "NA", "NA", "NA", "NA"];*/

  List<MoreModel> travel1 = [
    MoreModel(name: "Paris", image: "assets/images/svg/flag1.svg"),
    MoreModel(name: "London", image: "assets/images/svg/londonFlag.svg"),
    MoreModel(name: "Venice", image: "assets/images/svg/veniceFlag.svg"),
  ];

  List<MoreModel> more = [
    MoreModel(name: "Yoga", image: "assets/images/svg/yogaMore.svg"),
    MoreModel(
        name: "Photography", image: "assets/images/svg/PhotographyHome.svg"),
    MoreModel(name: "Coffee", image: "assets/images/svg/coffeeHome.svg"),
  ];

  @override
  void initState() {
    /*getSharedPrefs();*/
    initBackgroundNotifLis(context);
    initNotificationListener(context);
    super.initState();
    debugPrint("user profile page");
    isLoading = true;
    initStreamListener();
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
          if (data is List) {
            if (data[0]['receiver_id'].toString() == userId) {
              updateChatCount(data[0]['count']);
            }
          } else {
            if (data['receiver_id'].toString() == userId) {
              updateChatCount(data['count']);
            }
          }
          debugPrint('dattta$data');
        });
      /*  socket!.on('connectionCount', (data) async {
          debugPrint("under Socket data -> $data");
          debugPrint("under user_profile newNotification data $data userId --> $userId");

          if (data['login_user_id'][0]['login_user_id'].toString() == userId) {
            updateLikeCount(data['login_user_id'][0]['count']);
          }

          if (data['other_user_id'][0]['other_user_id'].toString() == userId) {
            updateLikeCount(data['other_user_id'][0]['count']);
          }

          // if (data['login_user_id'][0]['login_user_id'].toString() == userId) {
          //   updateLikeCount(data['login_user_id'][0]['count']);
          //   debugPrint(" under Socket --> $likeCount");
          // }
          // if (data['other_user_id'][0]['other_user_id'].toString() == userId) {
          //   updateLikeCount(data['other_user_id'][0]['count']);
          // }
          // debugPrint('dattta$data');
        });*/
        /*  SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('userId')??";
        socket!.emit('getNotification', {
          'my_id': userId,
        });*/
      });
     /* socket!.on('connectionCount', (data) async {
        debugPrint("under home_page connectionCount data $data");

        print(
            "CheckValues  ::: user_profile  ${(data['notification_count_login_user_id'][0]['login_user_id'].toString())}  useriddddd --> $userId");

        if (data['notification_count_login_user_id'][0]['login_user_id']
                .toString() ==
            userId) {
          updateNotificationCount(
              data['notification_count_login_user_id'][0]['count']);
        }
        if (data['notification_count_other_user_id'][0]['other_user_id']
                .toString() ==
            userId) {
          updateNotificationCount(
              data['notification_count_other_user_id'][0]['count']);
        }

        //
        // if (data['notification_count_login_user_id'][0]['login_user_id']
        //         .toString() ==
        //     userId) {
        //   updateNotificationCount(
        //       data['notification_count_login_user_id'][0]['count']);
        // }
        // if (data['notification_count_other_user_id'][0]['other_user_id']
        //         .toString() ==
        //     userId) {
        //   updateNotificationCount(
        //       data['notification_count_other_user_id'][0]['count']);
        // }
      });*/

      socket!.onConnectError((data) {
        debugPrint('Error: $data');
      });
    } catch (e) {
      debugPrint('Error$e');
    }
  }

  initStreamListener() {
    appStreamController.refreshProfilePageStream();
    appStreamController.refreshProfilePageAction.listen((event) {
      debugPrint("Profile Page initStreamListener $event");
      getCurrentLocation();
      init(showLoader: true);
    });
  }

  updateLikeCount(int count) {
    if (likeCount != count) {
      likeCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount
          .add(BadgesCountModel(likeCount: likeCount));

      setState(() {});
    }
  }

  updateChatCount(
    int count,
  ) {
    if (chatCount != count) {
      chatCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(
        chatCount: chatCount,
      ));

      if (mounted) {
        setState(() {});
      }
    }
  }

  updateNotificationCount(
    int count,
  ) {
    if (notificationCount != count) {
      notificationCount = count;
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(
        notificationCount: notificationCount,
      ));

      if (mounted) {
        setState(() {});
      }
    }
  }

  init({required bool showLoader}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProfileModel model =
          await CallService().getUserProfile(showLoader: showLoader);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'notificationEnabled',
          model.user![0].notificationEnabled != null
              ? model.user![0].notificationEnabled.toString()
              : "0");
      prefs.setString(
          'matchNotificationEnabled', model.user![0].matchNotification ?? "0");
      prefs.setString(
          'chatNotificationEnabled', model.user![0].messageNotification ?? "0");

      debugPrint("under getUserProfile ->");
      isLoading = false;
      userList = model.user!;
      userId = userList[0].id.toString();
      likeCount = model.likeCount ?? 0;
      chatCount = model.chatCount ?? 0;
      notificationCount = model.notificationCount ?? 0;
      debugPrint(
          "Under User Profile chatCount -> $chatCount likeCount $likeCount");
      gender = userList[0].gender == null ? '' : userList[0].gender!.toString();
      travel = userList[0].userdestinations!;
      interestList = userList[0].userinterest!;
      userImageList = userList[0].userimages!;
      if (userImageList.isEmpty) {
        profilePic = '';
      } else {
        profilePic = userImageList[0].imageName!;
        if (widget.callBack != null) {
          widget.callBack!(userImageList[0].imageName!);
        }
      }

      String? firstName = userList[0].firstName ?? "";
      String? lastName = userList[0].lastName ?? "";
      loginType = userList[0].loginWith ?? "";
      userName = firstName + lastName;
      userAge = userList[0].age.toString();
      currentAddress = userList[0].currentAddress!;
      countryCode = userList[0].countryCode!;
      dateOfBirth = userList[0].dob!;
      debugPrint("CurrentAddress$currentAddress");
      userImageList = userList[0].userimages!;
      bio = userList[0].bio ?? "";
      email = userList[0].email ?? "";
      phoneNumber = userList[0].phoneNumber ?? "";
      avgRating = userList[0].avgRating.toString();
      isSubscribe = userList[0].isSubscriber.toString();
      isShowAge = userList[0].isShowAge.toString();
      debugPrint("ShowAge$isShowAge");

      if (gender == "1") {
        gender = "Male".tr;
      } else if (gender == "2") {
        gender = "Female".tr;
      } else if (gender == "3") {
        gender = "Other".tr;
      } else if (gender == "4") {
        gender = "Prefer not to say".tr;
      } else if (gender.isEmpty) {
        gender = "";
        debugPrint("Value is $gender");
      }

      sexOrientation = userList[0].sexualOrientation == null
          ? ''
          : userList[0].sexualOrientation.toString();
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
        sexOrientation = "";
      }
      ethnicity = userList[0].ethinicity == null
          ? ''
          : userList[0].ethinicity.toString();
      debugPrint("ethnicity $ethnicity");
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
        ethnicity = "";
      }

      tripStyle =
          userList[0].tripStyle == null ? '' : userList[0].tripStyle.toString();
      if (tripStyle == "1") {
        tripStyle = "Backpacking".tr;
      } else if (tripStyle == "2") {
        tripStyle = "Mid-range".tr;
      } else if (tripStyle == "3") {
        tripStyle = "Luxury".tr;
      } else if (tripStyle.isEmpty) {
        tripStyle = "";
      }

      tripTimeLine = userList[0].tripTimeline == null
          ? ''
          : userList[0].tripTimeline.toString();
      if (tripTimeLine == "1") {
        tripTimeLine = "1-3 Months".tr;
      } else if (tripTimeLine == "2") {
        tripTimeLine = "3-6 Months".tr;
      } else if (tripTimeLine == "3") {
        tripTimeLine = "6-12 Months".tr;
      } else if (tripTimeLine.isEmpty) {
        tripTimeLine = "";
      }

      if (gender.isEmpty) {
        listBehav = [sexOrientation, ethnicity, tripStyle, tripTimeLine];
      } else if (sexOrientation.isEmpty) {
        listBehav = [gender, ethnicity, tripStyle, tripTimeLine];
      } else if (ethnicity.isEmpty) {
        listBehav = [gender, sexOrientation, tripStyle, tripTimeLine];
      } else if (tripStyle.isEmpty) {
        listBehav = [gender, sexOrientation, ethnicity, tripTimeLine];
      } else if (tripTimeLine.isEmpty) {
        listBehav = [
          gender,
          sexOrientation,
          ethnicity,
          tripStyle,
        ];
      } else {
        listBehav = [
          gender,
          sexOrientation,
          ethnicity,
          tripStyle,
          tripTimeLine
        ];
        debugPrint("User_Profile_Details ${listBehav.length}");
      }
      if (mounted) setState(() {});
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(
          chatCount: chatCount,
          likeCount: likeCount,
          notificationCount: notificationCount));
      initializeSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshEventList,
      child: SafeArea(
          child: isLoading
              ? FutureBuilder<bool>(
                  future: isNetworkAvailable(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!
                          ? SafeArea(
                              child: Column(
                                children: [
                                  /*StreamBuilder<BadgesCountModel>(
                            stream: _appStreamController.updateBadgesCountAction,
                            builder: (
                                BuildContext context,
                                AsyncSnapshot<BadgesCountModel> snapshot,
                                ) {
                              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data!.likeCount != null) {
                                      likeCount = snapshot.data!.likeCount;
                                    }
                                    if (snapshot.data!.likeCount != null) {
                                      chatCount = snapshot.data!.chatCount;
                                    }
                                  }
                                }
                              }

                              return GagagoHomeHeader(
                                showNewOption: false,
                                menuIcon: true,
                                connectionCount: likeCount!,
                                chatCount: chatCount!,
                              );
                            },
                          ),*/

                                  GagagoHomeHeader(
                                    showNewOption: false,
                                    menuIcon: true,
                                    connectionCount: likeCount,
                                    chatCount: chatCount,
                                    notificationCount: notificationCount,
                                    callBackConnectionCount: () {
                                      debugPrint("under callBackLikeCount");
                                      FlutterAppBadger.updateBadgeCount(
                                          likeCount +
                                              chatCount +
                                              notificationCount);
                                      appStreamController
                                          .rebuildupdateBadgesCountStream();
                                      appStreamController.updateBadgesCount.add(
                                          BadgesCountModel(
                                              chatCount: chatCount,
                                              likeCount: likeCount,
                                              notificationCount:
                                                  notificationCount));
                                    },
                                    callBackChatCount: () {
                                      debugPrint("under callBackLikeCount");
                                      FlutterAppBadger.updateBadgeCount(
                                          likeCount +
                                              chatCount +
                                              notificationCount);
                                      appStreamController
                                          .rebuildupdateBadgesCountStream();
                                      appStreamController.updateBadgesCount.add(
                                          BadgesCountModel(
                                              chatCount: chatCount,
                                              likeCount: likeCount,
                                              notificationCount:
                                                  notificationCount));
                                    },
                                    callBackNotificationCountCount: () {
                                      debugPrint("under callBackLikeCount");
                                      FlutterAppBadger.updateBadgeCount(
                                          likeCount +
                                              chatCount +
                                              notificationCount);
                                      appStreamController
                                          .rebuildupdateBadgesCountStream();
                                      appStreamController.updateBadgesCount.add(
                                          BadgesCountModel(
                                              chatCount: chatCount,
                                              likeCount: likeCount,
                                              notificationCount:
                                                  notificationCount));
                                    },
                                  ),
                                  Expanded(child: Container()),
                                  /*GagagoHeader(
                showNewOption: false,
                menuIcon: true,
                userList: userList,
            ),*/
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                ],
                              ),
                            )
                          : const Center(child: NoInternetScreen());
                    } else {
                      return Container();
                    }
                  })
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      /*GagagoHeader(showNewOption: false,menuIcon: true,verticalMenu: true,),*/

                      StreamBuilder<BadgesCountModel>(
                        stream: appStreamController.updateBadgesCountAction,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<BadgesCountModel> snapshot,
                        ) {
                          debugPrint("under user_profile_page stream");

                          if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                if (snapshot.data!.likeCount != null) {
                                  likeCount = snapshot.data!.likeCount ?? 0;
                                }
                                if (snapshot.data!.chatCount != null) {
                                  chatCount = snapshot.data!.chatCount ?? 0;
                                }
                                if (snapshot.data!.notificationCount != null) {
                                  notificationCount =
                                      snapshot.data!.notificationCount ?? 0;
                                }
                              }
                            }
                          }

                          debugPrint(
                              "under user_profile_page stream likeCount $likeCount chatCount $chatCount notificationCount $notificationCount");

                          return GagagoHomeHeader(
                            showNewOption: false,
                            menuIcon: true,
                            connectionCount: likeCount,
                            chatCount: chatCount,
                            notificationCount: notificationCount,
                            callBackConnectionCount: () {
                              debugPrint("under callBackLikeCount");
                              FlutterAppBadger.updateBadgeCount(
                                  likeCount + chatCount + notificationCount);
                              appStreamController
                                  .rebuildupdateBadgesCountStream();
                              appStreamController.updateBadgesCount.add(
                                  BadgesCountModel(
                                      chatCount: chatCount,
                                      likeCount: likeCount,
                                      notificationCount: notificationCount));
                            },
                            callBackChatCount: () {
                              debugPrint("under callBackLikeCount");
                              FlutterAppBadger.updateBadgeCount(
                                  likeCount + chatCount + notificationCount);

                              appStreamController
                                  .rebuildupdateBadgesCountStream();
                              appStreamController.updateBadgesCount.add(
                                  BadgesCountModel(
                                      chatCount: chatCount,
                                      likeCount: likeCount,
                                      notificationCount: notificationCount));
                            },
                            callBackNotificationCountCount: () {
                              FlutterAppBadger.updateBadgeCount(
                                  likeCount + chatCount + notificationCount);
                              appStreamController
                                  .rebuildupdateBadgesCountStream();
                              appStreamController.updateBadgesCount.add(
                                  BadgesCountModel(
                                      chatCount: chatCount,
                                      likeCount: likeCount,
                                      notificationCount: notificationCount));
                            },
                          );
                        },
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: Get.width * 0.040,
                              left: Get.width * 0.040,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    profilePic.isNotEmpty
                                        ? Container(
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
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                ),
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              //this padding will be you border size
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: CachedNetworkImage(
                                                    imageUrl: profilePic,
                                                    fit: BoxFit.cover,

                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Center(
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress)),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Column(
                                                      children: [
                                                        //Icon(Icons.error),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom:
                                                                  Get.height *
                                                                      0.005),
                                                          child: Image.asset(
                                                            'assets/images/png/profilespic.png',
                                                            fit: BoxFit.fill,
                                                            height: Get.height *
                                                                0.03,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        CircleAvatar(
                                                      radius: 15,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                                  )
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
                                          )
                                        : Container(
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
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                ),
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              //this padding will be you border size
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: const CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundImage:
                                                        //NetworkImage(profilePic),
                                                        AssetImage(
                                                            'assets/images/png/dummypic.png'),
                                                  ),
                                                ),
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
                                        isShowAge == "No"
                                            ? Row(
                                                children: [
                                                  Text(
                                                    userName.isNotEmpty
                                                        ? "$userName, "
                                                        : "",
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
                                                    userAge.isNotEmpty
                                                        ? userAge
                                                        : "",
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
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    userName.isNotEmpty
                                                        ? userName
                                                        : "",
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
                                          currentAddress.isNotEmpty
                                              ? currentAddress
                                              : "No Address".tr,
                                          style: TextStyle(
                                              fontSize: Get.height * 0.016,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.gagagoLogoColor,
                                              fontFamily: StringConstants
                                                  .poppinsRegular),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    //bottomSheet();
                                    Get.bottomSheet(
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.white),
                                              width: Get.width,
                                              height: Get.height * 0.3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: Get.height * 0.020,
                                                  ),
                                                  Text(
                                                    "Share Profile",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Get.height * 0.018,
                                                        color: Colors.black),
                                                  ),
                                                  const Divider(
                                                    color:
                                                        AppColors.dividerColor,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      /* Get.toNamed(RouteHelper
                                                      .getWriteReviewPage(
                                                          userList[0]
                                                              .id
                                                              .toString()));*/
                                                    },
                                                    child: Text(
                                                      "Write Review",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              StringConstants
                                                                  .poppinsRegular,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: Get.height *
                                                              0.018,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color:
                                                        AppColors.dividerColor,
                                                  ),
                                                  Text(
                                                    "Remove",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Get.height * 0.018,
                                                        color: AppColors
                                                            .redTextColor),
                                                  ),
                                                  const Divider(
                                                    color:
                                                        AppColors.dividerColor,
                                                  ),
                                                  Text(
                                                    "Block & Report".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Get.height * 0.018,
                                                        color: AppColors
                                                            .redTextColor),
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
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          Dimensions.radius15)),
                                                  color: Colors.white),
                                              width: Get.width,
                                              height: Get.height * 0.070,
                                              child: Center(
                                                  child: Text(
                                                "Cancel".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: StringConstants
                                                        .poppinsRegular,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        Get.height * 0.018,
                                                    color: Colors.black),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PersonalInfo(

                                                loginType:loginType,
                                                userName: userName,
                                                phoneNumber: phoneNumber,
                                                email: email,
                                                isSubscriber: isSubscribe,
                                                profilePic: profilePic,
                                                countryCode: countryCode,
                                                dateOfBirth: dateOfBirth,
                                                isShown: false)),
                                      ).then((value) {
                                        init(showLoader: false);
                                        appStreamController.handleBottomTab
                                            .add(true);
                                      });
                                      /* Get.toNamed(RouteHelper.getMyProfilePage(
                                      userName,
                                      phoneNumber,
                                      email,
                                      isSubscribe,
                                      profilePic,countryCode));*/
                                    },
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: Get.height * 0.040,
                                    ),
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
                                            return CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: Get.width,
                                              imageUrl: i.imageName!,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  Center(
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //Icon(Icons.error),
                                                    Image.asset(
                                                      'assets/images/png/galleryicon.png',
                                                      fit: BoxFit.cover,
                                                      height: Get.height * 0.06,
                                                    ),
                                                    /*   Text("Error! to Load Image"),*/
                                                  ],
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
                                                  corrousalCount = index;
                                                });
                                              })
                                          : CarouselOptions(
                                              height: Get.height * 0.57,
                                              viewportFraction: 1,
                                              scrollPhysics:
                                                  const NeverScrollableScrollPhysics(),
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
                                              color: Colors.white,
                                              //activeColor: AppColors.forgotPasswordColor,
                                              count: userImageList.length >= 5 ? 5 : userImageList.length,
                                              index: corrousalCount >= 4 ?4 :corrousalCount,
                                            )*/
                                              Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: indicators(
                                                      userImageList.length >= 5
                                                          ? 5
                                                          : userImageList
                                                              .length,
                                                      corrousalCount >= 4
                                                          ? 4
                                                          : corrousalCount))
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  height: Get.width,
                                  /*decoration: BoxDecoration(color: Colors.white),*/
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await Get.toNamed(RouteHelper
                                                    .getEditProfile())!
                                                .then((value) {
                                              if (value != null) {
                                                isLoading = true;
                                                init(showLoader: true);
                                              }
                                            });
                                          },
                                          child: Container(
                                              height: Get.height * 0.038,
                                              width: Get.width * 0.65,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: AppColors
                                                      .editProfileColor),
                                              child: Center(
                                                child: Text(
                                                  "Edit Profile".tr,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          Get.height * 0.015,
                                                      fontFamily:
                                                          StringConstants
                                                              .poppinsRegular,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                        ),
                                        InkWell(
                                          onTap: avgRating != "0"
                                              ? () {
                                                  Get.toNamed(RouteHelper
                                                      .getReviewsPage(
                                                          userId.toString()));
                                                }
                                              : () {},
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: avgRating != "0"
                                                    ? () {
                                                        Get.toNamed(RouteHelper
                                                            .getReviewsPage(userId
                                                                .toString()));
                                                      }
                                                    : () {},
                                                child: SvgPicture.asset(
                                                  "assets/images/svg/borderStar.svg",
                                                  height: Get.height * 0.020,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.010,
                                              ),
                                              InkWell(
                                                onTap: avgRating != "0"
                                                    ? () {
                                                        Get.toNamed(RouteHelper
                                                            .getReviewsPage(userId
                                                                .toString()));
                                                      }
                                                    : () {},
                                                child: Text(
                                                  avgRating.isEmpty
                                                      ? "NA".tr
                                                      : avgRating,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          Get.height * 0.015,
                                                      color: AppColors
                                                          .gagagoLogoColor,
                                                      fontFamily:
                                                          StringConstants
                                                              .poppinsRegular),
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
                                  height: Get.height * 0.010,
                                ),
                                if (listBehav.isNotEmpty)
                                  SizedBox(
                                    height: Get.width * 0.090,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: listBehav.length,
                                      itemBuilder: (context, index) {
                                        return listBehav[index].isEmpty
                                            ? const SizedBox()
                                            // Text(
                                            //         "NA",
                                            //         style: TextStyle(
                                            //             fontSize: Get.width * 0.025,
                                            //             color: AppColors.gagagoLogoColor,
                                            //             fontFamily: StringConstants.poppinsRegular,
                                            //             fontWeight: FontWeight.w600),
                                            //       )
                                            : Row(
                                                children: [
                                                  Text(
                                                    listBehav[index],
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.width * 0.025,
                                                        color: AppColors
                                                            .gagagoLogoColor,
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  if (index <
                                                      listBehav.length - 1)
                                                    SizedBox(
                                                      height: Get.width * 0.050,
                                                      child:
                                                          const VerticalDivider(
                                                        color: AppColors
                                                            .dividerColor,
                                                      ),
                                                    )
                                                ],
                                              );
                                      },
                                      // separatorBuilder: (BuildContext context, int index) {
                                      //   return const VerticalDivider(
                                      //     color: AppColors.dividerColor,
                                      //   );
                                      // },
                                    ),
                                  ),
                                SizedBox(
                                  height: Get.height * 0.005,
                                ),
                                Text(
                                  bio.isNotEmpty ? bio : "No Text Available".tr,
                                  style: TextStyle(
                                      color: AppColors.grayColorNormal,
                                      fontSize: Get.width * 0.03,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: Get.height * 0.020,
                                ),
                                Text(
                                  "Travel".tr,
                                  style: TextStyle(
                                      color: AppColors.gagagoLogoColor,
                                      fontSize: Get.height * 0.018,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: Get.height * 0.020,
                                ),
                                travel.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: travel.length >= 4
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.start,
                                        children: List<Widget>.generate(
                                            travel.length > 4
                                                ? 4
                                                : travel.length, (index) {
                                          return _buildUserDestinationModelList(
                                              travel[index],
                                              index,
                                              travel.length < 4);
                                        }))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Destination is Not Available!"
                                              .tr),
                                        ],
                                      ),
                                /*travel.isNotEmpty
                          ?Row(
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
                                return _buildUserDestinationModelList(travel[index], index,travel.length>4);
                              }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width:Get.width * 0.02); },),
                      ),
                            ],
                          ):Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Destination is Not Available!".tr),
                        ],
                      ),*/
                                SizedBox(
                                  height: Get.height * 0.020,
                                ),
                                Text(
                                  "Meet Now".tr,
                                  style: TextStyle(
                                      color: AppColors.gagagoLogoColor,
                                      fontSize: Get.height * 0.018,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: Get.height * 0.020,
                                ),
                                interestList.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            interestList.length >= 4
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.start,
                                        children: List<Widget>.generate(
                                            interestList.length > 4
                                                ? 4
                                                : interestList.length, (index) {
                                          return _buildUserInterestModelList(
                                              interestList[index],
                                              index,
                                              interestList.length < 4);
                                        }))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Meet Now is Not Available!!!!!"
                                              .tr),
                                        ],
                                      ),
                                /*interestList.isNotEmpty
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
                                return _buildUserInterestModelList(interestList[index], index,interestList.length>4);
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
                      )
                    ],
                  ),
                )),
    );
  }

  void getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      var position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);
      if (mounted) {
        setState(() {
          debugPrint("HomePage lat=====>${position.latitude}");
          debugPrint("HomePage long=====>${position.longitude}");
          latitude = "${position.latitude}";
          longitude = "${position.longitude}";
          if (latitude.isNotEmpty && longitude.isNotEmpty) {
            var map = <String, dynamic>{};
            map['lat'] = latitude;
            map['lng'] = longitude;
            debugPrint("updateLocation map $map");
            CallService().updateLocation(map);
          }
        });
      }
      //getAddressFromLatLong();
    } else {
      await [
        Permission.location,
      ].request();
      getCurrentLocation();
    }
  }

/*
  Future<void> getAddressFromLatLong() async {
    debugPrint("HomePage latLngIs=====> $latitude $longitude");
    List<Placemark> place = await placemarkFromCoordinates(double.parse(latitude), double.parse(longitude));
    Placemark p = place[0];
    setState(() {
      currentUserAddress = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}, ${p.country}';
      debugPrint("HomePage currentUserAddress=====>$currentUserAddress");
    });
  }
*/

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      init(showLoader: false);
      getCurrentLocation();
    });
    return;
  }

  Widget _buildUserDestinationModelList(
      Userdestinations userDestinations, int index, bool isRightMargin) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030),
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),

      height: Get.height * 0.088,
      width: Get.width * 0.20,

      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.inputFieldBorderColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
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
            imageUrl: userDestinations.destImage ?? "",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
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
            userdestinations.destImage!,
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
              userDestinations.destName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: StringConstants.poppinsRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: Get.height * 0.012,
                  color: AppColors.gagagoLogoColor),
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInterestModelList(
      Userinterest userInterest, int index, bool isRightMargin) {

    print("userInterest.interestImage --> ${userInterest.interestImage}");
    return Container(
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),
      // padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.inputFieldBorderColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: Get.width * 0.02, right: Get.width * 0.02),
            child: CachedNetworkImage(
              /* fit: BoxFit.fitWidth,
              height: Get.height * 0.035,
              width: Get.width*0.12,*/
              fit: BoxFit.contain,
              height: Get.height * 0.045,
              width: Get.width * 0.12,
              imageUrl: userInterest.interestImage ?? "",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
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
              userInterest.interestName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: StringConstants.poppinsRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: Get.height * 0.012,
                  color: AppColors.gagagoLogoColor),
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
