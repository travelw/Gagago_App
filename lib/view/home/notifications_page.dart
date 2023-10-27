import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/model/change_password_response_model.dart';
import 'package:gagagonew/model/notification_response_model.dart';
import 'package:gagagonew/model/readNotificationResponse.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/home/setting_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/common_no_notification_found.dart';
import '../../Service/call_service.dart';
import '../../constants/string_constants.dart';
import '../../model/connection_remove_model.dart';
import '../../utils/common_functions.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isLoading = false;

  List<Data> notificationsList = [];
  ScrollController scrollController = ScrollController();
  bool isPagination = false;
  int page = 0;
  int totalPage = 1;
  bool pageFlag = false;
  String appNotification = "notification_enabled",
      connectionNotification = "match_notification",
      messageNotification = "message_notification",
      messageNotificationEnableds = "",
      matchNotificationEnabled = "";
  int? isSubscribe;
  int? showNotifications = 0;
  int? showConnectionNotifications = 0;
  int? showMessageNotifications = 0;
  int? appNotificationEnabled;
  int? connectionNotificationEnabled;
  int? messageNotificationEnabled;
  SharedPreferences? prefs;
  int? notificationEnabled;
  AppStreamController appStreamController = AppStreamController.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount.add(BadgesCountModel(notificationCount: 0));
      debugPrint("user notification settings");
      appStreamController.handleBottomTab.add(false);
    });
    getSharedPrefences();
    init();
  }

  void hitApis() async {
    ReadNotification model = await CallService().readNotification(context, type: "notification", showLoader: false);
    setState(() {
      if (model.status = true) {}
    });
  }

  Future<void> init() async {
    scrollController.addListener(() {
      debugPrint("under scroll");
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && pageFlag) {
        loadNextPage();
      }
    });

    isLoading = true;
    hitApi();
    hitApis();
  }

  hitApi() {
    page = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationResponseModel responseModel = await CallService().getNotificationsList(page, true);
      setState(() {
        pageFlag = responseModel.flag ?? false;
        page = responseModel.page ?? 0;
        isLoading = false;
        notificationsList = responseModel.data!;
        debugPrint(" responseModel.data! ${responseModel.data!.length}");

        notificationEnabled = int.parse(responseModel.user!.notificationEnabled.toString());
        messageNotificationEnableds = responseModel.user!.messageNotification.toString();
        matchNotificationEnabled = responseModel.user!.matchNotification.toString();

        debugPrint("NotificationsList $notificationsList");
        debugPrint("NotificationsList $notificationEnabled");
        debugPrint("NotificationsList $messageNotificationEnableds");
        debugPrint("NotificationsList $matchNotificationEnabled");
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('notificationEnabled', notificationEnabled.toString());
      prefs.setString('matchNotificationEnabled', matchNotificationEnabled);
      prefs.setString('chatNotificationEnabled', messageNotificationEnableds);
    });
  }

  loadNextPage() async {
    setState(() {
      isPagination = true;
    });
    //isLoading = true;
    // page += 1;

    NotificationResponseModel responseModel = await CallService().getNotificationsList(page, false);
    setState(() {
      isPagination = false;

      isLoading = false;
      pageFlag = responseModel.flag ?? false;
      if (responseModel.page != null) {
        page = responseModel.page!;
      }
      notificationsList.addAll(responseModel.data!);
      notificationEnabled = int.parse(responseModel.user!.notificationEnabled.toString());
      messageNotificationEnableds = responseModel.user!.messageNotification.toString();
      matchNotificationEnabled = responseModel.user!.matchNotification.toString();
    });
  }

  getSharedPrefences() async {
    prefs = await SharedPreferences.getInstance();
    notificationEnabled = int.parse(prefs!.getString('notificationEnabled').toString());
    messageNotificationEnableds = prefs!.getString('chatNotificationEnabled').toString();
    matchNotificationEnabled = prefs!.getString('matchNotificationEnabled').toString();
    debugPrint("DataUserNotificationEnabled$notificationEnabled");
    debugPrint("DataUserNotificationEnabled$messageNotificationEnableds");
    debugPrint("DataUserNotificationEnabled$matchNotificationEnabled");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        appStreamController.handleBottomTab.add(true);

        return true;
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: Get.width * 0.14, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
          child: RefreshIndicator(
            onRefresh: () async {
              await init();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // debugPrint(" scrollInfo.metrics.pixels ${scrollInfo.metrics.pixels} scrollInfo.metrics.maxScrollExtent ${scrollInfo.metrics.maxScrollExtent} ");
                // if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && pageFlag) {
                //   loadNextPage();
                // }
                return true;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        CommonBackButton(
                          name: 'Notifications'.tr,
                        ),
                        Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       margin:
                            //           EdgeInsets.only(left: Get.width * 0.02),
                            //       child: Text(
                            //         "Notification History :".tr,
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontSize: Get.height * 0.018,
                            //             fontWeight: FontWeight.w600,
                            //             fontFamily:
                            //                 StringConstants.poppinsRegular),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            /* SizedBox(
                                height: Get.height * 0.010,
                              ),*/

                            const SizedBox(
                              height: 20,
                            ),
                            isLoading == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.transparent,
                                  ))
                                : notificationsList.isNotEmpty
                                    ? MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        removeBottom: true,
                                        removeLeft: true,
                                        removeRight: true,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          // physics: const BouncingScrollPhysics(),
                                          itemCount: notificationsList.length,
                                          itemBuilder: (context, index) {
                                            print("notificationsList --> ${notificationsList.length}");
                                            String notifyTitle = "";

                                            if (notificationsList[index].notificationType == "match_notification") {
                                              notifyTitle = "New Connection".tr;
                                            } else if (notificationsList[index].notificationType == "like_notification") {
                                              if (notificationsList[index].connection_type_notification == 'Both' || notificationsList[index].connection_type_notification == 'travel') {
                                                // notifyTitle = 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString();
                                                notifyTitle = notificationsList[index].likedByInfo!.commonDest == "destination"
                                                    ? "Gagago Travel"
                                                    : 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString();
                                              }
                                              // notiTitle=   notificationsList[index].likedByInfo!.commonDest == "destination"?"": 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString();}
                                              else {
                                                // notifyTitle = 'Gagago ${notificationsList[index].likedByInfo!.commonInterest}';

                                                if (notificationsList[index].connection_type_notification == "hobby" || notificationsList[index].connection_type_notification == "meetnow") {
                                                  if (notificationsList[index].likedByInfo!.commonInterest == "hobby") {
                                                    notifyTitle = "Meet Now";
                                                  } else {
                                                    notifyTitle = 'Gagago ${notificationsList[index].likedByInfo!.commonInterest}';
                                                  }
                                                } else {
                                                  notifyTitle = 'Gagago ${notificationsList[index].connection_type_notification}';
                                                }
                                              }
                                            }

                                            /* notificationsList[index].notificationType == 'match_found'
                                                    ? notificationsList[index].likedByInfo == null
                                                    ? ""
                                                    :
                                                notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                    notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                    ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                    : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                    : notificationsList[index].notificationType == 'chat_message'
                                                    ? notificationsList[index].likedByInfo == null
                                                    ? ""
                                                    : notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                    notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                    ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                    : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                    : notificationsList[index].notificationType == 'like_notification'
                                                    ? notificationsList[index].likedByInfo == null
                                                    ? ""
                                                    :

                                                notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                    notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                    ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                    : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                    : notificationsList[index].likedByInfo == null
                                                    ? ""
                                                    : notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                    notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                    ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                    : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString();*/

                                            return Slidable(
                                              key: const ValueKey(0),
                                              endActionPane: ActionPane(
                                                // extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: const Color(0xFFFE4A49),
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.delete,
                                                    label: 'Delete',
                                                    onPressed: (BuildContext context) async {
                                                      var map = <String, dynamic>{};
                                                      map['notification_id'] = notificationsList[index].id;
                                                      ConnectionRemoveModel connectionRemove = await CallService().deleteNotif(map);
                                                      if (connectionRemove.status! == true) {
                                                        setState(() {
                                                          notificationsList.removeAt(index);
                                                        });
                                                      } else {
                                                        CommonDialog.showToastMessage(connectionRemove.message.toString());
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                //  padding: EdgeInsets.only(top: Get.height * 0.015),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (notificationsList[index].notificationType == "like_notification") {
                                                      Navigator.of(
                                                        context,
                                                      )
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) => SettingPage(
                                                                  notificationsList[index].likedByUserId.toString(),
                                                                  isFromDashboard:
                                                                      // true,
                                                                      false,
                                                                )),
                                                      )
                                                          .then((value) {
                                                        appStreamController.handleBottomTab.add(false);
                                                      });
                                                    } else if (notificationsList[index].notificationType == "match_found") {
                                                      /*Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  ConnectionsPage()),
                                                            );*/
                                                      Navigator.of(
                                                        context,
                                                      )
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) => SettingPage(
                                                                  notificationsList[index].likedByUserId.toString(),
                                                                  isFromDashboard:
                                                                      // true,
                                                                      false,
                                                                )),
                                                      )
                                                          .then((value) {
                                                        appStreamController.handleBottomTab.add(false);
                                                      });
                                                    } else if (notificationsList[index].notificationType == "match_notification") {
                                                      /*Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  ConnectionsPage()),
                                                            );*/
                                                      Navigator.of(
                                                        context,
                                                      )
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) => SettingPage(
                                                                  notificationsList[index].likedByUserId.toString(),
                                                                  isFromDashboard:
                                                                      // true,
                                                                      false,
                                                                )),
                                                      )
                                                          .then((value) {
                                                        appStreamController.handleBottomTab.add(false);
                                                      });
                                                    } else if (notificationsList[index].notificationType == "chat_message") {
                                                      /*Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  ChatPage()),
                                                            );*/
                                                    }
                                                  },
                                                  child: Card(
                                                    color: Colors.white,
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(7),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 5),
                                                                width: Get.width * 0.08,
                                                                height: Get.width * 0.08,
                                                                child: Image.asset('assets/images/png/splash_icon.png'),
                                                              ),
                                                              Flexible(
                                                                child: Container(
                                                                  margin: const EdgeInsets.only(left: 5),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Flexible(
                                                                            child: Text(
                                                                              notifyTitle,
                                                                              // notificationsList[index].notificationType == 'match_found'
                                                                              //     ? notificationsList[index].likedByInfo == null
                                                                              //         ? ""
                                                                              //         :
                                                                              // notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                                              //                 notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                                              //             ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                                              //             : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                                              //     : notificationsList[index].notificationType == 'chat_message'
                                                                              //         ? notificationsList[index].likedByInfo == null
                                                                              //             ? ""
                                                                              //             : notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                                              //                     notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                                              //                 ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                                              //                 : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                                              //         : notificationsList[index].notificationType == 'like_notification'
                                                                              //             ? notificationsList[index].likedByInfo == null
                                                                              //                 ? ""
                                                                              //                 :
                                                                              //
                                                                              // notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                                              //                         notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                                              //                     ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                                              //                     : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString()
                                                                              //             : notificationsList[index].likedByInfo == null
                                                                              //                 ? ""
                                                                              //                 : notificationsList[index].likedByInfo!.connectionType == 'travell' ||
                                                                              //                         notificationsList[index].likedByInfo!.connectionType == 'Both'
                                                                              //                     ? 'Gagagoing to '.tr + notificationsList[index].likedByInfo!.commonDest.toString()
                                                                              //                     : 'Gagago ' + notificationsList[index].likedByInfo!.commonInterest.toString(),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                                fontSize: Get.width * 0.04,
                                                                                fontFamily: StringConstants.poppinsBold,
                                                                              ),
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                          notificationsList[index].createdAt == null
                                                                              ? Container()
                                                                              : Text(
                                                                                  notificationsList[index].createdAt == null
                                                                                      ? ""
                                                                                      : CommonFunctions.dayDurationToString(notificationsList[index].createdAt!.toString(), context),
                                                                                  // : CommonFunctions.durationToString(notificationsList[index].createdAt!.toString()),

                                                                                  // Jiffy(notificationsList[index].createdAt.toString()).fromNow(),
                                                                                  // Jiffy(notificationsList[index].createdAt.toString()).fromNow(),
                                                                                  /*'2 mins ago',*/
                                                                                  overflow: TextOverflow.visible,
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppColors.grayColorNormal,
                                                                                    fontSize: Get.width * 0.025,
                                                                                    fontFamily: StringConstants.poppinsRegular,
                                                                                  ),
                                                                                )
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        notificationsList[index].message!,
                                                                        overflow: TextOverflow.visible,
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.black,
                                                                          fontSize: Get.width * 0.035,
                                                                          fontFamily: StringConstants.poppinsRegular,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                    : const NoNotificationFoundScreen()
                          ],
                        ),
                      ],
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
                          color: Colors.white,
                          child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      init();
    });
  }
}
