import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/destination_model.dart';
import 'package:gagagonew/utils/internet_connection_checker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/web_view_class.dart';
import '../../Service/call_service.dart';
import '../../controller/register_controller.dart';
import '../../model/subscription_Response_Model.dart';
import '../../utils/app_network_image.dart';
import '../../utils/progress_bar.dart';

class ListModel {
  String country;
  List<StateListModel> statesList;

  //String state;

  ListModel({required this.country, required this.statesList});
}

class StateListModel {
  String image;
  String states;

  StateListModel({required this.image, required this.states});
}

class DestinationsScreen extends StatefulWidget {
  String? subscribe;
  DestinationsScreen({Key? key, this.subscribe}) : super(key: key);

  @override
  State<DestinationsScreen> createState() => _DestinationsState();
}

class _DestinationsState extends State<DestinationsScreen> {
  List<Data> countryList = [];
  List<Countries>? selectedDestinations = [];
  RegisterController c = Get.find();
  String? planPrice = "", planDuration = "";
  List<Message>? planList = [];
  SharedPreferences? prefs;
  int? isSubscribe;
  int? planId;
  int? userId;

  @override
  void initState() {
    debugPrint("destination page ");
    init();
    super.initState();
  }

  int? selectedIndex;

  showSubscriptionDialog(BuildContext context) async {
    setState(() {});
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Premium'.tr,
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
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections"
                        .tr,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: Get.width * 0.030,
                        children: List<Widget>.generate(planList!.length,
                            (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                planId = planList![index].id;
                                prefs!.setString('planId', planId!.toString());
                                debugPrint("GagagoPlanId $planId");
                              });
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 5,
                                      color: (index == selectedIndex)
                                          ? Colors.blue
                                          : Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color:
                                      AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    planList![index].planDuration!,
                                    style: TextStyle(
                                        fontSize: Get.height * 0.025,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    int.parse(planList![index].planDuration!) >
                                            1
                                        ? 'months'.tr
                                        : "month".tr,
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '\$${planList![index].planPrice!}',
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        color: AppColors.desColor),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  InkWell(
                      onTap: () async {
                        /*    _launchUrl(CallService().payPalUrl + userId.toString() + "/" + planId.toString());
                        debugPrint("planId $planId");*/
                        var isConnect = await checkConnectivity();
                        if (isConnect == ConnectivityResult.mobile) {
                          await Get.to(CommonWebView(userId.toString(), planId!));
                          setState(() {
                            isSubscribe = 1;
                          });
                        } else if (isConnect == ConnectivityResult.wifi) {
                          await Get.to(CommonWebView(userId.toString(), planId!));
                          setState(() {
                            isSubscribe = 1;
                          });
                        } else {
                          CommonDialog.showToastMessage(
                              "No Internet Available!!!!!");
                        }

                        //debugPrint("Print Url ${launchUrl(CallService().payPalUrl + '/' + userId.toString() + "/" + planId.toString()}");
                        //Get.back();
                      },
                      child: CustomButtonLogin(
                        buttonName: "Continue",
                      )),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "No Thanks".tr,
                      style: TextStyle(
                          fontSize: Get.height * 0.020,
                          fontWeight: FontWeight.w600,
                          fontFamily: StringConstants.poppinsRegular,
                          color: AppColors.desColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  init() async {
    if (widget.subscribe == 'Register') {
      isSubscribe = 2;
    } else {
      prefs = await SharedPreferences.getInstance();
      userId = int.parse(prefs!.getString('userId').toString());
      isSubscribe = int.parse(widget.subscribe.toString());
    }
    selectedDestinations = c.destinations;
    var isConnect = await checkConnectivity();
    if (isConnect == ConnectivityResult.mobile) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        DestinationModel model = await CallService().getDestinations();
        setState(() {
          countryList = model.data!;
        });
      });
    } else if (isConnect == ConnectivityResult.wifi) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        DestinationModel model = await CallService().getDestinations();
        setState(() {
          countryList = model.data!;
        });
      });
    } else {
      CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
    }

    // For Subscription
    if (isSubscribe != 2) {
      var isConnect = await checkConnectivity();
      if (isConnect == ConnectivityResult.mobile) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          SubscriptionResponseModel model =
              await CallService().getSubscriptionList(isShowLoader: false);
          setState(() {
            planList = model.message;
            planPrice = planList![0].planPrice;
            planDuration = planList![0].planDuration;
          });
        });
      } else if (isConnect == ConnectivityResult.wifi) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          SubscriptionResponseModel model =
              await CallService().getSubscriptionList(isShowLoader: false);
          setState(() {
            planList = model.message;
            planPrice = planList![0].planPrice;
            planDuration = planList![0].planDuration;
          });
        });
      } else {
        //CommonDialog.showToastMessage("No Internet Available!!!!!");
      }
    }
  }

  @override
  void dispose() {
    c.destinations = selectedDestinations;
    super.dispose();
  }

  Widget getMeetDestinationWidget(List<String> choices) {
    return Wrap(
      children: List<Widget>.generate(
        choices.length,
        (int idx) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.blueColor.withOpacity(0.08),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                color: AppColors.blueColor,
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.only(
                top: Get.height * 0.005,
                bottom: Get.height * 0.005,
                left: Get.width * 0.03,
                right: Get.width * 0.03),
            margin: EdgeInsets.only(right: Get.height * 0.01),
            child: Text(
              choices[idx],
              style: TextStyle(
                fontFamily: StringConstants.poppinsRegular,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: Get.height * 0.016,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
              top: Get.width * 0.14,
              left: Get.width * 0.060,
              right: Get.width * 0.060,
              bottom: Get.height * 0.020),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonBackButton(
                  name: 'Destinations'.tr,
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                _selectedDestination(),
                _allDestinations()
              ],
            ),
          ),
        ));
  }

  Widget _selectedDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Get.width * 0.035),
          width: Get.width * 0.9,
          margin: EdgeInsets.only(
              top: Get.height * 0.011, bottom: Get.height * 0.011),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: AppColors.inputFieldBorderColor,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/svg/location.svg',
                width: Get.width * 0.07,
                height: Get.width * 0.07,
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              selectedDestinations!.isEmpty
                  ? Flexible(
                      child: Text('Where do you want to go?'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.height * 0.016,
                              fontFamily: 'PoppinsRegular')),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: List<Widget>.generate(
                            selectedDestinations!.length,
                            (int idx) {
                              return Stack(
                                children: [
                                  InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: Get.width * 0.02),
                                      child: Chip(
                                        // avatar: AppNetworkImage(
                                        //   imageUrl: selectedDestinations![idx]
                                        //       .countryImage
                                        //       .toString(),
                                        //   height: Get.width ,
                                        //   width: Get.width ,
                                        //   boxFit: BoxFit.contain,
                                        // ),
                                        avatar: Image.network(
                                            selectedDestinations![idx]
                                                .countryImage
                                                .toString()),
                                        backgroundColor: /*countryList[index]
                                                      .countries![idx]
                                                      .selected
                                                  ? AppColors.blueColor
                                                      .withOpacity(0.08)
                                                  : */
                                            Colors.white,
                                        shape: const StadiumBorder(
                                            side: BorderSide(
                                                color:
                                                    AppColors.grayColorNormal)),
                                        label: Text(
                                          selectedDestinations![idx]
                                              .countryName
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily:
                                                StringConstants.poppinsRegular,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: Get.height * 0.018,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (isSubscribe == 2) {
                                        setState(() {
                                          selectedDestinations!.removeAt(idx);
                                        });
                                      } else {
                                        if (selectedDestinations![idx].destId ==
                                            0) {
                                          setState(() {
                                            selectedDestinations!.removeAt(idx);
                                          });
                                        } else {
                                          var map = <String, dynamic>{};
                                          map['id'] =
                                              selectedDestinations![idx].id;
                                          // DeleteImageModel login = await CallService().deleteDestination(map);
                                          // if (login.success == true) {
                                          setState(() {
                                            selectedDestinations!.removeAt(idx);
                                          });
                                          // } else {
                                          //   CommonDialog.showToastMessage(login.message.toString());
                                          // }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Visibility(
          visible: selectedDestinations!.length <= 4,
          child: Text(
              selectedDestinations!.length < 4
                  ? 'Choose 4 destinations'.tr
                  : 'You have chosen all 4 destinations. Remove any to change.'
                      .tr,
              style: TextStyle(
                  color: AppColors.grayColorNormal,
                  fontSize: Get.height * 0.018,
                  fontFamily: 'PoppinsRegular')),
        ),
      ],
    );
  }

  Widget _allDestinations() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        margin: EdgeInsets.only(
            top: Get.height * 0.012, bottom: Get.height * 0.012),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildDestinationItem(context, index);
            },
            itemCount: countryList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationItem(context, index) {
    return Container(
      margin:
          EdgeInsets.only(top: Get.height * 0.03, bottom: Get.height * 0.030),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                countryList[index].regionName.toString(),
                style: TextStyle(
                  fontFamily: StringConstants.poppinsRegular,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: Get.height * 0.025,
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.005),
          Wrap(
            children: List<Widget>.generate(
              countryList[index].countries!.length,
              (int idx) {
                return GestureDetector(
                  onTap: () async {
                    print("under 1");
                    int indexWhere = selectedDestinations!.indexWhere(
                        (element) =>
                            element.slug ==
                            countryList[index].countries![idx].slug);
                    if (indexWhere >= 0) {
                      return;
                    }

                    if (countryList[index].countries![idx].cities!.isNotEmpty) {
                      if (selectedDestinations!.length < 4) {
                        Get.bottomSheet(StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.transparent),
                            child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    color: Colors.white),
                                width: Get.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: countryList[index]
                                        .countries![idx]
                                        .cities!
                                        .length,
                                    itemBuilder: (context, ind) {
                                      return InkWell(
                                        onTap: () {
                                          print(
                                              "countryList[index].countries![idx].selected ${countryList[index].countries![idx].selected}");

                                          if (countryList[index]
                                              .countries![idx]
                                              .selected) {
                                          } else {
                                            if (selectedDestinations!.length <
                                                4) {
                                              int slugIndex =
                                                  selectedDestinations!
                                                      .indexWhere((element) {
                                                print(
                                                    "${element.slug} == ${countryList[index].countries![idx].cities![ind].slug}");

                                                return element.slug ==
                                                    countryList[index]
                                                        .countries![idx]
                                                        .cities![ind]
                                                        .slug;
                                              });
                                              print("slugIndex--> $slugIndex");
                                              if (slugIndex >= 0) {
                                                return;
                                              }
                                              setState(() {
                                                countryList[index]
                                                    .countries![idx]
                                                    .selectedCityIndex = ind;
                                              });
                                              Countries selectedCountry = Countries(
                                                  id: countryList[index]
                                                      .countries![idx]
                                                      .id,
                                                  destId: countryList[index]
                                                      .countries![idx]
                                                      .destId,
                                                  selectedCityIndex: ind,
                                                  selected: true,
                                                  selectedCityId: countryList[
                                                          index]
                                                      .countries![idx]
                                                      .cities![countryList[index]
                                                          .countries![idx]
                                                          .selectedCityIndex]
                                                      .id!,
                                                  countryName: countryList[index]
                                                      .countries![idx]
                                                      .cities![countryList[index]
                                                          .countries![idx]
                                                          .selectedCityIndex]
                                                      .cityName,
                                                  slug: countryList[index]
                                                      .countries![idx]
                                                      .cities![countryList[
                                                              index]
                                                          .countries![idx]
                                                          .selectedCityIndex]
                                                      .slug,
                                                  selectedContinentId:
                                                      countryList[index].id!,
                                                  countryImage:
                                                      countryList[index]
                                                          .countries![idx]
                                                          .countryImage);
                                              this.setState(() {
                                                /*countryList[index]
                                                                          .countries![idx]
                                                                          .selected = true;
                                                                      countryList[index]
                                                                          .countries![idx]
                                                                          .selectedCityId=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].id!;
                                                                      countryList[index]
                                                                          .countries![idx].countryName=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].cityName;
                                                                      countryList[index]
                                                                          .countries![idx]
                                                                          .selectedContinentId=countryList[index].id!;
                                                                      selectedDestinations?.add(
                                                                          countryList[index]
                                                                              .countries![idx]);*/
                                                selectedDestinations
                                                    ?.add(selectedCountry);
                                              });
                                            }
                                          }
                                          Get.back();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Get.height * 0.020,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Get.width * 0.08,
                                                  right: Get.width * 0.08,
                                                  top: Get.height * 0.01,
                                                  bottom: Get.height * 0.01),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    countryList[index]
                                                        .countries![idx]
                                                        .cities![ind]
                                                        .cityName
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            StringConstants
                                                                .poppinsRegular,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Get.height * 0.020,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.06,
                                                    height: Get.width * 0.06,
                                                    child: Checkbox(
                                                      shape:
                                                          const CircleBorder(), // Rounded Checkbox
                                                      checkColor: Colors.white,
                                                      value: countryList[index]
                                                              .countries![idx]
                                                              .selectedCityIndex ==
                                                          ind,
                                                      onChanged: (bool? value) {
                                                        int
                                                            indexWhere =
                                                            selectedDestinations!
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .slug ==
                                                                    countryList[
                                                                            index]
                                                                        .countries![
                                                                            idx]
                                                                        .cities![
                                                                            ind]
                                                                        .slug);
                                                        if (indexWhere >= 0) {
                                                          Get.back();

                                                          return;
                                                        }
                                                        if (countryList[index]
                                                            .countries![idx]
                                                            .selected) {
                                                          /*setState(() {
                                                                                  countryList[index].countries![idx].selectedCityIndex=-1;
                                                                                });
                                                                                this.setState(() {
                                                                                  countryList[index]
                                                                                      .countries![idx]
                                                                                      .selected = false;
                                                                                  countryList[index]
                                                                                      .countries![idx]
                                                                                      .selectedCityId=0;
                                                                                  countryList[index]
                                                                                      .countries![idx]
                                                                                      .selectedContinentId=0;
                                                                                  selectedDestinations?.remove(
                                                                                      countryList[index]
                                                                                          .countries![idx]);
                                                                                });*/
                                                        } else {
                                                          if (selectedDestinations!
                                                                  .length <
                                                              4) {
                                                            /* for(int i=0;i<selectedDestinations!.length;i++){
                                                                                    if(selectedDestinations![i].destId==countryList[index].countries![idx].cities![ind].id!){
                                                                                      CommonDialog.showToastMessage('City Already Selected');
                                                                                      return;
                                                                                    }
                                                                                  }*/
                                                            int slugIndex =
                                                                selectedDestinations!
                                                                    .indexWhere(
                                                                        (element) {
                                                              print(
                                                                  "${element.slug} == ${countryList[index].countries![idx].slug}");
                                                              return element
                                                                      .slug ==
                                                                  countryList[
                                                                          index]
                                                                      .countries![
                                                                          idx]
                                                                      .slug;
                                                            });
                                                            print(
                                                                "slugIndex--> 11 $slugIndex");
                                                            if (slugIndex >=
                                                                0) {
                                                              return;
                                                            }

                                                            setState(() {
                                                              countryList[index]
                                                                  .countries![
                                                                      idx]
                                                                  .selectedCityIndex = ind;
                                                            });
                                                            Countries selectedCountry = Countries(
                                                                id: countryList[index]
                                                                    .countries![
                                                                        idx]
                                                                    .id,
                                                                destId: countryList[index]
                                                                    .countries![
                                                                        idx]
                                                                    .destId,
                                                                selectedCityIndex:
                                                                    ind,
                                                                selected: true,
                                                                selectedCityId: countryList[index]
                                                                    .countries![
                                                                        idx]
                                                                    .cities![countryList[index]
                                                                        .countries![
                                                                            idx]
                                                                        .selectedCityIndex]
                                                                    .id!,
                                                                countryName: countryList[index]
                                                                    .countries![
                                                                        idx]
                                                                    .cities![countryList[index]
                                                                        .countries![
                                                                            idx]
                                                                        .selectedCityIndex]
                                                                    .cityName,
                                                                slug: countryList[index]
                                                                    .countries![
                                                                        idx]
                                                                    .cities![countryList[index]
                                                                        .countries![
                                                                            idx]
                                                                        .selectedCityIndex]
                                                                    .slug,
                                                                selectedContinentId:
                                                                    countryList[index].id!,
                                                                countryImage: countryList[index].countries![idx].countryImage);
                                                            this.setState(() {
                                                              /*countryList[index]
                                                                        .countries![idx]
                                                                        .selected = true;
                                                                    countryList[index]
                                                                        .countries![idx]
                                                                        .selectedCityId=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].id!;
                                                                    countryList[index]
                                                                        .countries![idx].countryName=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].cityName;
                                                                    countryList[index]
                                                                        .countries![idx]
                                                                        .selectedContinentId=countryList[index].id!;
                                                                    selectedDestinations?.add(
                                                                        countryList[index]
                                                                            .countries![idx]);*/
                                                              selectedDestinations
                                                                  ?.add(
                                                                      selectedCountry);
                                                            });
                                                          }
                                                        }
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              color: AppColors.dividerColor,
                                            ),
                                          ],
                                        ),
                                      );
                                    })),
                          );
                        }));
                      } else {
                        /*if(isSubscribe == 0){
                                                showSubscriptionDialog(context);
                                              }else{

                                              }*/
                        bool? canVibrate = await Vibration.hasVibrator();
                        if (canVibrate!) {
                          Vibration.vibrate(duration: 300);
                        }
                      }
                    } else {
                      if (countryList[index].countries![idx].selected) {
                        setState(() {
                          countryList[index].countries![idx].selected = false;
                          selectedDestinations
                              ?.remove(countryList[index].countries![idx]);
                        });
                      } else {
                        if (selectedDestinations!.length < 4) {
                          setState(() {
                            countryList[index].countries![idx].selected = true;
                            selectedDestinations
                                ?.add(countryList[index].countries![idx]);
                          });
                        } else {
                          /*if(isSubscribe == 0){
                                                  showSubscriptionDialog(context);
                                                }else{

                                                }*/
                          bool? canVibrate = await Vibration.hasVibrator();
                          if (canVibrate!) {
                            Vibration.vibrate(duration: 300);
                          }
                        }
                      }
                    }
                    /**/
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Get.width * 0.02),
                    child: Chip(
                      avatar:
                          // AppNetworkImage(
                          //   imageUrl: countryList[index]
                          //       .countries![idx]
                          //       .countryImage
                          //       .toString(),
                          //   height: Get.width * 0.02,
                          //   width: Get.width * 0.02,
                          //   boxFit: BoxFit.contain,
                          // ),

                          Image.network(countryList[index]
                              .countries![idx]
                              .countryImage
                              .toString()),
                      backgroundColor: /*countryList[index]
                                                    .countries![idx]
                                                    .selected
                                                ? AppColors.blueColor
                                                    .withOpacity(0.08)
                                                : */
                          Colors.white,
                      shape: const StadiumBorder(
                          side: BorderSide(color: AppColors.grayColorNormal)),
                      label: Text(
                        countryList[index]
                            .countries![idx]
                            .countryName
                            .toString(),
                        style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: Get.height * 0.018,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }

/*Widget _buildPlayerModelList(List<Data> items, int index) {
    return Padding(
      padding:  EdgeInsets.only(right: Get.width*0.045),
      child: Container(
        margin: EdgeInsets.only(top: Get.height*0.005),
        child: */ /*GridView.builder(
          itemCount: items[index].cities?.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:(Get.width/Get.height)*5,crossAxisCount: 3,crossAxisSpacing: Get.width*0.02,mainAxisSpacing: Get.width*0.02),
          itemBuilder: (BuildContext context, int i) {
            return Container(
              padding: EdgeInsets.only(top: Get.height*0.008,bottom:Get.height*0.008 ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.boder),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(100.0))),
              child:Flexible(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(right:Get.width*0.015),
                        child: Text(
                            items[index].cities![i].cityName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: Get.height*0.014,
                                overflow: TextOverflow.visible,
                                fontFamily: StringConstants.poppinsRegular),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
              */ /**/ /*Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left:Get.width*0.025,right: Get.width*0.015),
                    child: Image.network(
                      items[index].cities![i].cityImage.toString(),
                      //semanticsLabel:items[index].cities![i].cityName.toString() ,
                      width: Get.width*0.035,
                      height:Get.width*0.035 ,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(right:Get.width*0.015),
                      child: Text(
                          items[index].cities![i].cityName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: Get.height*0.014,
                              overflow: TextOverflow.visible,
                              fontFamily: StringConstants.poppinsRegular),textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              )*/ /**/ /*
            );
          },
        ),*/ /*

      ),
    );
  }*/

}

/*
Widget countryNameList(List<Cities>? cities, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      for(int i=0;i<3;i++)
      Container(
        padding: EdgeInsets.only(top: Get.height*0.015,bottom:Get.height*0.015 ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.boder),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(100.0))),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left:Get.width*0.025,right: Get.width*0.025),
              child: SvgPicture.asset(
                item.statesList[index].image,
                width: Get.width*0.035,
                height:Get.width*0.035 ,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right:Get.width*0.025),
              child: Text(
                  item.statesList[index].states,
                  style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: Get.height*0.016,
                  fontFamily: StringConstants.poppinsRegular)),
            ),
          ],
        ),
      ),
    ],
  );
}
*/
