import 'package:gagagonew/view/app_html_view_screen.dart';
import 'package:gagagonew/view/home/contact_us_page.dart';
import 'package:gagagonew/view/home/feedback_screen.dart';
import 'package:gagagonew/view/home/invite_friend.dart';
import 'package:gagagonew/view/home/match_users_list.dart';
import 'package:gagagonew/view/home/payment_successfully_done_screen.dart';
import 'package:gagagonew/view/home/user_history_page.dart';
import 'package:gagagonew/view/home/user_profile_liked_screen.dart';
import 'package:gagagonew/view/home/user_subscription.dart';
import 'package:gagagonew/view/login/splash_screen.dart';
import 'package:gagagonew/view/settings/select_destination.dart';
import 'package:get/get.dart';
import '../view/chat/chat_message_screen.dart';
import '../view/connections/connections_page.dart';
import '../view/home/block_list.dart';
import '../view/home/bottom_nav_page.dart';
import '../view/home/contact_us_thank_you_screen.dart';
import '../view/home/destinations_sceen.dart';
import '../view/home/edit_profile.dart';
import '../view/home/notifications_page.dart';
import '../view/home/notifications_settings_page.dart';
import '../view/home/terms_of_conditions.dart';
import '../view/login/create_new_password.dart';
import '../view/login/forgot_password_screen.dart';
import '../view/login/login_screen.dart';
import '../view/login/password_reset_successfully.dart';
import '../view/login/terms_and_conditions.dart';
import '../view/login/verify_your_profile.dart';
import '../view/review/reviews_page.dart';
import '../view/review/write_review.dart';
import '../view/sign_up/destinations.dart';
import '../view/sign_up/meet_now_screen.dart';
import '../view/sign_up/sign_up_images.dart';
import '../view/sign_up/sign_up_preference.dart';
import '../view/sign_up/sign_up_screen.dart';
import '../view/sign_up/sign_up_trip_details.dart';

class RouteHelper {
  //Route Strings
  static const String splash = "/";
  static const String loginPage = "/loginPage";
  static const String forgotPassword = "/forgotPassword";
  static const String verifyYourCodePage = "/verifyYourProfile";
  static const String createNewPassword = "/createNewPassword";
  static const String passwordResetAndRegisterSuccessfully =
      "/passwordResetAndRegisterSuccessfully";
  static const String termsAndConditions = "/termsAndConditions";
  static const String bottomSheetPage = "/bottomSheetPage";
  static const String signUpPreferencePage = "/signUpPreference";
  static const String signUpTripDetails = "/signUpTripDetails";
  static const String signUpImages = "/signUpImages";
  static const String signup = "/signup";
  static const String htmlScreen = "/htmlScreen";
  static const String meetNow = "/meetNow";
  static const String destinations = "/destinations";
  static const String destinationScreen =
      "/destinationsScreen"; // this is for Destinations screen in edit profile

  static const String writeReviewPage = "/writeReviewPage";
  static const String reviewsPage = "/reviewsPage";
  static const String editProfile = "/editProfile";
  static const String chatMessageScreen = "/chatMessageScreen";
  static const String connectionsPage = "/connectionsPage";
  static const String myProfilePage = "/myProfilePage";
  static const String contactUs = "/contactUs";
  static const String notifications = "/notifications";
  static const String notificationSettingsScreen =
      "/notificationSettingsScreen";
  static const String settingsTerms = "/settingsTerms";
  static const String userProfileLike = "/userProfileLike";
  static const String userFeedBack = "/userFeedBack";
  static const String userSubscription = "/userSubscription";
  static const String paymentSuccessfullyDone = "/paymentSuccessfullyDone";
  static const String matchUserList = "/matchUserList";
  static const String userHistoryList = "/userHistoryList";
  static const String inviteFriend = "/inviteFriend";
  static const String meetNowDestination = "/meetNowDestination";
  static const String othersUserProfile = '/otherProfile';
  static const String thankYou = "/thankYou";

  static String getSplash() => splash;

  static String getLoginPage() => loginPage;
  static String getMyProfilePage(
          String userName,
          String phoneNumber,
          String email,
          String isSubscribe,
          String profilePic,
          String countryCode) =>
      '$myProfilePage?userName=$userName&phoneNumber=$phoneNumber&email=$email&isSubscribe=$isSubscribe&profilePic=$profilePic&countryCode=$countryCode';

  static String getForgotPassword() => forgotPassword;

  static String otherUserProfile() => othersUserProfile;
  static String getThankYou() => thankYou;
  static String getPaymentSuccess() => paymentSuccessfullyDone;
  static String getMatchUserList() => matchUserList;
  static String getUserHistoryList() => userHistoryList;
  static String getMeetNow(String isSubscribe) =>
      '$meetNow?isSubscribe=$isSubscribe';
  static String getDestinations(String isSubscribe) =>
      '$destinations?isSubscribe=$isSubscribe';
  static String getDestinationsScreen(String isSubscribe) =>
      '$destinationScreen?isSubscribe=$isSubscribe';
  static String getSelectMeetDestination(String isSubscribe) =>
      '$meetNowDestination?isSubscribe=$isSubscribe';

  static String getContactUs(String userName, String email) =>
      '$contactUs?userName=$userName&email=$email';
  static String getSettingsTerms(String title) => '$settingsTerms?title=$title';

  static String getNotifications() => notifications;
  static String getNotificationsSettingScreen() => notificationSettingsScreen;
  static String getConnection() => connectionsPage;

  static String getProfileLikeUsers() => userProfileLike;
  static String getUserFeedBack() => userFeedBack;

  static String getVerifyYourCodePage(String email, String countryCode) =>
      '$verifyYourCodePage?email=$email&countryCode=$countryCode';
  static String getCreateNewPasswordPage(
          String email, String token, String countryCode) =>
      '$createNewPassword?email=$email&token=$token&countryCode=$countryCode';
  static String getPasswordResetAndRegisterSuccessfully(
          int checkResetAndRegPage) =>
      '$passwordResetAndRegisterSuccessfully?checkResetAndRegPage=$checkResetAndRegPage';
  static String getTermsAndConditions() => termsAndConditions;
  static String getBottomSheetPage() => bottomSheetPage;
  static String getSignUpPreferencePage() => signUpPreferencePage;
  static String getSignUpTripDetailsPage() => signUpTripDetails;
  static String getSignUpImagesPage() => signUpImages;
  static String getSignUpPage(
          {bool isSocialSignup = false,
          String? socialFirstName,
          String? socialLastName,
          String? socialEmail,
          String? socialImageUrl,
          String? socialType,
          String? socialToken}) =>
      '$signup?isSocialSignup=$isSocialSignup&socialFirstName=$socialFirstName&socialLastName=$socialLastName&socialEmail=$socialEmail&socialImageUrl=$socialImageUrl&socialType=$socialType&socialToken=$socialToken';
  static String getHtmlScreen({String? apiKey, String? title}) =>
      '$htmlScreen?apiKey=$apiKey&title=$title';

  static String getWriteReviewPage(String userId, String userName) =>
      '$writeReviewPage?userId=$userId&userName=$userName';
  static String getReviewsPage(String userId) => '$reviewsPage?userId=$userId';
  static String getEditProfile() => editProfile;
  //static String getChatMessageScreen(String receiverId)=>'$chatMessageScreen?receiverId=$receiverId';
  static String getConnectionsPage() => connectionsPage;
  static String getPlanList() => userSubscription;
  static String getInviteFriend() => inviteFriend;
  static String getChatMessageScreen(String receiverId, String connectionType,
          String commonInterest, String isMeBlocked) =>
      '$chatMessageScreen?receiverId=$receiverId&connectionType=$connectionType&commonInterest=$commonInterest&isMeBlocked=$isMeBlocked';

  // static String getAccountConfirmationPage(String firstMsg, String secondMsg) =>
  //     '$accountConfirmationPage?firstMsg=$firstMsg&secondMsg=$secondMsg';
  //
  static const String blockUsers = "/blockUsers";
  static String getBlockUserLists() => blockUsers;

  //Route List
  static List<GetPage> routes = [
    GetPage(
      page: () => const SplashScreen(),
      name: splash,
    ),
    GetPage(
        name: meetNowDestination,
        page: () {
          var isSubscribe = Get.parameters['isSubscribe'];
          return SelectDestination(subscribe: isSubscribe);
        }),
    GetPage(name: inviteFriend, page: () => const InviteFriend()),
    GetPage(name: blockUsers, page: () => const BlockUserListScreen()),
    GetPage(name: thankYou, page: () => const ThankYouScreen()),
    GetPage(
        name: paymentSuccessfullyDone,
        page: () => const PaymentSuccessFullyDoneScreen()),
    GetPage(name: matchUserList, page: () => const MatchUserListScreen()),
    GetPage(name: userHistoryList, page: () => const UserHistoryScreen()),
    GetPage(name: loginPage, page: () => const LoginScreen()),
    GetPage(name: userFeedBack, page: () => const FeedBackScreen()),
    GetPage(name: notifications, page: () => Notifications()),
    GetPage(
        name: notificationSettingsScreen,
        page: () => NotificationSettingsScreen()),
    GetPage(name: userProfileLike, page: () => const UserLikedListScreen()),
    GetPage(
        name: settingsTerms,
        page: () {
          var title = Get.parameters['title'];
          return TermsConditions(
            title: title,
          );
        }),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: userSubscription, page: () => const UserSubscriptionScreen()),
    GetPage(
        name: verifyYourCodePage,
        page: () {
          var email = Get.parameters['email'];
          var countryCode = Get.parameters['countryCode'];
          return VerifyYourProfile(
            email: email.toString(),
            countryCode: countryCode.toString(),
          );
        }),
    GetPage(
        name: createNewPassword,
        page: () {
          var email = Get.parameters['email'];
          var token = Get.parameters['token'];
          var countryCode = Get.parameters['countryCode'];
          return CreateNewPasswordPage(
              email: email, token: token, countryCode: countryCode);
        }),
    GetPage(
        name: passwordResetAndRegisterSuccessfully,
        page: () {
          var checkResetAndRegPage = Get.parameters['checkResetAndRegPage'];
          return PasswordResetAndRegisterSuccessfully(
            checkResetAndRegPage: int.parse(checkResetAndRegPage.toString()),
          );
        }),
    GetPage(name: termsAndConditions, page: () => const TermsAndConditions()),
    GetPage(name: bottomSheetPage, page: () => BottomNavigation()),
    GetPage(name: signUpPreferencePage, page: () => const SignUpPreference()),
    GetPage(name: signUpTripDetails, page: () => const SignUpTripDetails()),
    GetPage(name: signUpImages, page: () => const SignUpImages()),
    GetPage(
        name: signup,
        page: () {
          print("signup data --> ${Get.parameters}");
          var isSocialSignup = false;
          if (Get.parameters['isSocialSignup'] != null) {
            if (Get.parameters['isSocialSignup'] == "true") {
              isSocialSignup = true;
            }
          }
          var socialFirstName = Get.parameters['socialFirstName'];
          var socialLastName = Get.parameters['socialLastName'];
          var socialEmail = Get.parameters['socialEmail'];
          var socialImageUrl = Get.parameters['socialImageUrl'];
          var socialType = Get.parameters['socialType'];
          var socialToken = Get.parameters['socialToken'];
          if (isSocialSignup ?? false) {
            return SignUp(
                isSocialSignup: isSocialSignup,
                socialFirstName: socialFirstName,
                socialLastName: socialLastName,
                socialEmail: socialEmail,
                socialImageUrl: socialImageUrl,
                socialType: socialType,
                socialToken: socialToken);
          } else {
            return SignUp();
          }
        }),
    GetPage(
        name: htmlScreen,
        page: () {
          var apiKey = Get.parameters['apiKey'];
          var title = Get.parameters['title'];
          bool isAuth = Get.parameters['isAuth'] as bool;
          return AppHtmlViewScreen(
            apiKey: apiKey,
            title: title,
            isAuth: isAuth,
          );
        }),
    GetPage(
        name: writeReviewPage,
        page: () {
          var userId = Get.parameters['userId'];
          var userName = Get.parameters['userName'];
          return WriteReviewPage(userId: userId, userName: userName);
        }),
    GetPage(
        name: chatMessageScreen,
        page: () {
          var receiverId = Get.parameters['receiverId'];
          var connectionType = Get.parameters['connectionType'];
          var commonInterest = Get.parameters['commonInterest'];
          var isMeBlocked = Get.parameters['isMeBlocked'];
          return ChatMessageScreen(
            receiverId: receiverId,
            connectionType: connectionType,
            commonInterest: commonInterest,
            isMeBlocked: isMeBlocked,
          );
        }),
    /* GetPage(name: reviewsPage, page: ()=>ReviewsPage()),*/
    GetPage(
        name: reviewsPage,
        page: () {
          var userId = Get.parameters['userId'];
          return ReviewsPage(
            userId: userId,
          );
        }),
    GetPage(name: editProfile, page: () => const EditProfile()),

    /*GetPage(name: chatMessageScreen, page: (){
      var receiverId=Get.parameters['receiverId'];
      return ChatMessageScreen(receiverId: receiverId);
    }),*/
    GetPage(name: connectionsPage, page: () => const ConnectionsPage()),
    /* GetPage(name: myProfilePage, page: (){
      var userName = Get.parameters['userName'];
      var phoneNumber =Get.parameters['phoneNumber'];
      var email =Get.parameters['email'];
      var isSubscribe =Get.parameters['isSubscribe'];
      var profilePic =Get.parameters['profilePic'];
      var countryCode =Get.parameters['countryCode'];
      return PersonalInfo(userName: userName,
        phoneNumber: phoneNumber,email: email,isSubscriber: isSubscribe,profilePic: profilePic,countryCode:countryCode);
    }),*/

    GetPage(
        name: contactUs,
        page: () {
          var userName = Get.parameters['userName'];
          var email = Get.parameters['email'];
          return ContactUs(
            userName: userName,
            email: email.toString(),
          );
        }),

    GetPage(
        name: meetNow,
        page: () {
          var isSubscribe = Get.parameters['isSubscribe'];
          return MeetNow(subscribe: isSubscribe);
        }),
    GetPage(
        name: destinations,
        page: () {
          var isSubscribe = Get.parameters['isSubscribe'];
          return Destinations(subscribe: isSubscribe);
        }),
    GetPage(
        name: destinationScreen,
        page: () {
          var isSubscribe = Get.parameters['isSubscribe'];
          return DestinationsScreen(subscribe: isSubscribe);
        }),
    // GetPage(
    //      name: accountConfirmationPage,
    //      page: () {
    //        var secondMsg = Get.parameters['secondMsg'];
    //        var firstMsg = Get.parameters['firstMsg'];
    //        return AccountConfirmationPage(
    //          firstMsg: firstMsg,
    //          secondMsg: secondMsg,
    //        );
    //      }),
  ];
}
