import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/model/apply_coupon_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:get/get.dart';

import 'package:gagagonew/model/package/package_details_model.dart';
import 'package:gagagonew/model/package/package_list_model.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/progress_bar.dart';

class PackageDetailsController extends GetxController {
  var couponController = TextEditingController();
  var notificationCount = 0.obs;
  var readTerms = false.obs;

  var couponDiscount = 0.obs;
  var payableAmount = 0.obs;
  var totalAmount = 0.obs;
  var uiTotalAmount = 0.obs;
  var addons = 0.obs;

  var isReadMoreDays = false.obs;
  var isAddOnExpanded = true.obs;

  var carouselCount = 4.obs;
  var currentPage = 0.obs;
  var indicatorController = PageController(viewportFraction: 1, keepPage: true).obs;

  var packageData = PackageListModelData().obs;
  var cancellationPolicyModel = CancellationPolicyModel().obs;

  var partialPaymentItems = <String>["Pay 20% now", "Pay full amount"].obs;
  var selectedPaymentItem = "Pay 20% now".obs;
  var selectedPaymentItemIndex = 0.obs;

  resetData() {
    couponDiscount.value = 0;
    payableAmount.value = 0;
    totalAmount.value = 0;
    uiTotalAmount.value = 0;
    addons.value = 0;
    selectedPaymentItemIndex.value = 0;
  }

  handlePayableAmount() {
    if (packageData.value.isFirstPaymentDone == 0 && packageData.value.isSecondPaymentDone == 0) {
      if (selectedPaymentItemIndex.value == 0) {
        firstPhaseAmount();
      } else {
        secondPhaseAmount();
      }
    } else {
      secondPhaseAmount();
    }
  }

  firstPhaseAmount() {
    payableAmount.value = packageData.value.firstPaymentAmount ?? 0;
    // packageData.value.paidAmount = payableAmount.value;
  }

  secondPhaseAmount() {
    payableAmount.value = packageData.value.secondPaymentAmount ?? 0;
    // packageData.value.paidAmount = payableAmount.value;
  }

  callPayableAmount() {
    payableAmount.value = packageData.value.totalPrice ?? 0;
    // packageData.value.paidAmount = payableAmount.value;
  }

  int getUiTotalAmount() {
    print("selectedPaymentItemIndex --> ${(addons.value * (20 / 100)).toInt()}");

    // if (packageData.value.isFirstPaymentDone == 0 && packageData.value.isSecondPaymentDone == 0) {
    //   if (selectedPaymentItemIndex.value == 0) {
    //     return (uiTotalAmount.value - couponDiscount.value) + (addons.value * (20 / 100)).toInt();
    //   } else {
    //     return (uiTotalAmount.value - couponDiscount.value) + addons.value;
    //   }
    // } else {
    return (uiTotalAmount.value - couponDiscount.value) + addons.value;
    // }
  }

  int getTotalAmount() {
    if (packageData.value.isFirstPaymentDone == 0 && packageData.value.isSecondPaymentDone == 0) {
      if (selectedPaymentItemIndex.value == 0) {
        return (totalAmount.value - couponDiscount.value) + (addons.value * (20 / 100)).toInt();
      } else {
        return (totalAmount.value - couponDiscount.value) + addons.value;
      }
    } else {
      return (totalAmount.value - couponDiscount.value) + addons.value;
    }
  }

  int getPayAbleAmount() {
    print("couponDiscount.value --> ${couponDiscount.value}");
    int value = 0;
    if (packageData.value.isFirstPaymentDone == 0 && packageData.value.isSecondPaymentDone == 0) {
      if (selectedPaymentItemIndex.value == 0) {
        if (couponDiscount.value > 0) {
          return (getTotalAmount() * (20 / 100)).toInt();
        } else {
          return (payableAmount.value) + (addons.value * (20 / 100)).toInt();
        }
      } else {
        return (payableAmount.value) + addons.value;
      }
    } else {
      return (payableAmount.value) + addons.value;
    }
  }

  // Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? mapController;

  var kGoogle = const CameraPosition(
    target: LatLng(39.953388, -74.198151),
    zoom: 14.4746,
  ).obs;

  // on below line we have created list of markers
  RxList<Marker> mapMarker = <Marker>[].obs;

  callPackageDetailsApi({bool showLoader = true, required dynamic id}) async {
    if (await CommonFunctions.checkInternet()) {
      PackageDetailsModel packageListModel = await CallService().hitPackagesDetailsApi(id: id, showLoader: showLoader);
      if (packageListModel.status == 200) {
        if (packageListModel.data != null) {
          packageData.value = packageListModel.data!;
          cancellationPolicyModel.value = packageListModel.cancellationPolicyModel!;
          totalAmount.value = packageData.value.totalPrice ?? 0;
          uiTotalAmount.value = packageData.value.totalPrice ?? 0;

          addons.value = 0;
          for (var element in packageData.value.services!) {
            if (element.isApplied == 1) {
              addons.value = addons.value + element.service!.price!;
            }
          }
          handlePayableAmount();
          createIcons(Get.overlayContext!);
        }
      } else {
        CommonDialog.showToastMessage(packageListModel.message.toString());
      }
    }
  }

  //hit api for get tripe list
  cancelMyTripeApi({required var map, Function? callback}) async {
    if (await CommonFunctions.checkInternet()) {

      final responseModel = await CallService().cancelTrip(
        map,
      );
      if (responseModel.status == 200) {
        CommonDialog.showToastMessage(responseModel.message.toString());
        if (callback != null) {
          callback();
        }
      } else {
        CommonDialog.showToastMessage(responseModel.message.toString());
      }
    }
  }

  Future<void> createIcons(BuildContext context) async {
    if (packageData.value.itineraries != null) {
      var count = 1;
      for (int i = 0; i < packageData.value.itineraries!.length; i++) {
        var element = packageData.value.itineraries![i];


        if (element.lat != null && element.lng != null) {
          mapMarker.add(Marker(
            markerId: MarkerId('$count'),
            // icon: await bitmapDescriptorFromSvgAsset(context, element.title ?? ""),
            position: LatLng(double.parse(element.lat!), double.parse(element.lng!)),
          ));
          count = count + 1;
        }
      }
    }

    print("mapMarker length ${mapMarker.length}");
    if (mapMarker.isNotEmpty) {
      // final c = await mapController.future;
      double minLat = double.infinity;
      double maxLat = -double.infinity;
      double minLng = double.infinity;
      double maxLng = -double.infinity;

      // Calculate bounds to fit all markers
      for (Marker marker in mapMarker) {
        double lat = marker.position.latitude;
        double lng = marker.position.longitude;

        minLat = lat < minLat ? lat : minLat;
        maxLat = lat > maxLat ? lat : maxLat;
        minLng = lng < minLng ? lng : minLng;
        maxLng = lng > maxLng ? lng : maxLng;
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      // Calculate padding to ensure all markers are fully visible
      const double padding = 50.0; // Adjust this padding as needed

      if (mapController != null) {
        // Move camera to fit all markers within the visible region
        mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
      }
/*
        double minLat = double.infinity;
        double maxLat = -double.infinity;
        double minLng = double.infinity;
        double maxLng = -double.infinity;

        // Calculate bounds to fit all markers
        for (Marker marker in mapMarker) {
          double lat = marker.position.latitude;
          double lng = marker.position.longitude;

          minLat = lat < minLat ? lat : minLat;
          maxLat = lat > maxLat ? lat : maxLat;
          minLng = lng < minLng ? lng : minLng;
          maxLng = lng > maxLng ? lng : maxLng;
        }

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );

        LatLng center = LatLng(
          (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
          (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
        );

        // Calculate camera position to show all markers
        CameraPosition cameraPosition = CameraPosition(
          target: center,
          zoom: CommonFunctions.calculateZoomLevel(bounds), // Adjust this value as needed
        );

        if (mapController != null) {
          // Move camera to calculated position
          mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        }*/
    }
  }

  callApplyCoupon({required dynamic id}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (await CommonFunctions.checkInternet()) {
      var map = {"package_id": id, "coupon_code": couponController.text.trim()};

      ApplyCouponResponse responseModel = await CallService().hitApplyCouponApi(
        body: map,
      );
      if (responseModel.status == 200) {
        if (responseModel.discountType == "Amount") {
          if (responseModel.discount != null) {
            packageData.value.couponDiscount = responseModel.discount!;
            couponDiscount.value = packageData.value.couponDiscount!;
          }
          packageData.value.appliedCouponCode = couponController.text.trim();
        } else if (responseModel.discountType == "Percentage") {
          if (responseModel.discount != null) {
            var discount = responseModel.discount!;
            var rawAmount = (packageData.value.totalPrice! * (discount / 100)).toInt();
            packageData.value.couponDiscount = rawAmount;
            couponDiscount.value = packageData.value.couponDiscount!;

            packageData.refresh();
            packageData.value.appliedCouponCode = couponController.text.trim();
          }
        }
        CommonDialog.showToastMessage(responseModel.message.toString());
      } else {
        CommonDialog.showToastMessage(responseModel.message.toString());
      }
    }
  }

//   Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(BuildContext context, String price) async {
//     // Read SVG file as String
//     // String svgString = await DefaultAssetBundle.of(context).loadString(assetName,);
//     // Create DrawableRoot from SVG String
//
//     String text = price;
//     if (price.length > 6) {
//       text = price.substring(0, 5);
//     }
//     String svgStrings1 = '''<svg width="75" height="50" xmlns="http://www.w3.org/2000/svg">
//
//   <path stroke="#001EFF" id="svg_1" d="m74.14781,0.22566l-73.83144,-0.00774l0,31.59256l30.27788,0l5.12395,17.65467c0.04658,0.00774 3.86625,-17.02746 3.86625,-17.02746c0,0 34.48279,0 34.42362,-0.00774c0.00739,0.00097 0.01513,-0.5015 0.02299,-1.38155c0.00393,-0.44003 0.0079,-0.97446 0.01188,-1.58755c0.00398,-0.61309 0.00796,-1.30486 0.01193,-2.05955c0.02677,-7.20252 0.04414,-12.03835 0.05589,-15.41562c0.01175,-3.37727 0.0179,-5.29597 0.02223,-6.66423c0.00433,-1.36826 0.00686,-2.18608 0.00844,-2.71689c0.00158,-0.53081 0.00223,-0.77459 0.00281,-0.99479c0.00058,-0.2202 0.00109,-0.4168 0.00154,-0.58784c0.00044,-0.17104 0.00082,-0.31653 0.00112,-0.4345c0.0003,-0.11796 0.00053,-0.2084 0.00069,-0.26935c0.00015,-0.06095 0.00023,-0.0924 0.00023,-0.0924c-0.0102,3.52301 -0.01745,6.03945 -0.02249,7.80293c-0.00505,1.76348 -0.00789,2.77399 -0.00928,3.28516c-0.00139,0.51116 -0.00132,0.52297 -0.00054,0.28903c0.00077,-0.23394 0.00225,-0.71362 0.0037,-1.18544c0.00144,-0.47182 0.00284,-0.93578 0.00419,-1.38991c0.00135,-0.45413 0.00266,-0.89844 0.00393,-1.33095c0.00126,-0.43251 0.00248,-0.85323 0.00364,-1.26018c0.00116,-0.40696 0.00228,-0.80015 0.00334,-1.17762c-0.02728,9.05903 -0.02086,7.04596 -0.0151,5.15867c0.00576,-1.88729 0.01086,-3.64879 0.0151,-5.15867c0.00848,-3.01976 0.01351,-5.03301 0.01351,-5.03301z" stroke-width="0.5" fill="#3797F0"/>
//   <text  y="18.77155" x="10.02531" fill="#ffffff">$text</text>
//
// </svg>''';
//
//     String svgStrings = '''<svg width="41" height="29" viewBox="0 0 41 29" fill="none" xmlns="http://www.w3.org/2000/svg">
// <rect width="41" height="20" rx="4" fill="#3797F0"/>
// <path d="M19.634 27.0042C20.0189 27.6708 20.9811 27.6708 21.366 27.0042L25.3316 20.1356C25.7165 19.4689 25.2354 18.6356 24.4656 18.6356H16.5344C15.7646 18.6356 15.2835 19.4689 15.6684 20.1356L19.634 27.0042Z" fill="#3797F0"/>
//   <text  y="18.77155" x="15.02531" fill="#ffffff">$price</text>
//
// </svg>
// ''';
//     DrawableRoot svgDrawableRoot = await svg.fromSvgString(
//       svgStrings1,
//       "",
//     );
//
//     // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
//     MediaQueryData queryData = MediaQuery.of(context);
//     double devicePixelRatio = queryData.devicePixelRatio;
//     double width = 75 * devicePixelRatio; // where 32 is your SVG's original width
//     double height = 50 * devicePixelRatio; // same thing
//
//     // Convert to ui.Picture
//     ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
//
//     // Convert to ui.Image. toImage() takes width and height as parameters
//     // you need to find the best size to suit your needs and take into account the
//     // screen DPI
//     ui.Image image = await picture.toImage(width.toInt(), height.toInt());
//     ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
//     return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
//   }
}

class PackageItem {
  List? images;

  PackageItem({this.images});
}

class ItemDetails {
  String? title;
  bool? isSelected;

  ItemDetails({this.title, this.isSelected});
}
