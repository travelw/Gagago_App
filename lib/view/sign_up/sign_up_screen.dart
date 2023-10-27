import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/controller/register_controller.dart';
import 'package:gagagonew/model/check_email_model.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Service/call_service.dart';
import '../../model/change_password_response_model.dart';
import '../app_html_view_screen.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../dialogs/common_alert_dialog.dart';

class SignUp extends StatefulWidget {
  SignUp(
      {Key? key,
      this.isSocialSignup = false,
      this.socialFirstName,
      this.socialLastName,
      this.socialEmail,
      this.socialImageUrl,
      this.socialType,
      this.socialToken})
      : super(key: key);
  bool isSocialSignup;
  String? socialFirstName;
  String? socialLastName;
  String? socialEmail;
  String? socialImageUrl;
  String? socialType;
  String? socialToken;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController phoneNumber = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirmPassword = TextEditingController(text: "");
  TextEditingController dobController = TextEditingController(text: "");
  String selectedCountryCode = '+1';
  bool readTerms = false;

  bool showNameValidation = false;
  bool showDOBValidation = false;
  bool showEmailValidation = false;
  bool showValidEmailValidation = false;
  bool showPasswordValidation = false;
  bool showConfirmPassValidation = false;
  String socialFullName = "";
  String socialEmail = "";

  dynamic sensitivity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      askPermission(callBack: (value) async {});
      init();
    });
  }

  init() {
    if (widget.isSocialSignup) {
      if (widget.socialFirstName != null) {
        if (widget.socialFirstName != "null") {
          name.text = widget.socialFirstName ?? "";
        }
      }
      if (widget.socialLastName != null) {
        if (widget.socialLastName != "null") {
          name.text = "${name.text} ${widget.socialLastName}";
        }
      }
      if (widget.socialEmail != null) {
        if (widget.socialEmail != "null") {
          email.text = widget.socialEmail ?? "";
        }
      }
      socialFullName = name.text;
      socialEmail = email.text;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    RegisterController c = Get.put(RegisterController());
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                        left: Get.width * 0.1,
                        bottom: Get.height * 0.025,
                        right: Get.width * 0.1),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getInputField('Name'.tr, 'assets/images/svg/name.svg',
                              name, false,
                              isName: true,
                              isEnabled: widget.isSocialSignup
                                  ? socialFullName.isNotEmpty
                                      ? false
                                      : true
                                  : true,
                              showValidation: showNameValidation,
                              validationMessage: 'Name'.tr),
                          // if (!widget.isSocialSignup)
                          getDateOfBirthWidget(
                              'Date Of Birth'.tr, 'assets/images/svg/dob.svg'),
                          getInputField('Email'.tr,
                              'assets/images/svg/email.svg', email, false,
                              isName: false,
                              isEnabled: widget.isSocialSignup
                                  ? socialEmail.isNotEmpty
                                      ? false
                                      : true
                                  : true,
                              showValidation: showEmailValidation ||
                                  showValidEmailValidation,
                              validationMessage: showValidEmailValidation
                                  ? 'Please enter valid email'.tr
                                  : 'Email'.tr),
                          /*getPhoneNumberWidget('Phone Number',
                              'assets/images/svg/phone_number.svg'),*/
                          if (!widget.isSocialSignup)
                            getInputFieldPassword('Password'.tr,
                                'assets/images/svg/password.svg', password),
                          if (!widget.isSocialSignup)
                            getInputFieldConfirmPassword(
                                'Confirm Password'.tr,
                                'assets/images/svg/password.svg',
                                confirmPassword),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: getInputField('Password',
                                    'assets/images/svg/password.svg', password,true),
                                width: Get.width * 0.39,
                              ),
                              Container(
                                  child: getInputField(
                                      'Confirm Password',
                                      'assets/images/svg/password.svg',
                                      confirmPassword,true),
                                  width: Get.width * 0.39),
                            ],
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    value: readTerms,
                                    side: const BorderSide(width: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          readTerms = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                //  By clicking Agree & Join, you agree to Gagago Terms & Conditions and Privacy Policy.
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "By clicking Agree & Join, you agree to our "
                                                  .tr,
                                          style: TextStyle(
                                              fontSize: Get.height * 0.014,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily: StringConstants
                                                  .poppinsRegular)),
                                      TextSpan(
                                          text: "Terms & Conditions".tr,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Get.toNamed(RouteHelper.getHtmlScreen(
                                              //   apiKey: "terms-and-conditions",
                                              //   title: "Terms and Conditions",
                                              // ));
                                              Get.to(const AppHtmlViewScreen(
                                                  apiKey:
                                                      "terms-and-conditions",
                                                  title: "Terms & Conditions",
                                                  isAuth: false));
                                            },
                                          style: TextStyle(
                                              fontSize: Get.height * 0.014,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants
                                                  .poppinsRegular,
                                              color: AppColors
                                                  .forgotPasswordColor)),
                                      TextSpan(
                                          text: " and ".tr,
                                          style: TextStyle(
                                              fontSize: Get.height * 0.014,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily: StringConstants
                                                  .poppinsRegular)),
                                      TextSpan(
                                          text: "Privacy Policy".tr,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(AppHtmlViewScreen(
                                                  apiKey: "privacy-policy",
                                                  title: "Privacy Policy",
                                                  isAuth: false));
                                            },
                                          style: TextStyle(
                                              fontSize: Get.height * 0.014,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants
                                                  .poppinsRegular,
                                              color: AppColors
                                                  .forgotPasswordColor))
                                    ]),
                                  ),

                                  //   Text(
                                  //       'I have read and agree with the above terms and conditions'.tr,
                                  //       style: TextStyle(
                                  //           fontSize: Get.height * 0.015,
                                  //           fontWeight: FontWeight.w400,
                                  //           color: Colors.black,
                                  //           fontFamily:
                                  //           StringConstants.poppinsRegular)),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (widget.isSocialSignup) {
                                if (checkValidations()) {
                                  c.name = name.text;
                                  c.dob = dobController.text;
                                  c.email = email.text;
                                  c.countryCode =
                                      selectedCountryCode.replaceFirst('+', '');
                                  c.phoneNumber = phoneNumber.text;
                                  c.password = password.text;

                                  // For Sign up purposes
                                  c.isSocialSignup = widget.isSocialSignup;
                                  c.socialFirstName = widget.socialFirstName;
                                  c.socialLastName = widget.socialLastName;
                                  c.socialEmail = widget.socialEmail;
                                  c.socialImageUrl = widget.socialImageUrl;
                                  c.socialType = widget.socialType;
                                  c.socialToken = widget.socialToken;

                                  Get.toNamed(
                                      RouteHelper.getSignUpPreferencePage());
                                }
                              } else {
                                if (checkValidations()) {
                                  // askPermission(callBack: (value) async {
                                  var map = <String, dynamic>{};
                                  map['email'] = email.text;

                                  ///Language set
                                  ///
                                  ///

                                  Locale currentLocale = Get.locale ??
                                      StringConstants.LOCALE_ENGLISH;

                                  int? langId = 1;
                                  if (currentLocale ==
                                      StringConstants.LOCALE_ENGLISH) {
                                    langId = 1;
                                  } else if (currentLocale ==
                                      StringConstants.LOCALE_SPANISH) {
                                    langId = 2;
                                  } else if (currentLocale ==
                                          StringConstants.LOCALE_PURTUGUESE ||
                                      currentLocale ==
                                          StringConstants
                                              .LOCALE_PURTUGUESE_Brasil) {
                                    print("Device Lang $currentLocale");
                                    langId = 4;
                                  } else if (currentLocale ==
                                      StringConstants.LOCALE_FRENCH) {
                                    langId = 7;
                                  } else {
                                    langId = 1;
                                  }
                                  map['languageId'] = langId;
                                  print("Language Id $map");

                                  var isConnect = await checkConnectivity();
                                  if (isConnect == ConnectivityResult.mobile) {
                                    CheckEmailModel submit = await CallService()
                                        .checkEmailExist(map);
                                    if (submit.status ?? false) {
                                      c.name = name.text;
                                      c.dob = dobController.text;
                                      c.email = email.text;
                                      c.countryCode = selectedCountryCode
                                          .replaceFirst('+', '');
                                      c.phoneNumber = phoneNumber.text;
                                      c.password = password.text;
                                      Get.toNamed(RouteHelper
                                          .getSignUpPreferencePage());
                                    } else {
                                      CommonDialog.showToastMessage(
                                          submit.message.toString());
                                    }
                                  } else if (isConnect ==
                                      ConnectivityResult.wifi) {
                                    CheckEmailModel submit = await CallService()
                                        .checkEmailExist(map);
                                    if (submit.status ?? false) {
                                      c.name = name.text;
                                      c.dob = dobController.text;
                                      c.email = email.text;
                                      c.countryCode = selectedCountryCode
                                          .replaceFirst('+', '');
                                      c.phoneNumber = phoneNumber.text;
                                      c.password = password.text;
                                      Get.toNamed(RouteHelper
                                          .getSignUpPreferencePage());
                                    } else {
                                      CommonDialog.showToastMessage(
                                          submit.message.toString());
                                    }
                                  } else {
                                    CommonDialog.showToastMessage(
                                        "No Internet Available!!!!!".tr);
                                  }
                                  // });
                                }
                              }
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
                                "Agree & Join".tr,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: StringConstants.poppinsRegular,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          if (!widget.isSocialSignup)
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
                                      Get.offAllNamed(
                                          RouteHelper.getLoginPage());
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: Get.width * 0.01),
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
      ),
    );
  }

  checkValidations() {
    bool isValid = false;

    if (widget.isSocialSignup) {
      print("dobController--> ${dobController.text}");
      showDOBValidation = false;
      if (dobController.text.isEmpty) {
        showDOBValidation = true;
      } else if (name.text.trim().isEmpty) {
        showNameValidation = true;
      } else if (email.text.trim().isEmpty) {
        showEmailValidation = true;
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.text.trim())) {
        showValidEmailValidation = true;
      }

      if (dobController.text.trim().isEmpty) {
        // CommonDialog.showToastMessage('Please enter date of birth'.tr);
      } else if (name.text.trim().isEmpty) {
        // CommonDialog.showToastMessage('Please enter date of birth'.tr);
      } else if (email.text.trim().isEmpty) {
        // CommonDialog.showToastMessage('Please enter date of birth'.tr);
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.text.trim())) {
        // CommonDialog.showToastMessage('Please enter date of birth'.tr);
      } else if (!readTerms) {
        CommonDialog.showToastMessage(
            'Please accept Terms & Conditions and Privacy Policy'.tr);
      } else {
        isValid = true;
      }
    } else {
      showNameValidation = false;
      showDOBValidation = false;
      showEmailValidation = false;
      showValidEmailValidation = false;
      showPasswordValidation = false;
      showConfirmPassValidation = false;

      bool emailValid =
          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(email.text);
      if (name.text.isEmpty) {
        showNameValidation = true;
      }
      if (dobController.text.isEmpty) {
        showDOBValidation = true;
      }
      if (email.text.isEmpty) {
        showEmailValidation = true;
      }
      if (!emailValid) {
        showValidEmailValidation = true;
        // CommonDialog.showToastMessage('Please enter valid email'.tr);
      }
      if (password.text.isEmpty) {
        showPasswordValidation = true;
      }
      if (confirmPassword.text.isEmpty) {
        showConfirmPassValidation = true;
      }
      if (confirmPassword.text != password.text) {
        showPasswordValidation = true;
        showConfirmPassValidation = true;
        // CommonDialog.showToastMessage('Password and Confirm Password must match'.tr);
      }

      if (name.text.isEmpty) {
        // CommonDialog.showToastMessage('Please enter name'.tr);
      } else if (dobController.text.isEmpty) {
        // CommonDialog.showToastMessage('Please enter date of birth'.tr);
      } else if (email.text.isEmpty) {
        // CommonDialog.showToastMessage('Please enter email'.tr);
      } else if (!emailValid) {
        // CommonDialog.showToastMessage('Please enter valid email'.tr);
      } else if (password.text.isEmpty) {
        // CommonDialog.showToastMessage('Please enter password'.tr);
      } else if (confirmPassword.text.isEmpty) {
        // CommonDialog.showToastMessage('Please enter confirm password'.tr);
      } else if (confirmPassword.text != password.text) {
        // CommonDialog.showToastMessage('Password and Confirm Password must match'.tr);
      } else if (!readTerms) {
        CommonDialog.showToastMessage(
            'Please accept Terms & Conditions and Privacy Policy'.tr);
      } else {
        isValid = true;
      }
    }
    setState(() {});

    return isValid;
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

  Widget getInputField(
    String name,
    String image,
    TextEditingController controller,
    bool obscureText, {
    bool isName = true,
    bool isEnabled = true,
    bool showValidation = false,
    String? validationMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Get.height * 0.005, bottom: Get.height * 0.005),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color:
                  showValidation ? Colors.red : AppColors.inputFieldBorderColor,
              width: 1.0,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: Get.width * 0.026),
            child: SizedBox(
              child: TextField(
                enabled: isEnabled,
                controller: controller,
                obscureText: obscureText,
                onChanged: (v) {
                  if (isName) {
                    showNameValidation = false;
                  } else {
                    showEmailValidation = false;
                    showValidEmailValidation = false;
                  }
                  setState(() {});
                },
                style: TextStyle(
                    color: isEnabled ? Colors.black : Colors.grey[500],
                    fontFamily: StringConstants.poppinsRegular,
                    fontSize: Get.height * 0.016),
                decoration: InputDecoration(
                  hintText: name,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.015),
                    child: SvgPicture.asset(
                      image,
                      color: isEnabled ? Colors.black : Colors.grey[500],
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                      maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: StringConstants.poppinsRegular,
                      fontSize: Get.height * 0.016),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        if (showValidation)
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              validationMessage ?? "",
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;

  Widget getInputFieldPassword(
      String name, String image, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Get.height * 0.010, bottom: Get.height * 0.010),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: showPasswordValidation
                  ? Colors.red
                  : AppColors.inputFieldBorderColor,
              width: 1.0,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: Get.width * 0.026),
            child: SizedBox(
              child: TextField(
                controller: controller,
                onChanged: (v) {
                  showPasswordValidation = false;
                  setState(() {});
                },
                obscureText: obscureTextPassword,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: StringConstants.poppinsRegular,
                    fontSize: Get.height * 0.016),
                decoration: InputDecoration(
                  hintText: name,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.015),
                    child: SvgPicture.asset(image),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obscureTextPassword = !obscureTextPassword;
                      });
                    },
                    child: SvgPicture.asset(
                        StringConstants.svgPath +
                            (obscureTextPassword
                                ? 'eyeIcon.svg'
                                : 'eyeShow.svg'),
                        fit: BoxFit.scaleDown),
                  ),
                  prefixIconConstraints: BoxConstraints(
                      maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: StringConstants.poppinsRegular,
                      fontSize: Get.height * 0.016),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        if (showPasswordValidation)
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              name,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          )
      ],
    );
  }

  Widget getInputFieldConfirmPassword(
      String name, String image, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Get.height * 0.005, bottom: Get.height * 0.010),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: showConfirmPassValidation
                  ? Colors.red
                  : AppColors.inputFieldBorderColor,
              width: 1.0,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: Get.width * 0.026),
            child: SizedBox(
              child: TextField(
                controller: controller,
                obscureText: obscureTextConfirmPassword,
                onChanged: (v) {
                  showConfirmPassValidation = false;
                  setState(() {});
                },
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: StringConstants.poppinsRegular,
                    fontSize: Get.height * 0.016),
                decoration: InputDecoration(
                  hintText: name,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.015),
                    child: SvgPicture.asset(image),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obscureTextConfirmPassword =
                            !obscureTextConfirmPassword;
                      });
                    },
                    child: SvgPicture.asset(
                        StringConstants.svgPath +
                            (obscureTextConfirmPassword
                                ? 'eyeIcon.svg'
                                : 'eyeShow.svg'),
                        fit: BoxFit.scaleDown),
                  ),
                  prefixIconConstraints: BoxConstraints(
                      maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: StringConstants.poppinsRegular,
                      fontSize: Get.height * 0.016),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        if (showConfirmPassValidation)
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              name,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          )
      ],
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  late Locale locale;

  Widget getDateOfBirthWidget(String name, String image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            //await            CommonFunctions.callTest();
            _showDialog(CupertinoDatePicker(
              initialDateTime: DateTime(2004, 01, 01),
              // initialDateTime: DateTime(DateTime.now().year-18, DateTime.now().month, DateTime.now().day),
              maximumDate: DateTime(DateTime.now().year - 18,
                  DateTime.now().month, DateTime.now().day),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newTime) {
                showDOBValidation = false;
                // setState(() => dob.text = DateFormat('yyyy-MM-dd').format(newTime).toString());
                setState(() => dobController.text =
                    DateFormat('MM/dd/yyyy').format(newTime).toString());
              },
            ));
          },
          child: Container(
            margin: EdgeInsets.only(
                top: Get.height * 0.010, bottom: Get.height * 0.010),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: showDOBValidation
                    ? Colors.red
                    : AppColors.inputFieldBorderColor,
                width: 1.0,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: Get.width * 0.026),
              child: SizedBox(
                child: TextField(
                  controller: dobController,
                  enabled: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: StringConstants.poppinsRegular,
                      fontSize: Get.height * 0.016),
                  decoration: InputDecoration(
                    hintText: name,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: Get.width * 0.015),
                      child: SvgPicture.asset(image),
                    ),
                    prefixIconConstraints: BoxConstraints(
                        maxWidth: Get.width * 0.080,
                        maxHeight: Get.width * 0.04),
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: StringConstants.poppinsRegular,
                        fontSize: Get.height * 0.016),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showDOBValidation)
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              name,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          )
      ],
    );
  }

  Widget getPhoneNumberWidget(String name, String image) {
    return Container(
      margin:
          EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.003),
        child: SizedBox(
          child: TextField(
            controller: phoneNumber,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              hintText: name,
              prefixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(image),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountryCode = '+${country.phoneCode}';
                          });
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: Get.width * 0.010,
                        right: Get.width * 0.010,
                      ),
                      child: Text(selectedCountryCode,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: StringConstants.poppinsRegular,
                              fontSize: Get.height * 0.016)),
                    ),
                  )
                ],
              ),
              prefixIconConstraints: BoxConstraints(
                  maxWidth: Get.width * 0.15, maxHeight: Get.width * 0.05),
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
