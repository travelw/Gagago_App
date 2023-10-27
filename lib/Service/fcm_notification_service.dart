import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gagagonew/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../main.dart';
import '../utils/stream_controller.dart';

class FcmNotificationService {
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;

  static bool isFlutterLocalNotificationsInitialized = false;

  String? previousTitle;
  String? previousBody;
  Map<String, int> notificationCountMap = {}; // to maintain notification count for each user

  static init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (socket == null) {
        initializeSocket();
      }

      // increment the notification count for this chat

/*    if (message.data['type'] == 'chat_message') {
      if (message.data['sender_id'] != currentChatId) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        showFlutterNotification(message);
      }
    }else {
      debugPrint(" enter else");
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      showFlutterNotification(message);
    }*/
      debugPrint("under notification --> main ${message.data}");
      // socket!.emit('getNewConnectionNotification',
      //     {'other_user_id': 360, 'login_user_id': 372});

      if (message.data['type'] == 'chat_message') {
        if (message.data['sender_id'] != currentChatId) {
          if (isForground) {
            showFlutterNotification(message);
          }
        } else {
          if (showNotification) {
            debugPrint("enter showNotification!  $showNotification");
            if (isForground) {
              showFlutterNotification(message);
            }
          } else {
            debugPrint("enter else showNotification!  $showNotification");
            // await FirebaseMessaging.instance
            //     .setForegroundNotificationPresentationOptions(
            //   alert: false,
            //   badge: false,
            //   sound: false,
            // );
          }
        }
      } else {
        debugPrint(" enter else");
        // await FirebaseMessaging.instance
        //     .setForegroundNotificationPresentationOptions(
        //   alert: true,
        //   badge: true,
        //   sound: true,
        // );
        showFlutterNotification(message);
      }
      debugPrint('Handling a foreground message ${message.messageId}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("CheckData   ${message.data}");
      print("CheckData 2  ${message}");
      print("Check messageType 2 :::>  ${message.messageType}");
      print("Check messageType 2 :::::>  ${message.notification}");
      print("Check messageType 2 ::::::>  ${message.senderId}");

      AppStreamController appStreamController = AppStreamController.instance;

      Future.delayed(const Duration(milliseconds: 200), () {
        appStreamController.rebuildHomeScreenNotificationStream();
        appStreamController.handleHomeScreenNotification.add(message);
        print("time out ");
      });
      return;
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: false,
    //   badge: false,
    //   sound: false,
    // );
    // await setupFlutterNotifications();
    // showFlutterNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    debugPrint('Handling a background message ${message.messageId}');
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('drawable/ic_notification');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      // requestAlertPermission : true,
      // requestSoundPermission : true,
      // requestBadgePermission : true,
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications',
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    // await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel);
    }

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!.initialize(initializationSettings.iOS!);
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: Platform.isIOS ? false : true,
      badge: Platform.isIOS ? false : true,
      sound: Platform.isIOS ? false : true,
      // alert: true,
      // badge: true,
      // sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) async {
    debugPrint("notification title ${message.data}");
    debugPrint("notification title ${message.notification!.title} ${message.notification!.body}");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification!.title == null) {
      return;
    }
    // if (notification.title == previousTitle && notification.body == previousBody) {
    //   // This notification is the same as the previous one, so don't show it again
    //   return;
    // }
    // previousTitle = notification.title;
    // previousBody = notification.body;
    //
    // String senderId = message.data['sender_id'];
    //
    // // Check if there is already a notification for this sender
    // if (notification.toString().isNotEmpty &&
    //     android.toString().isNotEmpty &&
    //     !kIsWeb) {
    //   // Check if notification count for this sender exists in notificationCountMap
    //   int count = notificationCountMap[message.data['sender_id']] ?? 0;
    //
    //   // Create the notification details
    //   NotificationDetails notificationDetails = NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       channel.description,
    //       icon: 'drawable/ic_notification',
    //       importance: Importance.max,
    //     ),
    //   );
    //
    //   // Show the notification only if the count is 0
    //   if (count == 0) {
    //     _flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       notificationDetails,
    //     );
    //   }
    //
    //   // Increment the count for this sender in notificationCountMap
    //   notificationCountMap[message.data['sender_id']] = count + 1;
    // }

    if (notification.toString().isNotEmpty && android.toString().isNotEmpty && !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'drawable/ic_notification',
              importance: Importance.max,
            ),
            iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBadge: true)),
      );
    }
    // else if(apple!=null){
    //   flutterLocalNotificationsPlugin.show(
    //     notification.hashCode,
    //     notification.title,
    //     notification.body,
    //     NotificationDetails(
    //    iOS: DarwinNotificationDetails()
    //     ),
    //   );
    // }
  }
}
