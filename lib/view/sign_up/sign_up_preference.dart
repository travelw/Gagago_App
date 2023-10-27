import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/controller/register_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/progress_bar.dart';
import '../dialogs/common_alert_dialog.dart';

class SignUpPreference extends StatefulWidget {
  const SignUpPreference({Key? key}) : super(key: key);

  @override
  State<SignUpPreference> createState() => _SignUpPreferenceState();
}

class _SignUpPreferenceState extends State<SignUpPreference> {
  RegisterController c = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      askPermission(callBack: (value) async {});
    });
  }

  // String gender = '0';
  // String orientation = '0';
  // String ethnicity = '0';
  String? gender;
  String? orientation;
  String? ethnicity;
  bool visibleGender = false;
  bool visibleOrientation = false;
  bool visibleEthnicity = false;

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
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/png/splash_icon.png",
                width: Get.width * 0.36,
                height: Get.height * 0.36,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * 0.63,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Get.height * 0.05),
                      topRight: Radius.circular(Get.height * 0.05)),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                      top: Get.height * 0.05,
                      left: Get.width * 0.060,
                      bottom: Get.height * 0.025,
                      right: Get.width * 0.060),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getSelectionWidgetGender('Gender'.tr),
                        // Container(
                        //   margin: EdgeInsets.only(top: Get.height * 0.01, bottom: Get.height * 0.01),
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         width: Get.width * 0.05,
                        //         height: Get.width * 0.05,
                        //         child: Checkbox(
                        //           value: visibleGender,
                        //           onChanged: (newValue) {
                        //             setState(() {
                        //               visibleGender = newValue!;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: Get.height * 0.01,
                        //       ),
                        //       Text("Prefer not to say".tr,
                        //           style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        getSelectionWidgetSexual('Sexual Orientation'.tr),
                        // Container(
                        //   margin: EdgeInsets.only(top: Get.height * 0.01, bottom: Get.height * 0.01),
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         width: Get.width * 0.05,
                        //         height: Get.width * 0.05,
                        //         child: Checkbox(
                        //           value: visibleOrientation,
                        //           onChanged: (newValue) {
                        //             setState(() {
                        //               visibleOrientation = newValue!;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: Get.height * 0.01,
                        //       ),
                        //       Text("Prefer not to say".tr,
                        //           style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        getSelectionWidgetEthnicity('Ethnicity'.tr),
                        // Container(
                        //   margin: EdgeInsets.only(top: Get.height * 0.01, bottom: Get.height * 0.01),
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         width: Get.width * 0.05,
                        //         height: Get.width * 0.05,
                        //         child: Checkbox(
                        //           value: visibleEthnicity,
                        //           onChanged: (newValue) {
                        //             setState(() {
                        //               visibleEthnicity = newValue!;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: Get.height * 0.01,
                        //       ),
                        //       Text("Prefer not to say".tr,
                        //           style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
                        //     ],
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            if (gender == null) {
                              CommonDialog.showToastMessage(
                                  'Please select gender'.tr,
                                  toastPosition: ToastGravity.BOTTOM);
                            } else if (orientation == null) {
                              CommonDialog.showToastMessage(
                                  'Please select sexual orientation'.tr,
                                  toastPosition: ToastGravity.BOTTOM);
                            } else if (ethnicity == null) {
                              CommonDialog.showToastMessage(
                                  'Please select ethnicity'.tr,
                                  toastPosition: ToastGravity.BOTTOM);
                            } else {
                              c.gender = gender;
                              c.orientation = orientation;
                              c.ethnicity = ethnicity;
                              // c.genderVisible = visibleGender ? 1 : 0;
                              // c.sexualOrientationVisible = visibleOrientation ? 1 : 0;
                              // c.ethnicityVisible = visibleEthnicity ? 1 : 0;
                              debugPrint('c.gender ${c.gender} ');
                              debugPrint('c.orientation ${c.orientation}');
                              debugPrint('c.ethnicity ${c.ethnicity}');
                              debugPrint('c.genderVisible ${c.genderVisible}');
                              debugPrint(
                                  'c.sexualOrientationVisible ${c.sexualOrientationVisible}');
                              debugPrint(
                                  'c.ethnicityVisible ${c.ethnicityVisible}');
                              Get.toNamed(
                                  RouteHelper.getSignUpTripDetailsPage());
                            }
                            /*c.gender = gender;
                            c.orientation=orientation;
                            c.ethnicity=ethnicity;
                            c.genderVisible=visibleGender?1:0;
                            c.sexualOrientationVisible=visibleOrientation?1:0;
                            debugPrint(visibleGender.toString()+' Gender');
                            debugPrint(visibleOrientation.toString()+' Orientation');
                            Get.toNamed(RouteHelper.getSignUpTripDetailsPage());*/
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: Get.height * 0.015),
                            alignment: Alignment.center,
                            width: Get.width,
                            padding: EdgeInsets.only(
                                top: Get.height * 0.02,
                                bottom: Get.height * 0.02),
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "Next".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: StringConstants.poppinsRegular,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        if (!c.isSocialSignup)
                          Container(
                            margin: EdgeInsets.only(top: Get.width * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?'.tr,
                                  style: TextStyle(
                                      fontSize: Get.height * 0.016,
                                      color: AppColors.alreadyHaveColor,
                                      fontFamily:
                                          StringConstants.poppinsRegular),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed(RouteHelper.getLoginPage());
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: Get.width * 0.01),
                                    child: Text('Login'.tr,
                                        style: TextStyle(
                                            fontSize: Get.height * 0.016,
                                            color: AppColors.blueColor,
                                            fontFamily: StringConstants
                                                .poppinsRegular)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSelectionWidgetGender(String label) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      width: Get.width,
      margin: EdgeInsets.only(top: Get.height * 0.011),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
          ),
          Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Wrap(
                runSpacing: 5,
                spacing: Get.height * 0.05,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: gender == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              gender = '1';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Male'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: gender == '2',
                          onChanged: (bool? value) {
                            setState(() {
                              gender = '2';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Female'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: gender == '3',
                          onChanged: (bool? value) {
                            setState(() {
                              gender = '3';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Other'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: gender == '4',
                          onChanged: (bool? value) {
                            setState(() {
                              gender = '4';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Prefer not to say'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget getSelectionWidgetSexual(String label) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      width: Get.width,
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
          ),
          Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Wrap(
                runSpacing: 5,
                spacing: Get.height * 0.05,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: orientation == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              orientation = '1';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Straight'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: orientation == '2',
                          onChanged: (bool? value) {
                            setState(() {
                              orientation = '2';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Bisexual'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: orientation == '3',
                          onChanged: (bool? value) {
                            setState(() {
                              orientation = '3';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Lesbian'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: orientation == '4',
                          onChanged: (bool? value) {
                            setState(() {
                              orientation = '4';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Gay'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: orientation == '5',
                          onChanged: (bool? value) {
                            setState(() {
                              orientation = '5';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Prefer not to say'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                ],
              )),
          /*Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Get.height * 0.005),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                      ],
                    ),
                  ),
                ],
              ))*/
        ],
      ),
    );
  }

  Widget getSelectionWidgetEthnicity(String label) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
          ),
          Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Wrap(
                runSpacing: 5,
                spacing: Get.height * 0.05,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '1';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'White'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '2',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '2';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Hispanic or Latino'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '3',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '3';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Asian'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '4',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '4';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Black or African'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '5',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '5';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Other'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: ethnicity == '6',
                          onChanged: (bool? value) {
                            setState(() {
                              ethnicity = '6';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Prefer not to say'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  void askPermission({required Function(bool) callBack}) async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denined.");
      // await Permission.location.request();
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
                'Please allow location access to use the app. Your location is used to determine Travel and Meet Now mode connections',
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
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
                        'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                            .tr,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        isDialogShowing = false;
                        Navigator.pop(context);
                        openAppSettings();
                      },
                      child: Text(
                        "Ok".tr,
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
