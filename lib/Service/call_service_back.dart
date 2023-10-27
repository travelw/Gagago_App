import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/account_delete_model.dart';
import 'package:gagagonew/model/advertisement_response_model.dart';
import 'package:gagagonew/model/block_user_model.dart';
import 'package:gagagonew/model/change_password_response_model.dart';
import 'package:gagagonew/model/chat_by_user_model.dart';
import 'package:gagagonew/model/chat_list_model.dart';
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
import 'package:gagagonew/model/profile_verification_model.dart';
import 'package:gagagonew/model/register_model.dart';
import 'package:gagagonew/model/reset_password_model.dart';
import 'package:gagagonew/model/settings_model.dart';
import 'package:gagagonew/model/settings_update_model.dart';
import 'package:gagagonew/model/submit_review_model.dart';
import 'package:gagagonew/model/total_refferal_response_model.dart';
import 'package:gagagonew/model/update_profile_model.dart';
import 'package:gagagonew/model/user_liked_list_response_model.dart';
import 'package:gagagonew/model/user_subscription_model_response.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ads_click_model.dart';
import '../model/block_list_response_model.dart';
import '../model/connection_remove_model.dart';
import '../model/connection_response_model.dart';
import '../model/contact_us_response_model.dart';
import '../model/delete_image_model.dart';
import '../model/other_user_profile_response_model.dart';
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

class CallService extends GetConnect {
  //String apiBaseUrl = "https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/";

  //2nd Live url
  String apiBaseUrl = "https://api-v2.gagagoapp.com/api/";

  // String apiBaseUrl = "https://api.gagagoapp.com/api/"; //Live
  //String? baseUrl ='https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/api/';

  //1). For Login User
  Future<LoginModel> login(BuildContext context, dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();

      var res =
          await post('login', body, headers: {'accept': 'application/json'});
      //  var res = await post('${httpClient.baseUrl}login', body, headers: {'accept': 'application/json'});

      print('login $body');
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        var response = LoginModel.fromJson(res.body);
        debugPrint("loginResponse ${json.encode(response)}");
        if (response.success!) {
          String? data = response.accessToken;
          /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userToken', data!);

          prefs.setInt(StringConstants.LANGUAGE_ID,
              int.parse(response.data?.preferredLang ?? "1"));

          if (response.data?.preferredLang != null) {
            CommonFunctions().updateLanguage(
                int.parse(response.data?.preferredLang ?? "1"), context);
          } else {
            CommonFunctions().updateLanguage(1, context);
          }

          prefs.setString('userId', response.data!.id.toString());
          prefs.setString(
              'userFirstName', response.data?.firstName.toString() ?? "");
          prefs.setString(
              'userLastName', response.data?.lastName.toString() ?? "");
          prefs.setString('notificationEnabled',
              response.data?.notificationEnabled.toString() ?? "");
          prefs.setString('matchNotificationEnabled',
              response.data?.matchNotification.toString() ?? "");
          prefs.setString('chatNotificationEnabled',
              response.data?.messageNotification.toString() ?? "");
          prefs.setString(
              'refferalCode', response.data?.referralKey.toString() ?? "");
          debugPrint(data);
          return response;
        } else {
          if (response.deactivation ?? false) {
            CommonFunctions.showSessionOutDialog(
                "Error".tr /*"We\'ll miss you!".tr*/, response.message ?? "",
                callBack: () {
              Get.back();
            });
            throw "Error Occurred";
          } else {
            CommonDialog.hideLoading();
            CommonDialog.showErrorDialog(
                title: "Alert".tr, description: response.message.toString());
            //  CommonDialog.showToastMessage(response.message.toString());
            throw "Error Occurred";
          }
        }
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<ReadNotification> readNotification(
      BuildContext context, String body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();

      print("apiBaseUrl ${apiBaseUrl}user/update-like-notification-status ");

      var res = await post('user/update-like-notification-status', body,
          headers: {'accept': 'application/json'});

      print('readNotification  $body ');
      print('readNotificationUrl  $res');
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        var response = ReadNotification.fromJson(res.body);
        debugPrint("loginResponse ${json.encode(response)}");
        if (response.status == true) {
          /*String? lat = response.data!.lat;
      String? lng = response.data!.lng;*/

          return response;
        } else {
          CommonDialog.hideLoading();
          CommonDialog.showToastMessage(response.message.toString());
          throw "Error Occurred";
        }
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //2). For Forgot Password
  Future<ForgetPasswordModel> forgetPassword(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();
      debugPrint("forget-password $body");
      var res = await post('forget-password', body,
          headers: {'accept': 'application/json'});
      debugPrint("res $res ${res.body} ");
      res.printError();
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ForgetPasswordModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //3). For Verifying Profile
  Future<ProfileVerificationModel> profileVerification(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();
      var res = await post('profile-verification', body,
          headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ProfileVerificationModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //4). For Reset The Password
  Future<ResetPasswordModel> resetPassword(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();
      var res = await post('reset-password', body,
          headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ResetPasswordModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //5). For Getting Destination List
  Future<DestinationModel> getDestinations() async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();
      var langId = await CommonFunctions().getIdFromDeviceLang();
      debugPrint("get ${apiBaseUrl}destinations/$langId ");

      var res = await get('destinations/$langId',
          headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return DestinationModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //6). For Getting Interest List
  Future<InterestsModel> getInterests() async {
    try {
      int langId = await CommonFunctions().getIdFromDeviceLang();
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      CommonDialog.showLoading();
      var res = await get('meet_now/$langId',
          headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return InterestsModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //7). For Register A New Register
  Future<RegisterModel> register(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(minutes: 3);
      CommonDialog.showLoading();
      debugPrint("body $body");
      var res =
          await post('register', body, headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        debugPrint("RegisterResponse$res");
        CommonDialog.hideLoading();
        return RegisterModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //8).For Getting The List Of Users
  Future<User_dashboard_response_model> getUsersList(int page, bool showLoad,
      {int? totalPages,
      bool includePreviousPages = false,
      int? lastUserId}) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 120);

      // httpClient.maxRedirects = 15;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoad) {
        CommonDialog.showLoading();
      }

      String path =
          'user/dashboard?page_number=${page}&total_pages=$totalPages&previous_pages=${includePreviousPages}&last_user_id=$lastUserId';

      print('CheckUrl ::  > $apiBaseUrl$path');

      var res = await get(path, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });

      if (res.statusCode == 200) {
        log('dashboard_response===>  ${res.body.toString()}');
        if (showLoad) {
          CommonDialog.hideLoading();
        }
        return User_dashboard_response_model.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        // if (showLoad) {
        //   CommonDialog.hideLoading();
        // }
        // return User_dashboard_response_model.fromJson(res.body);

        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoad) {
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
      if (showLoad) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoad) {
        CommonDialog.hideLoading();
      }
      print("e --->>> ${e.toString()}");

      throw "Error Occurred";
    }
    throw "";
  }

  //9). For Getting The Mode
  Future<StatusUpdateResponseModel> getMode(dynamic body,
      {bool showLoading = true}) async {
    try {
      if (showLoading) {
        CommonDialog.showLoading();
      }
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      debugPrint('getMode_body===>$body  $accessToken');
      var res = await post('user/status-update', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (showLoading) {
        CommonDialog.hideLoading();
      }

      if (res.statusCode == 200) {
        debugPrint('getMode_response===>${res.body.toString()}');
        return StatusUpdateResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        throw "Error Occurred";
      }
    } on SocketException catch (e) {
      if (showLoading) {
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
      if (showLoading) {
        CommonDialog.hideLoading();
      }
      CommonDialog.showToastMessage("tryAgain".tr);
      debugPrint('TimeoutException thrown --> $e');
    } on DioError catch (e) {
      if (showLoading) {
        CommonDialog.hideLoading();
      }
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      if (showLoading) {
        CommonDialog.hideLoading();
      }
      throw "Error Occurred";
    }
    throw "";
  }

  //10). For Getting Connections List
  Future<ConnectionsResponseModel> getConnectionsList() async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("user/connections accessToken $accessToken");

      var res = await get('user/connections', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('getConnectionsList_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ConnectionsResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //11). For Getting Connections List
  Future<SettingsModel> getSettings({bool showLoader = true}) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoader) {
        CommonDialog.showLoading();
      }
      log("getSettings  Api ${apiBaseUrl}user/settings    Bearer $accessToken");
      var res = await get('user/settings', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (showLoader) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('getSettings response ===>${res.body.toString()}');
        return SettingsModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //12). For Submitting Review
  Future<SubmitReviewModel> submitReview(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      log("submitReview ${apiBaseUrl}add-review $body accessToken $accessToken");
      var res = await post('add-review', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('submitReview===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return SubmitReviewModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //13). For Blocking user
  Future<BlockUserModel> blockUser(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("POST user/block body $body accessToken $accessToken");
      var res = await post('user/block', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('blockUser_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return BlockUserModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //14). For Settings Update
  Future<SettingsUpdateModel> settingsUpdate(dynamic body,
      {bool showDialog = true}) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showDialog) {
        CommonDialog.showLoading();
      }
      var res = await post('user/settings-update', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (showDialog) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('settingsUpdate_response===>${res.body.toString()}');
        return SettingsUpdateModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //15). For Removing User From Connection List
  Future<ConnectionRemoveModel> removeConnection(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(minutes: 3);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await post('user/remove-connection', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('removeConnection_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      // log("${apiBaseUrl}user/profile accessToken $accessToken");

      if (showLoader) {
        CommonDialog.showLoading();
      }
      var res = await get('user/profile', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      //log('Erroor  getUserProfile_response===>${res.body.toString()}');

      if (res.statusCode == 200) {
        //     log('getUserProfile_response===>${res.body.toString()}');
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        return UserProfileModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        if (showLoader) {
          CommonDialog.hideLoading();
        }
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('review-list/$userId', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('getReviewList_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ReviewListModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("${apiBaseUrl}user/edit-profile $body ");
      debugPrint("accessToken $accessToken ");
      var res = await post('user/edit-profile', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('getEditProfileData_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return EditProfileModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //19). For Updating User Profile
  Future<UpdateProfileModel> updateProfile(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 60);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    CommonDialog.showLoading();
    debugPrint("user/update-profile $body");
    var res = await post('user/update-profile', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken"
    });
    debugPrint("update-profile res.statusCode ${res.statusCode}");
    if (res.statusCode == 200) {
      CommonDialog.hideLoading();
      return UpdateProfileModel.fromJson(res.body);
    } else if (res.statusCode == 401) {
      CommonDialog.hideLoading();
      if (res.hasError) {
        debugPrint("${res.body}");
        CommonFunctions.checkUnAuthorized(res);
      }
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
      var res = await post('user/update-profile', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return UpdateProfileModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await post('logout', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('getUerLogOut_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return UserLogOutResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //21). For Getting Terms And Condition
  Future<TermsAndConditionResponseModel> getTermsAndConditions(
      bool isAuth) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);

      int langId = await CommonFunctions().getIdFromDeviceLang();

      CommonDialog.showLoading();
      String url = 'terms-and-conditions/${langId.toString()}';
      debugPrint("getTermsAndConditions url $url");
      var res = await get(
        url,
      );

      if (res.statusCode == 200) {
        debugPrint('getTermsAndConditions_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return TermsAndConditionResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String ?accessToken = prefs.getString('userToken')!;

      int langId = await CommonFunctions().getIdFromDeviceLang();

      String url = 'privacy-policy/$langId';
      debugPrint("url privacy Policy $url");
      CommonDialog.showLoading();
      var res = await get(
        url,
/*        headers: {'accept':'application/json',
          'Authorization': "Bearer $accessToken",
        }*/
      );
      if (res.statusCode == 200) {
        debugPrint('getPrivacyPolicy_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return PrivacyPolicyResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/mode', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('getUserMode_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return UserModeResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log("under deleteUserAccount ${baseUrl}account-delete body $body accessToken $accessToken");
      CommonDialog.showLoading();
      var res = await post('account-delete', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('deleteUserAccount_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return AccountDeleteModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/delete-image', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //26). For Getting Subscription Details
  Future<SubscriptionResponseModel> getSubscriptionList(
      {bool isShowLoader = true}) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken') ?? "";
      if (isShowLoader) {
        CommonDialog.showLoading();
      }
      var res = await get('plan-list', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (isShowLoader) {
        CommonDialog.hideLoading();
      }
      if (res.statusCode == 200) {
        debugPrint('getSubscriptionList_Response===>${res.body.toString()}');
        return SubscriptionResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
  Future<ChatListModel> getChatList(bool showLoader, int page, int loader,
      {String? searchKeyword}) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
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
      String url = 'user/get-chat-list/$page$query';
      print("Check Url  :::::::   >>>>   $url");

      print("getChatList GET url $url accessToken $accessToken");
      var res = await get(url, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('getChatList===>${res.body.toString()}');
        if (showLoader) {
          if (loader == 0) {
            CommonDialog.hideLoading();
          }
        }
        return ChatListModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/change-image-order', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ImageReorderModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/block-list', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('user_blockList_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return BlockListResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/unblock', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('unblock_user_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return UnBlockResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      var res = await post('resend-email', body,
          headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return ResetPasswordModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/submit-query', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('contact_us_response===>${res.body.toString()}');
        return ContactUsResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      String url = 'user/view-other-user/$id';
      log("getOtherUserProfile url $url accessToken $accessToken");
      var res = await get(url, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Terms_and_conditions_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return OtherUserResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      log("POST --> user/likeUnlike-profile $body $accessToken");
      var res = await post('user/likeUnlike-profile', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('user_like_response===>${res.body.toString()}');
        return LikeResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/like-listing', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Terms_and_conditions_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return LikeListResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      log('getPasswordChange ===> ${baseUrl}user/change-password $body accessToken $accessToken');

      var res = await post('user/change-password', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        debugPrint('user_like_response===>${res.body.toString()}');
        return ChangePasswordResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/remove-destination', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/remove-interest', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return DeleteImageModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //39). For Displaying Notifications List
  Future<NotificationResponseModel> getNotificationsList(
      int page, bool showLoad) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      if (showLoad) {
        CommonDialog.showLoading();
      }
      log("${apiBaseUrl}user/received-notifications/$page accessToken $accessToken ");
      var res = await get('user/received-notifications/$page', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Notifications_List_Response===>${res.body.toString()}');
        if (showLoad) {
          CommonDialog.hideLoading();
        }
        return NotificationResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        if (showLoad) {
          CommonDialog.hideLoading();
        }

        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //40). For Chat History
  Future<ChatByUserModel> getChatByUser(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      // try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log("under getChatByUser POST user/get-chat-by-user $body token $accessToken");
      //CommonDialog.showLoading();
      var res = await post('user/get-chat-by-user', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      log("getChatByUser response ${json.encode(res.body)}");
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.body.toString()}');
        //CommonDialog.hideLoading();
        return ChatByUserModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        // CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        //CommonDialog.hideLoading();
        throw 'Some arbitrary error';
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      print("e ---->> $e");
      // CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //41). For Submitting User's Feedback
  Future<SubmitFeedBackResponseModel> submitFeedback(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/feedback', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('dashboar_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return SubmitFeedBackResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 60);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    CommonDialog.showLoading();
    var res = await get('user/plan', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    debugPrint('Subscription_Details_Response===>${res.body.toString()}');
    if (res.statusCode == 200) {
      CommonDialog.hideLoading();
      return UserSubscriptionResponseModel.fromJson(res.body);
    } else if (res.statusCode == 401) {
      CommonDialog.hideLoading();
      if (res.hasError) {
        debugPrint("${res.body}");
        CommonFunctions.checkUnAuthorized(res);
      }
      throw "Error Occurred";
    } else {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  //43).For Enabling Auto Renew Subscription
  Future<EnableSubscriptionResponseModel> getRenewSubscription(
      dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/auto-renewal-status', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Subscription_Enabled_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return EnableSubscriptionResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/notification-status', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('user_mode_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ChangePasswordResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/user-match-list', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return MatchUserResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/get-history', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return MatchUserResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //47).For Checking if email exist
  Future<ChangePasswordResponseModel> checkEmailExist(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      var res = await post('check-email-exist', body, headers: {
        'accept': 'application/json',
      });
      print("Check url     ${res.request}");
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        // CommonDialog.showToastMessage(res.statusText.toString());

        return ChangePasswordResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/email-update', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      });
      if (res.statusCode == 200) {
        debugPrint('Email_Update_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return EmailUpdateResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //48).For Updating User Email Address
  Future<UpdateLanguageModel> updateLanguage(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      log("updateLanguage POST  user/update-language body $body accessToken $accessToken");
      CommonDialog.showLoading();
      var res = await post('user/update-language', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      });
      if (res.statusCode == 200) {
        debugPrint('updateLanguage===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return UpdateLanguageModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //49).For updating meet now City update
  Future<ChangePasswordResponseModel> updateMeetNowCity(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/meet-now-city-update', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Match_User_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ChangePasswordResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await get('user/all-referals', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Total_User_Refferal_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return TotalRefferalResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      debugPrint("invite-friend-text'");
      int langId = await CommonFunctions().getIdFromDeviceLang();

      CommonDialog.showLoading();
      String url = 'invite-friend-text/${langId.toString()}';
      var res = await get(url, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Total_User_Refferal_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return InviteContentResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('user/update-user-data', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('Edit_Details_Response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return EditDetailsResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //53). For Displaying Advertisements
  Future<AdvertisementResponseModel> getAdvertisementList(
      int advertisementType) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      // var res = await get('advertisments/$advertisementtype', headers: {
      var res = await get('advertisments/', headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('Total_Advertisements_List_Response===>${res.body.toString()}');
        //CommonDialog.hideLoading();
        return AdvertisementResponseModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  //53). For Clicking Advertisements
  Future<AdsClickModel> clickAdvertisement(body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      var res = await post('add-click-on-advertisement', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        // debugPrint('Total_Advertisements_List_Response===>${res.body.toString()}');
        //CommonDialog.hideLoading();
        return AdsClickModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await post('user/remove_connection_chat', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('connection_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      var res = await post('user/remove_notification', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('connection_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<ConnectionRemoveModel> readOtherUserMessage(
      dynamic body, Function() callBack) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;
      debugPrint(
          "readOtherUserMessage user/read_other_user_message map $body token $accessToken");
      var res = await post('user/read_other_user_message', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint(''
            'connection_response===>${res.body.toString()}');

        callBack() ?? () {};
        CommonDialog.hideLoading();
        return ConnectionRemoveModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      CommonDialog.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken')!;

      var res = await post('upload-file', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint("RegisterResponse${res.toString()}");
        CommonDialog.hideLoading();
        return UploadAudio.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
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
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      CommonDialog.showLoading();
      var res = await post('edit-review', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        debugPrint('editReview_response===>${res.body.toString()}');
        CommonDialog.hideLoading();
        return SubmitReviewModel.fromJson(res.body);
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
    throw "";
  }

  Future<void> updateLocation(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      debugPrint("post update location==> ${apiBaseUrl}user/update-location");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('userToken')!;
      //CommonDialog.showLoading();
      var res = await post('user/update-location', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      if (res.statusCode == 200) {
        //CommonDialog.hideLoading();
        return;
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
        throw "Error Occurred";
      } else {
        // CommonDialog.hideLoading();
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred";
    }
  }

  Future<void> buySubscription(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      CommonDialog.showLoading();
      debugPrint(
          "post buySubscription==> ${apiBaseUrl}user/update-subscription  bodyData : $body");
      var res = await post('user/update-subscription', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      debugPrint("buySubscription response ${res.body.toString()}");
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        return;
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred $e";
    }
  }

  Future<void> packageInquiry(dynamic body) async {
    try {
      httpClient.baseUrl = apiBaseUrl;
      httpClient.timeout = const Duration(seconds: 60);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('userToken') ?? "";
      CommonDialog.showLoading();
      debugPrint(
          "post packageInquiry==> ${apiBaseUrl}user/package-inquiry  bodyData : $body");
      var res = await post('user/package-inquiry', body, headers: {
        'accept': 'application/json',
        'Authorization': "Bearer $accessToken",
      });
      debugPrint("packageInquiry response ${res.body.toString()}");
      if (res.statusCode == 200) {
        CommonDialog.hideLoading();
        Get.back();
        return;
      } else if (res.statusCode == 401) {
        CommonDialog.hideLoading();
        if (res.hasError) {
          debugPrint("${res.body}");
          CommonFunctions.checkUnAuthorized(res);
        }
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
    } on DioError catch (e) {
      CommonDialog.hideLoading();
      CommonFunctions.checkUnAuthorized(e);
      //showToast(ApiHelper.processErrorInDioServerResponse(e));
      throw Exception('BarException');
    } catch (e) {
      CommonDialog.hideLoading();
      throw "Error Occurred $e";
    }
  }
}
