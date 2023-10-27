import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart' as loc;

import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/model/settings_update_model.dart';
import 'package:gagagonew/model/subscription_Response_Model.dart';
import 'package:gagagonew/view/home/bottom_nav_page.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CommonWidgets/custom_button_login.dart';
import '../../Service/call_service.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../model/change_password_response_model.dart';
import '../../model/settingModel.dart';
import '../../model/settings_model.dart';
import '../../utils/progress_bar.dart';
import '../../utils/stream_controller.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import '../ConsumableStore.dart';
import '../dialogs/common_alert_dialog.dart';
import '../drawer/drawer_page.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

///In app product ids-->
const String oneMonth = '1_month';
const String sixMonth = '6_month';
const String twelveMonth = '12_month';

const String oneMonths = '1_months';
const String sixMonths = '6_months';
const String twelveMonths = '12_months';

const List<String> _andProductIds = <String>[oneMonth, sixMonth, twelveMonth];

const List<String> _iosProductIds = <String>[oneMonths, sixMonths, twelveMonths];

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  /// In app purchase
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> notFoundIds = [];
  List<PurchaseDetails> _purchases = [];
  List<ProductDetails> _products = [];
  List<String> consumables = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String? queryProductError;

  /// List Variables subscriptionList
  List<SubscriptionModal> subscriptionList = [];
  String newPlanId = "";

  AppStreamController appStreamController = AppStreamController.instance;
  bool? isSelect = true;
  int isShowAge = 0;
  int meetNowPassport = 0;
  int isShowSexualOrientation = 0;
  int? isSubscribe;
  int genderPreference = 1;
  int minAge = 0;
  int maxAge = 0;
  int ethnicityPreference = 1;
  int sexualOrientationPreference = 1;
  int tripStylePreference = 1;
  int tripTimelinePreference = 1;
  RangeValues _currentRangeValues = const RangeValues(18, 100);
  String? planPrice = "", planDuration = "";
  List<Message> planList = [];
  int? userId;
  int? planId;
  SharedPreferences? prefs;
  String? currentCity = "";
  LatLng currentLatLon = const LatLng(0.0, 0.0);
  bool isSlidingAge = false;

  bool isDataLoading = false;

  //For Purchasing Subscription
  // String url = "https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/charge/";

/*  final Completer<WebViewController> _controller = Completer<WebViewController>();*/

  @override
  void initState() {
    initBackgroundNotifLis(context);
    initNotificationListener(context);

    initStreamListener();
    debugPrint("under refreshBottomNavPageAction user profile");
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToMainPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("InApp Error");
    });
    initStoreInfo();

    super.initState();
  }

  /// here initialize the store information and check availability of in app purchase
  Future<void> initStoreInfo() async {
    final bool isCheckAvailable = await _inAppPurchase.isAvailable();

    debugPrint("checkingStoreAvailable-->$isCheckAvailable");

    if (!isCheckAvailable) {
      setState(() {
        isAvailable = isCheckAvailable;
        _products = [];
        _purchases = [];
        notFoundIds = [];
        consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }
    debugPrint("11111");
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    } else {}
    debugPrint("22222");
    ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(Platform.isIOS ? _iosProductIds.toSet() : _andProductIds.toSet());

    debugPrint("33333");
    if (productDetailResponse.error != null) {
      setState(() {
        queryProductError = productDetailResponse.error!.message;
        isAvailable = isCheckAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        notFoundIds = productDetailResponse.notFoundIDs;
        consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }
    debugPrint("44444 ${Platform.isAndroid ? "android" : "iOS"}");
    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        queryProductError = null;
        isAvailable = isCheckAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        notFoundIds = productDetailResponse.notFoundIDs;
        consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }
    debugPrint("55555");
    List<String> consumablesList = await ConsumableStore.load();
    setState(() {
      isAvailable = isCheckAvailable;
      _products = productDetailResponse.productDetails;
      notFoundIds = productDetailResponse.notFoundIDs;
      consumables = consumablesList;
      purchasePending = false;
      loading = false;
    });
    debugPrint("66666");
    debugPrint("product--->${_products.length}");

    if (productDetailResponse.productDetails.isNotEmpty) {
      debugPrint("product=====List======>${productDetailResponse.productDetails}");
      for (var element in productDetailResponse.productDetails) {
        setState(() {
          if (Platform.isIOS) {
            subscriptionList.add(SubscriptionModal(
              id: element.id,
              title: element.title,
              price: element.price.toString(),
              rawPrice: element.rawPrice.toString(),
              des: element.description.split(","),
              productItem: element,
              isSelected: false,
              duration: element.id == "1_months"
                  ? "1"
                  : element.id == "6_months"
                      ? "6"
                      : "12",
            ));
          } else {
            subscriptionList.add(SubscriptionModal(
              id: element.id,
              title: element.title,
              price: element.price.toString(),
              rawPrice: element.rawPrice.toString(),
              des: element.description.split(","),
              productItem: element,
              isSelected: false,
              duration: element.id == "1_month"
                  ? "1"
                  : element.id == "6_month"
                      ? "6"
                      : "12",
            ));
          }
        });
      }
      debugPrint("77777");

/*      var pos =
      subscriptionList.indexWhere((element) => element.id == packageName);
      debugPrint("pos=====>$pos");

      if (pos != -1) {
        debugPrint("pos=====>$pos");
        subscriptionList[pos].isSelected = true;
      }*/
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    debugPrint("insideVerifyPurchase=====>$purchaseDetails");

    /// IMPORTANT!! Always verify a purchase before delivering the product.
    /// For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    ///Here we show Failed Purchase dialog if we want.
    CommonDialog.showToastMessage(purchaseDetails.error.toString());
  }

  void showPendingUI() {
    setState(() {
      purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      debugPrint("IAppError-->${error.code}");
      debugPrint("IAppError-->${error.message}");
      debugPrint("IAppError-->${error.details}");
      purchasePending = false;
      CommonDialog.showToastMessage(error.message.toString());
    });
  }

  void stopPendingUI() {
    setState(() {
      purchasePending = false;
    });
  }

  void _listenToMainPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          stopPendingUI();
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          debugPrint("PurchaseStatus.purchased $valid");
          if (valid) {
            handleVerifyPurchase(purchaseDetails);
            if (selectedPosition != -1) {
              var map = <String, dynamic>{};
              map['productID'] = purchaseDetails.productID.toString() == "1_month" || purchaseDetails.productID.toString() == "1_months"
                  ? "1"
                  : purchaseDetails.productID.toString() == "6_month" || purchaseDetails.productID.toString() == "6_months"
                      ? "6"
                      : purchaseDetails.productID.toString() == "12_month" || purchaseDetails.productID.toString() == "12_months"
                          ? "12"
                          : "";
              map['transactionDate'] = purchaseDetails.transactionDate.toString();
              map['status'] = purchaseDetails.status.toString();
              map['purchaseID'] = purchaseDetails.purchaseID.toString();
              debugPrint("buySubscription map $map");
              CallService().buySubscription(map);
            }
          } else {
            _handleInvalidPurchase(purchaseDetails);
            continue;
          }
        }
        if (Platform.isAndroid) {
          if (purchaseDetails.productID == subscriptionList[selectedPos].id) {
            final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          //commonAlert(context, "Purchased Pending");
        }
      }
    }
  }

  void handleVerifyPurchase(PurchaseDetails purchaseDetails) async {
    /// IMPORTANT!! Always verify purchase details before delivering the product.
    if (Platform.isIOS) {
      if ((purchaseDetails.productID == oneMonths) || (purchaseDetails.productID == sixMonths) || (purchaseDetails.productID == twelveMonths)) {
        await ConsumableStore.save(purchaseDetails.purchaseID!);
        List<String> consumablesList = await ConsumableStore.load();
        setState(() {
          purchasePending = false;
          consumables = consumablesList;
        });
      } else {
        setState(() {
          _purchases.add(purchaseDetails);
          purchasePending = false;
        });
      }
    } else {
      if ((purchaseDetails.productID == oneMonth) || (purchaseDetails.productID == sixMonth) || (purchaseDetails.productID == twelveMonth)) {
        await ConsumableStore.save(purchaseDetails.purchaseID!);
        List<String> consumablesList = await ConsumableStore.load();
        setState(() {
          purchasePending = false;
          consumables = consumablesList;
        });
      } else {
        setState(() {
          _purchases.add(purchaseDetails);
          purchasePending = false;
        });
      }
    }
  }

  initStreamListener() {
    appStreamController.handleBottomTab.add(true);

    appStreamController.refreshSettingPageStream();
    appStreamController.refreshSettingPageAction.listen((event) {
      debugPrint("Setting Page initStreamListener $event");
      init(showLoader: false);
    });
  }

  init({bool showLoader = true}) async {
    appStreamController.rebuildRefreshBottomNavPageStream();
    appStreamController.refreshBottomNavPageAction.listen((event) {
      debugPrint("under refreshBottomNavPageAction");
      if (event.toString().isNotEmpty) {
        if (event == 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            handleData();
            callApis();
          });
        }
      }
    });
    handleData();
    callApis(showLoader: showLoader);
  }

  handleData() {
    listShowMe.clear();
    ethnicity.clear();
    sexual.clear();
    trip.clear();
    tripTime.clear();

    listShowMe.addAll([
      SettingModel(text: "Men", icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Women", icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Other", icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Everyone", icon: "assets/images/svg/blueTick.svg")
    ]);
    ethnicity.addAll([
      SettingModel(text: "White".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Hispanic or Latino".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Asian".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Black or African".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Other".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
    ]);
    sexual.addAll([
      SettingModel(text: "Straight".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Gay".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Lesbian".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Bisexual".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
    ]);
    trip.addAll([
      SettingModel(text: "Backpacking".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Mid-range".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Luxury".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
    ]);
    tripTime.addAll([
      SettingModel(text: "1-3 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "3-6 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "6-9 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
      SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
    ]);
  }

  callApis({bool showLoader = true}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SettingsModel model = await CallService().getSettings(showLoader: showLoader);
      prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          isDataLoading = true;
          isShowAge = model.data![0].isShowAge!;
          meetNowPassport = model.data![0].meetNowPassport!;
          isShowSexualOrientation = model.data![0].isShowSexualOrientation!;
          isSubscribe = model.user!.isSubscriber;
          currentCity = model.user!.meetNowAddress ?? 'Select Location'.tr;
          currentLatLon = LatLng(
              double.parse(model.user!.meetNowLat == null ? '0.0' : model.user!.meetNowLat.toString()), double.parse(model.user!.meetNowLng == null ? '0.0' : model.user!.meetNowLng.toString()));
          userId = model.data![0].userId;
          debugPrint("User Is Subscribe $isSubscribe");
          genderPreference = model.data![0].genderPreference!;
          minAge = model.data![0].minAge!;
          maxAge = model.data![0].maxAge!;
          _currentRangeValues = RangeValues(minAge.toDouble(), maxAge.toDouble());
          sexualOrientationPreference = model.data![0].sexualOrientationPreference!;
          ethnicityPreference = model.data![0].ethinicityPreference!;
          tripStylePreference = model.data![0].tripStylePreference!;
          tripTimelinePreference = model.data![0].tripTimelinePreference!;
        });
      }
    });

    // For Subscription
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SubscriptionResponseModel model = await CallService().getSubscriptionList();
      if (mounted) {
        setState(() {
          planList = model.message!;
          planId = planList[selectedIndex!].id;

          if (prefs != null) {
            prefs!.setString('planId', planId!.toString());
          } /*  planPrice = planList![0].planPrice;
        planDuration = planList![0].planDuration;*/
        });
      }
    });
  }

  List<SettingModel> listShowMe = [
    SettingModel(text: "Men", icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Women", icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Other", icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Everyone", icon: "assets/images/svg/blueTick.svg"),
  ];
  List<SettingModel> ethnicity = [
    SettingModel(text: "White".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Hispanic or Latino".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Asian".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Black or African".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Other".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
  ];
  List<SettingModel> sexual = [
    SettingModel(text: "Straight".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Gay".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Lesbian".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Bisexual".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
  ];
  List<SettingModel> trip = [
    SettingModel(text: "Backpacking".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Mid-range".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Luxury".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
  ];
  List<SettingModel> tripTime = [
    SettingModel(text: "1-3 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "3-6 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "6-9 Months".tr, icon: "assets/images/svg/grayEmpty.svg"),
    SettingModel(text: "Everyone".tr, icon: "assets/images/svg/blueTick.svg"),
  ];

  /*List<PremiumModel> premium=[
    PremiumModel(month: "1", price: r"$8.99"),
    PremiumModel(month: "6", price: r"39.99"),
    PremiumModel(month: "12", price: r"$59.99")
  ];*/

  Future<void> launch(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  int? selectedIndex = 1;
  int selectedPos = 0;
  int selectedPosition = -1;

  subscriptionShowDialog() async {
    setState(() {});
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Premium'.tr,
                    style: TextStyle(fontSize: Get.height * 0.022, fontWeight: FontWeight.w700, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                  ),
                  SizedBox(
                    height: Get.height * 0.010,
                  ),
                  Text(
                    "Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections".tr,
                    style: TextStyle(
                        fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.020,
                        fontWeight: FontWeight.w600,
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
                        children: List<Widget>.generate(subscriptionList.length, (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                //selectedIndex = index;
                                for (var element in subscriptionList) {
                                  element.isSelected = false;
                                }
                                subscriptionList[index].isSelected = true;
                                selectedPos = index;
                                selectedPosition = index;
                                newPlanId = subscriptionList[index].id;
                                //planId = planId[index].id!;
                                prefs!.setString('planId', newPlanId.toString());
                                //prefs!.setString('planId', planId.toString());
                                //debugPrint("GagagoPlanId $planId");
                                debugPrint("GagagoPlanId $newPlanId");
                              });
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 5, color: (index == selectedIndex) ? Colors.blue : Colors.white),
                                  border: Border.all(width: 5, color: (subscriptionList[index].isSelected) ? Colors.blue : Colors.white),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.chatInputTextBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    subscriptionList[index].duration,
                                    style: TextStyle(fontSize: Get.height * 0.025, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),
                                  Text(
                                    int.parse(subscriptionList[index].duration) > 1 ? 'months'.tr : "month".tr,
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: Colors.black),
                                  ),
                                  Text(
                                    subscriptionList[index].price,
                                    style: TextStyle(fontSize: Get.height * 0.014, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular, color: AppColors.desColor),
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
                        /*    launch(CallService().payPalUrl + userId.toString() + "/" + planId.toString());
                        debugPrint("planId $planId");*/

                        ///commented by amit
                        debugPrint("buyNowClick==========> ${subscriptionList[selectedPos].productItem.id}");

                        await _inAppPurchase
                            .buyNonConsumable(purchaseParam: GooglePlayPurchaseParam(productDetails: subscriptionList[selectedPos].productItem))
                            .whenComplete(() => null)
                            .onError((error, stackTrace) => false);
                        Get.back();
                        //await Get.to(CommonWebView(userId!, planId!));
                        //init();
                        ///

                        /*setState(() {
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
        //  drawer: (selectedBottomIndex == 1) ? const DrawerPage() : null,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // title: Center(
          //   child: Text(
          //     "Settings".tr,
          //     style: TextStyle(
          //         fontSize: Get.height * 0.025,
          //         color: AppColors.backTextColor,
          //         fontWeight: FontWeight.w600,
          //         fontFamily: StringConstants.poppinsRegular),
          //   ),
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width * 0.090,
                child: InkWell(
                  onTap: () {
                    // Get.offAllNamed(RouteHelper.getBottomSheetPage());
                    appStreamController.handleUpdateBottomTab.add(previousSelectTab);
                  },
                  child: SvgPicture.asset(
                    "${StringConstants.svgPath}backIcon.svg",
                    height: Get.height * 0.035,
                  ),
                ),
              ),
              Text(
                "Settings".tr,
                style: TextStyle(fontSize: Get.height * 0.025, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
              ),
              /*       Visibility(
                visible: false,
                child: InkWell(
                  onTap: () async {
                    var map = <String, dynamic>{};
                    map['is_show_age'] = isShowAge;
                    map['meet_now_passport'] = meetNowPassport;
                    map['gender_preference'] = genderPreference;
                    map['ethinicity_preference'] = ethnicityPreference;
                    map['sexual_orientation_preference'] = sexualOrientationPreference;
                    map['trip_style_preference'] = tripStylePreference;
                    map['trip_timeline_preference'] = tripTimelinePreference;
                    map['min_age'] = _currentRangeValues.start;
                    map['max_age'] = _currentRangeValues.end;
                    SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                    if (submit.success!) {
                      Get.offAllNamed(RouteHelper.getBottomSheetPage());
                    } else {
                      CommonDialog.showToastMessage(submit.message.toString());
                    }
                  },
                  child: Text(
                    "Save".tr,
                    style: TextStyle(fontSize: Get.height * 0.020, color: AppColors.backTextColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.020,)*/
              SizedBox(
                width: Get.width * 0.095,
              )
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            isDataLoading
                ? Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.010, left: Get.width * 0.080, right: Get.width * 0.080),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Don’t show my age".tr,
                                  style: TextStyle(
                                      fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                      color: AppColors.backTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: StringConstants.poppinsRegular),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  trackColor: Colors.grey,
                                  activeColor: Colors.blue,
                                  value: isShowAge == 1 ? true : false,
                                  onChanged: (newValue) async {
                                    if (isSubscribe == 0) {
                                      subscriptionShowDialog();
                                    } else {
                                      setState(() {
                                        isShowAge = newValue ? 1 : 0;
                                      });
                                      var map = <String, dynamic>{};
                                      map['is_show_age'] = isShowAge;
                                      SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                      if (submit.success!) {
                                        isFilterChanged = true;
                                        //CommonDialog.showToastMessage(submit.message.toString());
                                      } else {
                                        CommonDialog.showToastMessage(submit.message.toString());
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          /*  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Don’t show my sexual",
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "orientation",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: Get.height * 0.025,
                                    color: AppColors.backTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: StringConstants.poppinsRegular),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: Get.width * 0.02),
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.buttonColor),
                              height: Get.height * 0.029,
                              width: Get.width * 0.12,
                              child: Center(
                                  child: Text(
                                "Free",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.height * 0.018),
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      trackColor: Colors.grey,
                      activeColor: Colors.blue,
                      value: isShowSexualOrientation == 1,
                      onChanged: (newValue) async {
                        setState(() {
                          isShowSexualOrientation = newValue ? 1 : 0;
                        });
                        */ /* if(isSubscribe == 0){
                          subscriptionShowDialog();
                        }else{
                          setState(() {
                            isShowSexualOrientation=newValue?1:0;
                          });
                          var map = new Map<String, dynamic>();
                          map['is_show_sexual_orientation'] = isShowSexualOrientation;
                          SettingsUpdateModel submit= await CallService().settingsUpdate(map);
                          if(submit.success!){
                            CommonDialog.showToastMessage(submit.message.toString());
                          }
                          else{
                            CommonDialog.showToastMessage(submit.message.toString());
                          }
                        }*/ /*
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.020,
              ),*/
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Meet Now Passport".tr,
                                style: TextStyle(
                                    fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                    color: AppColors.backTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: StringConstants.poppinsRegular),
                              ),
                              Container(
                                padding: EdgeInsets.all(Get.width * 0.03),
                                margin: EdgeInsets.only(top: Get.height * 0.010, bottom: Get.height * 0.005),
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
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          _handleSelectLocationCLick();
                                        },
                                        child: Text(
                                          currentCity!.isNotEmpty ? currentCity.toString() : 'Select Location'.tr,
                                          maxLines: 1,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontFamily: StringConstants.poppinsRegular,
                                              fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Image.asset('assets/images/png/current_location.png'),
                                      onTap: () async {
                                        if (isSubscribe == 0) {
                                          subscriptionShowDialog();
                                        } else {
                                          _onCurrentLocationClick();
                                        }
                                        // Handle the result in your way
                                      },
                                    )
                                  ],
                                ),
                              ),
                              /* InkWell(
                    onTap: (){
                      Get.bottomSheet(
                          StatefulBuilder(builder: (context, StateSetter setState) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Container(
                                margin: EdgeInsets.all(Get.width*0.05),
                                child: Column(
                                  children: [
                                     Image.asset('assets/images/png/bag_travel.png'),
                                    Container(
                                      margin: EdgeInsets.only(top: Get.height*0.02),
                                      child: Text(
                                        "Get Travel Ready",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: Get.height * 0.028,
                                            color: AppColors.backTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: StringConstants.poppinsRegular),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: Get.height*0.02,left: Get.width*0.02,right:Get.width*0.02 ),
                                      child: Text(
                                        "Use Travel Mode to change your location to wherever you’re going, as often as you like",
                                        textAlign: TextAlign.center,
                                          style:TextStyle(
                                              fontSize: Get.height * 0.024,
                                              color: AppColors.grayColorNormal,
                                              fontFamily: StringConstants.poppinsRegular)
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Get.back();
                                        const kGoogleApiKey = "AIzaSyBwum8vSJGI-HNtsPVSiK9THpmA2IbgDTg";
                                        Prediction? p = await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey: kGoogleApiKey,
                                          radius: 10000000,
                                          types: [],
                                          strictbounds: false,
                                          mode: Mode.fullscreen,
                                          language: "fr",
                                          decoration: InputDecoration(
                                            hintText: "I'm travelling to...",
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: StringConstants.poppinsRegular,
                                                fontSize: Get.height * 0.016),
                                          ),
                                          components: [Component(Component.country, "fr")],
                                        );

                                        if (p != null) {
                                          // get detail (lat/lng)
                                          GoogleMapsPlaces _places = GoogleMapsPlaces(
                                              apiKey: kGoogleApiKey,
                                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                                        );
                                        PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
                                        final lat = detail.result.geometry!.location.lat;
                                        final lng = detail.result.geometry!.location.lng;
                                        this.setState(() {
                                        currentCity=p.description;
                                        });
                                          var map = new Map<String, dynamic>();
                                          map['meet_now_address'] = currentCity;
                                          map['meet_now_lat'] = lat.toString();
                                          map['meet_now_lng'] = lng.toString();
                                          ChangePasswordResponseModel submit= await CallService().updateMeetNowCity(map);
                                          if(submit.status!){
                                            CommonDialog.showToastMessage(submit.message.toString());
                                          }
                                          else{
                                            CommonDialog.showToastMessage(submit.message.toString());
                                          }
                                      }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: Get.height * 0.025),
                                        alignment: Alignment.center,
                                        width: Get.width,
                                        padding: EdgeInsets.only(
                                            top: Get.height * 0.02,
                                            bottom: Get.height * 0.02),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                        child: Text(
                                          "Use Travel Mode",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: StringConstants.poppinsRegular,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );})
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * 0.060,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Container(
                        margin: EdgeInsets.only(left: Get.width*0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/png/delete_travel.png'),
                                SizedBox(width: Get.width*0.03,),
                                Text(
                                  'Travel',
                                  style: TextStyle(
                                      fontSize: Get.height * 0.018,
                                      color: Colors.white,
                                      fontFamily: StringConstants.poppinsRegular,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            IconButton(onPressed: (){

                            }, icon: Icon(Icons.navigate_next,color: Colors.white,))
                          ],
                        ),
                      ),
                    ),
                  ),*/
                              // SizedBox(
                              //   height: Get.height * 0.0005,
                              // ),
                              Text('Traveling soon? Change your location to discover people in other locations'.tr,
                                  style: TextStyle(fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.020, color: AppColors.grayColorNormal, fontFamily: StringConstants.poppinsRegular))
                              /*Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      trackColor: Colors.grey,
                      activeColor:Colors.blue,
                      value: meetNowPassport==1,
                      onChanged: (newValue) async {
                        if(isSubscribe == 0){
                          subscriptionShowDialog();
                        }else{
                          setState(() {
                            meetNowPassport=newValue?1:0;
                          });
                          if(meetNowPassport==1){
                            await Get.toNamed(RouteHelper.getSelectMeetDestination(isSubscribe.toString()));
                            if(c.destinations!.length>0){
                              final form = FormData({});
                              for (int i = 0; i < c.destinations!.length; i++) {
                                if(c.destinations![i].selectedCityId!=0){
                                  form.fields.add(MapEntry(
                                      'userdestinations[' + i.toString() + ']',
                                      c.destinations![i].id.toString()+','+c.destinations![i].selectedCityId.toString()+','+c.destinations![i].selectedContinentId.toString()));
                                }else{
                                  form.fields.add(MapEntry(
                                      'userdestinations[' + i.toString() + ']',
                                      c.destinations![i].id.toString()));
                                }
                              }
                              ChangePasswordResponseModel registerModel = await CallService().updateMeetNowCity(form);
                              if (registerModel.status!) {
                                CommonDialog.showToastMessage(registerModel.message.toString());
                              }
                              else {
                                CommonDialog.showToastMessage(registerModel.message.toString());
                              }
                            }
                          }
                         */ /* var map = new Map<String, dynamic>();
                          map['meet_now_passport'] = meetNowPassport;
                          SettingsUpdateModel submit= await CallService().settingsUpdate(map);
                          if(submit.success!){

                          }
                          else{
                            CommonDialog.showToastMessage(submit.message.toString());
                          }*/ /*
                        }

                      },
                    ),
                  )*/
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.020,
                          ),
                          Text(
                            "Show me".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listShowMe.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (isSubscribe == 0) {
                                        subscriptionShowDialog();
                                      } else {
                                        setState(() {
                                          genderPreference = (index + 1);
                                        });
                                        var map = <String, dynamic>{};
                                        map['gender_preference'] = genderPreference;
                                        SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                        if (submit.success!) {
                                          isFilterChanged = true;

                                          //CommonDialog.showToastMessage(submit.message.toString());
                                        } else {
                                          CommonDialog.showToastMessage(submit.message.toString());
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          listShowMe[index].text.tr,
                                          style: TextStyle(
                                              fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.022,
                                              color: AppColors.backTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants.poppinsRegular),
                                        ),
                                        SvgPicture.asset(((index + 1) == genderPreference) ? 'assets/images/svg/blueTick.svg' : 'assets/images/svg/grayEmpty.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            "Age Between".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Listener(
                            // onPointerDown: (PointerDownEvent event) {
                            //   debugPrint('pointer is down');
                            // },
                            onPointerUp: (v) {
                              Future.delayed(const Duration(milliseconds: 200), () async {
                                isSlidingAge = false;
                              });
                              debugPrint('pointer is up isSlidingAge $isSlidingAge');
                            },

                            child: RangeSlider(
                              values: _currentRangeValues,
                              max: 100,
                              min: 18,
                              inactiveColor: Colors.grey,
                              divisions: 100,
                              onChangeEnd: (range) async {
                                isSlidingAge = true;
                                debugPrint("onChangeEnd");

                                if (isSubscribe == 0) {
                                  subscriptionShowDialog();
                                } else {
                                  Future.delayed(const Duration(milliseconds: 500), () async {
                                    debugPrint("isSlidingAge onChangeEnd $isSlidingAge");
                                    if (!isSlidingAge) {
                                      var map = <String, dynamic>{};
                                      map['min_age'] = range.start;
                                      map['max_age'] = range.end;
                                      SettingsUpdateModel submit = await CallService().settingsUpdate(map, showDialog: true);
                                      if (submit.success!) {
                                        isFilterChanged = true;

                                        // CommonDialog.showToastMessage(submit.message.toString());
                                      } else {
                                        CommonDialog.showToastMessage(submit.message.toString());
                                      }
                                    }
                                  });
                                }
                              },
                              onChanged: (values) {
                                isSlidingAge = true;

                                if (isSubscribe == 0) {
                                  subscriptionShowDialog();
                                } else {
                                  setState(() {
                                    _currentRangeValues = values;
                                  });
                                }
                              },
                            ),
                          ),
                          /*RangeSlider(
                values:  _currentRangeValues,
                min: minAge.toDouble(),
                max: maxAge.toDouble(),
                inactiveColor: Colors.grey,
                divisions: 100,
                onChangeEnd: (range) async {
                  if(isSubscribe == 0){
                    subscriptionShowDialog();
                  }else{
                    var map = new Map<String, dynamic>();
                    map['min_age'] = range.start;
                    map['max_age'] = range.end;
                    SettingsUpdateModel submit= await CallService().settingsUpdate(map);
                    if(submit.success!){
                      CommonDialog.showToastMessage(submit.message.toString());
                    }
                    else{
                      CommonDialog.showToastMessage(submit.message.toString());
                    }
                  }
                },
                onChanged: (values){
                  if(isSubscribe ==0){
                    subscriptionShowDialog();
                  }else{
                    setState(() {
                      //subscriptionShowDialog();
                      _currentRangeValues = values;
                    });
                  }
                },
              ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_currentRangeValues.start.round().toString(), style: const TextStyle(fontFamily: StringConstants.poppinsRegular)),
                              Text(_currentRangeValues.end.round().toString(), style: const TextStyle(fontFamily: StringConstants.poppinsRegular))
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Ethnicity".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                  color: AppColors.backTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: StringConstants.poppinsRegular),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ethnicity.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (isSubscribe == 0) {
                                        subscriptionShowDialog();
                                      } else {
                                        setState(() {
                                          ethnicityPreference = (index + 1);
                                        });
                                        var map = <String, dynamic>{};
                                        map['ethinicity_preference'] = ethnicityPreference;
                                        SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                        if (submit.success!) {
                                          isFilterChanged = true;

                                          // CommonDialog.showToastMessage(submit.message.toString());
                                        } else {
                                          CommonDialog.showToastMessage(submit.message.toString());
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ethnicity[index].text.tr,
                                          style: TextStyle(
                                              fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.022,
                                              color: AppColors.backTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants.poppinsRegular),
                                        ),
                                        SvgPicture.asset(((index + 1) == ethnicityPreference) ? 'assets/images/svg/blueTick.svg' : 'assets/images/svg/grayEmpty.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            "Sexual Orientation".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: sexual.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (isSubscribe == 0) {
                                        subscriptionShowDialog();
                                      } else {
                                        setState(() {
                                          sexualOrientationPreference = (index + 1);
                                        });
                                        var map = <String, dynamic>{};
                                        map['sexual_orientation_preference'] = sexualOrientationPreference;
                                        SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                        if (submit.success!) {
                                          isFilterChanged = true;

                                          // CommonDialog.showToastMessage(submit.message.toString());
                                        } else {
                                          CommonDialog.showToastMessage(submit.message.toString());
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          sexual[index].text.tr,
                                          style: TextStyle(
                                              fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.022,
                                              color: AppColors.backTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants.poppinsRegular),
                                        ),
                                        SvgPicture.asset(((index + 1) == sexualOrientationPreference) ? 'assets/images/svg/blueTick.svg' : 'assets/images/svg/grayEmpty.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            "Trip Style".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: trip.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (isSubscribe == 0) {
                                        subscriptionShowDialog();
                                      } else {
                                        setState(() {
                                          tripStylePreference = (index + 1);
                                        });
                                        var map = <String, dynamic>{};
                                        map['trip_style_preference'] = tripStylePreference;
                                        SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                        if (submit.success!) {
                                          isFilterChanged = true;

                                          //CommonDialog.showToastMessage(submit.message.toString());
                                        } else {
                                          CommonDialog.showToastMessage(submit.message.toString());
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          trip[index].text.tr,
                                          style: TextStyle(
                                              fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.022,
                                              color: AppColors.backTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants.poppinsRegular),
                                        ),
                                        SvgPicture.asset(((index + 1) == tripStylePreference) ? 'assets/images/svg/blueTick.svg' : 'assets/images/svg/grayEmpty.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            "Trip Timeline".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? Get.height * 0.020 : Get.height * 0.025,
                                color: AppColors.backTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: StringConstants.poppinsRegular),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tripTime.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (isSubscribe == 0) {
                                        subscriptionShowDialog();
                                      } else {
                                        setState(() {
                                          tripTimelinePreference = (index + 1);
                                        });
                                        var map = <String, dynamic>{};
                                        map['trip_timeline_preference'] = tripTimelinePreference;
                                        SettingsUpdateModel submit = await CallService().settingsUpdate(map);
                                        if (submit.success!) {
                                          isFilterChanged = true;

                                          // CommonDialog.showToastMessage(submit.message.toString());
                                        } else {
                                          CommonDialog.showToastMessage(submit.message.toString());
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tripTime[index].text.tr,
                                          style: TextStyle(
                                              fontSize: Platform.isIOS ? Get.height * 0.018 : Get.height * 0.022,
                                              color: AppColors.backTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: StringConstants.poppinsRegular),
                                        ),
                                        SvgPicture.asset(((index + 1) == tripTimelinePreference) ? 'assets/images/svg/blueTick.svg' : 'assets/images/svg/grayEmpty.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.010,
                                  )
                                ],
                              );
                            },
                          ),
                          /* SizedBox(height: Get.height*0.015,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.grey.shade200),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                width: Get.width,
                height: Get.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: Get.height*0.020,),
                    InkWell(
                      onTap: (){
                        Get.toNamed(RouteHelper.getLoginPage());
                      },
                      child: Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.height*0.018,
                            color: Colors.black),
                      ),
                    ),

                    Divider(
                      color: AppColors.dividerColor,
                    ),
                    Text(
                      "Delete Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height*0.018,
                          color: AppColors.redTextColor),
                    ),

                    SizedBox(height: Get.height*0.020,),
                  ],
                ),
              ),
              SizedBox(height: Get.height*0.015,),*/
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                    color: Colors.transparent,
                  )),
            if (purchasePending)
              Stack(
                children: const [
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(dismissible: false, color: Colors.grey),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
          ],
        ));
  }

  _onCurrentLocationClick() async {
    var location = loc.Location();
    bool enabled = await location.serviceEnabled();
    if (!enabled) {
      bool gotEnabled = await location.requestService();
      if (gotEnabled) {
        askPermission(callBack: (v) async {
          _handleCurrentLocation();
        });
      }
    } else {
      askPermission(callBack: (v) async {
        _handleCurrentLocation();
      });
    }
  }

  _handleCurrentLocation() async {
    LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyDQoCpGqlcMXZ-hF_yu2-5AKG03tfgI_dw",
              displayLocation: currentLatLon,
            )));
    if (result != null) {
      if (isSubscribe == 0) {
        subscriptionShowDialog();
      } else {
        setState(() {
          currentCity = '${result.name!},${result.country!.shortName!}';
        });
        var map = <String, dynamic>{};
        map['meet_now_address'] = currentCity;
        map['meet_now_lat'] = result.latLng!.latitude.toString();
        map['meet_now_lng'] = result.latLng!.longitude.toString();
        ChangePasswordResponseModel submit = await CallService().updateMeetNowCity(map);
        if (submit.status!) {
          isFilterChanged = true;

          CommonDialog.showToastMessage(submit.message.toString().tr);
        } else {
          CommonDialog.showToastMessage(submit.message.toString().tr);
        }
      }
    }
  }

  _handleSelectLocationCLick() async {
    var location = loc.Location();
    bool enabled = await location.serviceEnabled();
    if (!enabled) {
      bool gotEnabled = await location.requestService();
      if (gotEnabled) {
        askPermission(callBack: (v) async {
          _openAddressPicker();
        });
      }
    } else {
      askPermission(callBack: (v) async {
        _openAddressPicker();
      });
    }
  }

  _openAddressPicker() async {
    const kGoogleApiKey = "AIzaSyCfZpegALCsEMNmepJ8_qz1Bpne55K9X4w";
    // const kGoogleApiKey = "AIzaSyDQoCpGqlcMXZ-hF_yu2-5AKG03tfgI_dw";
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      radius: 10000000,
      types: [],
      strictbounds: false,
      mode: Mode.fullscreen,
      language: "en",
      decoration: InputDecoration(
        hintText: "Where to?".tr,
        hintStyle: TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
      ),
      components: [],
    );

    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId.toString());
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      if (isSubscribe == 0) {
        subscriptionShowDialog();
      } else {
        setState(() {
          currentCity = p.description;
        });
        var map = <String, dynamic>{};
        map['meet_now_address'] = currentCity;
        map['meet_now_lat'] = lat.toString();
        map['meet_now_lng'] = lng.toString();
        print("Meet Now Passport map --> ${map}");
        ChangePasswordResponseModel submit = await CallService().updateMeetNowCity(map);
        if (submit.status!) {
          isFilterChanged = true;
          CommonDialog.showToastMessage(submit.message.toString().tr);
        } else {
          CommonDialog.showToastMessage(submit.message.toString().tr);
        }
      }
    }
  }

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
            description: 'Please allow location access to use the app. Your location is used to determine Travel and Meet Now mode connections',
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
        });
  }
}
