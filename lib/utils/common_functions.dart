import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
// import 'package:exif/exif.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gagagonew/model/account_delete_model.dart';
import 'package:gagagonew/model/error_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/dialogs/common_alert_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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

import 'internet_connection_checker.dart';

class CommonFunctions {
  static durationToString(String dateTime) {
    DateTime tempDate = DateTime.parse(dateTime);

    final date2 = DateTime.now();
    final d = date2.difference(tempDate);

    List<String> parts = d.toString().split(':');
    // print("parts--> $parts");
    String time = "";
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    // int seconds  = int.parse(parts[2]);

    if (hours < 1 && minutes < 1) {
      int rawTime = double.parse(parts[2]).toInt();
      time = '${(rawTime / 60).ceil()}s ago';
    } else if (hours < 1 && (minutes >= 1 && minutes < 2)) {
      // time = '${parts[1].padLeft(2, '0')}m ago';
      time = '${minutes}m ago';
    } else if (hours < 1 && (minutes <= 1 && minutes > 60)) {
      time = '${minutes}m ago';
      // time = '${parts[1].padLeft(2, '0')}m ago';
    } else if (hours == 1 && minutes <= 60) {
      time = '${hours}h ago';
      // time = '${parts[0].padLeft(2, '0')}h ago';
    } else if (hours == 2 && minutes <= 60) {
      time = '${hours}h ago';
      // time = '${parts[0].padLeft(2, '0')}h ago';
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final aDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      if (aDate == today) {
        time = DateFormat.jm().format(tempDate); //5:08 PM
      } else if (aDate == yesterday) {
        time = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      } else {
        final DateFormat formatter = DateFormat('MMM dd yyyy');
        time = formatter.format(now);
      }
    }

    return time;
  }

  static dayDurationToString(String dateTime, BuildContext context, {bool toLocal = true}) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    DateTime tempDate;

    if (toLocal) {
      tempDate = DateTime.parse(dateTime).toLocal();
    } else {
      tempDate = DateTime.parse(dateTime);
    }

    print("dateTime --> $dateTime tempDate $tempDate");

    final date2 = DateTime.now();
    final d = date2.difference(tempDate);

    List<String> parts = d.toString().split(':');
    // print("parts--> $parts");
    String time = "";
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    final today = DateTime(date2.year, date2.month, date2.day);
    final yesterday = DateTime(date2.year, date2.month, date2.day - 1);

    final aDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
    if (aDate == today) {
      if (hours < 1 && minutes < 1) {
        time = "Now".tr;
      } else if (hours < 1 && (minutes >= 1 && minutes < 2)) {
        // time = '${parts[1].padLeft(2, '0')}m ago';
        time = "Now".tr;
      } else {
        time = "Today".tr;
      }
      print("nowwwww--->> $dateTime tempDate -> $tempDate");
    } else if (aDate == yesterday) {
      time = "Yesterday".tr;
    } else {
      final now = DateTime.now();
      final DateFormat formatter = DateFormat('MMM dd, yyyy', tag);
      time = formatter.format(DateTime.parse(dateTime));
      print("time of chat list ${time}");
    }

    return time;
  }

  static String formatDateMMddYYYY(String date) {
    if (date.contains("/")) {
      return date;
    }
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  Future<int> getIdFromDeviceLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? langId = prefs.getInt(StringConstants.LANGUAGE_ID);
    print("currentLocale $langId");

    if (langId != null) {
      return langId;
    }

    Locale currentLocale = Get.locale ?? StringConstants.LOCALE_ENGLISH;
    langId = 1;
    if (currentLocale.languageCode == StringConstants.LOCALE_ENGLISH.languageCode) {
      langId = 1;
    } else if (currentLocale.languageCode == StringConstants.LOCALE_SPANISH.languageCode) {
      langId = 2;
    } else if (currentLocale.languageCode == StringConstants.LOCALE_PURTUGUESE.languageCode || currentLocale.languageCode == StringConstants.LOCALE_PURTUGUESE_Brasil.languageCode) {
      print("Device Lang $currentLocale");
      langId = 4;
    } else if (currentLocale.languageCode == StringConstants.LOCALE_FRENCH.languageCode) {
      langId = 7;
    } else {
      langId = 1;
    }

    print("langId= $langId");
    return langId;
  }

  void updateLanguage(int id, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (id == 1) {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 1);
    } else if (id == 2) {
      Get.locale = StringConstants.LOCALE_SPANISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_SPANISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_SPANISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 2);
    } else if (id == 4) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_PURTUGUESE_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 4);
    } else if (id == 4) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE_Brasil;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_Brasil_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_PURTUGUESE_Brasil_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 4);
    } else if (id == 7) {
      Get.locale = StringConstants.LOCALE_FRENCH;
      LocalizationService.changeLocale(StringConstants.LOCALE_FRENCH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_FRENCH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 7);
    } else {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 1);

      // SessionManager.setLocale(Utils.LOCALE_ENGLISH_KEY);
    }

    String currentLang = await prefs.getString(StringConstants.CURRENT_LOCALE) ?? "";
    print(" currentLangcurrentLang --> $currentLang");
    // updateLanguageApi(context);
  }

  static getIdFromLangCode(String languageCode) {
    if (languageCode == StringConstants.LOCALE_ENGLISH.languageCode) {
      return 1;
    } else if (languageCode == StringConstants.LOCALE_SPANISH.languageCode) {
      return 2;
    } else if (languageCode == StringConstants.LOCALE_PURTUGUESE.languageCode || languageCode == StringConstants.LOCALE_PURTUGUESE_Brasil.languageCode) {
      return 4;
    } else if (languageCode == StringConstants.LOCALE_FRENCH.languageCode) {
      return 7;
    } else {
      return 1;
    }
    // }
  }

  void updateLanguageByCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (code == StringConstants.LOCALE_ENGLISH.languageCode) {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 1);
    } else if (code == StringConstants.LOCALE_SPANISH.languageCode) {
      Get.locale = StringConstants.LOCALE_SPANISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_SPANISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_SPANISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 2);
    } else if (code == StringConstants.LOCALE_PURTUGUESE.languageCode) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_PURTUGUESE_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 4);
    } else if (code == StringConstants.LOCALE_PURTUGUESE_Brasil.languageCode) {
      Get.locale = StringConstants.LOCALE_PURTUGUESE_Brasil;
      LocalizationService.changeLocale(StringConstants.LOCALE_PURTUGUESE_Brasil_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_PURTUGUESE_Brasil_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 4);
    } else if (code == StringConstants.LOCALE_FRENCH.languageCode) {
      Get.locale = StringConstants.LOCALE_FRENCH;
      LocalizationService.changeLocale(StringConstants.LOCALE_FRENCH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_FRENCH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 7);
    } else {
      Get.locale = StringConstants.LOCALE_ENGLISH;
      LocalizationService.changeLocale(StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setString(StringConstants.CURRENT_LOCALE, StringConstants.LOCALE_ENGLISH_KEY);
      prefs.setInt(StringConstants.LANGUAGE_ID, 1);

      // SessionManager.setLocale(Utils.LOCALE_ENGLISH_KEY);
    }

    String currentLang = prefs.getString(StringConstants.CURRENT_LOCALE) ?? "";
    print(" currentLangcurrentLang --> $currentLang");
    // updateLanguageApi(context);
  }

  Future<dynamic> getRecordPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var directory = await Directory(appDocDirectory.path + '/' + 'dir').create(recursive: false);

    // final path = io.Directory("storage/emulated/0/$folderName");
    if ((await directory.exists())) {
      print("exist");
    } else {
      print("not exist");
    }
    return directory.path;
  }

  Future<dynamic> getRecordPath2() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var directory = await Directory(appDocDirectory.path + '/' + 'dir').create(recursive: false);

    // final path = io.Directory("storage/emulated/0/$folderName");
    if ((await directory.exists())) {
      print("exist");
    } else {
      print("not exist");
    }
    return directory.path;
  }

  Future<dynamic> getRecordPathU() async {
    String folderName = "Gagago";
    var directory = await Directory('storage/emulated/0/$folderName').create(recursive: true);

    // final path = io.Directory("storage/emulated/0/$folderName");
    if ((await directory.exists())) {
      print("exist");
    } else {
      print("not exist");
    }
    return directory;
  }

  Future<String> createFolder(String name) async {
    final dir = Directory('${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory() //FOR IOS
        )!.path}/$name');

    // dir.deleteSync(recursive: true);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }

  static Future<File> createImageCopy(File image, String name) async {
    final dir = Directory((Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory() //FOR IOS
        )!
        .path);

// copy the file to a new path
    return await image.copy('$dir/$name');
  }

  //here goes the function
  static String parseHtmlString(String? htmlString) {
    if (htmlString == null) {
      return "";
    }
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static void checkSessionUnAuthorized(var error) async {
    if (error is DioError) {
      DioError dioError = error;
      print('DioErrorCheck======>${dioError.response}, ${dioError.response?.statusCode}, ${dioError.error}');
      if (dioError.response != null && dioError.response?.statusCode == 401) {
        try {
          ErrorModel model = errorModelFromJson(json.encode(dioError.response!.data));
          showSessionOutDialog(model.messageTitle, model.messageCaption);
        } catch (e) {
          print("e --> $e");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? accessToken = prefs.getString('userToken');
          if (accessToken != null) {
            sessionOut();
          }
        }
        // showSessionOutDialog('Alert'.tr, "");
        // showSessionDialog();

        //  WidgetUtils.checkUnAuthorized(ApiConstants.context!);
      }
    } else {
      print("Exception checkUnAuthorized: ${error.toString()}");
    }
  }

  static sessionOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? currentLocal = prefs.getString(StringConstants.CURRENT_LOCALE);
    // int? languageId = prefs.getInt(StringConstants.LANGUAGE_ID);

    for (String key in prefs.getKeys()) {
      if (key != "email" && key != "password" && key != 'remember_me'
          // &&
          // key != StringConstants.LANGUAGE_ID &&
          // key != StringConstants.CURRENT_LOCALE
          ) {
        prefs.remove(key);
      }
    }

    // if (languageId != null) {
    //   prefs.setInt(StringConstants.LANGUAGE_ID, languageId);
    // }
    // if (currentLocal != null) {
    //   prefs.setString(StringConstants.CURRENT_LOCALE, currentLocal);
    // }
    Get.offAllNamed(RouteHelper.getLoginPage());
  }

  static void checkUnAuthorized(var res) async {
    try {
      AccountDeleteModel resModel = AccountDeleteModel.fromJson(res.body);
      if (resModel.messageCaption != null && resModel.messageTitle != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? currentLocal = prefs.getString(StringConstants.CURRENT_LOCALE);
        int? languageId = prefs.getInt(StringConstants.LANGUAGE_ID);

        for (String key in prefs.getKeys()) {
          if (key != "email" && key != "password" && key != 'remember_me' && key != StringConstants.LANGUAGE_ID && key != StringConstants.CURRENT_LOCALE) {
            prefs.remove(key);
          }
        }

        if (languageId != null) {
          prefs.setInt(StringConstants.LANGUAGE_ID, languageId);
        }
        if (currentLocal != null) {
          prefs.setString(StringConstants.CURRENT_LOCALE, currentLocal);
        }

        showSessionOutDialog(resModel.messageTitle!, resModel.messageCaption!);
      }
    } catch (e) {
      print(e);
    }
  }

  static void showSessionOutDialog(String title, String desc, {Function? callBack}) {
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: CommonAlertDialog(
              title: title,
              description: desc,
              callback: () {
                if (callBack != null) {
                  callBack();
                } else {
                  sessionOut();
                  // Get.offAllNamed(RouteHelper.getLoginPage());
                }
              },
            ));

        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // contentPadding: EdgeInsets.all(5) ,
              title: Text(title, style: TextStyle(color: AppColors.backTextColor, fontSize: Get.height * 0.022, fontWeight: FontWeight.w700, fontFamily: 'PoppinsRegular')),
              content: Text(desc, style: TextStyle(color: AppColors.backTextColor, fontSize: Get.height * 0.020, fontWeight: FontWeight.w300, fontFamily: 'PoppinsRegular')),
              actions: [
                Column(
                  children: [
                    SizedBox(height: 5),
                    Divider(
                      height: 1,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (callBack != null) {
                            callBack();
                          } else {
                            sessionOut();
                            // Get.offAllNamed(RouteHelper.getLoginPage());
                          }
                        },
                        child: Text(
                          "Ok".tr,
                          style: TextStyle(color: Colors.black, fontSize: Get.height * 0.020, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // content: Text("Credentials not matced in our records!"),
            ));
      },
    );
  }

  static callTest() async {
    await initializeDateFormatting(Get.locale!.languageCode, null);
  }

  static String getDate(String? dateTime, {String opFormat = "yyyy-MM-dd"}) {
    if (dateTime == null) {
      return "";
    }
    var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime).toLocal();
    String value = DateFormat(
      opFormat,
    ).format(date);

    print("under getHH_MM value $value");

    return value;
  }

  static String getHH_MM(String time) {
    print("under getHH_MM $time");

    var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(time, true).toLocal();

    String value = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(date);

    print("under getHH_MM value $value");

    return value;
  }

  static String getHH_MM24(String? time) {
    print("under getHH_MM $time");

    if (time == null) {
      return "";
    }
    var date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(time, true).toLocal();

    // String value = DateFormat(
    //   'HH:mm',
    // ).format(date);

    String value = DateFormat.Hm().format(date);
    return value;
  }

  Future<String> getFilePath(String fileName) async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${fileName}.mp3";
  }

  static String formatChatTimerNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  static String getMM_ss(Duration d) {
    DateTime time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, d.inHours, d.inMinutes, d.inSeconds);
    print(time);
    final DateFormat formatter = DateFormat('mm:ss');

    return formatter.format(time);
  }

  checkDeviceVersion() {
    // if (Platform.isAndroid) {
    //   var androidInfo = await DeviceInfoPlugin().androidInfo;
    //   var release = androidInfo.version.release;
    //   var sdkInt = androidInfo.version.sdkInt;
    //   var manufacturer = androidInfo.manufacturer;
    //   var model = androidInfo.model;
    //   print('Android $release (SDK $sdkInt), $manufacturer $model');
    //   // Android 9 (SDK 28), Xiaomi Redmi Note 7
    // }
  }

  static convertDateToString(DateTime date) {
    return DateFormat('YYYY-MM-DD HH:MM:SS').format(date.toLocal());
  }

  // 2. compress file and get file.
  static Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 25,
    );

    print(file.lengthSync());
    // print(result.lengthSync());

    return result;
  }

  static String getLanguageText({
    required String englishText,
    required String spanishText,
    required String portoText,
    required String frenchText,
  }) {
    if (Get.locale!.languageCode == StringConstants.LOCALE_ENGLISH.languageCode) {
      return englishText;
    } else if (Get.locale!.languageCode == StringConstants.LOCALE_PURTUGUESE.languageCode) {
      return portoText;
    } else if (Get.locale!.languageCode == StringConstants.LOCALE_SPANISH.languageCode) {
      return spanishText;
    } else if (Get.locale!.languageCode == StringConstants.LOCALE_FRENCH.languageCode) {
      return frenchText;
    } else {
      return englishText;
    }
  }

  // Format File Size
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    final kb = bytes / 1024;
    final mb = kb / 1024;

    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

/*
  static Future<void> applyRotationFix(String originalPath) async {
    try {
      Map<String, IfdTag> data = await readExifFromFile(File(originalPath));
      print(data);

      int length = int.parse(data['EXIF ExifImageLength'].toString());
      int width = int.parse(data['EXIF ExifImageWidth'].toString());
      String orientation = data['Image Orientation'].toString();

      if (length != null && width != null && orientation != null) {
        if (length > width) {
          if (orientation.contains('Rotated 90 CW')) {
            img.Image? original = img.decodeImage(File(originalPath).readAsBytesSync());
            img.Image fixed = img.copyRotate(original!, angle: -90);
            File(originalPath).writeAsBytesSync(img.encodeJpg(fixed));
          } else if (orientation.contains('Rotated 180 CW')) {
            img.Image? original = img.decodeImage(File(originalPath).readAsBytesSync());
            img.Image fixed = img.copyRotate(original!, angle: -180);
            File(originalPath).writeAsBytesSync(img.encodeJpg(fixed));
          } else if (orientation.contains('Rotated 270 CW')) {
            img.Image? original = img.decodeImage(File(originalPath).readAsBytesSync());
            img.Image fixed = img.copyRotate(original!, angle: -270);
            File(originalPath).writeAsBytesSync(img.encodeJpg(fixed));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
*/

  static Future<bool> checkInternet() async {
    var isConnect = await checkConnectivity();
    if (isConnect == ConnectivityResult.mobile) {
      return true;
    } else if (isConnect == ConnectivityResult.wifi) {
      return true;
    } else {
      CommonDialog.showToastMessage("No Internet Available!!!!!".tr);
      return false;
    }
  }

  static convertDateToDDMMMYYY(DateTime? date) {
    return date == null ? "" : DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  static String calculateDatesDifference(
    DateTime? date1,
    DateTime? date2,
  ) {
    if (date1 == null && date2 == null) return "";
    final difference = date2!.difference(date1!).inDays + 1;

    return difference.toString();
  }

  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // in meters

    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLng = (lng2 - lng1) * (3.141592653589793 / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (3.141592653589793 / 180)) * cos(lat2 * (3.141592653589793 / 180)) * sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double getZoomFromDistance(double distance, double screenSize, double padding) {
    const double metersPerPixel = 156543.03392; // Earth's radius * 2 * PI / 256 / screen size in pixels
    double zoomLevel = (log(metersPerPixel * screenSize / (distance + 2 * padding)) / log(2.0));
    return zoomLevel;
  }

  static double calculateZoomLevel(LatLngBounds bounds) {
    const double padding = 10.0; // Adjust this padding as needed

    double screenSize = MediaQuery.of(Get.overlayContext!).size.shortestSide;
    double zoomLevel = 0;

    double distance = CommonFunctions.calculateDistance(
      bounds.southwest.latitude,
      bounds.southwest.longitude,
      bounds.northeast.latitude,
      bounds.northeast.longitude,
    );

    if (distance > 0) {
      zoomLevel = CommonFunctions.getZoomFromDistance(distance, screenSize, padding);
    }

    print("zoomLevel --> $zoomLevel");
    return zoomLevel;
  }

  static String formatPriceWithComma(String? valueD) {
    if (valueD == null) {
      return "";
    }

    if (valueD == "null") {
      return "";
    }
    var f = NumberFormat("###,###", "en_US");
    var value = f.format(int.parse(valueD!));

    print("");
    return value;
  }
}
