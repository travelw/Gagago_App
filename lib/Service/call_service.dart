import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/account_delete_model.dart';
import 'package:gagagonew/model/advertisement_response_model.dart';
import 'package:gagagonew/model/block_user_model.dart';
import 'package:gagagonew/model/change_password_response_model.dart';
import 'package:gagagonew/model/chat_by_user_model.dart';
import 'package:gagagonew/model/chat_list_model.dart';
import 'package:gagagonew/model/check_email_model.dart';
import 'package:gagagonew/model/destination_model.dart';
import 'package:gagagonew/model/edit_details_response_model.dart';
import 'package:gagagonew/model/edit_profile_model.dart';
import 'package:gagagonew/model/email_update_response_model.dart';
import 'package:gagagonew/model/enable_subscription_response_model.dart';
import 'package:gagagonew/model/feedback_response_model.dart';
import 'package:gagagonew/model/forget_password_model.dart';
import 'package:gagagonew/model/image_reorder_model.dart';
import 'package:gagagonew/model/interests_model.dart';
import 'package:gagagonew/model/invite_content_response_model.dart';
import 'package:gagagonew/model/login_model.dart';
import 'package:gagagonew/model/match_profile_response_model.dart';
import 'package:gagagonew/model/notification_response_model.dart';
import 'package:gagagonew/model/package/my_trips_model.dart';
import 'package:gagagonew/model/package/package_list_model.dart';
import 'package:gagagonew/model/profile_verification_model.dart';
import 'package:gagagonew/model/register_model.dart';
import 'package:gagagonew/model/reset_password_model.dart';
import 'package:gagagonew/model/settings_model.dart';
import 'package:gagagonew/model/settings_update_model.dart';
import 'package:gagagonew/model/simple_api_response.dart';
import 'package:gagagonew/model/submit_review_model.dart';
import 'package:gagagonew/model/total_refferal_response_model.dart';
import 'package:gagagonew/model/update_profile_model.dart';
import 'package:gagagonew/model/user_liked_list_response_model.dart';
import 'package:gagagonew/model/user_subscription_model_response.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ads_click_model.dart';
import '../model/apply_coupon_response.dart';
import '../model/block_list_response_model.dart';
import '../model/connection_remove_model.dart';
import '../model/connection_response_model.dart';
import '../model/contact_us_response_model.dart';
import '../model/delete_image_model.dart';
import '../model/other_user_profile_response_model.dart';
import '../model/package/cancellation_policy_response.dart';
import '../model/package/package_details_model.dart';
import '../model/privacy_policy_response_model.dart';
import '../model/readNotificationResponse.dart';
import '../model/review_list_model.dart';
import '../model/status_update.dart';
import '../model/subscription_Response_Model.dart';
import '../model/terms_and_condition_response_model.dart';
import '../model/unblock_response_model.dart';
import '../model/update_language_model.dart';
import '../model/upload_file.dart';
import '../model/user_dashboard_response_model.dart';
import '../model/user_like_model.dart';
import '../model/user_log_out_response_model.dart';
import '../model/user_mode_response_model.dart';
import '../model/user_profile_model.dart';
import '../utils/progress_bar.dart';

class CallService {
  static dio.BaseOptions options = dio.BaseOptions(
    receiveTimeout: const Duration(minutes: 3),
    connectTimeout: const Duration(minutes: 3),
  );
  final dio.Dio _dio = dio.Dio(options);

  CallService() {
    // _dio.interceptors.add(LoggingInterceptor());
  }

  //String apiBaseUrl = "https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/";

  //2nd Live url
  // String apiBaseUrl = "https://api-v2.gagagoapp.com/api/";
  String apiBaseUrl = "https://api.gagagoapp.com/api/"; //Live

  // String imageBaseUrl = "https://api.gagagoapp.com/message_files/";
  String imageBaseUrl = "https://api-v2.gagagoapp.com/message_files/";

  // String? baseUrl ='https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/';

  static String socketUrl = "https://chat.gagagoapp.com/"; // LIVE SOCKET
  // static String socketUrl = "http://server3.rvtechnologies.in:3003/"; // TESTING SOCKET

  //1). For Login User
  Future<LoginModel> login(BuildContext context, dynamic body) async {
    try {
      CommonDialog.showLoading();

      print('${apiBaseUrl}login');
      var res = await _dio.post('${apiBaseUrl}login', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      //  var res = await post('${apiBaseUrl}${httpClient.baseUrl}login', body,  dio.Options(headers: {'accept': 'application/json'});

      print('login $body');
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        var response = LoginModel.fromJson(res.data);
        debugPrint("loginResponse ${json.encode(response)}");
        if (response.success!) {
          String? data = response.accessToken;
          /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userToken', data!);
          prefs.setInt(StringConstants.LANGUAGE_ID, int.parse(response.data?.preferredLang ?? "1"));

          if (response.data?.preferredLang != null) {
            CommonFunctions().updateLanguage(int.parse(response.data?.preferredLang ?? "1"), context);
          } else {
            CommonFunctions().updateLanguage(1, context);
          }

          prefs.setString('userId', response.data!.id.toString());
          prefs.setString('userFirstName', response.data?.firstName.toString() ?? "");
          prefs.setString('userLastName', response.data?.lastName.toString() ?? "");
          prefs.setString('notificationEnabled', response.data?.notificationEnabled.toString() ?? "");
          prefs.setString('matchNotificationEnabled', response.data?.matchNotification.toString() ?? "");
          prefs.setString('chatNotificationEnabled', response.data?.messageNotification.toString() ?? "");
          prefs.setString('refferalCode', response.data?.referralKey.toString() ?? "");
          debugPrint(data);
          return response;
        } else {
          if (response.deactivation ?? false) {
            CommonFunctions.showSessionOutDialog(response.messageTitle ?? "Error".tr /*"We\'ll miss you!".tr*/, response.message ?? "", callBack: () {
              Get.back();
            });
            throw "Error Occurred";
          } else {
            CommonDialog.hideLoading();
            CommonDialog.showErrorDialog(title: response.messageTitle ?? "Alert".tr, description: response.message.toString());
            //  CommonDialog.showToastMessage(response.message.toString());
            throw "Error Occurred";
          }
        }
      }
      /*else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.data}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } */
      else {
        CommonDialog.hideLoading();

        throw "Error Occurred";
      }
    }
    /*on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } */ /*on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    }*/
    catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //1). For Login User
  Future<LoginModel> checkSocialLogin(BuildContext context, dynamic body) async {
    // try {
    CommonDialog.showLoading();

    print('${apiBaseUrl}social-login');
    var res = await _dio.post('${apiBaseUrl}social-login', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
    //  var res = await post('${apiBaseUrl}${httpClient.baseUrl}login', body,  dio.Options(headers: {'accept': 'application/json'});

    print('login $body');
    if (res.statusCode == 200) {
      CommonDialog.hideLoading();
      var response = LoginModel.fromJson(res.data);
      debugPrint("loginResponse ${json.encode(response)}");
      if (response.success!) {
        if (response.data != null) {
          String? data = response.accessToken;
          /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userToken', data!);

          prefs.setInt(StringConstants.LANGUAGE_ID, int.parse(response.data?.preferredLang ?? "1"));

          if (response.data?.preferredLang != null) {
            CommonFunctions().updateLanguage(int.parse(response.data?.preferredLang ?? "1"), context);
          } else {
            CommonFunctions().updateLanguage(1, context);
          }

          prefs.setString('userId', response.data!.id.toString());
          prefs.setString('userFirstName', response.data?.firstName.toString() ?? "");
          prefs.setString('userLastName', response.data?.lastName.toString() ?? "");
          prefs.setString('notificationEnabled', response.data?.notificationEnabled.toString() ?? "");
          prefs.setString('matchNotificationEnabled', response.data?.matchNotification.toString() ?? "");
          prefs.setString('chatNotificationEnabled', response.data?.messageNotification.toString() ?? "");
          prefs.setString('refferalCode', response.data?.referralKey.toString() ?? "");
          debugPrint(data);
        }
        return response;
      } else {
        if (response.deactivation ?? false) {
          CommonFunctions.showSessionOutDialog(response.messageTitle ?? "Error".tr /*"We\'ll miss you!".tr*/, response.message ?? "", callBack: () {
            Get.back();
          });
          throw "Error Occurred";
        } else {
          CommonDialog.hideLoading();
          CommonDialog.showErrorDialog(title: response.messageTitle ?? "Alert".tr, description: response.message.toString());
          //  CommonDialog.showToastMessage(response.message.toString());
          throw "Error Occurred";
        }
      }
    }
    /*else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.data}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } */
    else {
      CommonDialog.hideLoading();

      throw "Error Occurred";
    }
    // }
    /*on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } */ /*on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    }*/
    // catch (e) {
    //   CommonDialog.hideLoading();
    //   throw "Error Occurred";
    // }
  }

  Future<ReadNotification> readNotification(BuildContext context, {required String type, bool showLoader = true}) async {
    try {
      if (showLoader) {
        CommonDialog.showLoading();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;

      String url = "${apiBaseUrl}user/update-like-notification-status";
      log("update-like-notification-status --> $url $type");

      var map = {"type": type};
      var res = await _dio.post(url,
          data: map,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (showLoader) {
        CommonDialog.hideLoading();
      }

      print('readNotification  $type ');
      print('readNotificationUrl  $res');
      if (res.statusCode == 200) {
        var response = ReadNotification.fromJson(res.data);
        debugPrint("loginResponse ${json.encode(response)}");
        if (response.status == true) {
          /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

          return response;
        } else {
          CommonDialog.showToastMessage(response.message.toString());
          throw "Error Occurred";
        }
      } else if (res.statusCode == 401) {
        /*if (res.hasError) {
          debugPrint("${res.data}");
          CommonFunctions.checkUnAuthorized(res);
        }*/
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    }
    /*on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } */
    catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
  }

  //2). For Forgot Password
  Future<ForgetPasswordModel> forgetPassword(dynamic body) async {
    try {
      CommonDialog.showLoading();
      debugPrint("forget-password $body");
      var res = await _dio.post('${apiBaseUrl}forget-password', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      debugPrint("res $res ${res.data} ");
      res.printError();
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ForgetPasswordModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    }
    /*on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    }*/
    catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //3). For Verifying Profile
  Future<ProfileVerificationModel> profileVerification(dynamic body) async {
    try {
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}profile-verification', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ProfileVerificationModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //4). For Reset The Password
  Future<ResetPasswordModel> resetPassword(dynamic body) async {
    try {
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}reset-password', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ResetPasswordModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //5). For Getting Destination List
  Future<DestinationModel> getDestinations() async {
    try {
      CommonDialog.showLoading();
      var langId = await CommonFunctions().getIdFromDeviceLang();
      debugPrint("get ${apiBaseUrl}destinations/$langId ");

      var res = await _dio.get('${apiBaseUrl}destinations/$langId', options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return DestinationModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //6). For Getting Interest List
  Future<InterestsModel> getInterests() async {
    try {
      int langId = await CommonFunctions().getIdFromDeviceLang();

      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}meet_now/$langId', options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return InterestsModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //7). For Register A New Register
  Future<LoginModel> socialRegister(dynamic body) async {
    // try {
    CommonDialog.showLoading();
    debugPrint("body $body ${apiBaseUrl}social-signup");
    var res = await _dio.post('${apiBaseUrl}social-signup', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
    if (res.statusCode == 200) {
      LoginModel response = LoginModel.fromJson(res.data);

      log("RegisterResponse --> $res");
      CommonDialog.hideLoading();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.accessToken != null) {
        String? data = response.accessToken;
        /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

        prefs.setString('userToken', data!);
        debugPrint(data);
      }
      if (response.data != null) {
        prefs.setInt(StringConstants.LANGUAGE_ID, int.parse(response.data?.preferredLang ?? "1"));

        if (response.data?.preferredLang != null) {
          CommonFunctions().updateLanguage(int.parse(response.data?.preferredLang ?? "1"), Get.overlayContext!);
        } else {
          CommonFunctions().updateLanguage(1, Get.overlayContext!);
        }

        prefs.setString('userId', response.data!.id.toString());
        prefs.setString('userFirstName', response.data?.firstName.toString() ?? "");
        prefs.setString('userLastName', response.data?.lastName.toString() ?? "");
        prefs.setString('notificationEnabled', response.data?.notificationEnabled.toString() ?? "");
        prefs.setString('matchNotificationEnabled', response.data?.matchNotification.toString() ?? "");
        prefs.setString('chatNotificationEnabled', response.data?.messageNotification.toString() ?? "");
        prefs.setString('refferalCode', response.data?.referralKey.toString() ?? "");
      }
      return LoginModel.fromJson(res.data);
    } else if (res.statusCode == 401) {
      CommonDialog.hideLoading();
      // if (res.hasError) {
      //   debugPrint("${res.data}");
      //   CommonFunctions.checkUnAuthorized(res);
      // }
      throw "Error Occurred";
    } else {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    // } catch (e) {
    //   CommonDialog.hideLoading();
    //   throw "Error Occurred";
    // }
  }

  //7). For Register A New Register
  Future<RegisterModel> register(dynamic body) async {
    try {
      CommonDialog.showLoading();
      debugPrint("body $body");
      var res = await _dio.post('${apiBaseUrl}register', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        debugPrint("RegisterResponse$res");
        CommonDialog.hideLoading();
        return RegisterModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //8).For Getting The List Of Users
  Future<User_dashboard_response_model> getUsersList(int page, bool showLoad, {int? totalPages, bool includePreviousPages = false, int? lastUserId}) async {
    try {
      // httpClient.maxRedirects = 15;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoad) {
        CommonDialog.showLoading();
      }

      String path = '${apiBaseUrl}user/dashboard?page_number=$page&total_pages=$totalPages&previous_pages=$includePreviousPages&last_user_id=$lastUserId';

      print('CheckUrl ::  > $path');

      var res = await _dio.get(path,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));

      if (res.statusCode == 200) {
        log('dashboard_response===>  ${res.data.toString()}');
        if (showLoad) {
          CommonDialog.hideLoading();
        }
        return User_dashboard_response_model.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        // if (showLoad) {
        //   CommonDialog.hideLoading();
        // }
        // return User_dashboard_response_model.fromJson(res.data);

        throw "Error Occurred";
      }
    } catch (e) {
      if (showLoad) {
        CommonDialog.hideLoading();
      }
      print("e --->>> ${e.toString()}");

      throw "Error Occurred";
    }
  }

  //9). For Getting The Mode
  Future<StatusUpdateResponseModel> getMode(dynamic body, {bool showLoading = true}) async {
    try {
      if (showLoading) {
        CommonDialog.showLoading();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log('getMode_body===> user/status-update $body  $accessToken');
      var res = await _dio.post('${apiBaseUrl}user/status-update',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (showLoading) {
        CommonDialog.hideLoading();
      }

      if (res.statusCode == 200) {
        debugPrint('getMode_response===>${res.data.toString()}');
        return StatusUpdateResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } catch (e) {
      if (showLoading) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
  }

  //10). For Getting Connections List
  Future<ConnectionsResponseModel> getConnectionsList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("user/connections accessToken $accessToken");

      var res = await _dio.get('${apiBaseUrl}user/connections',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      CommonDialog.hideLoading();

      if (res.statusCode == 200) {
        debugPrint('getConnectionsList_response===>${res.data.toString()}');
        return ConnectionsResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //11). For Getting Connections List
  Future<SettingsModel> getSettings({bool showLoader = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoader) {
        CommonDialog.showLoading();
      }
      log("getSettings  Api ${apiBaseUrl}user/settings    Bearer $accessToken");
      var res = await _dio.get('${apiBaseUrl}user/settings',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('getSettings response ===>${res.data.toString()}');
        return SettingsModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //12). For Submitting Review
  Future<SubmitReviewModel> submitReview(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      log("submitReview ${apiBaseUrl}add-review $body accessToken $accessToken");
      var res = await _dio.post('${apiBaseUrl}add-review',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('submitReview===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SubmitReviewModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //13). For Blocking user
  Future<BlockUserModel> blockUser(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("POST user/block body $body accessToken $accessToken");
      var res = await _dio.post('${apiBaseUrl}user/block',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('blockUser_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return BlockUserModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //14). For Settings Update
  Future<SettingsUpdateModel> settingsUpdate(dynamic body, {bool showDialog = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showDialog) {
        CommonDialog.showLoading();
      }
      var res = await _dio.post('${apiBaseUrl}user/settings-update',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (showDialog) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('settingsUpdate_response===>${res.data.toString()}');
        return SettingsUpdateModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //15). For Removing User From Connection List
  Future<ConnectionRemoveModel> removeConnection(dynamic body) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await _dio.post('${apiBaseUrl}user/remove-connection',
          data: body,
          options: dio.Options(headers: {
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('removeConnection_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //16). For Getting User Profile
  Future<UserProfileModel> getUserProfile({required bool showLoader}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log("${apiBaseUrl}user/profile accessToken $accessToken");

      if (showLoader) {
        CommonDialog.showLoading();
      }
      var res = await _dio.get('${apiBaseUrl}user/profile',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      //log('Erroor  getUserProfile_response===>${res.data.toString()}');

      if (res.statusCode == 200) {
        //     log('getUserProfile_response===>${res.data.toString()}');
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        return UserProfileModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        if (showLoader) {
          CommonDialog.hideLoading();
          throw "Error Occurred";
        }
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
    throw "";
  }

  //17). For Getting Review List
  Future<ReviewListModel> getReviewList(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      print('${apiBaseUrl}review-list/$userId');
      var res = await _dio.get('${apiBaseUrl}review-list/$userId',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('getReviewList_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ReviewListModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //18). For Editing User Profile
  Future<EditProfileModel> getEditProfileData(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("${apiBaseUrl}user/edit-profile $body ");
      debugPrint("accessToken $accessToken ");
      var res = await _dio.post('${apiBaseUrl}user/edit-profile',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('getEditProfileData_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return EditProfileModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //19). For Updating User Profile
  Future<UpdateProfileModel> updateProfile(dio.FormData body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    CommonDialog.showLoading();
    log("${apiBaseUrl}user/update-profiles $body");
    var res = await _dio.post('${apiBaseUrl}user/update-profile',
        data: body, options: dio.Options(headers: {'accept': 'application/json', 'Authorization': "Bearer $accessToken", 'Content-Type': 'multipart/form-data'}));
    debugPrint("update-profile res.statusCode ${res.statusCode}");
    if (res.statusCode == 200) {
      CommonDialog.hideLoading();
      return UpdateProfileModel.fromJson(res.data);
    } else if (res.statusCode == 401) {
      CommonDialog.hideLoading();
      // if (res.hasError) {
      //   debugPrint("${res.data}");
      //   CommonFunctions.checkUnAuthorized(res);
      // }
      throw "Error Occurred";
    } else {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    /*  try{
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("user/update-profile $body");
      var res = await _dio.post('${apiBaseUrl}user/update-profile', data: body,  options: dio.Options( options: dio.Options(headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return UpdateProfileModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.data}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    }on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    }
    catch(e){
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";*/
  }

  //20). For User Log Out
  Future<UserLogOutResponseModel> getUerLogOut(dynamic body) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await _dio.post('${apiBaseUrl}logout',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('getUerLogOut_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return UserLogOutResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //21). For Getting Terms And Condition
  Future<TermsAndConditionResponseModel> getTermsAndConditions(bool isAuth) async {
    try {
      int langId = await CommonFunctions().getIdFromDeviceLang();

      CommonDialog.showLoading();
      String url = '${apiBaseUrl}terms-and-conditions/${langId.toString()}';
      log("getTermsAndConditions url $url");
      var res = await _dio.get(
        url,
      );

      if (res.statusCode == 200) {
        debugPrint('getTermsAndConditions_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return TermsAndConditionResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //22). For Getting Terms And Condition
  Future<PrivacyPolicyResponseModel> getPrivacyPolicy() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String ?accessToken = prefs.getString('userToken')!;

      int langId = await CommonFunctions().getIdFromDeviceLang();

      String url = '${apiBaseUrl}privacy-policy/$langId';
      debugPrint("url privacy Policy $url");
      CommonDialog.showLoading();
      var res = await _dio.get(
        url,
/*         options: dio.Options(headers: {'accept':'application/json',
          'Authorization': "Bearer $accessToken",
        }*/
      );
      if (res.statusCode == 200) {
        debugPrint('getPrivacyPolicy_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return PrivacyPolicyResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //22). For Getting Terms And Condition
  Future<CancellationPolicyResponse> getCancellationPolicy() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String ?accessToken = prefs.getString('userToken')!;

      int langId = await CommonFunctions().getIdFromDeviceLang();

      String url = '${apiBaseUrl}cancellation-policy';
      debugPrint("url privacy Policy $url");
      CommonDialog.showLoading();
      var res = await _dio.get(
        url,
/*         options: dio.Options(headers: {'accept':'application/json',
          'Authorization': "Bearer $accessToken",
        }*/
      );
      if (res.statusCode == 200) {
        debugPrint('getPrivacyPolicy_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return CancellationPolicyResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //23). For Getting User Mode Value
  Future<UserModeResponseModel> getUserMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/mode',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('getUserMode_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return UserModeResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //24). For Delete User account
  Future<AccountDeleteModel> deleteUserAccount(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      // log("under deleteUserAccount ${baseUrl}account-delete body $body accessToken $accessToken");
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}account-delete',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('deleteUserAccount_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return AccountDeleteModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //25). For Delete User account
  Future<DeleteImageModel> deleteImage(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/delete-image',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //26). For Getting Subscription Details
  Future<SubscriptionResponseModel> getSubscriptionList({bool isShowLoader = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken') ?? "";
      if (isShowLoader) {
        CommonDialog.showLoading();
      }
      var res = await _dio.get('${apiBaseUrl}plan-list',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (isShowLoader) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('getSubscriptionList_Response===>${res.data.toString()}');
        return SubscriptionResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (isShowLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (isShowLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (isShowLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
    throw "";
  }

  //27). For Getting Chat List
  Future<ChatListModel> getChatList(bool showLoader, int page, int loader, {String? searchKeyword}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoader) {
        if (loader == 0) {
          CommonDialog.showLoading();
        }
      }
      String query = "";
      if (searchKeyword != null) {
        if (searchKeyword.trim().isNotEmpty) {
          query = "/$searchKeyword";
        }
      }
      String url = '${apiBaseUrl}user/get-chat-list/$page$query';
      print("Check Url  :::::::   >>>>   $url");

      log("getChatList GET url $url accessToken $accessToken");
      var res = await _dio.get(url,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('getChatList===>${res.data.toString()}');
        if (showLoader) {
          if (loader == 0) {
            CommonDialog.hideLoading();
          }
        }
        return ChatListModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //28). For Image Reorder Api
  Future<ImageReorderModel> imageReorder(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/change-image-order',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ImageReorderModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //29). For Getting Block User List
  Future<BlockListResponseModel> getBlockUserList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/block-list',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('user_blockList_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return BlockListResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //30). For Unblocking The User
  Future<UnBlockResponseModel> unBlockUser(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/unblock',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('unblock_user_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return UnBlockResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //31). For Resending The Code
  Future<ResetPasswordModel> resendCode(dynamic body) async {
    try {
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}resend-email', data: body, options: dio.Options(headers: {'accept': 'application/json'}));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ResetPasswordModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //32). For Contact Us
  Future<ContactUsResponseModel> contactUs(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/submit-query',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('contact_us_response===>${res.data.toString()}');
        return ContactUsResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //33). For Getting Other User's Profile
  Future<OtherUserResponseModel> getOtherUserProfile(String? id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      String url = '${apiBaseUrl}user/view-other-user/$id';
      log("getOtherUserProfile url $url accessToken $accessToken");
      var res = await _dio.get(url,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Terms_and_conditions_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return OtherUserResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //34). For Liking Other User's Profile
  Future<LikeResponseModel> getLikeUser(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("POST --> user/likeUnlike-profile $body $accessToken");
      var res = await _dio.post('${apiBaseUrl}user/likeUnlike-profile',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('user_like_response===>${res.data.toString()}');
        return LikeResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //35). For Showing Liked User List
  Future<LikeListResponseModel> getLikedUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/like-listing',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Terms_and_conditions_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return LikeListResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //36).For Changing the Password
  Future<ChangePasswordResponseModel> getPasswordChange(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();

      var res = await _dio.post('${apiBaseUrl}user/change-password',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('user_like_response===>${res.data.toString()}');
        return ChangePasswordResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //37).For Reordering Image
  Future<DeleteImageModel> deleteDestination(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/remove-destination',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //38).For Deleting Interest
  Future<DeleteImageModel> removeInterst(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/remove-interest',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //39). For Displaying Notifications List
  Future<NotificationResponseModel> getNotificationsList(int page, bool showLoad) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoad) {
        CommonDialog.showLoading();
      }
      log("${apiBaseUrl}user/received-notifications/$page accessToken $accessToken ");
      var res = await _dio.get('${apiBaseUrl}user/received-notifications/$page',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Notifications_List_Response===>${res.data.toString()}');
        if (showLoad) {
          CommonDialog.hideLoading();
        }
        return NotificationResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        if (showLoad) {
          CommonDialog.hideLoading();
        }
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        if (showLoad) {
          CommonDialog.hideLoading();
        }

        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //40). For Chat History
  Future<ChatByUserModel> getChatByUser(dynamic body, {bool showLoader = false}) async {
    // try {
    // try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    log("under getChatByUser POST user/get-chat-by-user $body token $accessToken");

    if (showLoader) {
      CommonDialog.showLoading();
    }
    var res = await _dio.post('${apiBaseUrl}user/get-chat-by-user',
        data: body,
        options: dio.Options(headers: {
          'accept': 'application/json',
          'Authorization': "Bearer $accessToken",
        }));
    log("getChatByUser response ${json.encode(res.data)}");
    if (showLoader) {
      CommonDialog.hideLoading();
    }
    if (res.statusCode == 200) {
      // debugPrint('user_mode_response===>${res.data.toString()}');
      //CommonDialog.hideLoading();
      return ChatByUserModel.fromJson(res.data);
    } else if (res.statusCode == 401) {
      // CommonDialog.hideLoading();
      // if (res.hasError) {
      //   debugPrint("${res.data}");
      //   CommonFunctions.checkUnAuthorized(res);
      // }
      throw "Error Occurred";
    } else {
      //CommonDialog.hideLoading();
      throw 'Some arbitrary error';
    }
    // } on SocketException catch (e) {
    //   if (showLoader) {
    //     CommonDialog.hideLoading();
    //   }
    //   // CommonDialog.hideLoading();
    //   switch (e.osError!.errorCode) {
    //     case 7:
    //       CommonDialog.showToastMessage("internetError".tr);
    //       break;
    //     case 111:
    //       CommonDialog.showToastMessage("serverError".tr);
    //       break;
    //     default:
    //       CommonDialog.showToastMessage("unknownError".tr);
    //       break;
    //   }
    //   debugPrint('Socket Exception thrown --> $e');
    // } on TimeoutException catch (e) {
    //   if (showLoader) {
    //     CommonDialog.hideLoading();
    //   }
    //   // CommonDialog.hideLoading();
    //   CommonDialog.showToastMessage("tryAgain".tr);
    //   debugPrint('TimeoutException thrown --> $e');
    // } on dio.DioError catch (e) {
    //   if (showLoader) {
    //     CommonDialog.hideLoading();
    //   }
    //   CommonFunctions.checkSessionUnAuthorized(e);
    //   //showToast(ApiHelper.processErrorInDioServerResponse(e));
    //   throw Exception('BarException');
    // } catch (e) {
    //   print("e ---->> $e");
    //   if (showLoader) {
    //     CommonDialog.hideLoading();
    //   }
    //   // CommonDialog.hideLoading();
    //   throw "Error Occurred";
    // }
    // throw "";
  }

  //41). For Submitting User's Feedback
  Future<SubmitFeedBackResponseModel> submitFeedback(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/feedback',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('dashboar_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SubmitFeedBackResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //42).For Displaying User's Subscription Details
  Future<UserSubscriptionResponseModel> getUserSubscriptionDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    CommonDialog.showLoading();
    String url = '${apiBaseUrl}user/plan';
    log("url $url");
    var res = await _dio.get(url,
        options: dio.Options(headers: {
          'accept': 'application/json',
          'Authorization': "Bearer $accessToken",
        }));
    debugPrint('Subscription_Details_Response===>${res.data.toString()}');
    if (res.statusCode == 200) {
      CommonDialog.hideLoading();
      return UserSubscriptionResponseModel.fromJson(res.data);
    } else if (res.statusCode == 401) {
      CommonDialog.hideLoading();
      // if (res.hasError) {
      //   debugPrint("${res.data}");
      //   CommonFunctions.checkUnAuthorized(res);
      // }
      throw "Error Occurred";
    } else {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //43).For Enabling Auto Renew Subscription
  Future<EnableSubscriptionResponseModel> getRenewSubscription(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/auto-renewal-status',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Subscription_Enabled_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return EnableSubscriptionResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //44).For Enabling Notifications
  Future<ChangePasswordResponseModel> enableNotifications(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/notification-status',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ChangePasswordResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //45).For Displaying The Match User List
  Future<MatchUserResponseModel> getMatchUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/user-match-list',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return MatchUserResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //46).For Displaying The User's History List
  Future<MatchUserResponseModel> getUserHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/get-history',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return MatchUserResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //47).For Checking if email exist
  Future<CheckEmailModel> checkEmailExist(dynamic body) async {
    try {
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}check-email-exist',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
          }));
      print("Check url     ${body}");
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        // CommonDialog.showToastMessage(res.statusText.toString());

        var response = CheckEmailModel.fromJson(res.data);
        if (response.status != null) {
          if (!response.status!) {
            if (response.deactivation ?? false) {
              CommonFunctions.showSessionOutDialog(response.messageTitle ?? "Error".tr /*"We\'ll miss you!".tr*/, response.message ?? "", callBack: () {
                Get.back();
              });
              throw "Error Occurred";
            } else {
              CommonDialog.hideLoading();
              CommonDialog.showErrorDialog(title: response.messageTitle ?? "Alert".tr, description: response.message.toString());
              //  CommonDialog.showToastMessage(response.message.toString());
              throw "Error Occurred";
            }
          }
        }
        return response;
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "$e";
    }
    throw "";
  }

  //48).For Updating User Email Address
  Future<EmailUpdateResponseModel> updateEmailExist(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/email-update', data: body, options: dio.Options(headers: {'accept': 'application/json', 'Authorization': "Bearer $accessToken"}));
      if (res.statusCode == 200) {
        debugPrint('Email_Update_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return EmailUpdateResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //48).For Updating User Email Address
  Future<UpdateLanguageModel> updateLanguage(dynamic body, {bool showLoader = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log("updateLanguage POST  user/update-language body $body accessToken $accessToken");
      if (showLoader) {
        CommonDialog.showLoading();
      }
      var res = await _dio.post('${apiBaseUrl}user/update-language', data: body, options: dio.Options(headers: {'accept': 'application/json', 'Authorization': "Bearer $accessToken"}));
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('updateLanguage===>${res.data.toString()}');

        return UpdateLanguageModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
    throw "";
  }

  //49).For updating meet now City update
  Future<ChangePasswordResponseModel> updateMeetNowCity(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/meet-now-city-update',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ChangePasswordResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //50). For Displaying Total Referral
  Future<TotalRefferalResponseModel> getTotalUserRefferal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.get('${apiBaseUrl}user/all-referals',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Total_User_Refferal_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return TotalRefferalResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //51). For Displaying Total Referral
  Future<InviteContentResponseModel> getInviteContent() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("invite-friend-text'");
      int langId = await CommonFunctions().getIdFromDeviceLang();

      CommonDialog.showLoading();
      String url = '${apiBaseUrl}invite-friend-text/${langId.toString()}';
      var res = await _dio.get(url,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Total_User_Refferal_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return InviteContentResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

//52).For Editing User's Personal Details
  Future<EditDetailsResponseModel> editUserDetails(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/update-user-data',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('Edit_Details_Response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return EditDetailsResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //53). For Displaying Advertisements
  Future<AdvertisementResponseModel> getAdvertisementList(int advertisementType) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      // var res = await _dio.get('${apiBaseUrl}advertisments/$advertisementtype',  options: dio.Options(headers: {
      var res = await _dio.get('${apiBaseUrl}advertisments/',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('Total_Advertisements_List_Response===>${res.data.toString()}');
        //CommonDialog.hideLoading();
        return AdvertisementResponseModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        //CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      // CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      // CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      // CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      // CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //53). For Clicking Advertisements
  Future<AdsClickModel> clickAdvertisement(body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}add-click-on-advertisement',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        // debugPrint('Total_Advertisements_List_Response===>${res.data.toString()}');
        //CommonDialog.hideLoading();
        return AdsClickModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        //CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //54). For Removing Connection
  Future<ConnectionRemoveModel> removeConnectionChat(dynamic body) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;

      log("${apiBaseUrl}user/remove_connection_chat $body accessToken $accessToken");
      var res = await _dio.post('${apiBaseUrl}user/remove_connection_chat',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('connection_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //54). For Removing Connection
  Future<ConnectionRemoveModel> deleteNotif(dynamic body) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await _dio.post('${apiBaseUrl}user/remove_notification',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('connection_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<ConnectionRemoveModel> readOtherUserMessage(dynamic body, Function() callBack) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      debugPrint("readOtherUserMessage user/read_other_user_message map $body token $accessToken");
      var res = await _dio.post('${apiBaseUrl}user/read_other_user_message',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint(''
            'connection_response===>${res.data.toString()}');

        callBack() ?? () {};
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //7). For Register A New Register
  Future<UploadAudio> uploadFile(dynamic body) async {
    try {
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;

      var res = await _dio.post('${apiBaseUrl}upload-file',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint("RegisterResponse${res.toString()}");
        CommonDialog.hideLoading();
        return UploadAudio.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<SubmitReviewModel> editReview(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}edit-review',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('editReview_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SubmitReviewModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<void> updateLocation(dynamic body, {bool showLoader = true}) async {
    try {
      debugPrint("_dio.post update location==> ${apiBaseUrl}user/update-location");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/update-location',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        //CommonDialog.hideLoading();
        return;
      } else if (res.statusCode == 401) {
        if (showLoader) {
          CommonDialog.hideLoading();
        } // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        // CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
  }

  Future<void> buySubscription(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      CommonDialog.showLoading();
      debugPrint("_dio.post buySubscription==> ${apiBaseUrl}user/update-subscription  bodyData : $body");
      var res = await _dio.post('${apiBaseUrl}user/update-subscription',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      debugPrint("buySubscription response ${res.data.toString()}");
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return;
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred $e";
    }
  }

  Future<dynamic> hitPackagesListApi(dynamic body, {bool showLoader = true, String keyword = ""}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      if (showLoader) {
        CommonDialog.showLoading();
      }
      String url = "${apiBaseUrl}user/package-list";
      if (keyword.isNotEmpty) {
        url = "$url?keyword=$keyword";
      }
      debugPrint("_dio.post hitPackagesListApi==> $url");

      var res = await _dio.get(url,
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      debugPrint("buySubscription response ${res.data.toString()}");
      if (showLoader) {
        CommonDialog.hideLoading();
      }

      if (res.statusCode == 200) {
        return PackageListModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred $e";
    }
  }

  Future<dynamic> hitPackagesDetailsApi({required dynamic id, bool showLoader = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      if (showLoader) {
        CommonDialog.showLoading();
      }
      debugPrint("_dio.post hitPackagesDetailsApi==> ${apiBaseUrl}user/package-details/$id ");
      var res = await _dio.get('${apiBaseUrl}user/package-details/$id',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      debugPrint("buySubscription response ${res.data.toString()}");
      if (showLoader) {
        CommonDialog.hideLoading();
      }

      if (res.statusCode == 200) {
        return PackageDetailsModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred $e";
    }
  }

  Future<dynamic> hitApplyCouponApi({required dynamic body}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      CommonDialog.showLoading();
      debugPrint("_dio.post hitPackagesDetailsApi==> ${apiBaseUrl}user/apply-package-coupon $body");
      var res = await _dio.post('${apiBaseUrl}user/apply-package-coupon',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      debugPrint("buySubscription response ${res.data.toString()}");
      CommonDialog.hideLoading();

      if (res.statusCode == 200) {
        return ApplyCouponResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();

      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred $e";
    }
  }

  Future<SimpleApiResponse> hitSubscriptionApi(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();

      String url = '${apiBaseUrl}subscribed';
      log("url $url body --> $body");

      var res = await _dio.post(url,
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('hitBookMyTripeApi_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SimpleApiResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<SimpleApiResponse> hitBookMyTripeApi(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();

      String url = '${apiBaseUrl}user/book-trip';
      log("url $url body --> $body");

      var res = await _dio.post(url,
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('hitBookMyTripeApi_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SimpleApiResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<SimpleApiResponse> packageInquiry(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/package-inquiry',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('dashboar_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SimpleApiResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        // if (res.hasError) {
        //   debugPrint("${res.data}");
        //   CommonFunctions.checkUnAuthorized(res);
        // }
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<dynamic> hitMyTripApi(int type, {bool showLoader = true}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      if (showLoader) {
        CommonDialog.showLoading();
      }
      debugPrint("_dio.get hitMyTripApi==> ${apiBaseUrl}user/my-trips?type=$type");
      var res = await _dio.get('${apiBaseUrl}user/my-trips?type=$type',
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      debugPrint("hitMyTripApi response ${res.data.toString()}");
      if (showLoader) {
        CommonDialog.hideLoading();
      }

      if (res.statusCode == 200) {
        return MyTripsApiModel.fromJson(res.data);
      } else if (res.statusCode == 401) {
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkSessionUnAuthorized(e);
      throw Exception('BarException');
    } catch (e) {
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred $e";
    }
  }

  Future<SimpleApiResponse> giveTripRateApi(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/rate-trip',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('giveTripRateApi_response===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SimpleApiResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<SimpleApiResponse> cancelTrip(dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await _dio.post('${apiBaseUrl}user/cancel-trip',
          data: body,
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': "Bearer $accessToken",
          }));
      if (res.statusCode == 200) {
        debugPrint('cancelTrip===>${res.data.toString()}');
        CommonDialog.hideLoading();
        return SimpleApiResponse.fromJson(res.data);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      } else {
        CommonDialog.hideLoading();
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      CommonDialog.hideLoading();
      switch (e.osError!.errorCode) {
        case 7:
          CommonDialog.showToastMessage("internetError".tr);
          break;
        case 111:
          CommonDialog.showToastMessage("serverError".tr);
          break;
        default:
          CommonDialog.showToastMessage("unknownError".tr);
          break;
      }
      debugPrint('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on dio.DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkSessionUnAuthorized(e);
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }
}
