import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/register_controller.dart';
import '../../utils/app_network_image.dart';
import '../dialogs/common_alert_dialog.dart';

class SignUpTripDetails extends StatefulWidget {
  const SignUpTripDetails({Key? key}) : super(key: key);

  @override
  State<SignUpTripDetails> createState() => _SignUpTripDetailsState();
}

class _SignUpTripDetailsState extends State<SignUpTripDetails> {
  RegisterController c = Get.find();
  String tripStyle = '0';
  String travelWithin = '0';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      askPermission(callBack: (value) async {});
      init();
    });
  }

  init() {
    c.destinations!.clear();
    c.interests!.clear();
    setState(() {});
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(Get.height * 0.05), topRight: Radius.circular(Get.height * 0.05)),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: Get.height * 0.05, left: Get.width * 0.1, bottom: Get.height * 0.025, right: Get.width * 0.1),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getSelectionWidgetTripStyle('Trip Style'.tr),
                        getSelectionWidgetNext('Traveling within the next'.tr),
                        InkWell(
                            onTap: () async {
                              await Get.toNamed(RouteHelper.getDestinations('Register'));
                              setState(() {});
                            },
                            child: getNextButtonsWidgetDestination("Destinations".tr, 'assets/images/svg/destinations.svg')),
                        InkWell(
                            onTap: () async {
                              await Get.toNamed(RouteHelper.getMeetNow('Register'));
                              setState(() {});
                            },
                            child: getNextButtonsWidgetMeet("Meet Now 1".tr, 'assets/images/svg/globe.svg')),
                        InkWell(
                          onTap: () {
                            if (tripStyle == '0') {
                              CommonDialog.showToastMessage(
                                'Please select trip style'.tr, /* toastPosition: ToastGravity.CENTER*/
                              );
                            } else if (travelWithin == '0') {
                              CommonDialog.showToastMessage(
                                'Please select trip timeline'.tr, /*toastPosition: ToastGravity.CENTER*/
                              );
                            } else {
                              c.tripStyle = tripStyle;
                              c.travelWithIn = travelWithin;
                              if (c.destinations!.isEmpty) {
                                CommonDialog.showToastMessage(
                                  'Please select destinations'.tr, /*toastPosition: ToastGravity.CENTER*/
                                );
                              } else if (c.interests!.isEmpty) {
                                CommonDialog.showToastMessage(
                                  'Please select interests'.tr, /*toastPosition: ToastGravity.CENTER*/
                                );
                              } else {
                                print("c.tripStyle ${c.tripStyle}");
                                print("c.travelWithIn ${c.travelWithIn}");
                                print("c.destinations ${c.destinations!.length}");
                                print("c.interests ${c.interests!.length}");
                                Get.toNamed(RouteHelper.getSignUpImagesPage());
                              }
                            }
                            /*c.tripStyle=tripStyle;
                            c.travelWithIn=travelWithin;
                            if(c.destinations!.isEmpty){
                              CommonDialog.showToastMessage('Please select destinations'.tr);
                            }else if(c.interests!.isEmpty){
                              CommonDialog.showToastMessage('Please select interests'.tr);
                            }else{
                              Get.toNamed(RouteHelper.getSignUpImagesPage());
                            }*/
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: Get.height * 0.015),
                            alignment: Alignment.center,
                            width: Get.width,
                            padding: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.02),
                            decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "Next".tr,
                              style: const TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
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
                                  style: TextStyle(fontSize: Get.height * 0.016, color: AppColors.alreadyHaveColor, fontFamily: StringConstants.poppinsRegular),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed(RouteHelper.getLoginPage());
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Get.width * 0.01),
                                    child: Text('Login'.tr, style: TextStyle(fontSize: Get.height * 0.016, color: AppColors.blueColor, fontFamily: StringConstants.poppinsRegular)),
                                  ),
                                )
                              ],
                            ),
                          )
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

  Widget getSelectionWidgetTripStyle(String label) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      width: Get.width * 0.9,
      margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
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
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
          ),
          Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: tripStyle == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              tripStyle = '1';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Backpacking'.tr,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: tripStyle == '2',
                          onChanged: (bool? value) {
                            setState(() {
                              tripStyle = '2';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Mid-Range'.tr,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: tripStyle == '3',
                          onChanged: (bool? value) {
                            setState(() {
                              tripStyle = '3';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        'Luxury'.tr,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget getSelectionWidgetNext(String label) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      width: Get.width * 0.9,
      margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
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
            style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
          ),
          Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        child: Checkbox(
                          shape: const CircleBorder(), // Rounded Checkbox
                          checkColor: Colors.white,
                          value: travelWithin == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              travelWithin = '1';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      Text(
                        '1-3 Months'.tr,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Get.width * 0.09),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width * 0.06,
                          height: Get.width * 0.06,
                          child: Checkbox(
                            shape: const CircleBorder(), // Rounded Checkbox
                            checkColor: Colors.white,
                            value: travelWithin == '2',
                            onChanged: (bool? value) {
                              setState(() {
                                travelWithin = '2';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.005,
                        ),
                        Text(
                          '3-6 Months'.tr,
                          style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: Get.height * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.06,
                  height: Get.width * 0.06,
                  child: Checkbox(
                    shape: const CircleBorder(), // Rounded Checkbox
                    checkColor: Colors.white,
                    value: travelWithin == '3',
                    onChanged: (bool? value) {
                      setState(() {
                        travelWithin = '3';
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.005,
                ),
                Text(
                  '6-12 Months'.tr,
                  style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getNextButtonsWidgetDestination(String title, String image) {
    return Container(
      padding: EdgeInsets.only(left: Get.width * 0.035, right: Get.width * 0.035, top: Get.height * 0.017, bottom: Get.height * 0.017),
      width: Get.width * 0.9,
      margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                image,
                width: Get.width * 0.07,
                height: Get.width * 0.07,
              ),
              c.destinations!.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03),
                      width: Get.width * 0.58,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: List<Widget>.generate(
                            c.destinations!.length,
                            (int idx) {
                              return Container(
                                margin: EdgeInsets.only(right: Get.width * 0.02),
                                child: Chip(
                                  avatar: Image.network(c.destinations![idx].countryImage.toString()),
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder(side: BorderSide(color: AppColors.grayColorNormal)),
                                  label: Text(
                                    c.destinations![idx].countryName.toString(),
                                    style: TextStyle(
                                      fontFamily: StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: Get.height * 0.018,
                                    ),
                                  ),
                                ),
                              );
                              /*return Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color:
                          AppColors.blueColor.withOpacity(0.08),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6)),
                          border: new Border.all(
                            color: AppColors.blueColor,
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: Get.height * 0.005,
                            bottom: Get.height * 0.005,
                            left: Get.width * 0.03,
                            right: Get.width * 0.03),
                        margin: EdgeInsets.only(
                            right: Get.height * 0.01),
                        child: Text(
                          c.destinations![idx]
                              .countryName
                              .toString(),
                          style: TextStyle(
                            fontFamily:
                            StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                          ),
                        ),
                      );*/
                            },
                          ).toList(),
                        ),
                      ),
                    ),
            ],
          ),
          SvgPicture.asset('assets/images/svg/back.svg'),
        ],
      ),
    );
  }

  Widget getNextButtonsWidgetMeet(String title, String image) {
    return Container(
      padding: EdgeInsets.only(left: Get.width * 0.035, right: Get.width * 0.035, top: Get.height * 0.017, bottom: Get.height * 0.017),
      width: Get.width * 0.9,
      margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                image,
                width: Get.width * 0.07,
                height: Get.width * 0.07,
              ),
              c.interests!.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03),
                      width: Get.width * 0.58,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: List<Widget>.generate(
                            c.interests!.length,
                            (int idx) {
                              return Container(
                                margin: EdgeInsets.only(right: Get.width * 0.02),
                                child: Chip(
                                  avatar:
                                      // AppNetworkImage(
                                      //   imageUrl: c.interests![idx].image.toString(),
                                      //   height: Get.width * 0.02,
                                      //   width: Get.width * 0.02,
                                      //   boxFit: BoxFit.contain,
                                      // ),

                                      Image.network(c.interests![idx].image.toString()),
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder(side: BorderSide(color: AppColors.grayColorNormal)),
                                  label: Text(
                                    c.interests![idx].name.toString(),
                                    style: TextStyle(
                                      fontFamily: StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: Get.height * 0.018,
                                    ),
                                  ),
                                ),
                              );
                              /*return Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color:
                          AppColors.blueColor.withOpacity(0.08),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6)),
                          border: new Border.all(
                            color: AppColors.blueColor,
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: Get.height * 0.005,
                            bottom: Get.height * 0.005,
                            left: Get.width * 0.03,
                            right: Get.width * 0.03),
                        margin: EdgeInsets.only(
                            right: Get.height * 0.01),
                        child: Text(
                          c.interests![idx]
                              .name
                              .toString(),
                          style: TextStyle(
                            fontFamily:
                            StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: Get.height * 0.016,
                          ),
                        ),
                      );*/
                            },
                          ).toList(),
                        ),
                      ),
                    ),
            ],
          ),
          SvgPicture.asset('assets/images/svg/back.svg'),
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
