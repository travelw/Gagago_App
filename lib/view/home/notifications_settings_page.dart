import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/model/change_password_response_model.dart';
import 'package:gagagonew/model/notification_response_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/common_no_notification_found.dart';
import '../../Service/call_service.dart';
import '../../constants/string_constants.dart';

class NotificationSettingsScreen extends StatefulWidget {
  NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool isLoading = false;

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
    debugPrint("user notification settings");
    appStreamController.handleBottomTab.add(false);
    super.initState();
    getSharedPrefences();
    init();
  }

  Future<void> init() async {
    isLoading = true;
    hitApi();
  }

  hitApi() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationResponseModel responseModel =
          await CallService().getNotificationsList(0, true);
      setState(() {
        pageFlag = responseModel.flag ?? false;
        isLoading = false;
        debugPrint(" responseModel.data! ${responseModel.data!.length}");

        notificationEnabled =
            int.parse(responseModel.user!.notificationEnabled.toString());
        messageNotificationEnableds =
            responseModel.user!.messageNotification.toString();
        matchNotificationEnabled =
            responseModel.user!.matchNotification.toString();

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

  getSharedPrefences() async {
    prefs = await SharedPreferences.getInstance();
    notificationEnabled =
        int.parse(prefs!.getString('notificationEnabled').toString());
    messageNotificationEnableds =
        prefs!.getString('chatNotificationEnabled').toString();
    matchNotificationEnabled =
        prefs!.getString('matchNotificationEnabled').toString();
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
          padding: EdgeInsets.only(
              top: Get.width * 0.14,
              left: Get.width * 0.060,
              right: Get.width * 0.060,
              bottom: Get.height * 0.020),
          child: RefreshIndicator(
            onRefresh: () async {
              await init();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                return true;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        CommonBackButton(
                          name: 'Notifications'.tr,
                        ),
                        _settingsWidgets(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _settingsWidgets() {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.04,
        ),
        SizedBox(
          height: Get.height * 0.020,
        ),
        Container(
          margin: EdgeInsets.only(left: Get.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: Get.width * 0.3,
                  child: Text(
                    "App Notifications".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:
                            Get.locale! == StringConstants.LOCALE_SPANISH ||
                                    Get.locale! == StringConstants.LOCALE_FRENCH
                                ? Get.height * 0.018
                                : Get.height * 0.018,
                        fontWeight: FontWeight.w600,
                        fontFamily: StringConstants.poppinsRegular),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.1),
                child: SizedBox(
                  width: Get.width * 0.1,
                  child: FittedBox(
                    child: CupertinoSwitch(
                      trackColor: Colors.grey,
                      activeColor: isSubscribe == 0 ? Colors.grey : Colors.blue,
                      value: notificationEnabled == 1 ? true : false,
                      onChanged: (newValue) async {
                        debugPrint("DataValue$newValue");
                        setState(() {
                          if (newValue == true) {
                            appNotificationEnabled = 1;
                            notificationEnabled = 1;
                          } else {
                            appNotificationEnabled = 0;
                            notificationEnabled = 0;
                          }
                          //showNotifications=newValue?1:0;
                        });
                        var map = <String, dynamic>{};
                        map['type'] = appNotification;
                        map['status'] = appNotificationEnabled;
                        ChangePasswordResponseModel submit =
                            await CallService().enableNotifications(map);
                        if (submit.status!) {
                          hitApi();
                          CommonDialog.showToastMessage(
                              submit.message.toString());
                        } else {
                          CommonDialog.showToastMessage(
                              submit.message.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.010,
        ),
        Container(
          margin: EdgeInsets.only(left: Get.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: Get.width / 2,
                  child: Text(
                    "New Connections".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: Get.height * 0.018,
                        fontWeight: FontWeight.w600,
                        fontFamily: StringConstants.poppinsRegular),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.2),
                child: SizedBox(
                  width: Get.width * 0.1,
                  child: FittedBox(
                    child: CupertinoSwitch(
                      trackColor: Colors.grey,
                      activeColor: isSubscribe == 0 ? Colors.grey : Colors.blue,
                      value: matchNotificationEnabled == "1" ? true : false,
                      onChanged: (newValue) async {
                        debugPrint("DataValue$newValue");
                        setState(() {
                          if (newValue == true) {
                            connectionNotificationEnabled = 1;
                            matchNotificationEnabled = "1";
                          } else {
                            connectionNotificationEnabled = 0;
                            matchNotificationEnabled = "0";
                          }
                          //showConnectionNotifications=newValue?1:0;
                        });
                        var map = <String, dynamic>{};
                        map['type'] = connectionNotification;
                        map['status'] = connectionNotificationEnabled;
                        ChangePasswordResponseModel submit =
                            await CallService().enableNotifications(map);
                        if (submit.status!) {
                          /*CommonDialog.showToastMessage(submit.message.toString());*/
                          hitApi();
                        } else {
                          CommonDialog.showToastMessage(
                              submit.message.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.010,
        ),
        Container(
          margin: EdgeInsets.only(left: Get.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: Get.width / 2,
                  child: Text(
                    "New Messages".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: Get.height * 0.018,
                        fontWeight: FontWeight.w600,
                        fontFamily: StringConstants.poppinsRegular),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.2),
                child: SizedBox(
                  width: Get.width * 0.1,
                  child: FittedBox(
                    child: CupertinoSwitch(
                      trackColor: Colors.grey,
                      activeColor: isSubscribe == 0 ? Colors.grey : Colors.blue,
                      value: messageNotificationEnableds == "1" ? true : false,
                      onChanged: (newValue) async {
                        debugPrint("DataValue$newValue");
                        setState(() {
                          if (newValue == true) {
                            messageNotificationEnabled = 1;
                            messageNotificationEnableds = "1";
                          } else {
                            messageNotificationEnabled = 0;
                            messageNotificationEnableds = "0";
                          }
                          //showMessageNotifications=newValue?1:0;
                        });
                        var map = <String, dynamic>{};
                        map['type'] = messageNotification;
                        map['status'] = messageNotificationEnabled;
                        ChangePasswordResponseModel submit =
                            await CallService().enableNotifications(map);
                        if (submit.status!) {
                          hitApi();
                          CommonDialog.showToastMessage(
                              submit.message.toString());
                        } else {
                          CommonDialog.showToastMessage(
                              submit.message.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.010,
        ),
      ],
    );
  }

  Future<void> refreshEventList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      init();
    });
  }
}
