import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/custom_text_field.dart';
import '../../Service/call_service.dart';
import '../../Service/lang/localization_service.dart';
import '../../model/login_model.dart';
import '../../model/update_language_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/progress_bar.dart';
import '../dialogs/common_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fbLogin = FacebookLogin();

  bool _checkBoxValue = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String currentAddress = "";
  String latitude = "";
  String longitude = "";
  loc.Location location = loc.Location();

  String selectedCountryCode = '+1';
  bool isPhoneNumber = false;
  bool obscureText = true;

  @override
  void initState() {
    // email.text = kDebugMode ? "jessicaangelly@hotmail.com" : "";
    // password.text = kDebugMode ? "Gagago1" : "";
    super.initState();
    getCurrentLocation();
    setRememberMeData();
  }

  Future<void> setRememberMeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      setState(() {
        email.text = prefs.getString('email')!;
        password.text = prefs.getString('password')!;
        _checkBoxValue = prefs.getBool('remember_me')!;
      });
    }
  }

/*  Future<void> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = _currentPosition!.latitude.toString();
        debugPrint("Current latitude $lat");
        lng = _currentPosition!.longitude.toString();
      });

      getAddressFromLatLng();
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        lat = _currentPosition!.latitude.toString();
        debugPrint("Current latitude $lat");
        lng = _currentPosition!.longitude.toString();
        debugPrint("Current longitude $lng");
        currentAddress = "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/

/*
  void checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      checkGps();
    } else {
      debugPrint("No Permissions granted");
      await [Permission.location,].request();
      checkGps();
    }
  }

  Future checkGps() async {
    if (await Permission.location.isGranted) {
      if (!await location.serviceEnabled()) {
        location.requestService();
        getCurrentLocation();
      } else {
        getCurrentLocation();
      }
    }else{
      checkLocationPermission();
    }
  }*/

  void askPermission({required Function(bool) callBack}) async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denined.");
      await Permission.location.request();
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

  void getCurrentLocation() async {
    print("under getCurrentLocation");
    if (await Permission.location.isGranted) {
      print("under getCurrentLocation iff");

      var position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);
      setState(() {
        debugPrint("loginPage lat=====>${position.latitude}");
        debugPrint("loginPage long=====>${position.longitude}");
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
        /*     if(latitude.isNotEmpty && longitude.isNotEmpty) {
          var map = <String, dynamic>{};
          map['lat'] = latitude;
          map['lng'] = longitude;
          debugPrint("updateLocation map $map");
          CallService().updateLocation(map);
        }*/
      });
      getAddressFromLatLong();
    } else {
      print("under getCurrentLocation else ");

      PermissionStatus status = await Permission.location.request();
      print("under getCurrentLocation else $status");
      if (status.isDenied || status.isPermanentlyDenied) {
        // getCurrentLocation();
      }
    }
  }

  Future<void> getAddressFromLatLong() async {
    debugPrint("latLngIs=====> $latitude $longitude");
    List<Placemark> place = await placemarkFromCoordinates(
        double.parse(latitude), double.parse(longitude));
    Placemark p = place[0];
    setState(() {
      currentAddress =
          '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}, ${p.country}';
      debugPrint("currentAddress=====>$currentAddress");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Padding(
        //   padding: EdgeInsets.only(
        //       bottom: Get.height * 0.026,
        //       left: Get.width * 0.080,
        //       right: Get.width * 0.080),
        //   child: SvgPicture.asset(
        //     "${StringConstants.svgPath}bottomLogin.svg",
        //     height: Get.height * 0.15,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        backgroundColor: Colors.white,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            setState(() {
              if (direction == ScrollDirection.reverse) {
                FocusManager.instance.primaryFocus?.requestFocus();
              } else if (direction == ScrollDirection.forward) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            });
            return true;
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.020),
                  child: SvgPicture.asset(
                    "${StringConstants.svgPath}loginCircle.svg",
                    height: Get.height * 0.090,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.060),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}bagLogin.svg",
                  height: Get.height * 0.1,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: Get.height * 0.016,
                      left: Get.width * 0.080,
                      right: Get.width * 0.080),
                  child: SvgPicture.asset(
                    "${StringConstants.svgPath}bottomLogin.svg",
                    height: Get.height * 0.15,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  // color: Colors.green,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.only(
                        // top: Get.height * 0.19,
                        left: Get.width * 0.080,
                        right: Get.width * 0.080),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome!".tr,
                            style: TextStyle(
                                fontSize: Get.height * 0.040,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.016,
                          ),
                          Text(
                            'When you select common destinations and interests, you’ll see suggested connections.'
                                .tr,
                            style: TextStyle(
                                fontSize: Platform.isIOS
                                    ? Get.height * 0.018
                                    : Get.height * 0.020,
                                fontWeight: FontWeight.w400,
                                color: AppColors.grayColorNormal,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                          /*CustomTextField(
                            controller: email,
                            validateText: 'Please enter Phone number or email',
                            hintText: "Phone number or email",
                            prefixIcon: "loginMessage.svg",
                            suffixIcon: "",
                            keyboardType: TextInputType.text,
                          )*/
                          SizedBox(
                            child: TextFormField(
                              autofocus: false,
                              controller: email,
                              onChanged: (text) {
                                setState(() {
                                  isPhoneNumber = text.isNumericOnly;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email'.tr;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderTextFiledColor,
                                      width: 0.0),
                                ),
                                hintText: "Enter your email".tr,
                                hintStyle: TextStyle(
                                    fontFamily: StringConstants.poppinsRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Get.height * 0.018,
                                    color: AppColors.loginHintTextFiledColor),
                                suffixIcon: SvgPicture.asset(
                                    StringConstants.svgPath,
                                    fit: BoxFit.scaleDown),
                                prefixIcon: isPhoneNumber
                                    ? Container(
                                        width: Get.width * 0.15,
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: Get.width * 0.055,
                                            right: Get.width * 0.025),
                                        child: !isPhoneNumber
                                            ? SvgPicture.asset(
                                                '${StringConstants.svgPath}loginMessage.svg')
                                            : GestureDetector(
                                                onTap: () {
                                                  showCountryPicker(
                                                    context: context,
                                                    showPhoneCode: true,
                                                    // optional. Shows phone code before the country name.
                                                    onSelect:
                                                        (Country country) {
                                                      setState(() {
                                                        selectedCountryCode =
                                                            '+${country.phoneCode}';
                                                      });
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    left: Get.width * 0.010,
                                                    right: Get.width * 0.010,
                                                  ),
                                                  child: Text(
                                                      selectedCountryCode,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              StringConstants
                                                                  .poppinsRegular,
                                                          fontSize: Get.height *
                                                              0.020)),
                                                ),
                                              ))
                                    : Container(
                                        margin: EdgeInsets.only(
                                            left: Get.width * 0.055,
                                            right: Get.width * 0.025),
                                        child: SvgPicture.asset(
                                            '${StringConstants.svgPath}loginMessage.svg')),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          CustomTextField(
                            validateText: 'Please enter password'.tr,
                            obscureText: obscureText,
                            controller: password,
                            hintText: "Password".tr,
                            prefixIcon: "loginPassword.svg",
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: SvgPicture.asset(
                                  StringConstants.svgPath +
                                      (obscureText
                                          ? 'eyeIcon.svg'
                                          : 'eyeShow.svg'),
                                  fit: BoxFit.scaleDown),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Get.height * 0.030,
                                width: Get.width * 0.070,
                                child: Checkbox(
                                  hoverColor: AppColors.borderTextFiledColor,
                                  side: const BorderSide(
                                      width: 1,
                                      color: AppColors.borderTextFiledColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  value: _checkBoxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _checkBoxValue = value!;
                                      _handleRememberMe(value);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.010,
                              ),
                              Text(
                                "Remember Me".tr,
                                style: TextStyle(
                                  fontSize: Get.height * 0.016,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: StringConstants.poppinsRegular,
                                  color: AppColors.rememberMeColor,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                          RouteHelper.getForgotPassword());
                                    },
                                    child: Text(
                                      "Forgot Password?".tr,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: AppColors.forgotPasswordColor,
                                          fontSize: Get.height * 0.016,
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              StringConstants.poppinsRegular),
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.030,
                          ),
                          InkWell(
                            onTap: () async {
                              int langIds =
                                  await CommonFunctions().getIdFromDeviceLang();

                              print("Check Deive Lang 1 : $langIds");

                              if (_formKey.currentState!.validate()) {
                                askPermission(callBack: (v) async {
                                  CommonDialog.showLoading();

                                  var position =
                                      await geo.Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              geo.LocationAccuracy.high);
                                  debugPrint(
                                      "loginPage lat=====>${position.latitude}");
                                  debugPrint(
                                      "loginPage long=====>${position.longitude}");
                                  latitude = "${position.latitude}";
                                  longitude = "${position.longitude}";

                                  _handleRememberMe(_checkBoxValue);
                                  var map = <String, dynamic>{};
                                  map['email'] = email.text;
                                  map['password'] = password.text;
                                  map['lat'] = latitude;
                                  map['lng'] = longitude;
                                  map['device_token'] = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  int langId = await CommonFunctions()
                                      .getIdFromDeviceLang();
                                  map['lang_id'] = langId.toString();
                                  map['long'] = langId.toString();
                                  debugPrint(
                                      " language check id ${CommonFunctions().getIdFromDeviceLang()}");
                                  debugPrint(
                                      'Token- ${map['device_token'].toString()} map $map');
                                  if (isPhoneNumber) {
                                    map['country_code'] = selectedCountryCode
                                        .replaceFirst('+', '');
                                  }
                                  debugPrint("login map $map");
                                  CommonDialog.hideLoading();

                                  var isConnect = await checkConnectivity();
                                  if (isConnect == ConnectivityResult.mobile) {
                                    // I am connected to a mobile network.
                                    LoginModel login =
                                        await CallService().login(context, map);
                                    if (login.data?.emailVerifiedAt
                                            .toString() ==
                                        "null") {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CommonAlertDialog(
                                              description:
                                                  login.message.toString(),
                                              callback: () {
                                                // Navigator.pop(context);
                                              },
                                            );
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)), //this right here
                                              child: SizedBox(
                                                height: 240,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Alert'.tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .redAccent),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            login.message
                                                                .toString()
                                                                .tr,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                      SizedBox(height: 10),
                                                      Divider(
                                                        height: 1,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    } else if (login.success!) {
                                      Get.offAllNamed(
                                          RouteHelper.getBottomSheetPage());
                                    } else {
                                      CommonDialog.showToastMessage(
                                          login.message.toString());
                                    }
                                  } else if (isConnect ==
                                      ConnectivityResult.wifi) {
                                    // I am connected to a wifi network.
                                    LoginModel login =
                                        await CallService().login(context, map);
                                    if (login.success!) {
                                      Get.offAllNamed(
                                          RouteHelper.getBottomSheetPage());
                                    } else {
                                      CommonDialog.showToastMessage(
                                          login.message.toString());
                                    }
                                  } else {
                                    CommonDialog.showToastMessage(
                                        "No Internet Available!!!!!".tr);
                                  }
                                  debugPrint("login map $map");
                                });
                              }
                            },
                            child: CustomButtonLogin(
                              buttonName: "Login".tr,
                            ),
                          ),
                          _socialLoginButtons(),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.getSignUpPage());
                            },
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Don’t have an account?".tr,
                                      style: TextStyle(
                                          fontSize: Get.height * 0.016,
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              StringConstants.poppinsRegular,
                                          color: AppColors.grayColorNormal)),
                                  TextSpan(
                                      text: "Sign Up".tr,
                                      style: TextStyle(
                                          fontSize: Get.height * 0.016,
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              StringConstants.poppinsRegular,
                                          color: AppColors.forgotPasswordColor))
                                ]),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: Get.height * 0.010,
                          // ),
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ));
  }

  _socialLoginButtons() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () async {
              askPermission(callBack: (v) async {
                fbLogin.logOut();
                var isConnect = await checkConnectivity();
                if (isConnect == ConnectivityResult.mobile ||
                    isConnect == ConnectivityResult.wifi) {
                  print("tapped");
                  // Log in
                  final res = await fbLogin.logIn(permissions: [
                    FacebookPermission.publicProfile,
                    FacebookPermission.email,
                  ]);

                  // Check result status
                  switch (res.status) {
                    case FacebookLoginStatus.success:
                      // Logged in

                      // Send access token to server for validation and auth
                      final FacebookAccessToken? accessToken = res.accessToken;
                      print('Access token: ${accessToken!.token}');

                      // Get profile data
                      final profile = await fbLogin.getUserProfile();
                      print(
                          'Hello, ${profile!.name}!  You ID: ${profile.userId}');

                      // Get user profile image url
                      String? imageUrl =
                          await fbLogin.getProfileImageUrl(width: 100);
                      print('Your profile image: $imageUrl');

                      // Get email (since we request email permission)
                      String? email = await fbLogin.getUserEmail();
                      // But user can decline permission
                      if (email != null) print('And your email is $email');

                      var map = {
                        "type": "facebook",
                        "token": accessToken.token,
                        "email": email,
                      };
                      _handleSocialLogin(map, (data) {
                        Get.toNamed(RouteHelper.getSignUpPage(
                            isSocialSignup: true,
                            socialFirstName: profile.name,
                            socialEmail: email,
                            socialImageUrl: imageUrl,
                            socialType: "facebook",
                            socialToken: accessToken.token));
                      });
                      // var map = {
                      //   "type": "facebook",
                      //   "token": accessToken.token,
                      //   "email": email
                      // };
                      // var loginModel =
                      //     await CallService().checkSocialLogin(context, map);
                      // print("login --> ${loginModel.toString()}");
                      //
                      // if (loginModel.success == true) {
                      //   if (loginModel.data == null) {
                      //     Get.toNamed(RouteHelper.getSignUpPage(
                      //         isSocialSignup: true,
                      //         socialFirstName: profile.name,
                      //         socialEmail: email,
                      //         socialImageUrl: imageUrl,
                      //         socialToken: accessToken.token));
                      //   } else {}
                      // } else {}

                      break;
                    case FacebookLoginStatus.cancel:
                      print("cancelled");
                      // User cancel log in
                      break;
                    case FacebookLoginStatus.error:
                      // Log in failed
                      print('Error while log in: ${res.error}');
                      break;
                  }
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: Get.height * 0.060,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColors.fbColor,
                  border: Border.all(color: AppColors.fbColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Image.asset(
                      'assets/images/png/facebook_logo.png',
                      width: Get.height * 0.0250,
                      height: Get.height * 0.0250,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Continue with Facebook".tr,
                    style: TextStyle(
                        fontSize: Get.height * 0.018,
                        color: Colors.white,
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
        if (Platform.isIOS)
          const SizedBox(
            height: 10,
          ),
        if (Platform.isIOS)
          InkWell(
              onTap: () async {
                print("tapped");
                // Log in
                signInWithApple();
              },
              child: Container(
                alignment: Alignment.center,
                height: Get.height * 0.060,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/apple_logo.png',
                      width: Get.height * 0.0250,
                      height: Get.height * 0.0250,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Continue with Apple".tr,
                      style: TextStyle(
                          fontSize: Get.height * 0.018,
                          color: Colors.white,
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
        /*  SignInWithAppleButton(
          onPressed: () async {
            // signInWithApple();

            AuthorizationCredentialAppleID credential =
                await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
            );

            print(
                "email--> ${credential.email} givenName -> ${credential.givenName} familyName-->  ${credential.familyName} ${credential.authorizationCode}");

            // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
            // after they have been validated with Apple (see `Integration` section for more information on how to do this)
          },
        )*/
        // InkWell(
        //   onTap: () async {
        //     signInWithApple();
        //   },
        //   child: CustomButtonLogin(
        //     buttonName: "Apple Login".tr,
        //   ),
        // ),
      ],
    );
  }

  _handleSocialLogin(var map, Function(LoginModel) callback) async {
    int langIds = await CommonFunctions().getIdFromDeviceLang();

    print("Check Deive Lang 1 : $langIds");

    askPermission(callBack: (v) async {
      CommonDialog.showLoading();

      if (latitude.isEmpty && longitude.isEmpty) {
        var position = await geo.Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.high);
        debugPrint("loginPage lat=====>${position.latitude}");
        debugPrint("loginPage long=====>${position.longitude}");
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
      }
      // _handleRememberMe(_checkBoxValue);

      map['lat'] = latitude;
      map['lng'] = longitude;
      map['device_token'] = await FirebaseMessaging.instance.getToken();
      int langId = await CommonFunctions().getIdFromDeviceLang();
      map['lang_id'] = langId.toString();
      map['long'] = langId.toString();
      debugPrint(
          "language check id ${CommonFunctions().getIdFromDeviceLang()}");
      debugPrint('Token- ${map['device_token'].toString()} map $map');

      debugPrint("login map $map");
      CommonDialog.hideLoading();

      var isConnect = await checkConnectivity();
      if (isConnect == ConnectivityResult.mobile ||
          isConnect == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        LoginModel loginModel =
            await CallService().checkSocialLogin(context, map);

        if (loginModel.success == true) {
          if (loginModel.data == null) {
            callback(loginModel);
          } else {
            Get.offAllNamed(RouteHelper.getBottomSheetPage());
          }
        } else {
          CommonDialog.showToastMessage(loginModel.message.toString());
        }
      } else {
        CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
      }
      debugPrint("login map $map");
    });
  }

  void signInWithApple() async {
    askPermission(callBack: (v) async {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("------------------>cred${credential.email.toString()}");
      print("------------------>cred${credential.userIdentifier}");
      // socialLoginApi("apple",
      //     credential.authorizationCode ?? "privacly676^&*5@gmail.com");

      var map = {
        "type": "apple",
        "token": credential.userIdentifier,
        "email": credential.email,
      };

      _handleSocialLogin(map, (data) {
        Get.toNamed(RouteHelper.getSignUpPage(
            isSocialSignup: true,
            socialFirstName: credential.givenName,
            socialLastName: credential.familyName,
            socialEmail: credential.email,
            socialType: "apple",
            // socialImageUrl: credential.,
            socialToken: credential.userIdentifier));
      });
    });
  }

  updateLanguageData({
    int? id,
  }) async {
    var map = <String, dynamic>{};
    map['lang'] = id;
    UpdateLanguageModel model = await CallService().updateLanguage(map);
    if (model.status!) {
      updateLanguage(model.langId!, Get.overlayContext ?? context,
          callBack: () {
        CommonDialog.showToastMessage("Updated successfully".tr);
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setInt("language_id", id ?? 1);
      // CommonDialog.showToastMessage(model.message!.tr);
    } else {
      CommonDialog.showToastMessage(model.message.toString().tr);
    }
  }

  void updateLanguage(int id, BuildContext context,
      {Function? callBack}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (id == 1) {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      sharedPreferences.setString(
          StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
    } else if (id == 2) {
      Get.locale = StringConstants.LOCALE_SPANISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_SPANISH_KEY);

      sharedPreferences.setString(
          StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_SPANISH_KEY);
    } else if (id == 4) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_KEY);

      sharedPreferences.setString(StringConstants.CURRENT_LOCALE,
          StringConstants.LOCALE_PURTUGUESE_KEY);
    } else if (id == 7) {
      Get.locale = StringConstants.LOCALE_FRENCH;
      LocalizationService.changeLocale(StringConstants.LOCALE_FRENCH_KEY);

      sharedPreferences.setString(
          StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_FRENCH_KEY);
    } else {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);

      sharedPreferences.setString(
          StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      // SessionManager.setLocale(Utils.LOCALE_ENGLISH_KEY);
    }

    String currentLang =
        sharedPreferences.getString(StringConstants.CURRENT_LOCALE) ?? "";

    if (callBack != null) {
      callBack();
    }
    debugPrint(" currentLangcurrentLang --> $currentLang");
    // updateLanguageApi(context);
  }

  void _handleRememberMe(bool value) {
    debugPrint("Handle Remember Me");
    _checkBoxValue = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', email.text);
        prefs.setString('password', password.text);
      },
    );
    setState(() {
      _checkBoxValue = value;
    });
  }
}
