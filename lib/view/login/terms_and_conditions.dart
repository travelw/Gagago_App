import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/model/register_model.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' as dio;

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/register_controller.dart';
import '../../model/termsConditionModel.dart';
import '../../utils/progress_bar.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditiondsState();
}

class _TermsAndConditiondsState extends State<TermsAndConditions> {
  bool rememberMe = false;
  RegisterController c = Get.find();
  Position? _currentPosition;
  String currentAddress = "";
  String lat = "";
  String lng = "";
  ScrollController? controller;
  bool acceptVisible = false;
  bool readTerms = false;

  List<TermsCondition> termAndCon = [
    TermsCondition(
        header: "Eligibility".tr,
        title:
            "In order to create an account or use the service, you must: be at least 18 years of age and legally permitted to form a contract with Gagago; be authorized to use the service under the laws of the United States and any other applicable jurisdiction; you have never been convicted of a felony or offense, sex crime, or any crime involving violence.\n\nYou certify under penalty of perjure that the information you use to create an account is true, correct and your own.\n\nYou understand that any content that offends, discriminates or upset any group or individual’s race, ethnicity, national origin, age, religion, gender, identity, sexual orientation, disability, socioeconomic status or expression is not allowed.\n\nYou agree that you will comply with all applicable laws, including your local jurisdiction laws, rules and regulations. You will not add to your profile any travel destination or Hobbies / Interests prohibited by your local authorities. It’s your responsibility to ensure you are authorized and have all required licenses when engaging is certain activities. If you are unsure or have questions about how local laws apply you should seek legal advice.\n\nWe welcome your feedback and strive to provide you with a valuable platform, however, if for any reason you are unsatisfied with the service or cease to agree with our Terms, you must remove your profile from the application. If you fail to remove your profile and try to damage or undermine the application in any way, we will terminate your account and ban you from the service."
                .tr),
    TermsCondition(
        header: "Subscription".tr,
        title:
            'Unless you cancel your subscription, any service you subscribe for an initial term will be automatically renewed for the same duration at the current fee for such subscription. If you use a third party payment such as Apple or iTunes, you must manage your purchases directly with them to avoid additional billing.\n\nWhile we may offer free periods of advanced features such as filters or changing destinations and interests while keeping all previous connections, you will lose these benefits after the free period expires and your profile will be converted to the free user features without further notice.\n\nUsers based in the European Union may cancel with a full refund within 14 days after subscribing. For all other locations, you may cancel your subscription, without penalty or obligation, and request a refund at any time prior to midnight of the third business day following the date you subscribed. Users can exercise their cancellation right by contacting us.'
                .tr),
    TermsCondition(
        header: "Your data, content and information".tr,
        title:
            'With the exception of your account information, you agree that all information you provide to create an account and in the use of the service will be public and shared with other users, prospective users, third parties, partners and advertisers.\n\nYou can hide your sexual orientation from your profile by enabling the feature on the settings screen for free. Note that if you want to see users of all sexual orientations, you must not hide your own sexual orientation from your profile.\n\nYou grant Gagago a non-exclusive, worldwide, perpetual, irrevocable, royalty-free, sublicensable, transferable right and license (including a waiver of any moral rights) to use, host, store, reproduce, modify, create derivative works of, distribute and publish, without limitation, your content, including for commercialization and advertisement purposes in any domain. The license would permit your content to remain in use even after you cease to be a member of the Application.\n\nYou are not authorized to display any personal, banking or other financial information on your profile and you agree to maintain the security and confidentiality of your password and account information. If you share any personal or account information with others, you do it at your own risk. Gagago, its employees, owners and partners will not be liable for any damage, claims or losses related to the information you share.\n\nYour profile content and messages will be randomly moderated and we reserve the right to suspend or terminate your account at our sole discretion. If your account is suspended or terminated, you will not be refunded for any subscription you have already been charged for.\n\nYou can delete your account at anytime by going to the settings screen on your profile and clicking on “Delete Account”.\n\nYou are responsible and liable if any of your content violates or infringes the intellectual property or privacy rights of any third party.\n\nIf you believe that our content violates a copyright, trademark or any other form of intellectual property of a work you own, you must contact us to notify and request takedown of the content. Your request should include a signature, identification of the work claimed with supporting proof, contact information and a statement under penalty of perjury that you believe your work has been infringed and you are legally authorized to allege the infringement.'
                .tr),
    TermsCondition(
        header: "Safety".tr,
        title:
            'Gagago is a platform dedicated to connect people and facilitate social interaction. However, we are not responsible for the conduct of any user and will not be liable for any losses, scam, harm or death that may occur as a result of the application use. You acknowledge that some users, third parties and activities you may engage with through the application carry inherent dangers and you assume the entire risk arising out of your access to and use of the application.\n\nWe encourage you to use caution when sharing personal information as you should do in any other circumstances. You should conduct your own due diligence in all interactions with other users, whether in person or online.\n\nIf you travel with or meet other members in person, you do it at your own risk. You understand that Gagago does not perform any type of background checks on its members and you are the sole responsible for users you decide to interact with. We suggest that you only meet in public, tell your family and friends where you are going, who you are going to meet and don’t share transportation or accommodation until you are sure it’s safe to do so. It’s your responsibility to use caution.\n\nYou understand that Gagago does not inquire on criminal background of its users and makes no representations as to the conduct or suitability of any member. To the maximum extent permitted by applicable law, you agree to release Gagago and its owners, employees and associates from any claims, losses or actions that might arise from your interactions with other users, including damages of any nature, injuries, disability, harm or death.'
                .tr),
    TermsCondition(
        header: "LGBT".tr,
        title:
            'Due to the nature of Gagago application, we want to provide transparency to other users that you may meet and travel with. Sexual orientation is a data point collected during your account creation and publicly shared, unless you enable the hide mode.\n\nYou must comply with your local jurisdiction laws and regulations in order to use the service. In the event you are located in an unsafe jurisdiction for the LGBT community, for example, in territories where there is criminalization of same-sex preferences between adults, we suggest you to hide your sexual orientation from your profile. You can do so by clicking on “Don’t show my sexual orientation” on the settings screen. This feature is free and your information is considered by our algorithms.\n\nTo learn more about sexual orientation laws by country, we recommend you to visit the ILGA World website.'
                .tr),
    TermsCondition(
        header: "Third Parties".tr,
        title:
            'Gagago will display advertisements, promotions and deals offered by third parties. If you decide to contract with these third parties made available to you through our service, your relationship with them will be solely and directly governed by them. Gagago is not responsible or liable for the availability, suitability, quality or your satisfaction with the products and services offered by such parties.'
                .tr),
    TermsCondition(
        header: "Indemnification and Limitation of Liability".tr,
        title:
            'To the maximum extent permitted by law, you agree to release, indemnify and hold Gagago, its owners and personnel, harmless from and against any costs, expenses and liabilities derived from claims and attorney’s fees arising out of or in any way connected with the use of the service or your breach of these Terms.\n\nOur liability in connection with the application is limited to the fees you paid to us in the 12 months preceding the claim or \$100, whichever is greater.'
                .tr),
    TermsCondition(
        header: "Governing law".tr,
        title:
            'This Agreement constitutes a binding legal contract between you and Gagago. Any eventual claims arising from your relationship with us will be governed exclusively by the laws of the State of Texas in the United States.\n\nUsers based in the European Union may have additional or different rights, as provided by applicable law.\n\nYou waive any objection in other forum and jury trial. You will not file or join any class or collective action against us, whether in court or in arbitration.\n\nGagago has no obligation to get involved with any disputes you may have with other users or third parties, although we may try to facilitate a resolution.\n\nIf, for any reason, any portion of these Terms and Conditions is declared invalid by a court of a competent jurisdiction, the remainder of the Agreement will remain in force and in effect. This Agreement will continue to apply even if you stop using the application or delete your account.'
                .tr)
  ];
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    getCurrentLocation();
  }

  void _scrollListener() {
    if (controller!.position.maxScrollExtent == controller!.offset) {
      setState(() {
        acceptVisible = true;
      });
    } else {
      setState(() {
        acceptVisible = false;
      });
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
      debugPrint(e);
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
        backgroundColor: Colors.white,
        // bottomNavigationBar: ,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.width * 0.14,
                  left: Get.width * 0.080,
                  right: Get.width * 0.080),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonBackButton(
                    name: "",
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Text(
                            "Account Suspension".tr,
                            style: TextStyle(
                                fontSize: Get.height * 0.022,
                                fontWeight: FontWeight.w600,
                                color: AppColors.termConditionHeaderColor,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                value: rememberMe,
                                side: const BorderSide(width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      rememberMe = value;
                                    });
                                  }
                                },
                              ),
                              Flexible(
                                child: Text(
                                  "I understand that Gagago is not a dating application and all forms of improper solicitations are prohibited. Any inappropriate behavior reported by 3 users will lead to my account suspension for 30 days and permanent ban if I repeatedly misuse of the service."
                                      .tr,
                                  //  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: Get.height * 0.015,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          StringConstants.poppinsRegular),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Text(
                            "Terms & Conditions".tr,
                            style: TextStyle(
                                fontSize: Get.height * 0.022,
                                fontWeight: FontWeight.w600,
                                color: AppColors.termConditionHeaderColor,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Text(
                            "Welcome to Gagago!\n\nGagago offers a platform that enables users to connect to each other based on common interests, including travel to the same destinations. You must register an account to access and use the service.\n\nThis is a contract between you and Gagago. By creating a Gagago account, you are legally bound by these terms.\n\nWe are continuously working to improve our platform. This means that we may make changes to the service and/or to this Agreement from time to time. You will be notified and required to accept any material changes to the Agreement in order to continue using the service."
                                .tr,
                            style: TextStyle(
                                fontSize: Get.height * 0.015,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: termAndCon.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.010,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${index + 1}. ${termAndCon[index].header}',
                                          style: TextStyle(
                                              fontSize: Get.height * 0.018,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors
                                                  .termConditionHeaderColor,
                                              fontFamily: StringConstants
                                                  .poppinsRegular),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.010,
                                      ),
                                      (termAndCon[index]
                                              .title
                                              .contains('contact us'))
                                          ? RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    fontSize:
                                                        Get.height * 0.015,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .termConditionHeaderColor,
                                                    fontFamily: StringConstants
                                                        .poppinsRegular),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: termAndCon[index]
                                                          .title
                                                          .substring(
                                                              0,
                                                              termAndCon[index]
                                                                  .title
                                                                  .indexOf(
                                                                      'contact us'))),
                                                  TextSpan(
                                                      text: 'contact us',
                                                      style: TextStyle(
                                                          fontSize: Get.height *
                                                              0.015,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .defaultBlack,
                                                          fontFamily:
                                                              StringConstants
                                                                  .poppinsRegular)),
                                                  TextSpan(
                                                      text: termAndCon[index]
                                                          .title
                                                          .substring(
                                                              termAndCon[index]
                                                                      .title
                                                                      .indexOf(
                                                                          'contact us') +
                                                                  'contact us'
                                                                      .length,
                                                              termAndCon[index]
                                                                  .title
                                                                  .length)),
                                                ],
                                              ),
                                            )
                                          : (termAndCon[index]
                                                  .title
                                                  .endsWith('contacting us.'))
                                              ? RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .termConditionHeaderColor,
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: termAndCon[
                                                                  index]
                                                              .title
                                                              .substring(
                                                                  0,
                                                                  termAndCon[
                                                                          index]
                                                                      .title
                                                                      .indexOf(
                                                                          'contacting us.'))),
                                                      TextSpan(
                                                          text:
                                                              'contacting us.',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.height *
                                                                      0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .defaultBlack,
                                                              fontFamily:
                                                                  StringConstants
                                                                      .poppinsRegular)),
                                                    ],
                                                  ),
                                                )
                                              : (termAndCon[index]
                                                      .title
                                                      .contains('ILGA World'))
                                                  ? RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            fontSize:
                                                                Get.height *
                                                                    0.015,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .termConditionHeaderColor,
                                                            fontFamily:
                                                                StringConstants
                                                                    .poppinsRegular),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: termAndCon[
                                                                      index]
                                                                  .title
                                                                  .substring(
                                                                      0,
                                                                      termAndCon[
                                                                              index]
                                                                          .title
                                                                          .indexOf(
                                                                              'ILGA World'))),
                                                          TextSpan(
                                                              text:
                                                                  'ILGA World',
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () async {
                                                                      if (!await launchUrl(
                                                                          Uri.parse(
                                                                              'https://ilga.org/maps-sexual-orientation-laws'))) {
                                                                        throw 'Could not launch url';
                                                                      }
                                                                    },
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Get.height *
                                                                          0.015,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  fontFamily:
                                                                      StringConstants
                                                                          .poppinsRegular)),
                                                          const TextSpan(
                                                              text:
                                                                  ' website.'),
                                                        ],
                                                      ),
                                                    )
                                                  : Text(
                                                      termAndCon[index].title,
                                                      style: TextStyle(
                                                          fontSize: Get.height *
                                                              0.015,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .termConditionHeaderColor,
                                                          fontFamily:
                                                              StringConstants
                                                                  .poppinsRegular),
                                                    ),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Effective date".tr,
                                  style: TextStyle(
                                      fontSize: Get.height * 0.015,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.termConditionHeaderColor,
                                      fontFamily:
                                          StringConstants.poppinsRegular)),
                              TextSpan(
                                  text: "  October 3rd, 2022".tr,
                                  style: TextStyle(
                                      fontSize: Get.height * 0.015,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.termConditionHeaderColor,
                                      fontFamily:
                                          StringConstants.poppinsRegular))
                            ]),
                          ),
                          SizedBox(
                            height: Get.height * 0.010,
                          ),
                          Visibility(
                            visible: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
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
                                    Flexible(
                                      child: Text(
                                          'I have read and agree with the above terms and conditions'
                                              .tr,
                                          style: TextStyle(
                                              fontSize: Get.height * 0.015,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily: StringConstants
                                                  .poppinsRegular)),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Get.height * 0.015,
                                      right: Get.width * 0.080,
                                      left: Get.width * 0.080,
                                      bottom: Get.height * 0.015),
                                  child: InkWell(
                                      onTap: () async {
                                        var isConnect =
                                            await checkConnectivity();
                                        if (isConnect ==
                                            ConnectivityResult.mobile) {
                                          if (rememberMe && readTerms) {
                                            debugPrint(
                                                '${c.genderVisible} Gender');
                                            debugPrint(
                                                '${c.sexualOrientationVisible} Orientation');
                                            dio.FormData form =
                                                dio.FormData.fromMap({
                                              'name': c.name,
                                              'email': c.email,
                                              'password': c.password,
                                              'phone_number': c.phoneNumber,
                                              'country_code': c.countryCode,
                                              'dob': c.dob,
                                              'sexual_orientation':
                                                  c.orientation,
                                              'ethinicity': c.ethnicity,
                                              'trip_style': c.tripStyle,
                                              'travelling_duration':
                                                  c.travelWithIn,
                                              'bio': c.aboutMe,
                                              'referred_by': c.referralCode,
                                              'gender': c.gender,
                                              'lat': lat,
                                              'lng': lng,
                                              'gender_show': c.genderVisible,
                                              'is_show_ethinicity':
                                                  c.ethnicityVisible,
                                              'sexual_orientation_show':
                                                  c.sexualOrientationVisible
                                            });
                                            for (int i = 0;
                                                i < c.interests!.length;
                                                i++) {
                                              form.fields.add(MapEntry(
                                                  'user_interests[$i]',
                                                  c.interests![i].id
                                                      .toString()));
                                            }
                                            for (int i = 0;
                                                i < c.destinations!.length;
                                                i++) {
                                              if (c.destinations![i]
                                                      .selectedCityId !=
                                                  0) {
                                                form.fields.add(MapEntry(
                                                    'destinations[$i]',
                                                    '${c.destinations![i].id},${c.destinations![i].selectedCityId},${c.destinations![i].selectedContinentId}'));
                                              } else {
                                                form.fields.add(MapEntry(
                                                    'destinations[$i]',
                                                    c.destinations![i].id
                                                        .toString()));
                                              }
                                            }
                                            int count = 0;
                                            for (int i = 0;
                                                i < c.images.length;
                                                i++) {
                                              if (c.images[i] != '') {
                                                form.files.add(MapEntry(
                                                  'user_image[$count]',
                                                  await dio.MultipartFile
                                                      .fromFile(c.images[i],
                                                          filename: basename(
                                                              c.images[i])),
                                                ));
                                                count++;
                                              }
                                            }
                                            RegisterModel registerModel =
                                                await CallService()
                                                    .register(form);
                                            if (registerModel.success!) {
                                              CommonDialog.showToastMessage(
                                                  registerModel.message
                                                      .toString());
                                              Get.toNamed(RouteHelper
                                                  .getPasswordResetAndRegisterSuccessfully(
                                                      1));
                                            } else {
                                              CommonDialog.showToastMessage(
                                                  registerModel.message
                                                      .toString());
                                            }
                                          } else {
                                            CommonDialog.showToastMessage(
                                                'Please accept Terms & Conditions'
                                                    .tr);
                                          }
                                        } else if (isConnect ==
                                            ConnectivityResult.wifi) {
                                          if (rememberMe && readTerms) {
                                            dio.FormData form =
                                                dio.FormData.fromMap({
                                              'name': c.name,
                                              'email': c.email,
                                              'password': c.password,
                                              'phone_number': c.phoneNumber,
                                              'country_code': c.countryCode,
                                              'dob': c.dob,
                                              'sexual_orientation':
                                                  c.orientation,
                                              'ethinicity': c.ethnicity,
                                              'trip_style': c.tripStyle,
                                              'travelling_duration':
                                                  c.travelWithIn,
                                              'bio': c.aboutMe,
                                              'referred_by': c.referralCode,
                                              'gender': c.gender,
                                              'lat': lat,
                                              'lng': lng,
                                              'gender_show': c.genderVisible,
                                              'is_show_ethinicity':
                                                  c.ethnicityVisible,
                                              'sexual_orientation_show':
                                                  c.sexualOrientationVisible
                                            });
                                            for (int i = 0;
                                                i < c.interests!.length;
                                                i++) {
                                              form.fields.add(MapEntry(
                                                  'user_interests[$i]',
                                                  c.interests![i].id
                                                      .toString()));
                                            }
                                            for (int i = 0;
                                                i < c.destinations!.length;
                                                i++) {
                                              if (c.destinations![i]
                                                      .selectedCityId !=
                                                  0) {
                                                form.fields.add(MapEntry(
                                                    'destinations[$i]',
                                                    '${c.destinations![i].id},${c.destinations![i].selectedCityId},${c.destinations![i].selectedContinentId}'));
                                              } else {
                                                form.fields.add(MapEntry(
                                                    'destinations[$i]',
                                                    c.destinations![i].id
                                                        .toString()));
                                              }
                                            }
                                            int count = 0;
                                            for (int i = 0;
                                                i < c.images.length;
                                                i++) {
                                              if (c.images[i] != '') {
                                                form.files.add(MapEntry(
                                                  'user_image[$count]',
                                                  await dio.MultipartFile
                                                      .fromFile(c.images[i],
                                                          filename: basename(
                                                              c.images[i])),
                                                ));
                                                count++;
                                              }
                                            }
                                            RegisterModel registerModel =
                                                await CallService()
                                                    .register(form);
                                            if (registerModel.success!) {
                                              CommonDialog.showToastMessage(
                                                  registerModel.message
                                                      .toString());
                                              Get.toNamed(RouteHelper
                                                  .getPasswordResetAndRegisterSuccessfully(
                                                      1));
                                            } else {
                                              CommonDialog.showToastMessage(
                                                  registerModel.message
                                                      .toString());
                                            }
                                          } else {
                                            CommonDialog.showToastMessage(
                                                'Please accept Terms & Conditions'
                                                    .tr);
                                          }
                                        } else {
                                          CommonDialog.showToastMessage(
                                              "No Internet Available!!!!!".tr);
                                        }
                                      },
                                      child: CustomButtonLogin(
                                        buttonName: "Agree & Join".tr,
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.010),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}termsAndConTop.svg",
                  height: Get.height * 0.12,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.010),
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}globetd.svg",
                  height: Get.height * 0.12,
                ),
              ),
            ),
          ],
        ));
  }

  /* showDailogTerms(BuildContext context) async {
    setState(() {});
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Alert',
                    style: TextStyle(
                        fontSize: Get.height * 0.022,
                        fontWeight: FontWeight.w600,
                        fontFamily: StringConstants.poppinsRegular,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Text(
                    "If Minimum 3 Gagago Users will Block You. then your Account will be suspended for 30 days.",
                    style: TextStyle(
                        fontSize: Get.height * 0.020,
                        fontWeight: FontWeight.w500,
                        fontFamily: StringConstants.poppinsRegular,
                        color: AppColors.popupSmallTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                  InkWell(
                      onTap: () async {

                      },
                      child: CustomButtonLogin(buttonName: "Continue",)),
                  SizedBox(height: Get.height*0.010,),
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Text("No Thanks",
                      style: TextStyle(
                          fontSize: Get.height * 0.020,
                          fontWeight: FontWeight.w600,
                          fontFamily: StringConstants.poppinsRegular,
                          color: AppColors.desColor),),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }*/

}
