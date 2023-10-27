import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
// import 'package:device_info/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:reorderableitemsview/reorderableitemsview.dart';

import '../../CommonWidgets/crop_image_widget.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/register_controller.dart';
import '../../model/login_model.dart';
import '../../model/register_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/dimensions.dart';
import '../../utils/internet_connection_checker.dart';
import '../dialogs/common_alert_dialog.dart';
import '../take_image_capture_screen.dart';

class SignUpImages extends StatefulWidget {
  const SignUpImages({Key? key}) : super(key: key);

  @override
  State<SignUpImages> createState() => _SignUpImagesState();
}

class _SignUpImagesState extends State<SignUpImages> {
  RegisterController c = Get.find();
  TextEditingController aboutMe = TextEditingController(text: '');
  TextEditingController referralCode = TextEditingController(text: '');

  Position? _currentPosition;
  String currentAddress = "";
  String lat = "";
  String lng = "";

  @override
  void initState() {
    super.initState();
    init();
    // getCurrentLocation();
  }

  init() async {
    await getCurrentLocation();
    // await getStoragePermission();
    askPermission(callBack: (value) async {});

    setState(() {
      c.images = ['', '', '', '', '', '', '', '', ''];
      aboutMe.clear();
      c.aboutMe = "";
    });
  }

  Future getStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.photos.request();
      //PermissionStatus status1 = await Permission.accessMediaLocation.request();
      // PermissionStatus status2 =
      //     await Permission.manageExternalStorage.request();
      print('status $status   -> $status');
      if (status.isGranted /*&& status2.isGranted*/) {
        return true;
      } else if (status
          .isPermanentlyDenied /* || status2.isPermanentlyDenied*/) {
        await openAppSettings();
      } else if (status.isDenied) {
        print('Permission Denied');
      }
    }
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      getAddressFromLatLng();
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        lat = _currentPosition!.latitude.toString();
        debugPrint("Current latitude $lat");
        lng = _currentPosition!.longitude.toString();
        debugPrint("Current longitude $lng");
        currentAddress =
            "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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
                        getInputFieldReferral(
                            'Referral Code'.tr,
                            'assets/images/svg/referral.svg',
                            referralCode,
                            false),
                        getImagesWidget('Add Images'.tr, context),
                        //getInputField('About me', 'assets/images/svg/about_me.svg'),
                        getMultilineField(
                            'About me'.tr,
                            'assets/images/svg/about_me.svg',
                            aboutMe,
                            false,
                            aboutMe),
                        SizedBox(
                          height: Get.height * 0.020,
                        ),
                        InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              print("c.images --> ${c.images.length}");

                              int i = c.images
                                  .indexWhere((element) => element != '');
                              if (i < 0) {
                                CommonDialog.showToastMessage(
                                    'Please add at least one photo to your profile'
                                        .tr);
                              } else if (aboutMe.text.isEmpty) {
                                CommonDialog.showToastMessage(
                                    'Please create a profile bio'.tr);
                              } else {
                                c.aboutMe = aboutMe.text;
                                c.referralCode = referralCode.text;
                                // Get.toNamed(RouteHelper.getTermsAndConditions());

                                _onNextClick();
                              }
                            },
                            child: CustomButtonLogin(
                              buttonName: "Next".tr,
                            )),
                        SizedBox(
                          height: Get.height * 0.010,
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
                                Container(
                                  margin:
                                      EdgeInsets.only(left: Get.width * 0.01),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.offAllNamed(
                                          RouteHelper.getLoginPage());
                                    },
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
    );
  }

  _onNextClick() async {
    if (c.isSocialSignup) {
      _handleSocialRegister();
    } else {
      _handleRegister();
    }
  }

  _handleSocialRegister() async {
    print("under --> _handleSocialRegister");
    var isConnect = await checkConnectivity();
    int langId = await CommonFunctions().getIdFromDeviceLang();

    if (isConnect == ConnectivityResult.mobile ||
        isConnect == ConnectivityResult.wifi) {
      debugPrint('${c.genderVisible} Gender');
      debugPrint('${c.sexualOrientationVisible} Orientation');
      var map = {
        // 'first_name':c.socialFirstName,
        // 'last_name':c.socialFirstName,
        'type': c.socialType,
        'token': c.socialToken,
        'profile_picture': c.socialImageUrl,
        'name': c.name,
        'email': c.email,
        'password': c.password,
        'phone_number': c.phoneNumber,
        'country_code': c.countryCode,
        'dob': c.dob,
        'sexual_orientation': c.orientation,
        'ethinicity': c.ethnicity,
        'trip_style': c.tripStyle,
        'travelling_duration': c.travelWithIn,
        'bio': c.aboutMe,
        'referred_by': c.referralCode,
        'gender': c.gender,
        'lat': lat,
        'lng': lng,
        'gender_show': c.genderVisible,
        'is_show_ethinicity': c.ethnicityVisible,
        'sexual_orientation_show': c.sexualOrientationVisible,
        'image_backend_compress': false,
        'langId': langId.toString(),
        'device_token': await FirebaseMessaging.instance.getToken()
      };

      print("map--> $map");
      dio.FormData form = dio.FormData.fromMap(map);
      for (int i = 0; i < c.interests!.length; i++) {
        form.fields
            .add(MapEntry('user_interests[$i]', c.interests![i].id.toString()));
      }

      for (int i = 0; i < c.destinations!.length; i++) {
        if (c.destinations![i].selectedCityId != 0) {
          form.fields.add(MapEntry('destinations[$i]',
              '${c.destinations![i].id},${c.destinations![i].selectedCityId},${c.destinations![i].selectedContinentId}'));
        } else {
          form.fields.add(
              MapEntry('destinations[$i]', c.destinations![i].id.toString()));
        }
      }
      int count = 0;
      for (int i = 0; i < c.images.length; i++) {
        if (c.images[i] != '') {
          form.files.add(MapEntry(
            'user_image[$count]',
            await dio.MultipartFile.fromFile(c.images[i],
                filename: basename(c.images[i])),
          ));
          count++;
        }
      }
      debugPrint("body ${form.fields}");
      LoginModel registerModel = await CallService().socialRegister(form);
      if (registerModel.success!) {
        CommonDialog.showToastMessage(registerModel.message.toString());
        Get.offAllNamed(RouteHelper.getBottomSheetPage());
        // debugPrint("first msg re${registerModel.message.toString()}");
        // Get.toNamed(RouteHelper.getPasswordResetAndRegisterSuccessfully(1));
      } else {
        CommonDialog.showToastMessage(registerModel.message.toString());
      }
    } else {
      CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
    }
  }

  _handleRegister() async {
    print("under --> _handleRegister");

    var isConnect = await checkConnectivity();
    int langId = await CommonFunctions().getIdFromDeviceLang();

    if (isConnect == ConnectivityResult.mobile) {
      debugPrint('${c.genderVisible} Gender');
      debugPrint('${c.sexualOrientationVisible} Orientation');
      var map = {
        'name': c.name,
        'email': c.email,
        'password': c.password,
        'phone_number': c.phoneNumber,
        'country_code': c.countryCode,
        'dob': c.dob,
        'sexual_orientation': c.orientation,
        'ethinicity': c.ethnicity,
        'trip_style': c.tripStyle,
        'travelling_duration': c.travelWithIn,
        'bio': c.aboutMe,
        'referred_by': c.referralCode,
        'gender': c.gender,
        'lat': lat,
        'lng': lng,
        'gender_show': c.genderVisible,
        'is_show_ethinicity': c.ethnicityVisible,
        'sexual_orientation_show': c.sexualOrientationVisible,
        'langId': langId.toString()
      };

      print("map--> $map");
      dio.FormData form = dio.FormData.fromMap(map);
      for (int i = 0; i < c.interests!.length; i++) {
        form.fields
            .add(MapEntry('user_interests[$i]', c.interests![i].id.toString()));
      }
      for (int i = 0; i < c.destinations!.length; i++) {
        if (c.destinations![i].selectedCityId != 0) {
          form.fields.add(MapEntry('destinations[$i]',
              '${c.destinations![i].id},${c.destinations![i].selectedCityId},${c.destinations![i].selectedContinentId}'));
        } else {
          form.fields.add(
              MapEntry('destinations[$i]', c.destinations![i].id.toString()));
        }
      }
      int count = 0;
      for (int i = 0; i < c.images.length; i++) {
        if (c.images[i] != '') {
          form.files.add(MapEntry(
            'user_image[$count]',
            await dio.MultipartFile.fromFile(c.images[i],
                filename: basename(c.images[i])),
          ));
          count++;
        }
      }
      debugPrint("body ${form.fields}");
      RegisterModel registerModel = await CallService().register(form);
      if (registerModel.success!) {
        // CommonDialog.showToastMessage(registerModel.message.toString());
        // debugPrint("first msg re${registerModel.message.toString()}");
        Get.toNamed(RouteHelper.getPasswordResetAndRegisterSuccessfully(1));
      } else {
        CommonDialog.showToastMessage(registerModel.message.toString());
      }
    } else if (isConnect == ConnectivityResult.wifi) {
      var map = {
        'name': c.name,
        'email': c.email,
        'password': c.password,
        'phone_number': c.phoneNumber,
        'country_code': c.countryCode,
        'dob': c.dob,
        'sexual_orientation': c.orientation,
        'ethinicity': c.ethnicity,
        'trip_style': c.tripStyle,
        'travelling_duration': c.travelWithIn,
        'bio': c.aboutMe,
        'referred_by': c.referralCode,
        'gender': c.gender,
        'lat': lat,
        'lng': lng,
        'gender_show': c.genderVisible,
        'is_show_ethinicity': c.ethnicityVisible,
        'sexual_orientation_show': c.sexualOrientationVisible,
        'langId': langId.toString(),
        'image_backend_compress': false,
      };

      print('map --> ${map}');
      dio.FormData form = dio.FormData.fromMap(map);
      for (int i = 0; i < c.interests!.length; i++) {
        form.fields
            .add(MapEntry('user_interests[$i]', c.interests![i].id.toString()));
      }
      for (int i = 0; i < c.destinations!.length; i++) {
        if (c.destinations![i].selectedCityId != 0) {
          form.fields.add(MapEntry('destinations[$i]',
              '${c.destinations![i].id},${c.destinations![i].selectedCityId},${c.destinations![i].selectedContinentId}'));
        } else {
          form.fields.add(
              MapEntry('destinations[$i]', c.destinations![i].id.toString()));
        }
      }
      int count = 0;
      for (int i = 0; i < c.images.length; i++) {
        if (c.images[i] != '') {
          form.files.add(MapEntry(
            'user_image[$count]',
            await dio.MultipartFile.fromFile(c.images[i],
                filename: basename(c.images[i])),
          ));
          count++;
        }
      }
      log("body ${form.fields}");

      RegisterModel registerModel = await CallService().register(form);
      if (registerModel.success!) {
        // CommonDialog.showToastMessage(registerModel.message.toString());
        // debugPrint("msg re${registerModel.message.toString()}");
        Get.toNamed(RouteHelper.getPasswordResetAndRegisterSuccessfully(1));
      } else {
        CommonDialog.showToastMessage(registerModel.message.toString());
      }
    } else {
      CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
    }
  }

  Widget getImagesWidget(String title, BuildContext context) {
    RegisterController c = Get.find();
    List<DraggableGridItem> _listOfDraggableGridItem = [];

    for (int i = 0; i < c.images.length; i++) {
      _listOfDraggableGridItem.add(DraggableGridItem(
          child: getGridTile(c.images[i], c.images[i] == '', i, context)));
    }
    return Container(
      padding: EdgeInsets.only(left:Get.width*0.042,right:Get.width*0.042,top: Get.height*0.017,bottom: Get.height*0.017),
      width: Get.width*0.9,
      margin: EdgeInsets.only(top: Get.height*0.011,bottom: Get.height*0.011 ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(title,style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),),
          ),
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            removeLeft: true,
            removeRight: true,
            child: Container(
              margin: EdgeInsets.only(top: Get.height*0.015),
              child: GridView.builder(
                itemCount: c.images.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:(Get.width/Get.height)*4,crossAxisCount: 3,crossAxisSpacing: Get.width*0.03,mainAxisSpacing: Get.width*0.03),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: AppColors.inputFieldBorderColor,
                        width: 1.0,
                      ),
                    ),
                    child: c.images[index]==''?IconButton(
                      icon: SvgPicture.asset('assets/images/svg/add_image.svg'),
                      onPressed: () async {
                        openImageOptions(index,context);
                      },
                    ):Stack(
                      children: [
                        Image.file(File(c.images[index],),
                        fit: BoxFit.cover,height: Get.height,width: Get.width,),
                        Positioned(
                            top:1,
                            right:1,
                            child: InkWell(
                              onTap:(){
                                setState(() {
                                  c.images[index]='';
                                });
                              },
                              child: Image.asset("assets/images/png/cross.png",
                              height: Get.height*0.02),
                            )),
                     ],
                    ),);
                },
              ),
            ),
          ),
        ],
      ),

    );
    // var height = Get.width - ((Get.width * 0.1) + (Get.width * 0.1));
    // height = height + (Get.width * 0.015) + (Get.width * 0.015);
    // height = height + (Get.width / 3);
    // return SizedBox(
    //   // height: Get.height * 0.67,
    //   height: height,
    //   child: MediaQuery.removePadding(
    //     context: context,
    //     removeTop: true,
    //     removeBottom: true,
    //     child: DraggableGridViewBuilder(
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2,
    //         childAspectRatio: MediaQuery.of(context).size.width /
    //             (MediaQuery.of(context).size.height / 3),
    //       ),
    //       isOnlyLongPress: false,
    //       dragCompletion:
    //           (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
    //         print('onDragAccept: $beforeIndex -> $afterIndex');
    //       },
    //       dragFeedback: (List<DraggableGridItem> list, int index) {
    //         return Container(
    //           child: list[index].child,
    //           width: 200,
    //           height: 150,
    //         );
    //       },
    //       dragPlaceHolder: (List<DraggableGridItem> list, int index) {
    //         return PlaceHolderWidget(
    //           child: Container(
    //             color: Colors.white,
    //           ),
    //         );
    //       },
    //       children: _listOfDraggableGridItem,
    //     ),
    //   ),
    // );
  }

  Widget getGridTile(
      String image, bool isEmpty, int index, BuildContext context) {
    return Container(
      key: Key('$index'),
      child: isEmpty ? Text('Empty') : Image.asset(image),
    );
  }
}

Widget getGridTile(String image, bool add, int index, BuildContext context) {
  RegisterController c = Get.find();
  return index == 0
      ? Stack(
          key: Key(index.toString()),
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: c.images[index] == ''
                    ? Image.asset(
                        image,
                        fit: BoxFit.cover,
                      )
                    : c.images[index].startsWith('https://')
                        ? Image.network(c.images[index], fit: BoxFit.cover)
                        : Image.file(File(c.images[index]), fit: BoxFit.cover),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    if (add) {
                      openImageOptions(index, context);
                      //
                      // if (await Permission.camera.isDenied) {
                      //   await Permission.camera.request();
                      // }
                      //
                      // if (await Permission.storage.isDenied) {
                      //   await Permission.storage.request();
                      // }
                    } else {
                      c.images[index] = '';
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: AppColors.forgotPasswordColor,
                        shape: BoxShape.circle),

                    // Image.asset(add
                    //     ? "assets/images/png/plus.png"
                    //     : "assets/images/png/cross.png"),
                    margin: EdgeInsets.only(
                        top: Get.height * 0.007, right: Get.width * 0.04),

                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(add ? 0 : 45 / 360),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ))
          ],
        )
      : Stack(
          key: Key(index.toString()),
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: c.images[index] == ''
                    ? Image.asset(
                        image,
                        fit: BoxFit.cover,
                      )
                    : c.images[index].startsWith('https://')
                        ? Image.network(c.images[index], fit: BoxFit.cover)
                        : Image.file(File(c.images[index]), fit: BoxFit.cover),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    if (add) {
                      openImageOptions(index, context);
                    } else {
                      c.images[index] = '';
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Get.height * 0.007, right: Get.width * 0.02),
                    decoration: const BoxDecoration(
                        color: AppColors.forgotPasswordColor,
                        shape: BoxShape.circle),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(add ? 0 : 45 / 360),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),

                    // Image.asset(add
                    //     ? "assets/images/png/plus.png"
                    //     : "assets/images/png/cross.png"),
                    // margin: EdgeInsets.only(
                    //     top: Get.height * 0.007, right: Get.width * 0.025),
                  ),
                ))
          ],
        );
}

bool showAboutMe = true;
String counterText = '500 ';
Widget getMultilineField(
    String name,
    String image,
    TextEditingController controller,
    bool obscuretext,
    TextEditingController text) {
  //TextEditingController controller = new TextEditingController(text: text.toString());
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
      margin: EdgeInsets.only(left: Get.width * 0.026),
      child: SizedBox(
        child: TextField(
          enableSuggestions: true,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          //keyboardType: Platform.isAndroid?TextInputType.multiline:TextInputType.multiline,
          keyboardType: TextInputType.multiline,

          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(500),
          ],
          maxLength: 500,
          onChanged: (value) {
            debugPrint("text length=====>>>>${text.text.length}");
            if (text.text.isEmpty) {
              showAboutMe = true;
              counterText = '500 ';
            } else {
              showAboutMe = false;
              RegExp exp = RegExp(
                  r"([\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2694-\u2697]|\uD83E[\uDD10-\uDD5D])");
              Iterable<Match> matches = exp.allMatches(value);
              int emojiLength = 0;
              for (var m in matches) {
                emojiLength += m.group(0)!.length;
              }
              counterText =
                  '${500 - (value.length - emojiLength + matches.length)} ';
              debugPrint('counterTxet $counterText');
            }
            // setState(() {});
          },
          controller: controller,
          maxLines: 12,
          obscureText: obscuretext,
          style: TextStyle(
              color: Colors.black,
              fontFamily: StringConstants.poppinsRegular,
              fontSize: Get.height * 0.016),
          decoration: InputDecoration(
            counterText: counterText,
            counterStyle: TextStyle(
                color: AppColors.grayColorNormal,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
            hintText: name,
            prefixIcon: text.text.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 0),
                    // margin:  EdgeInsets.only(top: Platform.isIOS?0: 13),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: Get.width * 0.015, bottom: Get.height * 0.24),
                      child: SvgPicture.asset(image),
                    ),
                  )
                : null,
            prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080),
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

/*Widget getInputField(String name, String image) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.020),
          child: TextField(
            controller: aboutMe,
            keyboardType: TextInputType.multiline,
            maxLength: 500,
            maxLines: 1,
            onChanged: (text){
              if(text.isEmpty){
                setState(() {
                  showAboutMe=true;
                  counterText='500 ';
                });
              }else{
                setState(() {
                  showAboutMe=false;
                  counterText=(500 - text.length).toString()+' ';
                });
              }
            },
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.height * 0.016),
            decoration: InputDecoration(
              hintText: name,
              counterText: counterText,
              counterStyle:TextStyle(
                  color: AppColors.grayColorNormal,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.016) ,
              prefixIcon:Visibility(
                visible:showAboutMe ,
                child: Padding(
                  padding:  EdgeInsets.only(right: Get.width*0.01),
                  child: SvgPicture.asset(image),
                ),
              ) ,
              contentPadding: EdgeInsets.all(0),
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width*0.05,maxHeight: Get.width*0.05),
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.016),
              border: InputBorder.none,
            ),
          ),
      ),
    );
  }*/
void openImageOptions(int index, BuildContext context) {
  RegisterController c = Get.find();
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent),
      margin: EdgeInsets.only(
          right: Get.width * 0.050,
          left: Get.width * 0.050,
          bottom: Get.height * 0.020),
      height: Get.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    askAppPermission(context,
                        type: 'Camera',
                        description:
                            'Please allow camera access to add at least one image.'
                                .tr, callBack: (v) async {
                      // if (await Permission.camera.isDenied) {
                      //   await Permission.camera.request();
                      // }
                      Get.back();

                      Get.to(TakePictureScreen(
                          // camera: camerasAvailable[0],
                          callBack: (XFile? res) async {
                        Get.back();

                        print("cliccccked $res");
                        if (res != null) {
                          File file = File(res.path);

                          CroppedFile? croppedFile =
                              await ImageCropper().cropImage(
                            // compressQuality: 100,
                            sourcePath: res.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                              // CropAspectRatioPreset.ratio3x2,
                              // CropAspectRatioPreset.original,
                              // CropAspectRatioPreset.ratio4x3,
                              // CropAspectRatioPreset.ratio16x9
                            ],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Crop Image',
                                  toolbarColor: Colors.black,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: false,
                                  hideBottomControls: true),
                              IOSUiSettings(
                                title: 'Crop Image',
                              ),
                              WebUiSettings(
                                context: context,
                              ),
                            ],
                          );

                          if (croppedFile != null) {
                            c.images[index] = croppedFile.path;
                            c.backendImageCompress[index] = false;
                          }

                          return;
                          // await Future.delayed(
                          //     const Duration(milliseconds: 200));
                          // await Navigator.of(Get.overlayContext!)
                          //     .push(MaterialPageRoute(
                          //   builder: (context) => CropImage(
                          //     path: file.path,
                          //   ),
                          // ))
                          //     .then((value) {
                          //   if (value != null) {
                          //     setState(() {
                          //       c.images[index] = value;
                          //     });
                          //   }
                          // });
                        }
                      }));
                      /*
                        final ImagePicker _picker = ImagePicker();

                        XFile? res = await _picker.pickImage(
                            imageQuality: 25, source: ImageSource.camera);
                        //
                        // List<Media>? res = await ImagesPicker.openCamera(
                        //   pickType: PickType.image,
                        // );
                        if (res != null) {
                          */ /*CroppedFile? croppedFile = await ImageCropper().cropImage(
                          sourcePath: res[0].path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'Cropper',
                            ),
                            WebUiSettings(
                              context: context,
                            ),
                          ],
                        );*/ /*

                           Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => CropImage(
                              path: res.path,
                            ),
                          ))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                c.images[index] = value;
                              });
                            }
                          });
                        }*/
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Camera".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                InkWell(
                  onTap: () async {
                    askAppPermission(context,
                        type: 'Gallery',
                        description:
                            'Please allow storage access to add at least one image.'
                                .tr, callBack: (v) async {
                      Get.back();
                      final ImagePicker _picker = ImagePicker();

                      XFile? res = await _picker.pickImage(
                          // imageQuality: 25,
                          source: ImageSource.gallery);

                      // List<Media>? res = await ImagesPicker.pick(
                      //   pickType: PickType.image,
                      // );

                      if (res != null) {
                        // var res = await CommonFunctions.compressFile(
                        //     File(mainRes.path));
                        /*CroppedFile? croppedFile = await ImageCropper().cropImage(
                          sourcePath: res[0].path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'Cropper',
                            ),
                            WebUiSettings(
                              context: context,
                            ),
                          ],
                        );*/

                        final dir =
                            await CommonFunctions().createFolder("gagago");

                        File image = File(res.path);

// copy the file to a new path
                        File file = await image.copy(
                            '$dir/${DateTime.now().millisecondsSinceEpoch}.png');
                        c.images[index] = file.path;

                        await Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => CropImage(
                            path: file.path,
                          ),
                        ))
                            .then((value) {
                          if (value != null) {
                            c.images[index] = value;
                            c.backendImageCompress[index] = false;
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Gallery".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
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
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.radius15)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.070,
              child: Center(
                  child: Text(
                "Cancel".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: StringConstants.poppinsRegular,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height * 0.018,
                    color: Colors.black),
              )),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getInputFieldReferral(String name, String image,
    TextEditingController controller, bool obscuretext) {
  return Container(
    margin:
        EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.030),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(
        color: AppColors.inputFieldBorderColor,
        width: 1.0,
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(left: Get.width * 0.026),
      child: SizedBox(
        child: TextField(
          controller: controller,
          obscureText: obscuretext,
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
      context: Get.overlayContext ?? context,
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

void askAppPermission(context,
    {required Function(bool) callBack,
    required String type,
    required String description}) async {
  late PermissionStatus? status;
  if (type == "Camera") {
    status = await Permission.camera.request();
  } else if (type == "Gallery") {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      // Android 9 (SDK 28), Xiaomi Redmi Note 7

      int id;
      if (release.contains(".")) {
        int idx = release.indexOf(".");
        release.substring(0, idx).trim();
        id = release.indexOf(".");
      } else {
        id = int.parse(release);
      }
      if (id < 13) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      status = await Permission.storage.request();
    }
  } else if (type == "Location") {
    status = await Permission.location.request();
  }

  if (status != null) {
    if (status.isDenied) {
      print("status --> isDenied");
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      //    print("Permission is denied.");
      if (type == "Camera") {
        status = await Permission.camera.request();
      } else if (type == "Gallery") {
        if (Platform.isAndroid) {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          var release = androidInfo.version.release;
          // Android 9 (SDK 28), Xiaomi Redmi Note 7

          int id;
          if (release.contains(".")) {
            int idx = release.indexOf(".");
            release.substring(0, idx).trim();
            id = release.indexOf(".");
          } else {
            id = int.parse(release);
          }
          if (id < 13) {
            status = await Permission.storage.request();
          } else {
            status = await Permission.photos.request();
          }
        } else {
          status = await Permission.storage.request();
        }
      } else if (type == "Location") {
        status = await Permission.location.request();
      }
    } else if (status.isGranted) {
      print("status --> isGranted");
      //permission is already granted.
      callBack(true);
      //  scrollController = widget.scrollController;
    } else if (status.isPermanentlyDenied) {
      print("status --> isPermanentlyDenied");
      //permission is permanently denied.
      // callBack(true);
      openAppSettingBox(context, description: description);
      //   print("Permission is permanently denied");
    } else if (status.isRestricted) {
      print("status --> isRestricted");
      //permission is OS restricted.
      // callBack(true);
      openAppSettingBox(context, description: description);
    } else {
      print("status --> under else");
    }
  }
}

bool isShowing = false;

void openAppSettingBox(context, {required String description}) {
  print("under --> openAppBox ${isDialogShowing}");
  if (isDialogShowing) {
    return;
  }
  isDialogShowing = true;
  showDialog(
      context: Get.overlayContext ?? context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CommonAlertDialog(
          description: description,
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
                      description.tr,
                      // 'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                      //     .tr,
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
