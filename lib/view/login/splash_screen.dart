import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../constants/string_constants.dart';
import '../../main.dart';
import '../dialogs/common_alert_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  String? accessToken = "";

  Future<dynamic> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('userToken');
    debugPrint("Access Token $accessToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/png/splash_background.png",
                fit: BoxFit.fill,
                width: Get.width,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/png/splash_icon.png",
                width: Get.width * 0.4,
                height: Get.height * 0.4,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(bottom: Get.height * 0.070),
                  child: GradientText(
                    'GagaGo',
                    style: TextStyle(
                        fontSize: Get.height * 0.035,
                        fontWeight: FontWeight.w700,
                        fontFamily: StringConstants.interBold),
                    colors: const [
                      AppColors.splashGradColor1,
                      AppColors.splashGradColor2,
                      AppColors.splashGradColor3,
                      AppColors.splashGradColor4
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  bool showVersionScreen = false;

  @override
  void initState() {
    super.initState();
    // askPermission(callBack: (value) async {
    init();
    // });
    // init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state  --->>> ${state.name}");
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        askPermission(callBack: (value) async {
          init();
        });

        break;
      case AppLifecycleState.inactive:
        //getBadgesCount();

        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");

        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        break;
    }
  }

  init() async {
    availableCameras().then((value) {
      camerasAvailable = value;
    });

// Instantiate NewVersion manager object (Using GCP Console app as example)

// try {
//   final newVersion = NewVersion(
//     iOSId: 'com.gagago.gagagonew',
//     androidId: 'com.gagago.gagagonew',
//   );
//   showVersionScreen = await advancedStatusCheck(newVersion);
// } catch (e) {
//   print(e);
// }
    getSharedPrefs();

    var value = await Permission.notification
        .isDenied; /*.then((value) async {
  print("value ------> $value");
  if (value) {
    await Permission.notification.request();
  }
});*/

    if (value) {
      await Permission.notification.request();
    }

    if (showVersionScreen) {
    } else {
      Timer(
        const Duration(seconds: 4),
        () => accessToken == null
            ? Get.offAllNamed(RouteHelper.getLoginPage())
            : Get.offAllNamed(RouteHelper.getBottomSheetPage()),
      );
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  void askPermission({required Function(bool) callBack}) async {
    var status = await Permission.notification.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denined.");
      await Permission.notification.request();
      callBack(true);
    } else if (status.isGranted) {
      //permission is already granted.
      callBack(true);
      //  scrollController = widget.scrollController;
    } else if (status.isPermanentlyDenied) {
      //permission is permanently denied.
      // callBack(true);
      openAppBox(context);
      //   print("Permission is permanently denied");
    } else if (status.isRestricted) {
      //permission is OS restricted.
      // callBack(true);
      openAppBox(context);
    } else {
      callBack(false);
    }
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
            description:
                'Please allow notification access to get notification in the app.',
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
        });
  }

  Future<bool> advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint('P<===> ${status}');
    if (status != null) {
      // debugPrint('P===> ${status.releaseNotes}');
      // debugPrint('P===> ${status.appStoreLink}');
      // debugPrint('P===> ${status.localVersion}');
      // debugPrint('P===> ${status.storeVersion}');
      // debugPrint('P===> ${status.canUpdate.toString()}');
      return status.canUpdate;
      // newVersion.showUpdateDialog(
      //   context: context,
      //   versionStatus: status,
      //   dialogTitle: 'Custom Title',
      //   dialogText: 'Custom Text',
      // );
    }
    return false;
  }
}
