// import 'dart:developer';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gagagonew/CommonWidgets/crop_image_widget.dart';
// import 'package:gagagonew/RouteHelper/route_helper.dart';
// import 'package:gagagonew/constants/color_constants.dart';
// import 'package:gagagonew/model/delete_image_model.dart';
// import 'package:gagagonew/model/image_reorder_model.dart';
// import 'package:gagagonew/utils/common_functions.dart';
// import 'package:get/get.dart';
// import 'package:images_picker/images_picker.dart';
// import 'package:path/path.dart';
// import 'package:reorderableitemsview/reorderableitemsview.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../CommonWidgets/common_back_button.dart';
// import '../../Service/call_service.dart';
// import '../../constants/string_constants.dart';
// import '../../controller/register_controller.dart';
// import '../../model/destination_model.dart';
// import '../../model/edit_profile_model.dart';
// import '../../model/interests_model.dart';
// import '../../model/update_profile_model.dart';
// import '../../utils/dimensions.dart';
// import '../../utils/progress_bar.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   List<User>? user = [];
//   TextEditingController aboutController = TextEditingController(text: '');
//
//   /*TextEditingController nameController=new TextEditingController(text: '');
//   TextEditingController phoneNumberController=new TextEditingController(text: '');*/
//   String sexualOrientation = '1';
//   String gender = '1';
//   String trip_style = "1";
//   String trip_timeline = "1";
//   String ethinicity = '1';
//   List<Userdestinations>? userdestinations = [];
//   List<Userinterest>? userinterest = [];
//   List<String?>? userimages = ['', '', '', '', '', '', '', '', ''];
//   List<String>? userimagesIds = ['', '', '', '', '', '', '', '', ''];
//
//   int? isSubscribe;
//   bool visibleGender = false;
//   bool visibleOrientation = false;
//   bool visibleEthnicity = false;
//   String? is_show_sexual_orientation;
//   String ethnicity = '1';
//   bool isInterestUpdated = false;
//   bool isDestinationUpdated = false;
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   init() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String userId = prefs.getString('userId')!;
//       var map = Map<String, dynamic>();
//       map['user_id'] = userId;
//       EditProfileModel model = await CallService().getEditProfileData(map);
//       setState(() {
//         user = model.user;
//         isSubscribe = user![0].isSubscriber;
//         visibleOrientation = user![0].isShowSexualOrientation == 'Yes';
//         visibleGender = user![0].isShowGender == 'Yes';
//         visibleEthnicity = user![0].isShowEthnicity == 'Yes';
//         userId = user![0].id.toString();
//         /*nameController.text=user![0].firstName.toString()+' '+user![0].lastName.toString();
//         phoneNumberController.text=user![0].phoneNumber.toString();*/
//         aboutController.text = user![0].bio.toString();
//         if (aboutController.text.isEmpty) {
//           counterText = '500 ';
//           showAboutMe = true;
//         } else {
//           counterText = '${500 - aboutController.text.length} ';
//           showAboutMe = false;
//         }
//         gender = user![0].gender!;
//         ethnicity = user![0].ethinicity == null ? '' : user![0].ethinicity!;
//         sexualOrientation = user![0].sexualOrientation!;
//         trip_style = user![0].tripStyle!;
//         trip_timeline = user![0].tripTimeline!;
//         userdestinations = user![0].userdestinations;
//         userinterest = user![0].userinterest;
//         for (int i = 0; i < user![0].userimages!.length; i++) {
//           if (i <= (userimages!.length - 1)) {
//             userimages![i] = user![0].userimages![i].imageName.toString();
//             userimagesIds![i] = user![0].userimages![i].id.toString();
//           }
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     RegisterController c = Get.put(RegisterController());
//     double tapToEditFontSize = Get.height * 0.020;
//
//     if (Platform.isMacOS) {
//       tapToEditFontSize = Get.height * 0.020;
//     }
//
//     print(" tapToEditFontSize $tapToEditFontSize");
//
//     var height = Get.width - ((Get.width * 0.060) + (Get.width * 0.060));
//     height = height + (Get.width * 0.015) + (Get.width * 0.015);
//     height = height + (Get.width / 3);
//
//     print("data ${Get.width} $height ");
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(top: Get.height * 0.080, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonBackButton(
//                 name: 'Edit Profile'.tr,
//               ),
//               SizedBox(
//                 height: Get.height * 0.04,
//               ),
//               Text('Tap to edit, drag to reorder'.tr,
//                   style: TextStyle(
//                       color: AppColors.grayColorNormal, fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular')),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               SizedBox(
//                 height: height,
//                 child: MediaQuery.removePadding(
//                   context: context,
//                   removeTop: true,
//                   removeBottom: true,
//                   child: ReorderableItemsView(
//                     crossAxisCount: 3,
//                     isGrid: true,
//                     longPressToDrag: true,
//                     staggeredTiles: [for (int i = 0; i < userimages!.length; i++) i == 0 ? StaggeredTileExtended.count(2, 2) : StaggeredTileExtended.count(1, 1)],
//                     crossAxisSpacing: Get.width * 0.015,
//                     mainAxisSpacing: Get.width * 0.015,
//                     onReorder: (int oldIndex, int newIndex) async {
//                       if (userimages![oldIndex] != '' && userimages![newIndex] != '') {
//                         var map = Map<String, dynamic>();
//                         map['replaced_by'] = userimagesIds![oldIndex];
//                         map['replaced_to'] = userimagesIds![newIndex];
//                         ImageReorderModel reorderModel = await CallService().imageReorder(map);
//                         if (reorderModel.success == true) {
//                           setState(() {
//                             userimages!.insert(newIndex, userimages!.removeAt(oldIndex));
//                           });
//                         } else {
//                           CommanDialog.showToastMessage(reorderModel.message.toString());
//                         }
//                       }
//                     },
//                     children: [
//                       /*StaggeredGridTile.count(
//                         crossAxisCellCount: 2,
//                         mainAxisCellCount: 2,
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               child:
//                                   Image.asset("assets/images/png/girl_image.png"),
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             Align(
//                                 child: Container(
//                                   child: Image.asset("assets/images/png/cross.png"),
//                                   margin: EdgeInsets.only(
//                                       top: Get.height * 0.007,
//                                       right: Get.width * 0.04),
//                                 ),
//                                 alignment: Alignment.topRight)
//                           ],
//                         ),
//                       ),*/
//                       //getGridTile("assets/images/png/land_scape.png", false),
//                       for (int i = 0; i < userimages!.length; i++) getGridTile('assets/images/png/placeholder.png', userimages![i] == '' || userimages![i] == null, i, context)
//                     ],
//                   ),
//                 ),
//               ),
//               getInputFieldMultipleLine('About me'.tr, 'assets/images/svg/about_me.svg', aboutController.text),
//               getSelectionWidgetGender('Gender'.tr),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: Get.width * 0.05,
//                     height: Get.width * 0.05,
//                     child: Checkbox(
//                       value: visibleGender,
//                       onChanged: (newValue) {
//                         setState(() {
//                           visibleGender = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     width: Get.height * 0.01,
//                   ),
//                   Text("Visible on profile".tr, style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
//                 ],
//               ),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               getSelectionWidgetSexual('Sexual Orientation'.tr),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: Get.width * 0.05,
//                     height: Get.width * 0.05,
//                     child: Checkbox(
//                       value: visibleOrientation,
//                       onChanged: (newValue) {
//                         setState(() {
//                           visibleOrientation = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     width: Get.height * 0.01,
//                   ),
//                   Text("Visible on profile".tr, style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
//                 ],
//               ),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               getSelectionWidgetEthnicity('Ethnicity'.tr),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: Get.width * 0.05,
//                     height: Get.width * 0.05,
//                     child: Checkbox(
//                       value: visibleEthnicity,
//                       onChanged: (newValue) {
//                         setState(() {
//                           visibleEthnicity = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     width: Get.height * 0.01,
//                   ),
//                   Text("Visible on profile".tr, style: TextStyle(color: AppColors.grayColorNormal, fontSize: Get.height * 0.020, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular'))
//                 ],
//               ),
//               SizedBox(
//                 height: Get.height * 0.01,
//               ),
//               getSelectionWidgetTripStyle('Trip Style'.tr),
//               getSelectionWidgetNext('Traveling within the next'.tr),
//               InkWell(
//                   onTap: () async {
//                     c.destinations!.clear();
//                     for (int i = 0; i < userdestinations!.length; i++) {
//                       Countries countries = Countries();
//                       countries.id = int.parse(userdestinations![i].id.toString());
//                       countries.destId = int.parse(userdestinations![i].destId.toString());
//                       countries.countryName = userdestinations![i].destName.toString();
//                       countries.countryImage = userdestinations![i].destImage.toString();
//                       if (userdestinations![i].type.toString() == "1") {
//                         countries.selectedCityId = 1;
//                         if (userdestinations![i].regionId != null) {
//                           countries.selectedContinentId = userdestinations![i].regionId!;
//                         }
//                       }
//                       c.destinations!.add(countries);
//                     }
//                     await Get.toNamed(RouteHelper.getDestinations(
//                       isSubscribe.toString(),
//                     ));
//                     isDestinationUpdated = true;
//                     if (c.destinations!.isNotEmpty) {
//                       userdestinations!.clear();
//                       for (int i = 0; i < c.destinations!.length; i++) {
//                         Userdestinations destination = Userdestinations();
//                         destination.id = c.destinations![i].id;
//                         destination.destId = c.destinations![i].destId.toString();
//                         destination.destName = c.destinations![i].countryName;
//                         destination.destImage = c.destinations![i].countryImage;
//                         destination.selectedCityId = c.destinations![i].selectedCityId;
//                         destination.selectedContinentId = c.destinations![i].selectedContinentId;
//                         userdestinations!.add(destination);
//                       }
//                       setState(() {});
//                     }
//                   },
//                   child: getMeetDestinationWidget('assets/images/svg/location.svg', userdestinations)),
//               InkWell(
//                   onTap: () async {
//                     c.interests!.clear();
//                     for (int i = 0; i < userinterest!.length; i++) {
//                       Interest interest = Interest();
//                       interest.id = int.parse(userinterest![i].id.toString());
//                       interest.interestId = int.parse(userinterest![i].interestId.toString());
//                       interest.name = userinterest![i].interestName.toString();
//                       interest.image = userinterest![i].interestImage.toString();
//                       c.interests!.add(interest);
//                     }
//                     await Get.toNamed(RouteHelper.getMeetNow(isSubscribe.toString()));
//                     isInterestUpdated = true;
//                     if (c.interests!.isNotEmpty) {
//                       userinterest!.clear();
//                       for (int i = 0; i < c.interests!.length; i++) {
//                         Userinterest interest = Userinterest();
//                         interest.id = c.interests![i].id;
//                         interest.interestId = c.interests![i].interestId;
//                         interest.interestName = c.interests![i].name;
//                         interest.interestImage = c.interests![i].image;
//                         userinterest!.add(interest);
//                       }
//                       setState(() {});
//                     }
//                   },
//                   child: getInterestsWidget('assets/images/svg/globe.svg', userinterest)),
//               Container(
//                 margin: EdgeInsets.only(top: Get.height * 0.005),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: Get.height * 0.060,
//                         width: Get.width * 0.43,
//                         decoration: BoxDecoration(color: AppColors.cancelButtonColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
//                         child: Text(
//                           'Cancel'.tr,
//                           style: TextStyle(fontSize: Get.height * 0.016, color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       onTap: () {
//                         Get.back();
//                       },
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         SharedPreferences prefs = await SharedPreferences.getInstance();
//                         final form = FormData({
//                           'user_id': prefs.getString('userId'),
//                           'bio': aboutController.text,
//                           'gender': gender,
//                           'sexual_orientation': sexualOrientation,
//                           'ethinicity': ethnicity,
//                           'style_type': trip_style,
//                           'travelling_duration': trip_timeline,
//                           'sexual_orientation_show': visibleOrientation ? 1 : 0,
//                           'is_show_gender': visibleGender ? 1 : 0,
//                           'is_show_ethinicity': visibleEthnicity ? 1 : 0
//                           /*'country_code':'1',
//                           'phone_number':phoneNumberController.text,
//                           'name':nameController.text*/
//                         });
//                         for (int i = 0; i < userinterest!.length; i++) {
//                           if (userinterest![i].interestId.toString() == '0') {
//                             form.fields.add(MapEntry('userinterest[$i]', userinterest![i].id.toString()));
//                           } else {
//                             form.fields.add(MapEntry('userinterest[$i]', userinterest![i].interestId.toString()));
//                           }
//                         }
//                         print("userdestinations.length ${userdestinations!.length}");
//                         if (isDestinationUpdated) {
//                           for (int i = 0; i < userdestinations!.length; i++) {
//                             print("1-->> $i ${userdestinations![i].selectedCityId.toString()}");
//                             // if (userdestinations![i].selectedCityId != 0) {
//                             if (userdestinations![i].selectedCityId.toString() != "0") {
//                               print("2-->> $i ${userdestinations![i].destId}");
//
//                               if (userdestinations![i].destId.toString() == '0') {
//                                 form.fields
//                                     .add(MapEntry('userdestinations[$i]', '${userdestinations![i].id},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                               } else {
//                                 form.fields.add(
//                                     MapEntry('userdestinations[$i]', '${userdestinations![i].destId},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                               }
//                             } else {
//                               print("3-->> $i ${userdestinations![i].destId}");
//
//                               // if (userdestinations![i].destId.toString() != "0") {
//                               if (userdestinations![i].destId.toString() == '0') {
//                                 print("4-->> $i ${userdestinations![i].id}");
//
//                                 form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].id.toString()));
//                               } else {
//                                 form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].destId.toString()));
//                               }
//                               // }
//                             }
//                           }
//                         }
//                         int count = 0;
//                         for (int i = 0; i < userimages!.length; i++) {
//                           if (userimages![i] != '') {
//                             if (userimages![i]!.startsWith('https://')) {
//                               form.fields.add(MapEntry('images[$count]', basename(userimages![i]!)));
//                               count++;
//                             } else {
//                               form.files.add(MapEntry(
//                                 'images[$count]',
//                                 MultipartFile(userimages![i], filename: basename(userimages![i]!)),
//                               ));
//                               count++;
//                             }
//                           }
//                         }
//                         //
//                         log("form ${form.fields}");
//                         UpdateProfileModel updateProfileModel = await CallService().updateProfile(form);
//                         if (updateProfileModel.success!) {
//                           Get.back();
//                           //Get.offAllNamed(RouteHelper.getBottomSheetPage());
//                           //CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                         } else {
//                           CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                         }
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: Get.height * 0.060,
//                         width: Get.width * 0.43,
//                         decoration: BoxDecoration(color: AppColors.buttonColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
//                         child: Text(
//                           'Save'.tr,
//                           style: TextStyle(fontSize: Get.height * 0.016, color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getGridTile(String image, bool add, int index, BuildContext context) {
//     return index == 0 ? _largeImageItem(image: image, add: add, index: index, context: context) : _smallImageItem(image: image, add: add, index: index, context: context);
//   }
//
//   _largeImageItem({required String image, required bool add, required int index, required BuildContext context}) {
//     return Stack(
//       key: Key(index.toString()),
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10.0),
//             child: userimages![index] == ''
//                 ? Image.asset(
//                     image,
//                     fit: BoxFit.cover,
//                   )
//                 : userimages![index]!.startsWith('https://')
//                     ? Image.network(userimages![index]!, fit: BoxFit.cover)
//                     : Image.file(File(userimages![index]!), fit: BoxFit.cover),
//           ),
//         ),
//         Align(
//             alignment: Alignment.topRight,
//             child: InkWell(
//               onTap: () async {
//                 if (add) {
//                   openImageOptions(index, context, callBack: () async {
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     final form = FormData({
//                       'user_id': prefs.getString('userId'),
//                       'bio': aboutController.text,
//                       'gender': gender,
//                       'sexual_orientation': sexualOrientation,
//                       'ethinicity': ethnicity,
//                       'style_type': trip_style,
//                       'travelling_duration': trip_timeline,
//                       'sexual_orientation_show': visibleOrientation ? 1 : 0,
//                       'is_show_gender': visibleGender ? 1 : 0,
//                       'is_show_ethinicity': visibleEthnicity ? 1 : 0
//                       /*'country_code':'1',
//                           'phone_number':phoneNumberController.text,
//                           'name':nameController.text*/
//                     });
//                     for (int i = 0; i < userinterest!.length; i++) {
//                       if (userinterest![i].interestId.toString() == '0') {
//                         form.fields.add(MapEntry('userinterest[$i]', userinterest![i].id.toString()));
//                       } else {
//                         form.fields.add(MapEntry('userinterest[$i]', userinterest![i].interestId.toString()));
//                       }
//                     }
//                     if (isDestinationUpdated) {
//                       for (int i = 0; i < userdestinations!.length; i++) {
//                         if (userdestinations![i].selectedCityId != 0) {
//                           if (userdestinations![i].destId.toString() == '0') {
//                             form.fields
//                                 .add(MapEntry('userdestinations[$i]', '${userdestinations![i].id},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                           } else {
//                             form.fields
//                                 .add(MapEntry('userdestinations[$i]', '${userdestinations![i].destId},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                           }
//                         } else {
//                           if (userdestinations![i].destId.toString() == '0') {
//                             form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].id.toString()));
//                           } else {
//                             form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].destId.toString()));
//                           }
//                         }
//                       }
//                     }
//                     int count = 0;
//                     for (int i = 0; i < userimages!.length; i++) {
//                       if (userimages![i] != '') {
//                         if (userimages![i]!.startsWith('https://')) {
//                           form.fields.add(MapEntry('images[$count]', basename(userimages![i]!)));
//                           count++;
//                         } else {
//                           form.files.add(MapEntry(
//                             'images[$count]',
//                             MultipartFile(userimages![i], filename: basename(userimages![i]!)),
//                           ));
//                           count++;
//                         }
//                       }
//                     }
//                     print("form ${form.fields}");
//                     UpdateProfileModel updateProfileModel = await CallService().updateProfile(form);
//                     init();
//                     // if (updateProfileModel.success!) {
//                     //   Get.back();
//                     //   //Get.offAllNamed(RouteHelper.getBottomSheetPage());
//                     //   //CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                     // } else {
//                     //   CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                     // }
//                   });
//                 } else {
//                   if (userimages![index]!.startsWith('https://')) {
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     String userId = prefs.getString('userId')!;
//                     var map = Map<String, dynamic>();
//                     map['user_id'] = userId;
//                     map['image_name'] = basename(userimages![index]!);
//                     DeleteImageModel deleteImage = await CallService().deleteImage(map);
//                     if (deleteImage.success == true) {
//                       CommanDialog.showToastMessage(deleteImage.message.toString());
//                       setState(() {
//                         // userimages!.removeAt(index);
//                         userimages![index] = '';
//                       });
//                     } else {
//                       CommanDialog.showToastMessage(deleteImage.message.toString());
//                     }
//                   } else {
//                     setState(() {
//                       // userimages!.removeAt(index);
//                       userimages![index] = '';
//                     });
//                   }
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(color: AppColors.forgotPasswordColor, shape: BoxShape.circle),
//                 // Image.asset(add ? "assets/images/png/plus.png" : "assets/images/png/cross.png"),
//                 margin: EdgeInsets.only(top: Get.height * 0.007, right: Get.width * 0.04),
//                 child: RotationTransition(
//                   turns: AlwaysStoppedAnimation(add ? 0 : 45 / 360),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ))
//       ],
//     );
//   }
//
//   _smallImageItem({required String image, required bool add, required int index, required BuildContext context}) {
//     print("userimages![index] ${userimages![index]}");
//     return Stack(
//       key: Key(index.toString()),
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10.0),
//             child: userimages![index] == ''
//                 ? Image.asset(
//                     image,
//                     fit: BoxFit.cover,
//                   )
//                 : userimages![index]!.startsWith('https://')
//                     ? Image.network(userimages![index]!, fit: BoxFit.cover)
//                     : Image.file(File(userimages![index]!), fit: BoxFit.cover),
//           ),
//         ),
//         Align(
//             alignment: Alignment.topRight,
//             child: InkWell(
//               onTap: () async {
//                 if (add) {
//                   openImageOptions(index, context, callBack: () async {
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     final form = FormData({
//                       'user_id': prefs.getString('userId'),
//                       'bio': aboutController.text,
//                       'gender': gender,
//                       'sexual_orientation': sexualOrientation,
//                       'ethinicity': ethnicity,
//                       'style_type': trip_style,
//                       'travelling_duration': trip_timeline,
//                       'sexual_orientation_show': visibleOrientation ? 1 : 0,
//                       'is_show_gender': visibleGender ? 1 : 0,
//                       'is_show_ethinicity': visibleEthnicity ? 1 : 0
//                       /*'country_code':'1',
//                           'phone_number':phoneNumberController.text,
//                           'name':nameController.text*/
//                     });
//                     for (int i = 0; i < userinterest!.length; i++) {
//                       if (userinterest![i].interestId.toString() == '0') {
//                         form.fields.add(MapEntry('userinterest[$i]', userinterest![i].id.toString()));
//                       } else {
//                         form.fields.add(MapEntry('userinterest[$i]', userinterest![i].interestId.toString()));
//                       }
//                     }
//                     for (int i = 0; i < userdestinations!.length; i++) {
//                       if (userdestinations![i].selectedCityId != 0) {
//                         if (userdestinations![i].destId.toString() == '0') {
//                           form.fields.add(MapEntry('userdestinations[$i]', '${userdestinations![i].id},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                         } else {
//                           form.fields
//                               .add(MapEntry('userdestinations[$i]', '${userdestinations![i].destId},${userdestinations![i].selectedCityId},${userdestinations![i].selectedContinentId}'));
//                         }
//                       } else {
//                         if (userdestinations![i].destId.toString() == '0') {
//                           form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].id.toString()));
//                         } else {
//                           form.fields.add(MapEntry('userdestinations[$i]', userdestinations![i].destId.toString()));
//                         }
//                       }
//                     }
//                     int count = 0;
//                     for (int i = 0; i < userimages!.length; i++) {
//                       if (userimages![i] != '') {
//                         if (userimages![i]!.startsWith('https://')) {
//                           form.fields.add(MapEntry('images[$count]', basename(userimages![i]!)));
//                           count++;
//                         } else {
//                           form.files.add(MapEntry(
//                             'images[$count]',
//                             MultipartFile(userimages![i], filename: basename(userimages![i]!)),
//                           ));
//                           count++;
//                         }
//                       }
//                     }
//                     print("form ${form.fields}");
//                     UpdateProfileModel updateProfileModel = await CallService().updateProfile(form);
//                     init();
//                     // if (updateProfileModel.success!) {
//                     //   Get.back();
//                     //   //Get.offAllNamed(RouteHelper.getBottomSheetPage());
//                     //   //CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                     // } else {
//                     //   CommanDialog.showToastMessage(updateProfileModel.message.toString());
//                     // }
//                   });
//                 } else {
//                   if (userimages![index] != null) {
//                     if (userimages![index]!.startsWith('https://')) {
//                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                       String userId = prefs.getString('userId')!;
//                       var map = <String, dynamic>{};
//                       map['user_id'] = userId;
//                       map['image_name'] = basename(userimages![index]!);
//                       DeleteImageModel deleteImage = await CallService().deleteImage(map);
//                       if (deleteImage.success == true) {
//                         CommanDialog.showToastMessage(deleteImage.message.toString());
//                         setState(() {
//                           // userimages!.removeAt(index);
//                           userimages![index] = '';
//                         });
//                       } else {
//                         CommanDialog.showToastMessage(deleteImage.message.toString());
//                       }
//                     } else {
//                       setState(() {
//                         // userimages!.removeAt(index);
//                         userimages![index] = '';
//                       });
//                     }
//                   }
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(color: AppColors.forgotPasswordColor, shape: BoxShape.circle),
//
//                 // Image.asset(add
//                 //     ? "assets/images/png/plus.png"
//                 //     : "assets/images/png/cross.png"),
//                 margin: EdgeInsets.only(top: Get.height * 0.007, right: Get.width * 0.025),
//                 child: RotationTransition(
//                   turns: AlwaysStoppedAnimation(add ? 0 : 45 / 360),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ))
//       ],
//     );
//   }
//
//   Widget getInputFieldName(String name, String image, String text) {
//     return Container(
//       margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Container(
//         margin: EdgeInsets.only(left: Get.width * 0.026),
//         child: SizedBox(
//           child: TextField(
//             //controller: nameController,
//             textAlign: TextAlign.start,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//             decoration: InputDecoration(
//               hintText: name,
//               prefixIcon: Padding(
//                 padding: EdgeInsets.only(right: Get.width * 0.008),
//                 child: SvgPicture.asset(image),
//               ),
//               contentPadding: EdgeInsets.only(right: Get.width * 0.01),
//               prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.04, maxHeight: Get.width * 0.04),
//               hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getInputFieldPhone(String name, String image, String text) {
//     return Container(
//       margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Container(
//         margin: EdgeInsets.only(left: Get.width * 0.026),
//         child: SizedBox(
//           child: TextField(
//             //controller: phoneNumberController,
//             textAlign: TextAlign.start,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//             decoration: InputDecoration(
//               hintText: name,
//               prefixIcon: Padding(
//                 padding: EdgeInsets.only(right: Get.width * 0.008),
//                 child: SvgPicture.asset(image),
//               ),
//               contentPadding: EdgeInsets.only(right: Get.width * 0.01),
//               prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.04, maxHeight: Get.width * 0.04),
//               hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getSelectionWidgetGender(String label) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.011),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: Get.height * 0.01),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: gender == '1',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               gender = '1';
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: Get.width * 0.005,
//                       ),
//                       Text(
//                         'Male'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: gender == '2',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               gender = '2';
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: Get.width * 0.005,
//                       ),
//                       Text(
//                         'Female'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: gender == '3',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               gender = '3';
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: Get.width * 0.005,
//                       ),
//                       Text(
//                         'Transgender'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget getSelectionWidgetSexual(String label) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.023),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: Get.height * 0.01),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: sexualOrientation == '1',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   sexualOrientation = '1';
//                                 });
//                               },
//                             ),
//                           ),
//                           Text(
//                             'Straight'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: sexualOrientation == '2',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   sexualOrientation = '2';
//                                 });
//                               },
//                             ),
//                           ),
//                           Text(
//                             'Bisexual'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: sexualOrientation == '3',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   sexualOrientation = '3';
//                                 });
//                               },
//                             ),
//                           ),
//                           Text(
//                             'Lesbian'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: Get.height * 0.005),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: Get.width * 0.06,
//                               height: Get.width * 0.06,
//                               child: Checkbox(
//                                 shape: const CircleBorder(), // Rounded Checkbox
//                                 checkColor: Colors.white,
//                                 value: sexualOrientation == '4',
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     sexualOrientation = '4';
//                                   });
//                                 },
//                               ),
//                             ),
//                             Text(
//                               'Gay'.tr,
//                               style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget getSelectionWidgetTripStyle(String label) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(bottom: Get.height * 0.011, top: Get.height * 0.023),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: Get.height * 0.01),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: trip_style == '1',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               trip_style = '1';
//                             });
//                           },
//                         ),
//                       ),
//                       Text(
//                         'Backpacking'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: trip_style == '2',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               trip_style = '2';
//                             });
//                           },
//                         ),
//                       ),
//                       Text(
//                         'Mid-Range'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: trip_style == '3',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               trip_style = '3';
//                             });
//                           },
//                         ),
//                       ),
//                       Text(
//                         'Luxury'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget getSelectionWidgetNext(String label) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: Get.height * 0.01),
//               child: Row(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: Get.width * 0.06,
//                         height: Get.width * 0.06,
//                         child: Checkbox(
//                           shape: const CircleBorder(), // Rounded Checkbox
//                           checkColor: Colors.white,
//                           value: trip_timeline == '1',
//                           onChanged: (bool? value) {
//                             setState(() {
//                               trip_timeline = '1';
//                             });
//                           },
//                         ),
//                       ),
//                       Text(
//                         '1-3 Months'.tr,
//                         style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(left: Get.width * 0.09),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: Get.width * 0.06,
//                           height: Get.width * 0.06,
//                           child: Checkbox(
//                             shape: const CircleBorder(), // Rounded Checkbox
//                             checkColor: Colors.white,
//                             value: trip_timeline == '2',
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 trip_timeline = '2';
//                               });
//                             },
//                           ),
//                         ),
//                         Text(
//                           '3-6 Months'.tr,
//                           style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//           Container(
//             margin: EdgeInsets.only(top: Get.height * 0.01),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: Get.width * 0.06,
//                   height: Get.width * 0.06,
//                   child: Checkbox(
//                     shape: const CircleBorder(), // Rounded Checkbox
//                     checkColor: Colors.white,
//                     value: trip_timeline == '3',
//                     onChanged: (bool? value) {
//                       setState(() {
//                         trip_timeline = '3';
//                       });
//                     },
//                   ),
//                 ),
//                 Text(
//                   '6-12 Months'.tr,
//                   style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getMeetDestinationWidget(String image, List<Userdestinations>? choices) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Row(
//         children: [
//           SvgPicture.asset(
//             image,
//             width: Get.width * 0.07,
//             height: Get.width * 0.07,
//           ),
//           SizedBox(
//             width: Get.width * 0.02,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Wrap(
//                 children: List<Widget>.generate(
//                   choices!.length,
//                   (int idx) {
//                     /*return Container(
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         color: AppColors.blueColor.withOpacity(0.08),
//                         borderRadius: BorderRadius.all(Radius.circular(6)),
//                         border: new Border.all(
//                           color: AppColors.blueColor,
//                           width: 1.0,
//                         ),
//                       ),
//                       padding: EdgeInsets.only(
//                           top: Get.height * 0.005,
//                           bottom: Get.height * 0.005,
//                           left: Get.width * 0.03,
//                           right: Get.width * 0.03),
//                       margin: EdgeInsets.only(right: Get.height * 0.01),
//                       child: Text(
//                         choices[idx].destName.toString(),
//                         style: TextStyle(
//                           fontFamily: StringConstants.poppinsRegular,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black,
//                           fontSize: Get.height * 0.016,
//                         ),
//                       ),
//                     );*/
//                     return Container(
//                       margin: EdgeInsets.only(right: Get.width * 0.02),
//                       child: Chip(
//                         avatar: Image.network(choices[idx].destImage.toString()),
//                         backgroundColor: Colors.white,
//                         shape: StadiumBorder(side: BorderSide(color: AppColors.grayColorNormal)),
//                         label: Text(
//                           choices[idx].destName.toString(),
//                           style: TextStyle(
//                             fontFamily: StringConstants.poppinsRegular,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                             fontSize: Get.height * 0.018,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getInterestsWidget(String image, List<Userinterest>? choices) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.011, bottom: Get.height * 0.011),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Row(
//         children: [
//           SvgPicture.asset(
//             image,
//             width: Get.width * 0.07,
//             height: Get.width * 0.07,
//           ),
//           SizedBox(
//             width: Get.width * 0.02,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Wrap(
//                 children: List<Widget>.generate(
//                   choices!.length,
//                   (int idx) {
//                     /*return Container(
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         color: AppColors.blueColor.withOpacity(0.08),
//                         borderRadius: BorderRadius.all(Radius.circular(6)),
//                         border: new Border.all(
//                           color: AppColors.blueColor,
//                           width: 1.0,
//                         ),
//                       ),
//                       padding: EdgeInsets.only(
//                           top: Get.height * 0.005,
//                           bottom: Get.height * 0.005,
//                           left: Get.width * 0.03,
//                           right: Get.width * 0.03),
//                       margin: EdgeInsets.only(right: Get.height * 0.01),
//                       child: Text(
//                         choices[idx].interestName.toString(),
//                         style: TextStyle(
//                           fontFamily: StringConstants.poppinsRegular,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black,
//                           fontSize: Get.height * 0.016,
//                         ),
//                       ),
//                     );*/
//                     return Container(
//                       margin: EdgeInsets.only(right: Get.width * 0.02),
//                       child: Chip(
//                         avatar: Image.network(choices[idx].interestImage.toString()),
//                         backgroundColor: Colors.white,
//                         shape: StadiumBorder(side: BorderSide(color: AppColors.grayColorNormal)),
//                         label: Text(
//                           choices[idx].interestName.toString(),
//                           style: TextStyle(
//                             fontFamily: StringConstants.poppinsRegular,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                             fontSize: Get.height * 0.018,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   bool showAboutMe = true;
//   String counterText = '500 ';
//
//   Widget getInputFieldMultipleLine(String name, String image, String text) {
//     return Container(
//       margin: EdgeInsets.only(bottom: Get.height * 0.010),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Container(
//         margin: EdgeInsets.only(left: Get.width * 0.026),
//         child: SizedBox(
//           child: TextField(
//             keyboardType: TextInputType.multiline,
//             inputFormatters: [
//               LengthLimitingTextInputFormatter(500),
//             ],
//             //maxLength: 500,
//             onChanged: (text) {
//               if (text.isEmpty) {
//                 setState(() {
//                   showAboutMe = true;
//                   counterText = '500 ';
//                 });
//               } else {
//                 setState(() {
//                   showAboutMe = false;
//                   RegExp exp = RegExp(r"([\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2694-\u2697]|\uD83E[\uDD10-\uDD5D])");
//                   Iterable<Match> matches = exp.allMatches(text);
//                   int emojiLength = 0;
//                   for (var m in matches) {
//                     emojiLength += m.group(0)!.length;
//                   }
//                   counterText = '${500 - (text.length - emojiLength + matches.length)} ';
//                 });
//               }
//             },
//             maxLines: null,
//             controller: aboutController,
//             textAlign: TextAlign.start,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//             decoration: InputDecoration(
//               counterText: counterText,
//               counterStyle: TextStyle(color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//               hintText: name,
//               prefixIcon: Visibility(
//                 visible: showAboutMe,
//                 child: Padding(
//                   padding: EdgeInsets.only(right: Get.width * 0.006),
//                   child: SvgPicture.asset(image),
//                 ),
//               ),
//               contentPadding: EdgeInsets.only(right: Get.width * 0.01),
//               prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.04, maxHeight: Get.width * 0.04),
//               hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void openImageOptions(int index, BuildContext context, {Function? callBack}) {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
//         margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.020),
//         height: Get.height * 0.4,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
//               width: Get.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       Get.back();
//                       List<Media>? res = await ImagesPicker.openCamera(
//                         pickType: PickType.image,
//                       );
//                       if (res!.isNotEmpty) {
//                         /* setState(() {
//                           userimages![index]=res[0].path;
//                         });*/
//                         // ignore: use_build_context_synchronously
//                         await Navigator.of(context)
//                             .push(MaterialPageRoute(
//                           builder: (context) => CropImage(
//                             path: res[0].path,
//                           ),
//                         ))
//                             .then((value) {
//                           if (value != null) {
//                             setState(() {
//                               userimages![index] = value;
//                             });
//                             if (callBack != null) {
//                               callBack();
//                             }
//                           }
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Camera".tr,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     color: AppColors.dividerColor,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       Get.back();
//                       List<Media>? res = await ImagesPicker.pick(
//                         pickType: PickType.image,
//                       );
//                       if (res == null) {
//                         return;
//                       }
//
//                       if (res.isNotEmpty) {
//                         print("res ----> ${res.length}");
//
//                         final dir = await CommonFunctions().createFolder("gagago");
//
//                         File image = File(res[0].path);
//
// // copy the file to a new path
//                         File file = await image.copy('${dir}/${DateTime.now().millisecondsSinceEpoch}.png');
//
//                         /* setState(() {
//                           userimages![index]=res[0].path;
//                         });*/
//                         // ignore: use_build_context_synchronously
//                         await Navigator.of(context)
//                             .push(MaterialPageRoute(
//                           builder: (context) => CropImage(
//                             path: file.path,
//                           ),
//                         ))
//                             .then((value) {
//                           if (value != null) {
//                             setState(() {
//                               userimages![index] = value;
//                             });
//                             if (callBack != null) {
//                               callBack();
//                             }
//                           }
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Gallery".tr,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.transparent,
//               width: Get.width,
//               height: Get.height * 0.016,
//             ),
//             InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)), color: Colors.white),
//                 width: Get.width,
//                 height: Get.height * 0.070,
//                 child: Center(
//                     child: Text(
//                   "Cancel".tr,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                 )),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getSelectionWidgetEthnicity(String label) {
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.035),
//       width: Get.width * 0.9,
//       margin: EdgeInsets.only(top: Get.height * 0.023),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(
//           color: AppColors.inputFieldBorderColor,
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: Get.height * 0.01),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: ethnicity == '1',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   ethnicity = '1';
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: Get.width * 0.005,
//                           ),
//                           Text(
//                             'White'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: ethnicity == '2',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   ethnicity = '2';
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: Get.width * 0.005,
//                           ),
//                           Text(
//                             'Hispanic or Latino'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: Get.width * 0.06,
//                             height: Get.width * 0.06,
//                             child: Checkbox(
//                               shape: const CircleBorder(), // Rounded Checkbox
//                               checkColor: Colors.white,
//                               value: ethnicity == '3',
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   ethnicity = '3';
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: Get.width * 0.005,
//                           ),
//                           Text(
//                             'Asian'.tr,
//                             style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: Get.height * 0.005),
//                     child: Row(
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: Get.width * 0.06,
//                               height: Get.width * 0.06,
//                               child: Checkbox(
//                                 shape: const CircleBorder(), // Rounded Checkbox
//                                 checkColor: Colors.white,
//                                 value: ethnicity == '4',
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     ethnicity = '4';
//                                   });
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               width: Get.width * 0.005,
//                             ),
//                             Text(
//                               'Black or African'.tr,
//                               style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: Get.width * 0.015),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: Get.width * 0.06,
//                                 height: Get.width * 0.06,
//                                 child: Checkbox(
//                                   shape: const CircleBorder(), // Rounded Checkbox
//                                   checkColor: Colors.white,
//                                   value: ethnicity == '5',
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       ethnicity = '5';
//                                     });
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: Get.width * 0.005,
//                               ),
//                               Text(
//                                 'Multiracial'.tr,
//                                 style: TextStyle(color: Colors.black, fontSize: Get.height * 0.016, fontFamily: 'PoppinsRegular'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }
