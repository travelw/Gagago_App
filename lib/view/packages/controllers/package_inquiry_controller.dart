import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageInquiryController extends GetxController {
  var showAboutMe = true.obs;
  var counterText = '500 '.obs;

  var inputFieldController = TextEditingController(text: "").obs;
}
