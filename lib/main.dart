import 'dart:io';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gagagonew/Service/fcm_notification_service.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/utils/common_functions.dart';
import 'package:gagagonew/utils/stream_controller.dart';
import 'package:gagagonew/view/a_test_payment/test_payment.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RouteHelper/route_helper.dart';
import 'Service/call_service.dart';
import 'Service/lang/localization_service.dart';
import 'Service/life_cycle_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dummy_screen.dart';
import 'model/update_language_model.dart';

io.Socket? socket;
bool showNotification = false;
String currentChatId = "";

updateCurrentChatId(String chatId, bool showNotify) {
  currentChatId = chatId;
  showNotification = showNotify;
  debugPrint(
      "currentChatId Main $currentChatId showNotification $showNotification");
}

resetFirebaseSettings() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

initializeSocket() {
  try {
    socket = io.io(
      CallService.socketUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      },
    );
    socket!.connect();
    socket!.onConnect((data) async {
      debugPrint('Connectedddd: $data');
      socket!.on('newnotification', (data) async {
        debugPrint("under home_page newNotification data $data");

        debugPrint('data:::::$data');
      });

      /*  SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('userId')!;
        socket!.emit('getNotification', {
          'my_id': userId,
        });*/
    });

    socket!.onConnectError((data) {
      debugPrint('Errors onConnectError: $data');
    });
  } catch (e) {
    debugPrint('Error $e');
  }
}

bool isForground = false;
AppStreamController appStreamController = AppStreamController.instance;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late List<CameraDescription> camerasAvailable;


// void main() {
//   runApp(PayMaterialApp());
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // print("value ------> 11 ${await Permission.notification.status}");

  /* var value = await Permission.notification
      .isDenied; *//*.then((value) async {
    print("value ------> $value");
    if (value) {
      await Permission.notification.request();
    }
  });*//*
  if (value) {
    await Permission.notification.request();
  }*/
  await Firebase.initializeApp();


  FcmNotificationService.init();

  initializeSocket();
  String? deviceToken;
  try {
    deviceToken = await FirebaseMessaging.instance.getToken();
  } catch (e) {
    print(e.toString());
  }
  debugPrint("device token $deviceToken");

  /*FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    print("Check Data   ${message?.data}");
    print("Check Data 2  ${message}");
    print("Check messageType 2  ${message?.messageType}");
    print("Check messageType 2  ${message?.notification}");
    print("Check messageType 2  ${message?.senderId}");

    if (message != null && message.data['type'] != null) {
      if (message.data['type'] == 'chat_message') {
        print("Check Data Here ");
        Get.toNamed(RouteHelper.getChatMessageScreen(
            message.data['sender_id'].toString(), "", "", ""));

        // Navigator.pushReplacement(navigator!.context, MaterialPageRoute(
        //   builder: (context) => ChatMessageScreen(receiverId:  message.data['sender_id'].toString()
        //   , connectionType: "",  commonInterest: "", isMeBlocked: "",)));

      } else if (message.data['type'] == 'match_notification') {
        Get.toNamed(RouteHelper.getConnectionsPage());
      } else {
        Navigator.push(
            navigator!.context,
            MaterialPageRoute(
              builder: (context) => Notifications(),
            )).then((value) => appStreamController.handleBottomTab.add(true));
      }
    }
  });*/

  HttpOverrides.global = MyHttpOverrides();
  /*ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());*/

  Locale locale = await getLocale();
  print("locale ---> ${locale.languageCode}");
  LocalizationService.setCurrentLocale(locale);
  //initializeDateFormatting(locale.languageCode, null);

  // Admob.initialize();
  runApp(MyApp(
    locale: locale,
  ));
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? currentLocale = prefs.getString(StringConstants.CURRENT_LOCALE);
  print("currentLocale --> $currentLocale");
  // if (currentLocale != Get.deviceLocale!.languageCode) {
  //   return Get.deviceLocale ?? StringConstants.LOCALE_ENGLISH;
  // } else {
  print("currentLocale $currentLocale");
  if (currentLocale == null) {
    print("Get.deviceLocale --> ${Get.deviceLocale}");
    // return StringConstants.LOCALE_PURTUGUESE_Brasil;
    // return Get.deviceLocale ?? StringConstants.LOCALE_ENGLISH;
  }
  if (currentLocale == StringConstants.LOCALE_ENGLISH_KEY) {
    return StringConstants.LOCALE_ENGLISH;
  } else if (currentLocale == StringConstants.LOCALE_FRENCH_KEY) {
    return StringConstants.LOCALE_FRENCH;
  } else if (currentLocale == StringConstants.LOCALE_PURTUGUESE_KEY) {
    return StringConstants.LOCALE_PURTUGUESE;
  } else if (currentLocale == StringConstants.LOCALE_PURTUGUESE_Brasil_KEY) {
    return StringConstants.LOCALE_PURTUGUESE_Brasil;
  } else if (currentLocale == StringConstants.LOCALE_SPANISH_KEY) {
    return StringConstants.LOCALE_SPANISH;
  } else {
    Locale local = Get.deviceLocale ?? StringConstants.LOCALE_ENGLISH;
    CommonFunctions().updateLanguageByCode(local.languageCode);
    return local;

    return StringConstants.LOCALE_ENGLISH;
  }
  // }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  Locale locale;
  MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    isForground = true;
    initLifeCycler();
  }

  initLifeCycler() {
    String oldLanguageCode = Platform.localeName.split('_')[0];

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        print("under resumeCallBack");
        isForground = true;
        String languageCode = Platform.localeName.split('_')[0];
        print(
            "under resumeCallBack oldLanguageCode $oldLanguageCode languageCode $languageCode");

        if (oldLanguageCode != languageCode) {
          oldLanguageCode = languageCode;
          String? accessToken;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          accessToken = prefs.getString('userToken');
          debugPrint("Access Token $accessToken");
          if (accessToken == null) {
            CommonFunctions().updateLanguageByCode(oldLanguageCode);
          } else {
            var map = <String, dynamic>{};
            map['lang'] = CommonFunctions.getIdFromLangCode(oldLanguageCode);

            print("updateLanguageByCode  -> map ---> $map");
            UpdateLanguageModel model =
            await CallService().updateLanguage(map, showLoader: false);
            if (model.status!) {
              CommonFunctions().updateLanguage(
                model.langId!,
                Get.overlayContext ?? context,
              );
              prefs.setInt("language_id",
                  CommonFunctions.getIdFromLangCode(oldLanguageCode));
              // CommonDialog.showToastMessage(model.message!.tr);
            } else {
              // CommonDialog.showToastMessage(model.message.toString().tr);
            }
          }
        }
        print("under resumeCallBack $isForground");
      },
      suspendingCallBack: () async {
        isForground = false;
        print("under suspendingCallBack $isForground");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent, //top status bar
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor:
          Colors.white, // navigation bar color, the one Im looking for
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
        ),
        child: GetMaterialApp(
          key: navigatorKey,
          title: 'Gagago',

          debugShowCheckedModeBanner: false,
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          localizationsDelegates: const [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('pt'),
            Locale('fr'),
            Locale('es'),
            // Chinese *See Advanced Locales below*
            // ... other locales the app supports
          ],

          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),

          //<<-- backup code //
          // translations: MultiLanguages(),
          // locale: Locale('en', 'US'),
          // fallbackLocale: Locale('en', 'US'),
          //backup code -->>
          locale: widget.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          translations: LocalizationService(),
          initialRoute: RouteHelper.getSplash(),
          getPages: RouteHelper.routes,
          // home:  DummyScreen(),
        ));
  }
}
