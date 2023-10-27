import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:gagagonew/CommonWidgets/custom_button_login.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/model/account_delete_model.dart';
import 'package:gagagonew/model/edit_details_response_model.dart';
import 'package:gagagonew/model/email_update_response_model.dart';
import 'package:gagagonew/model/subscription_Response_Model.dart';
import 'package:gagagonew/model/update_language_model.dart';
import 'package:gagagonew/model/update_profile_model.dart';
import 'package:gagagonew/model/user_log_out_response_model.dart';
import 'package:gagagonew/model/user_profile_model.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/dimensions.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/home/notifications_page.dart';
import 'package:gagagonew/view/home/notifications_settings_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonWidgets/common_back_button.dart';
import '../../CommonWidgets/web_view_class.dart';
import '../../Service/lang/localization_service.dart';
import '../../Service/subscription_service.dart';
import '../../constants/string_constants.dart';
import '../app_html_view_screen.dart';
import '../dialogs/common_alert_dialog.dart';
import '../packages/my_trips/my_trips_list_screen.dart';
import 'change_language_dialog.dart';
import 'change_pass_page.dart';
import 'controller/subscription_payment_controller.dart';

class PersonalInfo extends StatefulWidget {
  String? userName;
  String? email;
  String? phoneNumber;
  String? isSubscriber;
  String? profilePic;
  String? countryCode;
  String? dateOfBirth;
  String? loginType;
  bool? isShown;

  PersonalInfo({Key? key, this.userName, this.email, this.phoneNumber, this.isSubscriber, this.profilePic, this.countryCode, this.dateOfBirth, this.loginType, this.isShown}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String userName = "", phoneNumber = "", email = "", profilePic = "", subscriber = "", countryCode = "", dateOfBirth = "";
  String? planPrice = "", planDuration = "";
  //List<Message>? planList = [];
  int? planId;
  int? isSubscribe;
  String userId = "";
  // List<Media>? res;
  File? image;
  late SharedPreferences sharedPreferences;
  String? reffaralCode = "";
  String selectedCountryCode = '';
  int? notificationEnabled;
  List<User> userList = [];
  int? showNotifications = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isCheck = true;
  final FocusNode f1 = FocusNode();
  final FocusNode fDob = FocusNode();
  final FocusNode f2 = FocusNode();
  final FocusNode f3 = FocusNode();
  AppStreamController appStreamController = AppStreamController.instance;
  bool? isShown;
  TextEditingController dob = TextEditingController(text: "");
  SubscriptionPaymentController subscriptionPaymentController = Get.put(SubscriptionPaymentController());

  ///In App Purchase
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription? _connectionSubscription;
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  bool isLoading = true;

  @override
  void initState() {
    appStreamController.handleBottomTab.add(false);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    //subscriptionMethod();

    initPlatformState();

  }

  ///In App Purchase
  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');
    if (!mounted) return;
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
          print('connected: $connected');
        });
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
          print('purchase-updated: ${productItem!.productId}');
          CommonDialog.hideLoading();
          await Get.to(CommonWebViewSubscription(userId.toString(), productItem.productId!));
          Get.back();
          setState(() {
            isSubscribe = 1;
          });
        });
    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((PurchaseResult? purchaseError) {

          print('purchase-error: $purchaseError');
          CommonDialog.hideLoading();
          if(purchaseError!.code == "E_USER_CANCELLED"){
            CommonDialog.showToastMessage("Purchase Cancelled");
          }else{
            CommonDialog.showToastMessage("Purchase failed, Please try again. [${purchaseError.code}]");
          }
        });
    _getSubscriptions();
  }

  Future _getSubscriptions() async {
   List<IAPItem> items =Platform.isIOS?  await FlutterInappPurchase.instance.getProducts(SubscriptionService.productLists): await FlutterInappPurchase.instance.getSubscriptions(SubscriptionService.productLists);
    _items.clear();
    for (var item in items) {
      print("Item: " + item.toString());
      /*print("Item: " + item.toJson().toString());
      _items.add(IAPItem.fromJSON(item.toJson()));*/
    }

    setState(() {
      _items = items;
    });
    _getPurchaseHistory();
  }

  Future<void> _requestPurchase(IAPItem item) async {
    try{
      CommonDialog.showLoading();
      await FlutterInappPurchase.instance.clearTransactionIOS();
      await FlutterInappPurchase.instance.requestSubscription(item.productId!);
    }catch(e){
      print("_requestPurchase: $e");
      //setLoading(false);
    }
  }

  Future _getPurchaseHistory() async {
    //setLoading(true);
    try{
      List<PurchasedItem>? pItems =
      await FlutterInappPurchase.instance.getPurchaseHistory();
      _purchases.clear();
      if(pItems != null){
        for (var item in pItems) {
          print('${item.transactionStateIOS}');
          if(item.transactionStateIOS == TransactionState.purchased || item.transactionStateIOS == TransactionState.restored){
            _purchases.add(item);
            break;
          }
        }
      }
    }catch(e){
      print("_getPurchaseHistory: $e");
    }
    //setLoading(false);
  }

  _restorePurchase(BuildContext context){
    //setLoading(true);
    Future.delayed(Duration(seconds: 2)).then((value){
      //setLoading(false);
      CommonDialog.showToastMessage("Please login with the same account you subscribed with.");
    });
  }

  init() {
    setState(() {
      getSharedPref();
      subscriber = widget.isSubscriber!;
      debugPrint("ghvhjm$subscriber");
      userName = widget.userName!;
      debugPrint("UserName $userName");
      phoneNumber = widget.phoneNumber!;
      debugPrint("UserName $phoneNumber");
      email = widget.email!;
      debugPrint("UserName $email");
      profilePic = widget.profilePic!;
      debugPrint("UserProfilePic $profilePic");
      countryCode = widget.countryCode!;
      debugPrint("countryCode $countryCode");
      dateOfBirth = widget.dateOfBirth!;
      name.text = userName;

      // dob.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(dateOfBirth)) ;
      dob.text = CommonFunctions.formatDateMMddYYYY(dateOfBirth);

      phone.text = phoneNumber;
      emailController.text = email;
      debugPrint("EmailData ${emailController.text}");
      isCheck = true;
    });
  }

  getSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('userId') ?? "";
    notificationEnabled = int.parse(sharedPreferences.getString('notificationEnabled').toString());
    reffaralCode = sharedPreferences.getString("refferalCode") ?? "";
  }

  subscriptionMethod() {
    // For Subscription
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SubscriptionResponseModel model = await CallService().getSubscriptionList();
      setState(() {
        /*planList = model.message;
        planPrice = planList![0].planPrice;
        planDuration = planList![0].planDuration;
        planId = planList![selectedIndex!].id;*/
        sharedPreferences.setString('planId', planId!.toString());
      });
    });
  }

  updateUserProfile() async {
    print("under updateUserProfile");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProfileModel model = await CallService().getUserProfile(showLoader: true);
      setState(() {
        userList = model.user!;
        userName = userList[0].firstName ?? " ${userList[0].lastName ?? ""}";
        userName = userList[0].firstName ?? " ${userList[0].lastName ?? ""}";
        String phoneNumber = userList[0].phoneNumber ?? "";
        profilePic = userList[0].profilePicture!;
        countryCode = userList[0].countryCode!;
        phoneNumber = phoneNumber;
        debugPrint("UserProfile$phoneNumber");
        debugPrint("UserProfile$profilePic");
        debugPrint("countryCode $countryCode");
        sharedPreferences.setString('userProfile', profilePic);
        name.text = userName;
        debugPrint("userList[0].dob.toString() ${userList[0].dob.toString()}");
        dob.text = CommonFunctions.formatDateMMddYYYY(userList[0].dob.toString());

        userList[0].dob.toString();
        phone.text = phoneNumber;
        emailController.text = email;
        debugPrint("EmailData ${emailController.text}");
        isCheck = true;
        //Get.offAllNamed(RouteHelper.getBottomSheetPage());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (Platform.isIOS) {
      if (_connectionSubscription != null) {
        _connectionSubscription!.cancel();
        _connectionSubscription = null;
      }
    }
  }

/*  updateUserProfile1() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProfileModel model = await CallService().getUserProfile();
      setState(() {
        sharedPreferences!.clear();
        userList = model.user!;
        //Navigator.pop(context);
        Get.offAllNamed(RouteHelper.getLoginPage());
      });
    });
  }*/

  int selectedIndex = 1;
  showSubscriptionDialog() async {
    setState(() {});
    showDialog(
      context: context, // <<----
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Premium'.tr,
                    style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Text(
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections".tr,
                    style: TextStyle(
                        fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.020,
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
                        spacing: Get.width * 0.020,
                        children: List<Widget>.generate(_items.length, (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                /*planId = _items[index].id;
                                sharedPreferences.setString('planId', planId!.toString());
                                debugPrint("GagagoPlanId $planId");*/
                              });
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.21,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 5, color: (index == selectedIndex) ? Colors.blue : Colors.white),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 Platform.isIOS?Text( "${_items[index].title!.split(" ").first}\n${_items[index].title!.split(" ").last}" ):
                                 Text( "${_items[index].description!}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),
                                  /*Text(
                                    int.parse(planList![index].planDuration!) > 1 ? 'months'.tr : "month".tr,
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),*/
                                  Text(
                                    '${_items[index].localizedPrice}',
                                    style: TextStyle(fontSize: Get.height * 0.010, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular, color: AppColors.desColor),
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

                        ///commented by amit
                        Get.back();
                        _requestPurchase(_items[selectedIndex]);
                        subscriptionPaymentController.userId = userId;
                        //subscriptionPaymentController.planId = planId;
                        //subscriptionPaymentController.init();


                        /*subscriptionPaymentController.showPaymentMethodSheet(callback: () {
                          setState(() {});
                          isSubscribe = 1;
                        });*/

                        /*await Get.to(CommonWebView(userId.toString(), planId!));
                        Get.back();
                        setState(() {
                          isSubscribe = 1;
                        });*/
                        //debugPrint("Print Url ${launchUrl(CallService().payPalUrl + '/' + userId.toString() + "/" + planId.toString()}");
                        //Get.back();
                      },
                      child: CustomButtonLogin(
                        buttonName: "Continue".tr,
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
                      style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: AppColors.desColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.14, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    CommonBackButton(
                      name: 'Personal Info'.tr,
                    ),
                    /* SizedBox(
                      height: Get.height * 0.04,
                    ),*/
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(userName.isNotEmpty ? userName : '',
                                style: TextStyle(
                                    fontSize: Get.height * 0.018,
                                    fontFamily: StringConstants.poppinsRegular)),
                            SizedBox(width: Get.width*0.015),
                            InkWell(
                              onTap: (){
                                name.text=userName;
                                showNameDialog(context,userName);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),*/
                    SizedBox(
                      height: Get.height * 0.022,
                    ),

                    SizedBox(
                        height: Get.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 1 : 1,
                              child: Padding(
                                padding: EdgeInsets.only(top: Get.height * 0.014),
                                child: Text('Name'.tr,
                                    style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.012,
                            ),
                            Expanded(
                              flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 2 : 2,
                              child: SizedBox(
                                // width: Get.width * 0.6,
                                child: TextFormField(
                                  readOnly: isCheck,
                                  controller: name,
                                  focusNode: f1,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isCheck = false;
                                          FocusScope.of(context).requestFocus(f1);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: Get.width * 0.08),
                                        child: const SizedBox(
                                          width: 1,
                                          height: 0.5,
                                          child: Icon(
                                            Icons.edit,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //controller: myTextField,
                                  style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
                                  /* autofocus: false,*/
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 0,
                    ),
                    SizedBox(
                        height: Get.height * 0.05,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                          Expanded(
                            flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 1 : 0,
                            child: Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.014),
                              child: Text('Date Of Birth'.tr,
                                  style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.012,
                          ),
                          Expanded(
                            flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 2 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade500, width: 1.0),
                                ),
                              ),
                              child: SizedBox(
                                // width: Get.width * 0.6,
                                child: TextFormField(
                                  enabled: false,
                                  readOnly: isCheck,
                                  controller: dob,
                                  focusNode: fDob,

                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  //controller: myTextField,
                                  style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
                                  /* autofocus: false,*/
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     _showDialog(
                          //       CupertinoDatePicker(
                          //         initialDateTime: DateTime(
                          //           DateTime.now().year - 18,
                          //           DateTime.now().month,
                          //           DateTime.now().day,
                          //         ),
                          //         maximumDate: DateTime(
                          //           DateTime.now().year - 18,
                          //           DateTime.now().month,
                          //           DateTime.now().day,
                          //         ),
                          //         mode: CupertinoDatePickerMode.date,
                          //         onDateTimeChanged: (DateTime newTime) {
                          //           setState(() => dob.text = DateFormat('yyyy-MM-dd').format(newTime).toString());
                          //         },
                          //       ),
                          //     );
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.010),
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.rectangle,
                          //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                          //       border: Border.all(
                          //         color: AppColors.inputFieldBorderColor,
                          //         width: 1.0,
                          //       ),
                          //     ),
                          //     child: Container(
                          //       margin: EdgeInsets.only(left: Get.width * 0.026),
                          //       child: SizedBox(
                          //         child: TextField(
                          //           controller: dob,
                          //           enabled: false,
                          //           style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                          //           decoration: InputDecoration(
                          //             hintText: "Date Of Birth",
                          //             // prefixIcon: Padding(
                          //             //   padding: EdgeInsets.only(right: Get.width * 0.015),
                          //             //   child: SvgPicture.asset(image),
                          //             // ),
                          //             prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.080, maxHeight: Get.width * 0.04),
                          //             hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
                          //             border: InputBorder.none,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ])),
                    SizedBox(
                      height: Get.height * 0.002,
                    ),
                    SizedBox(
                      // margin: EdgeInsets.only(top:10.0),
                        height: Get.height * 0.058,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 1 : 1,
                              child: Padding(
                                padding: EdgeInsets.only(top: Get.height * 0.008),
                                child: Text('Phone Number'.tr,
                                    style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.012,
                            ),
                            Expanded(
                              flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 2 : 2,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                readOnly: isCheck,
                                controller: phone,
                                focusNode: f2,
                                maxLength: 15,
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(top: Get.height * 0.017),
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        // optional. Shows phone code before the country name.
                                        onSelect: (Country country) {
                                          selectedCountryCode = '+${country.phoneCode}';
                                          //selectedCountryCode = '+${country.phoneCode}';
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: /*selectedCountryCode.isEmpty ||
                                        countryCode.length == 0
                                    ? Icon(Icons.phone,
                                        size: 15,
                                        color: Colors.grey.withOpacity(0.4))
                                    : */
                                    Container(
                                      width: 5,
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.only(right: Get.width * 0.02),
                                      decoration: BoxDecoration(
                                        //color:Colors.red,
                                          border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.6)))),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: Get.height * 0.013),
                                        child: selectedCountryCode.isEmpty
                                            ? Text(
                                          countryCode == '' ? '+' : countryCode,
                                          style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018),
                                        )
                                            : Text(
                                          selectedCountryCode,
                                          style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018),
                                        ) /*:*/,
                                      ),
                                    ),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isCheck = false;
                                        FocusScope.of(context).requestFocus(f2);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: Get.width * 0.08),
                                      child: const SizedBox(
                                        width: 1,
                                        height: 0.5,
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //controller: myTextField,
                                style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
                                /* autofocus: false,*/
                              ),
                            ),
                          ],
                        )),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone Number',
                            style: TextStyle(
                                fontSize: Get.height * 0.018,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular)),
                        Row(
                          children: [
                            Text(
                                phoneNumber.isNotEmpty
                                    ? "+${countryCode}" + "" +phoneNumber
                                    : '',
                                style: TextStyle(
                                    fontSize: Get.height * 0.018,
                                    fontFamily: StringConstants.poppinsRegular)),
                            SizedBox(width: Get.width*0.015),
                            InkWell(
                              onTap: (){
                                phone.text = phoneNumber;
                                showPhoneDialog(context,phoneNumber);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),*/
                    // SizedBox(
                    //   height: Get.height * 0.022,
                    // ),

                    SizedBox(
                        height: Get.height * 0.055,
                        // margin: EdgeInsets.only(top:10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 1 : 1,
                                child: Padding(
                                  padding: EdgeInsets.only(top: Get.height * 0.008),
                                  child: Text('Email'.tr,
                                      style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                                )),
                            //SizedBox(width: Get.width*0.20,),
                            SizedBox(
                              width: Get.width * 0.012,
                            ),
                            Expanded(
                              flex: Get.locale! == StringConstants.LOCALE_ENGLISH ? 2 : 2,
                              child: TextFormField(
                                readOnly: isCheck,
                                controller: emailController,
                                focusNode: f3,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  suffixIcon: widget.loginType != "1"
                                      ? null
                                      : InkWell(
                                    onTap: () {
                                      setState(() {
                                        isCheck = false;
                                        FocusScope.of(context).requestFocus(f3);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: Get.width * 0.08),
                                      child: const SizedBox(
                                        width: 1,
                                        height: 0.5,
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //controller: myTextField,
                                style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
                                /* autofocus: false,*/
                              ),
                            ),
                          ],
                        )),
                    isCheck == true
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Get.height * 0.022,
                        )
                        /*ElevatedButton(
                       style: ElevatedButton.styleFrom(
                            primary: AppColors.backgroudColor,),
                        child: const Text("Save",style: TextStyle(color: Colors.black12),),
                        onPressed: () async {})*/
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            child: Text(
                              "Save".tr,
                            ),
                            onPressed: () async {
                              bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailController.text);
                              if (!emailValid) {
                                CommonDialog.showToastMessage('Please enter valid email'.tr);
                              } else if (emailController.text.isEmpty) {
                                CommonDialog.showToastMessage('Please enter email.'.tr);
                              } else {
                                var map = <String, dynamic>{};
                                map['email'] = emailController.text;
                                map['name'] = name.text;
                                map['country_code'] = selectedCountryCode;
                                map['phone_number'] = phone.text;
                                // map['date_of_birth'] = dob.text;
                                EditDetailsResponseModel updateName = await CallService().editUserDetails(map);
                                if (updateName.success!) {
                                  if (updateName.message == "Please check your updated email inbox for the email verification.") {
                                    sharedPreferences.clear();
                                    CommonDialog.showToastMessage(updateName.message!);
                                    Get.offAllNamed(RouteHelper.getLoginPage());
                                  } else {
                                    updateUserProfile();
                                  }
                                } else {
                                  CommonDialog.showToastMessage(updateName.message.toString());
                                }
                              }
                              // your code
                            })
                      ],
                    ),
                    Container(
                      width: Get.width * 0.9,
                      height: 1,
                      color: AppColors.headerGrayColor,
                      margin: EdgeInsets.only(top: Get.height * 0.025),
                    ),
                    SizedBox(
                      height: Get.height * 0.030,
                    ),

                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(
                          context,
                        )
                            .push(
                          MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
                        )
                            .then((value) {
                          appStreamController.handleBottomTab.add(false);
                        });
                        //Get.toNamed(RouteHelper.getNotifications());
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifications'.tr,
                                style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(ChangePasswordPage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Change Password'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    InkWell(
                      onTap: () {
                        ///temporary commented
                        debugPrint("subscriber $subscriber");
                        if (subscriber == "1") {
                          Get.toNamed(RouteHelper.getPlanList())!.then((value) {
                            if (value == false) {
                              showSubscriptionDialog();
                            }
                          });
                        } else {
                          showSubscriptionDialog();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subscriptions'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(MyTripsListScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('My Trips'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.toNamed(RouteHelper.getContactUs(userName, email));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact Us'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.toNamed(RouteHelper.getBlockUserLists());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Blocked Users'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    /* GestureDetector(
                      onTap: () {
                        //Get.toNamed(RouteHelper.getProfileLikeUsers());
                        if(widget.isSubscriber == "1"){
                          Get.toNamed(RouteHelper.getProfileLikeUsers());
                        }else{
                          showSubscriptionDialog();
                        }
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Like Me',
                                style: TextStyle(
                                    fontSize: Get.height * 0.018,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                    StringConstants.poppinsRegular)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.022,
                    ),
                    GestureDetector(
                      onTap: () {
                        //Get.toNamed(RouteHelper.getProfileLikeUsers());
                      Get.toNamed(RouteHelper.getMatchUserList());
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Match Users',
                                style: TextStyle(
                                    fontSize: Get.height * 0.018,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                    StringConstants.poppinsRegular)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.022,
                    ),*/
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.toNamed(RouteHelper.getUserFeedBack());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Feedback'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.toNamed(RouteHelper.getInviteFriend());
                        //Share.share("https://www.figma.com/file/pofNWYN3BMJkLhWycZwHiP/Final-Gagago?node-id=1122%3A1715" + "Your Reffaral Code is: $reffaralCode");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Invite a Friend'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showLanguageDialog("Choose Language".tr);
                        //Share.share("https://www.figma.com/file/pofNWYN3BMJkLhWycZwHiP/Final-Gagago?node-id=1122%3A1715" + "Your Reffaral Code is: $reffaralCode");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Language'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    /* GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getUserHistoryList());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('User Activity History',
                              style: TextStyle(
                                  fontSize: Get.height * 0.018,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: StringConstants.poppinsRegular)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.022,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(const AppHtmlViewScreen(apiKey: "terms-and-conditions", title: "Terms & Conditions", isAuth: true));
                            // Get.toNamed(RouteHelper.getSettingsTerms("Terms and Conditions"));
                          },
                          child: Text('Terms & Conditions'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.032,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(const AppHtmlViewScreen(apiKey: "privacy-policy", title: "Privacy Policy", isAuth: true));
                            // Get.toNamed(RouteHelper.getSettingsTerms('Privacy Policy'));
                          },
                          child: Text('Privacy Policy'.tr,
                              style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Get.height * 0.030),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.9,
                        height: 1,
                        color: AppColors.dividerColor,
                        margin: EdgeInsets.only(top: Get.height * 0.025),
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      InkWell(
                        onTap: () {
                          showAlertDialogDeleteAccount(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delete Account'.tr,
                                style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular)),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.025,
                      ),
                      InkWell(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Text(
                          'Logout'.tr,
                          style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.017 : Get.height * 0.018, color: Colors.red, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel".tr,
        style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
        child: Text(
          "Continue".tr,
          style: TextStyle(fontSize: Get.height * 0.018, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
        ),
        onPressed: () async {
          Get.back();
          var map = <String, dynamic>{};
          map['device_token'] = await FirebaseMessaging.instance.getToken();

          UserLogOutResponseModel stateUpdate = await CallService().getUerLogOut(map);
          if (stateUpdate.success == true) {
            // String? currentLocal =
            //     sharedPreferences.getString(StringConstants.CURRENT_LOCALE);
            // int? languageId =
            //     sharedPreferences.getInt(StringConstants.LANGUAGE_ID);

            for (String key in sharedPreferences.getKeys()) {
              if (key != "email" && key != "password" && key != 'remember_me'
              // &&
              // key != StringConstants.LANGUAGE_ID &&
              // key != StringConstants.CURRENT_LOCALE
              ) {
                debugPrint("key :::::::::::::::$key");
                sharedPreferences.remove(key);
              }
            }

            // if (languageId != null) {
            //   sharedPreferences.setInt(StringConstants.LANGUAGE_ID, languageId);
            // }
            // if (currentLocal != null) {
            //   sharedPreferences.setString(
            //       StringConstants.CURRENT_LOCALE, currentLocal);
            // }

            //Navigator.pop(context);
            Get.offAllNamed(RouteHelper.getLoginPage());
            //Navigator.pop(context);
          } else {
            CommonDialog.showToastMessage(stateUpdate.message.toString());
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Log out".tr,
        style: TextStyle(color: Colors.red, fontSize: Get.height * 0.028, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular),
      ),
      content: Text(
        "Do you want to log out?".tr,
        style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
      ),
      actions: [
        Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateLanguage(int id, BuildContext context, {Function? callBack}) async {
    if (id == 1) {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      sharedPreferences.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      sharedPreferences.setInt(StringConstants.LANGUAGE_ID, 1);
    } else if (id == 2) {
      Get.locale = StringConstants.LOCALE_SPANISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_SPANISH_KEY);
      sharedPreferences.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_SPANISH_KEY);
      sharedPreferences.setInt(StringConstants.LANGUAGE_ID, 2);
    } else if (id == 4) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_KEY);

      sharedPreferences.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_PURTUGUESE_KEY);
      sharedPreferences.setInt(StringConstants.LANGUAGE_ID, 4);
    } else if (id == 7) {
      Get.locale = StringConstants.LOCALE_FRENCH;
      LocalizationService.changeLocale(StringConstants.LOCALE_FRENCH_KEY);

      sharedPreferences.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_FRENCH_KEY);
      sharedPreferences.setInt(StringConstants.LANGUAGE_ID, 7);
    } else {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);

      sharedPreferences.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      sharedPreferences.setInt(StringConstants.LANGUAGE_ID, 1);

      // SessionManager.setLocale(Utils.LOCALE_ENGLISH_KEY);
    }

    String currentLang = sharedPreferences.getString(StringConstants.CURRENT_LOCALE) ?? "";

    if (callBack != null) {
      callBack();
    }
    debugPrint(" currentLangcurrentLang --> $currentLang");
    // updateLanguageApi(context);
  }

  showAlertDialogDeleteAccount(BuildContext context) {
    // showDeleteAccountMessage(context, "deleteAccount.messageTitle!",
    //     "deleteAccount.messageCaption!");
    // return;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel".tr),
      onPressed: () {
        Get.back();
        // Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: Text("Continue".tr),
        onPressed: () async {
          var map = <String, dynamic>{};
          AccountDeleteModel deleteAccount = await CallService().deleteUserAccount(map);
          if (deleteAccount.success == true) {
            sharedPreferences.clear();
            Get.back();
            showDeleteAccountMessage(context, deleteAccount.messageTitle!, deleteAccount.messageCaption!);
          } else {
            CommonDialog.showToastMessage(deleteAccount.message.toString());
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Delete Account".tr,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        "Are you sure you want to delete your account?".tr,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteAccountMessage(BuildContext context, String title, String desc) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CommonAlertDialog(
          title: title,
          description: desc,
          titleStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          descStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          callback: () {
            // Get.back();
            Get.offAllNamed(RouteHelper.getLoginPage());
          },
        );
      },
    );
  }

  void openImageOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
        margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.020),
        height: Get.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                      XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
                      // var pickedImage = await CommonFunctions.compressFile(
                      //     File(mainRes!.path));
                      image = File(pickedImage!.path);
                      final bytes = File(image!.path).readAsBytesSync();
                      String base64Image = "data:image/png;base64,${base64Encode(bytes)}";
                      debugPrint("img_pan : $base64Image");
                      if (image != null) {
                        dio.FormData form = dio.FormData.fromMap({'profile_picture': base64Image});
                        var map = <String, dynamic>{};
                        //map['user_id'] = userId;
                            ;
                        UpdateProfileModel model = await CallService().updateProfile(form);
                        if (model.success == true) {
                          updateUserProfile();
                        } else {
                          CommonDialog.showToastMessage(model.message.toString());
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Camera",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
                      // var pickedImage = await CommonFunctions.compressFile(
                      //     File(mainRes!.path));
                      image = File(pickedImage!.path);
                      final bytes = File(image!.path).readAsBytesSync();
                      String base64Image = "data:image/png;base64,${base64Encode(bytes)}";
                      debugPrint("img_pan : $base64Image");
                      if (image != null) {
                        dio.FormData form = dio.FormData.fromMap({'profile_picture': base64Image});
                        var map = <String, dynamic>{};
                        //map['user_id'] = userId;
                        map['profile_picture'] = base64Image;
                        UpdateProfileModel model = await CallService().updateProfile(form);
                        if (model.success == true) {
                          updateUserProfile();
                        } else {
                          CommonDialog.showToastMessage(model.message.toString());
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)), color: Colors.white),
                width: Get.width,
                height: Get.height * 0.070,
                child: Center(
                    child: Text(
                      "Cancel".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showNameDialog(BuildContext context, String userName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: AppColors.blueColor, border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                        child: const Center(
                            child: Text("Edit Name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: StringConstants.poppinsRegular,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.2)))),
                                    child: Center(child: Icon(Icons.person, size: 35, color: Colors.grey.withOpacity(0.4))),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: name,
                                    decoration: InputDecoration(
                                        hintText: userName,
                                        contentPadding: const EdgeInsets.only(left: 20),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: const BoxDecoration(color: AppColors.blueColor),
                            child: const Center(
                                child: Text(
                                  "Update Name",
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                )),
                          ),
                          onPressed: () async {
                            Get.back();
                            dio.FormData form = dio.FormData.fromMap({'name': name.text});
                            var map = <String, dynamic>{};
                            //map['user_id'] = userId;
                            map['name'] = name.text;
                            UpdateProfileModel updateName = await CallService().updateProfile(form);
                            if (updateName.success!) {
                              updateUserProfile();
                            } else {
                              CommonDialog.showToastMessage(updateName.message.toString());
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showPhoneDialog(BuildContext context, String phoneNumber) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: AppColors.blueColor, border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                          child: const Center(
                              child: Text("Edit Phone Number",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: StringConstants.poppinsRegular,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                              child: GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,

                                    // optional. Shows phone code before the country name.
                                    onSelect: (Country country) {
                                      selectedCountryCode = country.phoneCode;

                                      setState(() {});
                                    },
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 30,
                                        decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.2)))),
                                        child: Center(child: selectedCountryCode.isEmpty ? Icon(Icons.phone, size: 35, color: Colors.grey.withOpacity(0.4)) : Text(selectedCountryCode)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextFormField(
                                        controller: phone,
                                        decoration: InputDecoration(
                                            hintText: phoneNumber,
                                            contentPadding: const EdgeInsets.only(left: 20, top: 8),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextButton(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: const BoxDecoration(color: AppColors.blueColor),
                              child: const Center(
                                  child: Text(
                                    "Update Phone Number",
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                  )),
                            ),
                            onPressed: () async {
                              Get.back();
                              dio.FormData form = dio.FormData.fromMap({
                                'country_code': selectedCountryCode,
                                'phone_number': phone.text,
                              });
                              var map = <String, dynamic>{};
                              //map['user_id'] = userId;
                              map['country_code'] = selectedCountryCode;
                              map['phone_number'] = phone.text;
                              UpdateProfileModel updateName = await CallService().updateProfile(form);
                              if (updateName.success!) {
                                updateUserProfile();
                              } else {
                                CommonDialog.showToastMessage(updateName.message.toString());
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  showEmailDialog(BuildContext context, String email) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: AppColors.blueColor, border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                        child: const Center(
                            child: Text("Edit Email Address",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: StringConstants.poppinsRegular,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.2)))),
                                    child: Center(child: Icon(Icons.email, size: 35, color: Colors.grey.withOpacity(0.4))),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: email,
                                        contentPadding: const EdgeInsets.only(left: 20),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: const BoxDecoration(color: AppColors.blueColor),
                            child: const Center(
                                child: Text(
                                  "Update Email",
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                )),
                          ),
                          onPressed: () async {
                            bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailController.text);
                            if (!emailValid) {
                              CommonDialog.showToastMessage('Please enter valid email');
                            } else if (emailController.text.isEmpty) {
                              CommonDialog.showToastMessage('Please enter email');
                            } else {
                              Get.back();
                              var map = <String, dynamic>{};
                              map['email'] = emailController.text;
                              EmailUpdateResponseModel updateName = await CallService().updateEmailExist(map);
                              if (updateName.success!) {
                                sharedPreferences.clear();
                                CommonDialog.showToastMessage(updateName.message!);
                                Get.offAllNamed(RouteHelper.getLoginPage());
                              } else {
                                CommonDialog.showToastMessage(updateName.message.toString());
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showLanguageDialog(String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ChangeLanguageDialog(
            callBack: (int id) async {
              debugPrint("int $id");
              Get.back();
              var map = <String, dynamic>{};
              map['lang'] = id;
              UpdateLanguageModel model = await CallService().updateLanguage(map);
              if (model.status!) {
                updateLanguage(model.langId!, context, callBack: () {
                  CommonDialog.showToastMessage("Updated successfully".tr);
                });
                sharedPreferences.setInt("language_id", id);
                // CommonDialog.showToastMessage(model.message!.tr);
              } else {
                CommonDialog.showToastMessage(model.message.toString().tr);
              }
            },
          );
        });
  }
}
