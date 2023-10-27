import 'dart:io';
import 'dart:ui';
import 'package:gagagonew/model/account_delete_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RouteHelper/route_helper.dart';
import '../Service/lang/localization_service.dart';
import 'package:html/parser.dart';
import 'package:gagagonew/constants/color_constants.dart';

class CommonFunctions {
  static callTest()async{
    await initializeDateFormatting(Get.locale!.languageCode, null);

  }
}
