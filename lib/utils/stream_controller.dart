import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class AppStreamController {
  AppStreamController._internal();
  static final AppStreamController _instance = AppStreamController._internal();
  static AppStreamController get instance => _instance;

  StreamController<bool> handleBottomTab = StreamController.broadcast();
  Stream get handleBottomTabAction => handleBottomTab.stream;

  void disposeHandleBottomTabStream() => handleBottomTab.close();

  void rebuildHandleBottomTabStream() {
    if (handleBottomTab.isClosed) {
      handleBottomTab = StreamController.broadcast();
    }
  }

  StreamController<int> handleUpdateBottomTab = StreamController.broadcast();
  Stream get handleUpdateBottomTabAction => handleUpdateBottomTab.stream;

  void disposeHandleUpdateBottomTabStream() => handleUpdateBottomTab.close();

  void rebuildHandleUpdateBottomTabStream() {
    if (handleUpdateBottomTab.isClosed) {
      handleUpdateBottomTab = StreamController.broadcast();
    }
  }

  StreamController<BadgesCountModel> updateBadgesCount =
      StreamController.broadcast();
  Stream<BadgesCountModel> get updateBadgesCountAction =>
      updateBadgesCount.stream;

  void disposeupdateBadgesCountStream() => updateBadgesCount.close();

  void rebuildupdateBadgesCountStream() {
    if (updateBadgesCount.isClosed) {
      updateBadgesCount = StreamController.broadcast();
    }
  }

  StreamController<int> refreshBottomNavPage = StreamController.broadcast();
  Stream<int> get refreshBottomNavPageAction => refreshBottomNavPage.stream;

  void disposeRefreshBottomNavPageStream() => updateBadgesCount.close();

  void rebuildRefreshBottomNavPageStream() {
    if (refreshBottomNavPage.isClosed) {
      refreshBottomNavPage = StreamController.broadcast();
    }
  }

  StreamController<bool> refreshSettingPage = StreamController.broadcast();
  Stream get refreshSettingPageAction => refreshSettingPage.stream;

  void refreshSettingPageStream() {
    if (refreshSettingPage.isClosed) {
      refreshSettingPage = StreamController.broadcast();
    }
  }

  void disposeRefreshSettingPageStream() {
    refreshSettingPage.close();
  }

  StreamController<bool> refreshProfilePage = StreamController.broadcast();
  Stream get refreshProfilePageAction => refreshProfilePage.stream;

  void refreshProfilePageStream() {
    if (refreshProfilePage.isClosed) {
      refreshProfilePage = StreamController.broadcast();
    }
  }

  void disposeRefreshProfilePageStream() {
    refreshProfilePage.close();
  }

  StreamController<int> refreshHomePage = StreamController.broadcast();
  Stream<int> get refreshHomePageAction => refreshHomePage.stream;

  void disposeRefreshHomePageStream() => refreshHomePage.close();

  void rebuildRefreshHomePageStream() {
    if (refreshHomePage.isClosed) {
      refreshBottomNavPage = StreamController.broadcast();
    }
  }

  StreamController<bool> handleRefreshHomeScreen = StreamController.broadcast();
  Stream<bool> get handleRefreshHomeScreenAction =>
      handleRefreshHomeScreen.stream;

  void disposeRefreshHomeScreenStream() => handleRefreshHomeScreen.close();

  void rebuildRefreshHomeScreenStream() {
    if (handleRefreshHomeScreen.isClosed) {
      handleRefreshHomeScreen = StreamController.broadcast();
    }
  }

  StreamController<RemoteMessage> handleHomeScreenNotification =
      StreamController.broadcast();
  Stream<RemoteMessage> get handleHomeScreenNotificationAction =>
      handleHomeScreenNotification.stream;

  void disposeHomeScreenNotificationStream() =>
      handleHomeScreenNotification.close();

  void rebuildHomeScreenNotificationStream() {
    if (handleHomeScreenNotification.isClosed) {
      handleHomeScreenNotification = StreamController.broadcast();
    }
  }
}

class BadgesCountModel {
  final int? likeCount;
  final int? chatCount;
  final int? notificationCount;

  BadgesCountModel({this.likeCount, this.chatCount, this.notificationCount});
}
