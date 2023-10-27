import 'package:flutter/material.dart';
import 'package:gagagonew/model/package/package_list_model.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:get/get.dart';

import '../../../Service/call_service.dart';
import '../../../utils/progress_bar.dart';

class PackageListController extends GetxController {
  var notificationCount = 0.obs;

  var searchController = TextEditingController().obs;

  var carouselCount = 4.obs;
  var currentPage = 0.obs;


  RxList<PackageListModelData> packageListItems = <PackageListModelData>[].obs;
  var packageList = [
    PackageItem(currentIndex: 0, images: [
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
    ]),
    PackageItem(currentIndex: 0, images: [
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
    ]),
    PackageItem(currentIndex: 0, images: [
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
      ItemDetails(title: "assets/images/png/dummy_img_package.png"),
    ]),
  ].obs;

  Future<void> refreshPackageList() async {
    callPackageListApi(showLoader: true);
  }

  callPackageListApi({bool showLoader = true}) async {
    debugPrint("callPackageListApi: ");
    if (await CommonFunctions.checkInternet()) {
      var map = <String, dynamic>{};
      debugPrint("callPackageListApi: $map");
      PackageListModel packageListModel = await CallService()
          .hitPackagesListApi(map,
              showLoader: showLoader, keyword: searchController.value.text);
      if (packageListModel.status == 200) {
        packageListItems.clear();
        packageListItems.addAll(packageListModel.data ?? []);
      } else {
        CommonDialog.showToastMessage(packageListModel.message.toString());
      }
    }
  }
}

class PackageItem {
  List<ItemDetails>? images;
  int? currentIndex;

  PackageItem({this.images, this.currentIndex});
}

class ItemDetails {
  final String? title;

  ItemDetails({
    this.title,
  });
}
