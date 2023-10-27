import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gagagonew/utils/app_custome_network_image.dart';
import 'package:geolocator/geolocator.dart' as geo;
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:gagagonew/CommonWidgets/no_internet_screen.dart';
import 'package:gagagonew/controller/review_controller.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:gagagonew/view/chat/chat_message_screen.dart';
import 'package:gagagonew/view/home/bottom_nav_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/CommonWidgets/common_no_home_data_found.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/model/advertisement_response_model.dart';
import 'package:gagagonew/model/block_user_model.dart';
import 'package:gagagonew/model/connection_remove_model.dart';
import 'package:gagagonew/model/user_dashboard_response_model.dart';
import 'package:gagagonew/model/user_like_model.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/drawer/drawer_page.dart';
import 'package:gagagonew/view/home/setting_page.dart';
import 'package:gagagonew/view/settings/custom_readMore.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CommonWidgets/LoadingDataScreen.dart';
import '../../CommonWidgets/common_gagago_home_header.dart';
import '../../constants/string_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../main.dart';
import '../../model/ads_click_model.dart';
import '../../model/readNotificationResponse.dart';
import '../../utils/common_functions.dart';
import '../app_web_view_screen.dart';
import '../connections/connections_page.dart';
import '../dialogs/common_alert_dialog.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.addScrollController = true}) : super(key: key);
  bool addScrollController;
  static _HomePageState state = _HomePageState();

  static void setCount(int count) {
    state.setLikeCount(count);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, WidgetsBindingObserver {
  bool isLoading = false;
  bool isFirstTime = true;
  String accessToken = "", refferalCode = "", userId = "";
  int? userMode;
  int likeCount = 0;
  int notificationCount = 0;
  int chatCount = 0;
  bool showNewOption = false;
  List<User> userList = [];
  List<Userimages> userImages = [];
  List<AdvertisementList> allAdvertisementList = [];
  List<AdvertisementList> advertisementList = [];
  var randomBannerIndex = Random();
  int? adsShowIndex;
  bool isPagination = false;

  String loadingData = "Loading...";

  String userName = "";
  int advertisementType = 1;
  String image = "assets/images/svg/homePageWorld.svg";

  //image1 = "assets/images/svg/homePageWorld.svg";
  final ScrollController _controller = ScrollController();
  int? totalPages = 2;
  int locationStatus = 0;

  final AppStreamController _appStreamController = AppStreamController.instance;

  int carouselCount = 0;

  // AdmobBannerSize? bannerSize;

  BuildContext? mContext;

  int page = 1;
  ReviewController c = Get.put(ReviewController());

  getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    refferalCode = prefs.getString('refferalCode')!;
    accessToken = prefs.getString('userToken') ?? "";
    userId = prefs.getString('userId') ?? "";
    String userFName = prefs.getString('userFirstName') ?? "";
    String userLName = prefs.getString('userLastName') ?? "";
    userName = "$userFName $userLName";
    setState(() {});
    // if (accessToken.isNotEmpty) {
//      getCurrentLocation();
//     }
    debugPrint("RefferalCode is $refferalCode");
  }

  setLikeCount(int count) {
    setState(() {
      likeCount = count;
    });
    _appStreamController.rebuildupdateBadgesCountStream();
    _appStreamController.updateBadgesCount.add(BadgesCountModel(likeCount: likeCount));
  }

  // void getCurrentLocation() async {
  //   if (await Permission.location.isGranted) {
  //     var position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  //     setState(() {
  //       debugPrint("HomePage lat=====>${position.latitude}");
  //       debugPrint("HomePage long=====>${position.longitude}");
  //
  //       latitude = "${position.latitude}";
  //       longitude = "${position.longitude}";
  //       if (latitude.isNotEmpty && longitude.isNotEmpty && accessToken.isNotEmpty) {
  //         var map = <String, dynamic>{};
  //         map['lat'] = latitude;
  //         map['lng'] = longitude;
  //         debugPrint("updateLocation map $map");
  //         CallService().updateLocation(map);
  //       }
  //     });
  //     getAddressFromLatLong();
  //   } else {
  //     // await [
  //     //   Permission.location,
  //     // ].request();
  //     getCurrentLocation();
  //   }
  // }

  Future<void> getAddressFromLatLong() async {
    debugPrint("HomePage latLngIs=====> $latitude $longitude");
    List<Placemark> place = await placemarkFromCoordinates(double.parse(latitude), double.parse(longitude));
    Placemark p = place[0];
    setState(() {
      currentAddress = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}, ${p.country}';
      debugPrint("HomePage currentAddress=====>$currentAddress");
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    initBackgroundNotifLis(context);
    initNotificationListener(context);
    initStreamListener();
    if (widget.addScrollController) {
      _controller.addListener(() {
        if (_controller.position.pixels == _controller.position.maxScrollExtent) {
          loadNextPage();
        }
      });
    } else {
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          loadNextPage();
        }
      });
    }
    WidgetsBinding.instance.addObserver(this);
    askPermission();

    // initScrollingListener();
    // init();
    // getSharedPrefs();
    //
    // bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
    // scrollController = widget.scrollController;
    //scrollController?.addListener(pagination);
  }

  initStreamListener() {
    appStreamController.updateBadgesCountAction.listen((event) {
      if (event != null) {
        bool isClearNoti = false;
        if (event.likeCount != null) {
          likeCount = event.likeCount ?? 0;
          if (likeCount == 0) {
            isClearNoti = true;
          }
        }
        if (event.notificationCount != null) {
          notificationCount = event.notificationCount ?? 0;
          if (notificationCount == 0) {
            isClearNoti = true;
          }
        }
        if (event.chatCount != null) {
          chatCount = event.chatCount ?? 0;
          if (chatCount == 0) {
            isClearNoti = true;
          }
        }
        if (isClearNoti) {
          // final fln = FlutterLocalNotificationsPlugin();
          // fln.cancelAll();
        }

        FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);

        setState(() {});
      }
    });
    appStreamController.handleRefreshHomeScreenAction.listen((event) {
      debugPrint("under bottom nav stream event $event");
      if (event != null) {
        if (mounted) {
          hitInitApi(callback: () {
            if (!widget.addScrollController) {
              scrollController.animateTo(
                0,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 700),
              );
            } else {
              _controller.animateTo(
                0,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 700),
              );
            }
          });
        }
      }
    });
  }

  initScrollingListener() {
//     widget.scrollController.addListener(() {
// // nextPageTrigger will have a value equivalent to 80% of the list size.
//       var nextPageTrigger = 0.8 * widget.scrollController.position.maxScrollExtent;
//
// // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
//       if (widget.scrollController.position.pixels > nextPageTrigger) {
//         // _loading = true;
//         // fetchData();
//         loadNextPage();
//       }
//     });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        if (!isForground) {
          getBadgesCount();
          askPermission();
        }
        isForground = true;

        break;
      case AppLifecycleState.inactive:
        //getBadgesCount();

        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        isForground = false;
        getBadgesCount();
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        getBadgesCount();
        break;
    }
  }

  hitInitApi({Function()? callback}) async {
    print("under hitInitApi");
    isLoading = true;

    page = 1;
    User_dashboard_response_model model = await CallService().getUsersList(
      page,
      true,
      totalPages: null, /* lastUserId: userList.isNotEmpty ?userList.last.id:null*/
    );

    setState(() {
      isLoading = false;
      isFirstTime = false;
      userList = model.user!;
      if (userList.isNotEmpty) {
        loadingData = "";
      } else {
        loadingData = "";
      }
      userMode = model.userMode!;
      if (model.total_pages != null) {
        totalPages = int.parse(model.total_pages.toString());
      }
      likeCount = model.likeCount ?? 0;
      chatCount = model.chatCount ?? 0;
      notificationCount = model.notificationCount ?? 0;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      debugPrint("userMode $userMode");
      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));

      if (callback != null) {
        callback();
      }
    });
    getAdvertisementList();
  }

  init() async {
    hitInitApi();
    initializeSocket();
  }

  getBadgesCount() async {
    debugPrint("under getBadgesCount");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var model = await CallService().getUserProfile(showLoader: false);
      likeCount = model.likeCount ?? 0;
      chatCount = model.chatCount ?? 0;
      notificationCount = model.notificationCount ?? 0;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      setState(() {});
      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
    });
  }

  void hitApi({required String type}) async {
    ReadNotification model = await CallService().readNotification(context, type: type, showLoader: false);
    print("Model ${model.status}");
    setState(() {
      if (model.status = true) {
        notificationCount = 0;
        print("Check NOtificvation iss Zero $notificationCount");
      }
    });
  }

  Future getAdvertisementList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AdvertisementResponseModel model = await CallService().getAdvertisementList(advertisementType);
      debugPrint("Advertisement_Response $model");
      setState(() {
        isLoading = false;
        allAdvertisementList = model.advertisementList!;
        if (model.advertisementSetting != null) {
          adsShowIndex = int.parse(model.advertisementSetting!.inDashboardHowAnyUsersAfterShowAdd!);
        }
        if (allAdvertisementList.isNotEmpty) {
          for (var element in allAdvertisementList) {
            if (element.advShowArea != 2) {
              advertisementList.add(element);
            }
          }
        }

        // advertisementList.removeWhere((element) => element.advShowArea == 2);

        debugPrint("Advertisement_Response ${advertisementList.length}");
      });
    });
  }

  Future advertisementClick(int adsId, {String? title}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var map = <String, dynamic>{};
      map['advertisement_id'] = adsId;
      CommonDialog.showLoading();
      AdsClickModel model = await CallService().clickAdvertisement(map);
      CommonDialog.hideLoading();
      if (model.status != null) {
        if (model.status == true) {
          if (model.url != null) {
            if (Platform.isIOS) {
              if (model.url!.contains("https://apps.apple.com")) {
                if (!await launchUrl(Uri.parse(model.url!), mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch ${model.url}';
                }
              } else {
                if (!await launchUrl(Uri.parse(model.url!), mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch ${model.url}';
                }
                /*Get.to(AppWebViewScreen(
                  url: model.url,
                  title: title ?? "",
                ));*/
              }
            } else {
              if (!await launchUrl(Uri.parse(model.url!), mode: LaunchMode.externalApplication)) {
                throw 'Could not launch ${model.url}';
              }
              /*Get.to(AppWebViewScreen(
                url: model.url,
                title: title ?? "",
              ));*/
            }
            // if (!await launchUrl(Uri.parse(model.url!))) {
            //   throw 'Could not launch ${model.url}';
            // }
          }
        }
      }
    });
  }

  Future updateList({bool includePreviousPages = false, bool sendTotalPages = true}) async {
    print("under updateList");
    // page = 1;
    User_dashboard_response_model model = await CallService().getUsersList(page, true,
        includePreviousPages: includePreviousPages,
        // lastUserId: userList.isNotEmpty ? userList.last.id : null,
        totalPages: sendTotalPages ? totalPages : null);
    setState(() {
      userList = model.user!;
      userMode = model.userMode!;
      totalPages = int.parse(model.total_pages.toString());
      likeCount = model.likeCount ?? 0;
      chatCount = model.chatCount ?? 0;
      notificationCount = model.notificationCount ?? 0;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      debugPrint("userMode $userMode");
      /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      });*/
    });
    _appStreamController.rebuildupdateBadgesCountStream();
    _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount, notificationCount: notificationCount));
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
        debugPrint('Connectedddd: $data');
        socket!.on('newnotification', (data) async {
          debugPrint("under home_page newNotification data $data");
          if (data is List) {
            if (data[0]['receiver_id'].toString() == userId) {
              updateChatCount(data[0]['count']);
            }
          } else {
            if (data['receiver_id'].toString() == userId) {
              updateChatCount(data['count']);
            }
          }
        });
        socket!.on('connectionCount', (data) async {
          debugPrint("under home_page connectionCount data $data userId --> $userId");
          if (userId.isEmpty) {
            return;
          }

          if (data['login_user_id'][0]['login_user_id'].toString() == userId) {
            updateLikeCount(data['login_user_id'][0]['count']);
          }

          if (data['other_user_id'][0]['other_user_id'].toString() == userId) {
            updateLikeCount(data['other_user_id'][0]['count']);
          }
        });

        socket!.on('connectionCount', (data) async {
          debugPrint("under home_page connectionCount data $data");
          if (userId.isEmpty) {
            return;
          }

          print("CheckValues  ::: Home   ${(data['notification_count_login_user_id'][0]['login_user_id'].toString())} useriddddd --> $userId");

          if (data['notification_count_login_user_id'][0]['login_user_id'].toString() == userId) {
            updateNotificationCount(data['notification_count_login_user_id'][0]['count']);
          }
          if (data['notification_count_other_user_id'][0]['other_user_id'].toString() == userId) {
            updateNotificationCount(data['notification_count_other_user_id'][0]['count']);
          }
        });
        /*  SharedPreferences prefs = await SharedPreferences.getInstance();
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
    print("count ---- >> $count $likeCount");
    if (likeCount != count) {
      likeCount = count;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(likeCount: likeCount));
      if (mounted) {
        setState(() {});
      }
    }
  }

  updateNotificationCount(int count) {
    print("Under home_page updateNotificationCount $count");

    if (notificationCount != count) {
      notificationCount = count;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(notificationCount: notificationCount));
      if (mounted) {
        setState(() {});
      }
    }
  }

  updateChatCount(int count) {
    if (chatCount != count) {
      chatCount = count;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount + notificationCount);
      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(
        chatCount: chatCount,
      ));

      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    //scrollController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isPaginationGoing = false;

  loadNextPage() async {
    // if (scrollController.position.pixels ==
    //     scrollController.position.maxScrollExtent) {
    if (page <= totalPages!) {
      isPagination = true;
      if (isPaginationGoing) {
        return;
      }
      isPaginationGoing = true;
      debugPrint("loadNextPage isPagination $isPagination");

      if (mounted) {
        setState(() {});
      }

      debugPrint("loadNextPage isPagination $isPagination hiting api");
      page += 1;
      User_dashboard_response_model model = await CallService().getUsersList(page, false, lastUserId: userList.isNotEmpty ? userList.last.id : null, totalPages: totalPages);

      setState(() {
        isPagination = false;

        //isLoading = false;

        userList.addAll(model.user!);
        print(userList);
        isPaginationGoing = false;
        userMode = model.userMode!;
        totalPages = int.parse(model.total_pages.toString());
        likeCount = model.likeCount ?? 0;
        chatCount = model.chatCount ?? 0;
        notificationCount = model.notificationCount ?? 0;
        // debugPrint("userMode $userMode");
      });

      _appStreamController.rebuildupdateBadgesCountStream();
      _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: model.chatCount, likeCount: model.likeCount, notificationCount: model.notificationCount));
    } else {
      isPagination = false;
      if (mounted) {
        setState(() {});
      }
      // }
    }
  }

  void shareApp(String urlLink) async {
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
      text: "${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr} $urlLink+ ${"Your Referral Code is:".tr + " $refferalCode".tr}",
      subject: "Let’s go with Gagago!".tr,
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("under home_page $isLoading $loadingData $userList");
    //updateList();
    super.build(context);

    mContext = context;

    return Scaffold(
      drawer: (selectedBottomIndex == 1) ? DrawerPage() : null,
      body: isLoading == true
          ? FutureBuilder<bool>(
              future: isNetworkAvailable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                                  getBadgesCount();
                                  init();
                                  hitApi(type: "like");

                                  /*  // setState(() {
                    likeCount = 0;
                    // });
                    _appStreamController.rebuildupdateBadgesCountStream();
                    _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));*/
                                },
                                callBackChatCount: () {
                                  getBadgesCount();
                                  init();
                                },
                                callBackNotificationCountCount: () {
                                  getBadgesCount();
                                  init();
                                  hitApi(type: "notification");
                                },
                              ),
                              const Expanded(child: SizedBox()

                                  // isFirstTime
                                  //     ? const SizedBox()
                                  //     : const LoadingDataScreen()
                                  ),
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
          : SafeArea(
              child: loadingData.isEmpty
                  ? (userList.isNotEmpty
                      ? Column(
                          children: [
                            StreamBuilder<BadgesCountModel>(
                              stream: _appStreamController.updateBadgesCountAction,
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<BadgesCountModel> snapshot,
                              ) {
                                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      if (snapshot.data!.likeCount != null) {
                                        likeCount = snapshot.data!.likeCount ?? 0;
                                      }
                                      if (snapshot.data!.chatCount != null) {
                                        chatCount = snapshot.data!.chatCount ?? 0;
                                      }
                                      if (snapshot.data!.notificationCount != null) {
                                        notificationCount = snapshot.data!.notificationCount ?? 0;
                                      }
                                    }
                                  }
                                }

                                return GagagoHomeHeader(
                                  showNewOption: false,
                                  menuIcon: true,
                                  connectionCount: likeCount,
                                  chatCount: chatCount,
                                  notificationCount: notificationCount,
                                  callBackConnectionCount: () {
                                    likeCount = 0;
                                    getBadgesCount();
                                    init();
                                    hitApi(type: "like");

                                    /*likeCount = 0;
                        _appStreamController.rebuildupdateBadgesCountStream();
                        _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));*/
                                  },
                                  callBackChatCount: () {
                                    //  debugPrint("under callBackChatCount");
                                    chatCount = 0;
                                    getBadgesCount();
                                    init();
                                  },
                                  callBackNotificationCountCount: () {
                                    notificationCount = 0;
                                    getBadgesCount();
                                    init();
                                    hitApi(type: "notification");
                                  },
                                );
                              },
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: refreshEventList,
                                child: SingleChildScrollView(
                                  controller: widget.addScrollController ? _controller : scrollController,
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                        padding: EdgeInsets.zero,
                                        key: const PageStorageKey<String>('controllerA'),
                                        //scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          print("under List View");

                                          return _buildUserModelList(userList[index], index);
                                        },

                                        separatorBuilder: (context, index) {
                                          if (adsShowIndex == null) {
                                            return const SizedBox();
                                          }
                                          if (advertisementList.isNotEmpty) {
                                            if (index < userList.length) {
                                              if ((index + 1) % adsShowIndex! == 0) {
                                                int rawIndex = ((index + 1) ~/ adsShowIndex! - 1);

                                                if (rawIndex >= advertisementList.length) {
                                                  debugPrint("1 advertisementList---???  ${advertisementList.length}");
                                                  advertisementList = [
                                                    ...advertisementList,
                                                    ...advertisementList,
                                                  ];
                                                  // advertisementList.addAll(advertisementList);
                                                  debugPrint("2. advertisementList---???  ${advertisementList.length}");
                                                }

                                                if (rawIndex < advertisementList.length) {
                                                  debugPrint("if advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex rawIndex $rawIndex");
                                                  // bannerIndex = rawIndex;
                                                  return _buildAdsItem(context, rawIndex);
                                                } else {
                                                  int val1 = randomBannerIndex.nextInt(advertisementList.length);
                                                  debugPrint(" else advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex rawIndex $rawIndex val1 $val1");

                                                  return _buildAdsItem(context, val1 == advertisementList.length ? val1 - 1 : val1);
                                                }
                                              }
                                            }
                                          }
                                          return const SizedBox();

/*
                                                if (index < advertisementList.length) {
                                                  if ((index + 2) % 2 == 0) {
                                                    return _buildAdsItem(context, index);
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                                return SizedBox(
                                                  height: Get.height * 0.010,
                                                );*/
                                        },
                                        itemCount: userList.length,
                                      ),
                                      if (isPagination)
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            )

                            /* Expanded(
                              flex: 8,
                              child: Stack(
                                children: [
                                  NotificationListener<ScrollNotification>(
                                    onNotification:
                                        (ScrollNotification scrollInfo) {
                                      //  print("page $page totalPages $totalPages");
                                      // debugPrint(
                                      //     "--------->>>>>>>>>>>>>>>>>> onNotification ${scrollInfo.metrics.pixels}  ${scrollInfo.metrics.maxScrollExtent} ${scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && page <= totalPages!}");

                                      if (scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent &&
                                          page <= totalPages!) {
                                        isPagination = true;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                        //   debugPrint("--------->>>>>>>>>>>>>>>>>> onNotification");
                                        loadNextPage();
                                      }
                                      return true;
                                    },
                                    child: RefreshIndicator(
                                      onRefresh: refreshEventList,
                                      child: ListView.separated(
                                        key: const PageStorageKey<String>(
                                            'controllerA'),
                                        //scrollDirection: Axis.vertical,
                                        controller:scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return _buildUserModelList(
                                              userList[index], index);
                                        },
                                        separatorBuilder: (context, index) {
                                          if (adsShowIndex == null) {
                                            return const SizedBox();
                                          }
                                          if (advertisementList.isNotEmpty) {
                                            if (index < userList.length) {
                                              if ((index + 1) % adsShowIndex! ==
                                                  0) {
                                                int rawIndex = ((index + 1) ~/
                                                        adsShowIndex! -
                                                    1);

                                                if (rawIndex >=
                                                    advertisementList.length) {
                                                  debugPrint(
                                                      "1 advertisementList---???  ${advertisementList.length}");
                                                  advertisementList = [
                                                    ...advertisementList,
                                                    ...advertisementList,
                                                  ];
                                                  // advertisementList.addAll(advertisementList);
                                                  debugPrint(
                                                      "2. advertisementList---???  ${advertisementList.length}");
                                                }

                                                if (rawIndex <
                                                    advertisementList.length) {
                                                  debugPrint(
                                                      "if advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex rawIndex $rawIndex");
                                                  // bannerIndex = rawIndex;
                                                  return _buildAdsItem(
                                                      context, rawIndex);
                                                } else {
                                                  int val1 = randomBannerIndex
                                                      .nextInt(advertisementList
                                                          .length);
                                                  debugPrint(
                                                      " else advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex rawIndex $rawIndex val1 $val1");

                                                  return _buildAdsItem(
                                                      context,
                                                      val1 ==
                                                              advertisementList
                                                                  .length
                                                          ? val1 - 1
                                                          : val1);
                                                }
                                              }
                                            }
                                          }
                                          return const SizedBox();

*/ /*
                                      if (index < advertisementList.length) {
                                        if ((index + 2) % 2 == 0) {
                                          return _buildAdsItem(context, index);
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                      return SizedBox(
                                        height: Get.height * 0.010,
                                      );*/ /*
                                        },
                                        itemCount: userList.length,
                                      ),
                                    ),
                                  ),
                                  if (isPagination)
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Container(
                                          width: double.infinity,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: const SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator()),
                                        ))
                                ],
                              ),
                            ),*/
                          ],
                        )
                      : Column(
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
                                getBadgesCount();
                                init();
                                hitApi(type: "like");

                                /*  // setState(() {
                  likeCount = 0;
                  // });
                  _appStreamController.rebuildupdateBadgesCountStream();
                  _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));*/
                              },
                              callBackChatCount: () {
                                getBadgesCount();
                                init();
                              },
                              callBackNotificationCountCount: () {
                                getBadgesCount();
                                init();
                                hitApi(type: "notification");
                              },
                            ),
                            Expanded(child: NoHomeDataFoundScreen(
                              callback: () {
                                init();
                              },
                            )),
                            /*GagagoHeader(
              showNewOption: false,
              menuIcon: true,
              userList: userList,
            ),*/
                            SizedBox(
                              height: Get.height * 0.015,
                            ),
                          ],
                        ))
                  : Column(
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
                            getBadgesCount();
                            init();
                            hitApi(type: "like");

                            /*  // setState(() {
                  likeCount = 0;
                  // });
                  _appStreamController.rebuildupdateBadgesCountStream();
                  _appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));*/
                          },
                          callBackChatCount: () {
                            getBadgesCount();
                            init();
                          },
                          callBackNotificationCountCount: () {
                            getBadgesCount();
                            init();
                            hitApi(type: "notification");
                          },
                        ),
                        Expanded(child: isFirstTime ? const SizedBox() : LoadingDataScreen()),
                        /*GagagoHeader(
              showNewOption: false,
              menuIcon: true,
              userList: userList,
            ),*/
                        SizedBox(
                          height: Get.height * 0.015,
                        ),
                      ],
                    )),
    );
  }

  _buildAdsItem(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        advertisementClick(advertisementList[index].id!, title: advertisementList[index].advTxt ?? "");
        return;
        /*  if (advertisementList[index].advActionUrl != null) {
          if (!await launchUrl(Uri.parse(advertisementList[index].advActionUrl.toString() ?? ""))) {
            throw 'Could not launch ${advertisementList[index].advActionUrl.toString()}'.tr;
          }
        } else {}*/
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Get.width * 0.040, left: Get.width * 0.040, bottom: Get.height * 0.020),
            child: Text(
              'Promoted'.tr,
              style: TextStyle(fontSize: Get.height * 0.021, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
            ),
          ),
          CachedNetworkImage(
            fit: BoxFit.fill,
            width: Get.width,
            height: Get.width,
            maxHeightDiskCache: 1300,
            maxWidthDiskCache: 1300,
            imageUrl: advertisementList[index].advImage.toString(),
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
                  /*Text(
                                                        "Error! to Load Image"),*/
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: Get.height * 0.05,
            color: Colors.blue,
            child: Container(
              margin: EdgeInsets.only(left: Get.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    advertisementList[index].advTxt.toString(),
                    style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w400, color: Colors.white, fontFamily: StringConstants.poppinsRegular),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (advertisementList[index].advActionUrl != null) {
                          if (!await launchUrl(Uri.parse(advertisementList[index].advActionUrl.toString()))) {
                            throw 'Could not launch ${advertisementList[index].advActionUrl.toString()}'.tr;
                          }
                        } else {}
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.02, top: Get.height * 0.015, bottom: Get.height * 0.02),
            child: Text(
              advertisementList[index].advDescription == null ? '' : advertisementList[index].advDescription.toString(),
              style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: StringConstants.poppinsRegular),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserModelList(User userList, int index) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.018,
        ),
        Padding(
          padding: EdgeInsets.only(right: Get.width * 0.040, left: Get.width * 0.040),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
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
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingPage(userList.id!.toString())),
                          ).then((value) {
                            if (value != null) {
                              updateList(includePreviousPages: true);
                            }
                          });
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: userList.userimages!.isNotEmpty
                                ? /*ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: CachedNetworkImage(

                                  fit: BoxFit.fitWidth,
                                  width: Get.width,

                                  imageUrl: userList.userimages!.isEmpty
                                      ? ''
                                      : userList.userimages![0].imageName
                                          .toString(),
                                  maxHeightDiskCache: 1000,
                                  maxWidthDiskCache: 1000,
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress
                                                  .progress)),
                                  errorWidget: (context, url, error) =>
                                      Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/png/galleryicon.png',
                                          fit: BoxFit.cover,
                                          height: Get.height * 0.06,
                                        ),
                                        */ /* Icon(Icons.error),
                                  */ /*
                                      ],
                                    ),
                                  ),
                                ),
                              )
*/
                                Image.network(
                                    userList.userimages!.isEmpty ? '' : userList.userimages![0].imageName.toString(),
                                    scale: 0.5,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/png/dummypic.png',
                                  )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.015,
                  ),
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingPage(userList.id!.toString())),
                      ).then((value) {
                        if (value != null) {
                          updateList(includePreviousPages: true);
                        }
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            userList.isShowAge == "No"
                                ? Row(
                                    children: [
                                      Text(
                                        //"${userList.firstName??"${userList.lastName ??""},${userList.age.toString()??""}"}",
                                        userList.firstName ?? "",
                                        /* " " +
                                      "${userList.lastName ?? ""+','},"
                                      " " +
                                      userList.age.toString(),*/
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Text(
                                        //"${userList.firstName??"${userList.lastName ??""},${userList.age.toString()??""}"}",
                                        "${userList.lastName ?? "" ','}, ${userList.age}",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        //"${userList.firstName??"${userList.lastName ??""},${userList.age.toString()??""}"}",
                                        "${userList.firstName}".tr ?? "",
                                        /* " " +
                                      "${userList.lastName ?? ""+','},"
                                      " " +
                                      userList.age.toString(),*/
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                      Text(
                                        //"${userList.firstName??"${userList.lastName ??""},${userList.age.toString()??""}"}",
                                        " ${userList.lastName}".tr ?? "",
                                        style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              width: Get.width * 0.010,
                            ),
                            (showNewOption == true)
                                ? Container(
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.buttonColor),
                                    height: Get.height * 0.024,
                                    width: Get.width * 0.1,
                                    child: Center(
                                        child: Text(
                                      "New",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: Get.height * 0.018),
                                    )),
                                  )
                                : Container()
                          ],
                        ),
                        Text(
                          "${userList.currentAddress}".tr ?? "",
                          style: TextStyle(fontSize: Get.height * 0.016, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  //bottomSheet();
                  openOptionBottomSheet(userList);
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
        userList.userimages!.isNotEmpty
            ? Stack(
                children: [
                  CarouselSlider(
                    items: userList.userimages!.map((i) {
                      // print("CheckIn Image ${ i.imageName.toString()}");

                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                              height: Get.width,
                              /* decoration: BoxDecoration(color: Colors.amber),*/
                              child: /*AppCustomNetworkImage(
                                height: Get.width,
                                width: Get.width,
                                imageUrl: i.imageName.toString(),
                                boxFit: BoxFit.fill,
                              )*/

                                  CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: Get.width,
                                imageUrl: i.imageName.toString(),
                                maxHeightDiskCache: 1300,
                                maxWidthDiskCache: 1300,
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
                                      Icon(Icons.error),
                                    ],
                                  ),
                                ),
                              )
                              /*Image.network(
                              i.imageName!,
                              fit: BoxFit.fill,
                            ),*/
                              /*Image.asset(
                          i.imageName!,
                          fit: BoxFit.fill,
                        )*/
                              );
                        },
                      );
                    }).toList(),
                    options: userList.userimages!.length > 1
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
                                //carouselCount = index;
                              });
                            }),
                  ),
                  Positioned(
                    bottom: Get.width * 0.05,
                    child: SizedBox(
                      width: Get.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: userList.userimages!.length > 1
                            ? /*CarouselIndicator(
                    height: 1,
                    width: Get.width * 0.080,
                    color: Colors.white,activeColor: Colors.blue,
                    //activeColor: AppColors.forgotPasswordColor,
                    //count: userList.userimages!.length,
                    //index: carouselCount,
                    count: userList.userimages!.length >= 5 ? 5 : userList.userimages!.length,
                    index: carouselCount >= 4 ? 4 : carouselCount,
                  )*/
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: indicators(userList.userimages!.length >= 5 ? 5 : userList.userimages!.length, carouselCount >= 4 ? 4 : carouselCount))
                            : Container(),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                height: Get.width,
                /*  decoration: BoxDecoration(color: Colors.white),*/
                child: Image.asset(
                  "assets/images/png/splash_icon.png",
                  width: Get.width * 0.36,
                  height: Get.height * 0.36,
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
          child: userMode == 1
              ? /*Row(
            mainAxisAlignment: userList.userdestinations!.length < 4 ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
                  SizedBox(
                    height: Get.height * 0.085,
                    child: userList.userdestinations!.isNotEmpty
                        ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        //physics: AlwaysScrollableScrollPhysics(),
                        physics: const BouncingScrollPhysics(),
                        itemCount: userList.userdestinations!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildUserDestinationModelList(userList.userdestinations![index], index);
                        }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width: Get.width*0.02,); },)
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Destination is Not Available!".tr),
                      ],
                    ),
                  ),
                ],
              )*/
              userList.userdestinations!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: userList.userdestinations!.length >= 4 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                      children: List<Widget>.generate(userList.userdestinations!.length > 4 ? 4 : userList.userdestinations!.length, (index) {
                        return _buildUserDestinationModelList(userList.userdestinations![index], index, userList.userdestinations!.length < 4);
                      }))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Destination is Not Available!".tr),
                      ],
                    )
              : /*Row(
            mainAxisAlignment: userList.userinterest!.length < 4 ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
                  SizedBox(
                    height: Get.height * 0.085,
                    child: userList.userinterest!.isNotEmpty
                        ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      //physics: AlwaysScrollableScrollPhysics(),
                      physics: const BouncingScrollPhysics(),
                        itemCount: userList.userinterest!.length,
                        itemBuilder: (BuildContext context, int index) {
                          debugPrint("ListLengthhh ${userList.userinterest!.length}");
                          return _buildUserInterestModelList(userList.userinterest![index], index);
                        }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width: Get.width*0.02,); },)
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Interest is Not Available!".tr),
                      ],
                    ),
                  ),
                ],
              ),*/
              userList.userinterest!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: userList.userinterest!.length >= 4 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                      children: List<Widget>.generate(userList.userinterest!.length > 4 ? 4 : userList.userinterest!.length, (index) {
                        return _buildUserInterestModelList(userList.userinterest![index], index, userList.userinterest!.length < 4);
                      }))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Meet Now is Not Available!!!!!".tr),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userList.isLikedCount == 1
                      ? InkWell(
                          onTap: () async {
                            print("under 11111111");
                            if (userList.isBlocked!) {
                              //CommonDialog.showToastMessage('You are blocked by  ${userList.firstName!} ${userList.lastName ?? ""}');
                            } else {
                              int status = 0;
                              var map = <String, dynamic>{};
                              map['liked_to'] = userList.id;
                              map['status'] = status;
                              LikeResponseModel userLike = await CallService().getLikeUser(map);
                              if (userLike.status == true) {
                                if (userLike.connestionStatus != null) {
                                  if (userLike.connestionStatus == 1) {
                                    this.userList[index].chatMatch = 1;
                                  } else {
                                    this.userList[index].chatMatch = 0;
                                  }
                                }
                                socket!.emit('getNewConnectionNotification', {'other_user_id': userList.id, 'login_user_id': userId});
                                setState(() {
                                  userList.isLikedCount = 0;
                                });
                              } else {
                                CommonDialog.showToastMessage(userLike.message.toString());
                              }
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/images/svg/colorGlobe.svg",
                            height: Get.height * 0.055,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            print("under 22222222");
                            if (userList.isBlocked!) {
                              // CommonDialog.showToastMessage('You are blocked by  ${userList.firstName!} ${userList.lastName ?? ""}');
                            } else {
                              int status = 1;
                              var map = <String, dynamic>{};
                              map['liked_to'] = userList.id;
                              map['status'] = status;
                              LikeResponseModel userLike = await CallService().getLikeUser(map);
                              if (userLike.status! == true) {
                                if (userLike.connestionStatus != null) {
                                  if (userLike.connestionStatus == 1) {
                                    this.userList[index].chatMatch = 1;
                                  } else {
                                    this.userList[index].chatMatch = 0;
                                  }
                                }
                                if (userLike.notificationType == 'match_notification') {
                                  if (await CommonFunctions().getIdFromDeviceLang() == 2) {
                                    //CommonDialog.showToastMessage(("${userList.firstName!} ${userList.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                  } else if (await CommonFunctions().getIdFromDeviceLang() == 7) {
                                    //CommonDialog.showToastMessage(("${' is now a connection!'.tr}${userList.firstName!} ${userList.lastName ?? ""}").trimRight());
                                  } else {
                                    // CommonDialog.showToastMessage(("${userList.firstName!} ${userList.lastName ?? ""}").trimRight() + ' is now a connection!'.tr);
                                  }
                                }
                                socket!.emit('getNewConnectionNotification', {'other_user_id': userList.id, 'login_user_id': userId});
                                setState(() {
                                  userList.isLikedCount = 1;
                                });
                              } else {
                                //  CommonDialog.showToastMessage(userLike.message.toString());
                              }
                            }
                          },
                          child: SvgPicture.asset(
                            image,
                            height: Get.height * 0.055,
                          ),
                        ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        //width: Get.width * 0.645,
                        child: ReadMoreText(
                          userList.bio == null ? '' : userList.bio.toString().tr,
                          trimLines: 2,
                          preDataTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.016),
                          style: TextStyle(
                            color: AppColors.gagagoLogoColor,
                            fontFamily: StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.height * 0.017,
                          ),
                          colorClickableText: Colors.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'more'.tr,
                          onTap: () {
                            debugPrint('more');
                            setState(() {
                              this.userList[index].isreadMore = true;
                            });
                          },
                          readMore: this.userList[index].isreadMore,
                          /* trimCollapsedText: '...more',
                            trimExpandedText: '',*/
                        )

                        /* ExpandableText(
                            text: userList.bio == null
                                ? ''
                                : userList.bio.toString(),
                            onTap: () {
                              userList.isreadMore = !userList.isreadMore;
                              setState(() {});
                            },
                            readMore: userList.isreadMore,
                          ),*/
                        ),
                  ),
                  InkWell(
                    onTap: userList.avgRating! > 0
                        ? () {
                            Get.toNamed(RouteHelper.getReviewsPage(userList.id.toString()));
                          }
                        : () {},
                    child: Container(
                      height: Get.height * 0.055,
                      //alignment: Alignment.center,
                      margin: EdgeInsets.only(top: Get.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/borderStar.svg",
                            height: Get.height * 0.022,
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          ),
                          Text(
                            userList.avgRating.toString().isEmpty ? "NA".tr : userList.avgRating.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            width: Get.width * 0.010,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.010,
              )
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.018,
        ),
        /*if(nextPageLoading)
        Center(
          child: CircularProgressIndicator.adaptive(),
        )*/
      ],
    );
  }

  openOptionBottomSheet(User userList) {
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
                    onTap: () async {
                      Get.back();
                      shareApp(userList.shareProfileLink!);
                      /*   await Share.share(
                                      "${"Hey there, check out Gagago and connect with people who have the same interests as you!".tr} ${userList.shareProfileLink!}+ ${"Your Referral Code is:".tr + " $refferalCode".tr}",
                                      subject: "Let’s go with Gagago!".tr,
                                    );*/
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
                  (!userList.checkAlreadyReviewStatus!)
                      ? InkWell(
                          onTap: () async {
                            if (userList.chatMatch != null) {
                              if (userList.chatMatch == 1) {
                                Get.back();
                                c.review = userList.viewReviewStatus;
                                String userName = "${userList.firstName!} ${userList.lastName ?? "" ','}";
                                await Get.toNamed(RouteHelper.getWriteReviewPage(userList.id.toString(), userName));
                                updateList(includePreviousPages: true);
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
                                color: (userList.chatMatch == null)
                                    ? Colors.grey[300]
                                    : (userList.chatMatch == 1)
                                        ? Colors.black
                                        : Colors.grey[300]),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            // if (userList.chatMatch != null) {
                            //   if (userList.chatMatch == 1) {
                            Get.back();
                            c.review = userList.viewReviewStatus;
                            String userName = "${userList.firstName!} ${userList.lastName ?? "" ','}";
                            await Get.toNamed(RouteHelper.getWriteReviewPage(userList.id.toString(), userName));
                            updateList(includePreviousPages: true);
                            //   }
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
                                    .black /* (userList.chatMatch == null)
                                    ? Colors.grey[300]
                                    : (userList.chatMatch == 1)
                                        ? Colors.black
                                        : Colors.grey[300]*/
                                ),
                          ),
                        ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      debugPrint("My User Id $userId");
                      //int remove_from = 2;
                      var map = <String, dynamic>{};
                      map['removed_to'] = userList.id.toString();
                      //map['removed_by'] = userId;
                      //map['removed_from'] = remove_from;
                      ConnectionRemoveModel connectionRemove = await CallService().removeConnection(map);
                      if (connectionRemove.status! == true) {
                        updateList().then((value) {
                          String message = "";
                          if (userList.chatMatch == null) {
                            message = " has been removed.".tr;
                          } else {
                            if (userList.chatMatch == 1) {
                              message = " has been removed.".tr;
                            } else {
                              message = " has been hidden.".tr;
                            }
                          }
                          CommonDialog.showToastMessage(("${userList.firstName!} ${userList.lastName ?? ""}").trimRight() + message);
                        });
                      } else {
                        CommonDialog.showToastMessage(connectionRemove.message.toString());
                      }
                    },
                    child: Text(
                      userList.chatMatch == null
                          ? "Remove".tr
                          : userList.chatMatch == 1
                              ? "Remove".tr
                              : "Hide".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.redTextColor),
                    ),
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back(); // pop Sheet

                      _displayTextInputDialog(context, (reasonText) async {
                        Get.back(); // pop Dialog
                        String id = userList.id.toString();
                        var map = <String, dynamic>{};
                        //map['blocked_by'] = userId;
                        map['blocked_to'] = id;
                        map['reason_and_comment_report'] = reasonText;
                        BlockUserModel userBlock = await CallService().blockUser(map);
                        if (userBlock.success! == true) {
                          Get.back();

                          CommonDialog.showToastMessage("${("${userList.firstName!} ${userList.lastName ?? ""}").trimRight()} ${"has been blocked.".tr}");
                        } else {
                          CommonDialog.showToastMessage(userBlock.message.toString());
                        }
                        refreshEventList();
                      });
                    },
                    child: Text(
                      "Block & Report".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: AppColors.redTextColor),
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
  }

  Future<void> _displayTextInputDialog(BuildContext context, Function(String) callbackPositive) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Block & Report'.tr,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: Get.height * 0.021, fontFamily: StringConstants.poppinsRegular),
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
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                // focusedBorder: const OutlineInputBorder(
                //   borderSide: BorderSide(width: 1, color: Color(0xffF02E65)),
                // ),
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

  Widget _buildUserDestinationModelList(Userdestinations userDestinations, int index, bool isRightMargin) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030),
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),
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
            maxHeightDiskCache: 1300,
            maxWidthDiskCache: 1300,
            /* fit: BoxFit.fitHeight,
            height: Get.height * 0.040,
            width: Get.width*0.08,*/
            imageUrl: userDestinations.destImage ?? "",
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
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      margin: EdgeInsets.only(right: isRightMargin ? Get.width * 0.04 : 0.0),
      // padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030),
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
              maxHeightDiskCache: 1300,
              maxWidthDiskCache: 1300,
              fit: BoxFit.contain,
              height: Get.height * 0.045,
              width: Get.width * 0.12,
              imageUrl: userInterest.interestImage ?? "",
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
              userInterest.interestName ?? "",
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

/*  Widget _buildUserDestinationModelList(Userdestinations userDestinations, int index) {
    return Container(
      //margin: EdgeInsets.only(left: index > 0 ? Get.width * 0.02 : 0),
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      */ /*height: Get.height * 0.090,
      width: Get.width * 0.21,*/ /*
      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.inputFieldBorderColor), borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            fit: BoxFit.fill,
            height: Get.height * 0.045,
            width: Get.width * 0.12,
            */ /* fit: BoxFit.fitHeight,
            height: Get.height * 0.040,
            width: Get.width*0.08,*/ /*
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
                  */ /*  Icon(Icons.error),
                   */ /*
                ],
              ),
            ),
          ),
          */ /*Image.network(
            userdestinations.destImage!,
            fit: BoxFit.fill,
            height: Get.height * 0.040,
          ),*/ /*
          */ /*SvgPicture.asset(
            "assets/images/svg/flag.svg",
            height: Get.height * 0.040,
          ),*/ /*
          SizedBox(
            height: Get.height * 0.005,
          ),
          Flexible(
            child: Text(
              userDestinations.destName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500, fontSize: Get.height * 0.012, color: AppColors.gagagoLogoColor),
            ),
          ),
          SizedBox(
            width: Get.width * 0.013,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInterestModelList(Userinterest userInterest, int index) {

    return Container(
     // margin: EdgeInsets.only(left: index > 0 ? Get.width * 0.03 : 0),
      height: Get.height * 0.088,
      width: Get.width * 0.20,
      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.inputFieldBorderColor), borderRadius:const BorderRadius.all(Radius.circular(10)), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02),
            child: CachedNetworkImage(
              */ /* fit: BoxFit.fitWidth,
              height: Get.height * 0.035,
              width: Get.width*0.12,*/ /*
              fit: BoxFit.fill,
              height: Get.height * 0.035,
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
                    */ /* Icon(Icons.error),
                      */ /*
                  ],
                ),
              ),
            ),
          ),
          */ /* Image.network(
            userinterest.interestImage!,
            fit: BoxFit.fill,
            height: Get.height * 0.040,
          ),*/ /*
          */ /*SvgPicture.asset(
            "assets/images/svg/flag.svg",
            height: Get.height * 0.040,
          ),*/ /*
          SizedBox(
            height: Get.height * 0.005,
          ),
          Flexible(
            child: Text(
              userInterest.interestName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500, fontSize: Get.height * 0.012, color: AppColors.gagagoLogoColor),
            ),
          ),
          SizedBox(
            width: Get.width * 0.013,
          ),
        ],
      ),
    );
  }*/

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

  Future<void> refreshEventList() async {
    page = 1;
    /*await Future.delayed(Duration(seconds: 2));
    setState(() {
      updateList();
    });*/
    updateList(sendTotalPages: false);
    //getCurrentLocation();
  }

  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  void askPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denined.");
      Permission.location.request();
    } else if (status.isGranted) {
      getCurrentLocation();
      //permission is already granted.
      //   print("Permission is already granted.");

      initScrollingListener();
      init();
      getSharedPrefs();
      // bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
      //  scrollController = widget.scrollController;
    } else if (status.isPermanentlyDenied) {
      //permission is permanently denied.
      openAppBox(context);

      //   print("Permission is permanently denied");
    } else if (status.isRestricted) {
      //permission is OS restricted.
      //   print("Permission is OS restricted.");
      openAppBox(context);
    }
  }

  void getCurrentLocation() async {
    // if (await Permission.location.isGranted) {
    var position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    debugPrint("HomePage lat=====>${position.latitude}");
    debugPrint("HomePage long=====>${position.longitude}");
    latitude = "${position.latitude}";
    longitude = "${position.longitude}";
  }

  bool isDialogShowing = false;

  void openAppBox(context) {
    if (isDialogShowing) {
      return;
    }
    isDialogShowing = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            description: 'Please allow location access to use the app. Your location is used to determine Travel and Meet Now mode connections',
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Alert'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'.tr,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 10),
                  Divider(),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        isDialogShowing = false;
                        Navigator.pop(context);
                        openAppSettings();
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ExpandableTexts extends StatefulWidget {
  const ExpandableTexts({
    Key? key,
    this.text,
    this.trimLines = 3,
    this.readMore = false,
    this.onTap,
    this.textAlign,
  })  : assert(text != null),
        super(key: key);

  final String? text;
  final int? trimLines;
  final bool? readMore;
  final VoidCallback? onTap;
  final TextAlign? textAlign;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableTexts> {
/*  bool _readMore = true;
  */ /* void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }*/

  @override
  Widget build(BuildContext context) {
    print('dsfdsg===>>${widget.readMore}');
    const widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: widget.readMore == false ? "...more".tr : " ",
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
        /*TextStyle(
          color: colorClickableText,
        ),*/
        recognizer: TapGestureRecognizer()..onTap = widget.onTap);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth - 10;
        // Create a TextSpan with data
        final text =
            TextSpan(text: widget.text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular));
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          textAlign: TextAlign.justify,
          text: link,
          textDirection: TextDirection.rtl,
          //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int? endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: widget.readMore == false ? widget.text?.substring(0, endIndex) : widget.text,
            style: const TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: const TextStyle(
              color: widgetColor,
            ),
          );
        }
        return RichText(
          maxLines: 3,
          textAlign: TextAlign.justify,
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
