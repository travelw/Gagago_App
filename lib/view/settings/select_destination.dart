import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/delete_image_model.dart';
import 'package:gagagonew/model/destination_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../CommonWidgets/web_view_class.dart';
import '../../Service/call_service.dart';
import '../../controller/register_controller.dart';
import '../../model/subscription_Response_Model.dart';
import '../../utils/progress_bar.dart';

class ListModel {
  String Country;
  List<StateListModel> statesList;

  //String state;

  ListModel({required this.Country, required this.statesList});
}

class StateListModel {
  String image;
  String states;

  StateListModel({required this.image, required this.states});
}

class SelectDestination extends StatefulWidget {
  String? subscribe;
  SelectDestination({Key? key,this.subscribe}) : super(key: key);

  @override
  State<SelectDestination> createState() => _DestinationsState();
}

class _DestinationsState extends State<SelectDestination> {
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
                    'Premium',
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
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections",
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
                        spacing: Get.width*0.030,
                        children: List<Widget>.generate(planList!.length, (int index) {
                          return InkWell(
                            onTap: (){
                              setState(() {
                                selectedIndex=index;
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
                                  border: Border.all(width: 5,color: (index==selectedIndex)? Colors.blue:Colors.white),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    planList![index].planDuration!,
                                    style: TextStyle(
                                        fontSize: Get.height * 0.025,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "month",
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: StringConstants.poppinsRegular,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '\$${planList![index].planPrice!}',
                                    style: TextStyle(
                                        fontSize: Get.height * 0.014,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: StringConstants.poppinsRegular,
                                        color: AppColors.desColor),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        ),
                      ) ],
                  ),
                  SizedBox(height: Get.height*0.010,),

                  InkWell(
                      onTap: () async {
                        /*    _launchUrl(CallService().payPalUrl + userId.toString() + "/" + planId.toString());
                        debugPrint("planId $planId");*/
                        await Get.to(CommonWebView(userId.toString(),planId!));
                        setState(() {
                          isSubscribe=1;
                        });
                        //debugPrint("Print Url ${launchUrl(CallService().payPalUrl + '/' + userId.toString() + "/" + planId.toString()}");
                        //Get.back();
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
  }



  init() async {
    if(widget.subscribe=='Register'){
      isSubscribe=2;
    }else{
      prefs = await SharedPreferences.getInstance();
      userId = int.parse(prefs!.getString('userId').toString());
      isSubscribe=int.parse(widget.subscribe.toString());
    }
    selectedDestinations=c.destinations;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DestinationModel model = await CallService().getDestinations();
      setState(() {
        countryList = model.data!;
      });
    });
    // For Subscription
    if(isSubscribe!=2){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        SubscriptionResponseModel model = await CallService().getSubscriptionList();
        setState(() {
          planList = model.message;
          planPrice = planList![0].planPrice;
          planDuration = planList![0].planDuration;
        });
      });
    }
  }
  @override
  void dispose() {
    c.destinations=selectedDestinations;
    super.dispose();
  }

  Widget getMeetDestinationWidget(List<String> choices) {
    return Wrap(
      children: List<Widget>.generate(
        choices.length,
        (int idx) {
          return Container(
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.blueColor.withOpacity(0.08),
              borderRadius:const BorderRadius.all(Radius.circular(6)),
              border:  Border.all(
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
              top: Get.height * 0.080,
              left: Get.width * 0.060,
              right: Get.width * 0.060,
              bottom: Get.height * 0.020),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonBackButton(
                  name: 'Destinations',
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Container(
                  padding: EdgeInsets.all(Get.width * 0.035),
                  width: Get.width * 0.9,
                  margin: EdgeInsets.only(
                      top: Get.height * 0.011, bottom: Get.height * 0.011),
                  decoration:  BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:const BorderRadius.all(Radius.circular(10)),
                    border:  Border.all(
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
                          ? Text('Select your meet now city',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Get.height * 0.016,
                                  fontFamily: 'PoppinsRegular'))
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
                                                avatar: Image.network(selectedDestinations![idx]
                                                    .countryImage
                                                    .toString()),
                                                backgroundColor: /*countryList[index]
                                                      .countries![idx]
                                                      .selected
                                                  ? AppColors.blueColor
                                                      .withOpacity(0.08)
                                                  : */Colors.white,
                                                shape: const StadiumBorder(
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .grayColorNormal)),
                                                label: Text(
                                                  selectedDestinations![idx]
                                                      .countryName
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: StringConstants
                                                        .poppinsRegular,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: Get.height * 0.018,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              if(isSubscribe==2){
                                                setState(() {
                                                  selectedDestinations!.removeAt(idx);
                                                });
                                              }else{
                                                if(selectedDestinations![idx].destId==0){
                                                  setState(() {
                                                    selectedDestinations!.removeAt(idx);
                                                  });
                                                }else{
                                                  var map =  <String, dynamic>{};
                                                  map['id'] = selectedDestinations![idx].id;
                                                  DeleteImageModel login= await CallService().deleteDestination(map);
                                                  if(login.success == true){
                                                    setState(() {
                                                      selectedDestinations!.removeAt(idx);
                                                    });
                                                  }
                                                  else{
                                                    CommonDialog.showToastMessage(login.message.toString());
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                          /*Container(
                                            decoration:  BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color:
                                                  AppColors.blueColor.withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(6)),
                                              border:  Border.all(
                                                color: AppColors.blueColor,
                                                width: 1.0,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: Get.height * 0.012,
                                                bottom: Get.height * 0.005,
                                                left: Get.width * 0.03,
                                                right: Get.width * 0.03),
                                            margin: EdgeInsets.only(
                                                right: Get.height * 0.030,top: Get.height*0.01),
                                            child: Text(
                                              selectedDestinations![idx]
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
                                          ),*/
                                          /*Positioned(
                                            child: IconButton(onPressed: () async {

                                      }, icon: Icon(Icons.cancel_outlined)),
                                            right: -Get.width*0.020,
                                            bottom: Get.height*0.020,
                                          )*/
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
                MediaQuery.removePadding(
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
                          return Container(
                            margin: EdgeInsets.only(top: Get.height * 0.03,bottom:Get.height * 0.030),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      countryList[index].regionName.toString(),
                                      style: TextStyle(
                                        fontFamily:
                                            StringConstants.poppinsRegular,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: Get.height * 0.025,
                                      ),
                                    ),
                                    /*Container(
                                      child: Image.network(
                                        countryList[index]
                                            .countryImage
                                            .toString(),
                                        width: Get.width * 0.050,
                                        height: Get.width * 0.050,
                                      ),
                                      margin: EdgeInsets.only(
                                          left: Get.width * 0.02),
                                    )*/
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.005),
                                Wrap(
                                  children: List<Widget>.generate(
                                    countryList[index].countries!.length,
                                    (int idx) {
                                      return GestureDetector(
                                        onTap: () {
                                          if(countryList[index].countries![idx].cities!.isNotEmpty){
                                            if(selectedDestinations!.length<1){
                                              Get.bottomSheet(
                                                  StatefulBuilder(builder: (context, StateSetter setState) {
                                                    return Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                          color: Colors.transparent),
                                                      child: Container(
                                                          decoration:const  BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20) ),
                                                              color: Colors.white),
                                                          width: Get.width,
                                                          child: ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount:countryList[index].countries![idx].cities!.length,itemBuilder: (context,ind){
                                                            return InkWell(
                                                              onTap: (){
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
                                                                  if (selectedDestinations!.length <
                                                                      1) {
                                                                    setState(() {
                                                                      countryList[index].countries![idx].selectedCityIndex=ind;
                                                                    });
                                                                    this.setState(() {
                                                                      countryList[index]
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
                                                                              .countries![idx]);
                                                                    });
                                                                  }
                                                                }
                                                                Get.back();
                                                                Get.back();
                                                              },
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: Get.height * 0.020,
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: Get.width*0.08,right:Get.width*0.08,top: Get.height*0.01,bottom:Get.height*0.01),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          countryList[index].countries![idx].cities![ind].cityName.toString(),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                              StringConstants.poppinsRegular,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: Get.height * 0.020,
                                                                              color: Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                          width: Get.width*0.06,
                                                                          height: Get.width*0.06,
                                                                          child: Checkbox(
                                                                            shape: const CircleBorder(), // Rounded Checkbox
                                                                            checkColor: Colors.white,
                                                                            value: countryList[index].countries![idx].selectedCityIndex==ind,
                                                                            onChanged: (bool? value) {
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
                                                                                if (selectedDestinations!.length <
                                                                                    1) {
                                                                                  setState(() {
                                                                                    countryList[index].countries![idx].selectedCityIndex=ind;
                                                                                  });
                                                                                  this.setState(() {
                                                                                    countryList[index]
                                                                                        .countries![idx]
                                                                                        .selected = true;
                                                                                    countryList[index]
                                                                                        .countries![idx]
                                                                                        .selectedCityId=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex=ind].id!;
                                                                                    countryList[index]
                                                                                        .countries![idx].countryName=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].cityName;
                                                                                    countryList[index]
                                                                                        .countries![idx]
                                                                                        .selectedContinentId=countryList[index].id!;
                                                                                    selectedDestinations?.add(
                                                                                        countryList[index]
                                                                                            .countries![idx]);
                                                                                  });
                                                                                }
                                                                              }
                                                                              Get.back();
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
                                                          })
                                                      ),
                                                    );})
                                              );
                                            }else{
                                              if(isSubscribe == 0){
                                                showSubscriptionDialog(context);
                                              }else{
                                                /*if(isSubscribe!=2){
                                                  Get.bottomSheet(
                                                      StatefulBuilder(builder: (context, StateSetter setState) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                                              color: Colors.transparent),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20) ),
                                                                  color: Colors.white),
                                                              width: Get.width,
                                                              child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  itemCount:countryList[index].countries![idx].cities!.length,itemBuilder: (context,ind){
                                                                return InkWell(
                                                                  onTap: (){
                                                                    if (countryList[index]
                                                                        .countries![idx]
                                                                        .selected) {
                                                                     *//* setState(() {
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
                                                                      });*//*
                                                                    } else {
                                                                        setState(() {
                                                                          countryList[index].countries![idx].selectedCityIndex=ind;
                                                                        });
                                                                        this.setState(() {
                                                                          countryList[index]
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
                                                                                  .countries![idx]);
                                                                        });
                                                                    }
                                                                    Get.back();
                                                                  },
                                                                  child: Container(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height: Get.height * 0.020,
                                                                        ),
                                                                        Container(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                countryList[index].countries![idx].cities![ind].cityName.toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    fontFamily:
                                                                                    StringConstants.poppinsRegular,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: Get.height * 0.020,
                                                                                    color: Colors.black),
                                                                              ),
                                                                              SizedBox(
                                                                                child: Checkbox(
                                                                                  shape: CircleBorder(), // Rounded Checkbox
                                                                                  checkColor: Colors.white,
                                                                                  value: countryList[index].countries![idx].selectedCityIndex==ind,
                                                                                  onChanged: (bool? value) {
                                                                                    if (countryList[index]
                                                                                        .countries![idx]
                                                                                        .selected) {
                                                                                      setState(() {
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
                                                                                      });
                                                                                    } else {
                                                                                      if (selectedDestinations!.length <
                                                                                          4) {
                                                                                        setState(() {
                                                                                          countryList[index].countries![idx].selectedCityIndex=ind;
                                                                                        });
                                                                                        this.setState(() {
                                                                                          countryList[index]
                                                                                              .countries![idx]
                                                                                              .selected = true;
                                                                                          countryList[index]
                                                                                              .countries![idx]
                                                                                              .selectedCityId=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex=ind].id!;
                                                                                          countryList[index]
                                                                                              .countries![idx].countryName=countryList[index].countries![idx].cities![countryList[index].countries![idx].selectedCityIndex].cityName;
                                                                                          countryList[index]
                                                                                              .countries![idx]
                                                                                              .selectedContinentId=countryList[index].id!;
                                                                                          selectedDestinations?.add(
                                                                                              countryList[index]
                                                                                                  .countries![idx]);
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                                width: Get.width*0.06,
                                                                                height: Get.width*0.06,
                                                                              ),
                                                                            ],
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          ),
                                                                          margin: EdgeInsets.only(left: Get.width*0.08,right:Get.width*0.08,top: Get.height*0.01,bottom:Get.height*0.01),
                                                                        ),
                                                                        Divider(
                                                                          color: AppColors.dividerColor,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                          ),
                                                        );})
                                                  );
                                                }*/
                                              }
                                            }
                                          }else{
                                            if (countryList[index]
                                                .countries![idx]
                                                .selected) {
                                              setState(() {
                                                countryList[index]
                                                    .countries![idx]
                                                    .selected = false;
                                                selectedDestinations?.remove(
                                                    countryList[index]
                                                        .countries![idx]);
                                              });
                                            } else {
                                              if (selectedDestinations!.length <
                                                  1) {
                                                setState(() {
                                                  countryList[index]
                                                      .countries![idx]
                                                      .selected = true;
                                                  selectedDestinations?.add(
                                                      countryList[index]
                                                          .countries![idx]);
                                                });
                                                Get.back();
                                              }else{
                                                if(isSubscribe == 0){
                                                  showSubscriptionDialog(context);
                                                }else{
                                                  /*if(isSubscribe!=2){
                                                    setState(() {
                                                      countryList[index]
                                                          .countries![idx]
                                                          .selected = true;
                                                      selectedDestinations?.add(
                                                          countryList[index]
                                                              .countries![idx]);
                                                    });
                                                  }*/
                                                }
                                              }
                                            }
                                          }
                                          /**/
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: Get.width * 0.02),
                                          child: Chip(
                                            avatar: Image.network(countryList[index].countries![idx].countryImage.toString()),
                                            backgroundColor: /*countryList[index]
                                                    .countries![idx]
                                                    .selected
                                                ? AppColors.blueColor
                                                    .withOpacity(0.08)
                                                : */Colors.white,
                                            shape:const StadiumBorder(
                                                side: BorderSide(
                                                    color: AppColors
                                                        .grayColorNormal)),
                                            label: Text(
                                              countryList[index]
                                                  .countries![idx]
                                                  .countryName
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: StringConstants
                                                    .poppinsRegular,
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
                        },
                        itemCount: countryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
