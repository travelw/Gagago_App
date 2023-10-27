import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/Service/call_service.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/user_profile_model.dart';
import 'package:gagagonew/view/home/user_profile_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../utils/stream_controller.dart';
import '../chat/chat_message_screen.dart';
import '../connections/connections_page.dart';
import '../drawer/drawer_page.dart';
import '../packages/packages_list_screen.dart';
import '../settings/userProfile_setting_page.dart';
import 'home_page.dart';
import 'notifications_page.dart';

int isAlreadySelected = 0;
int selectedBottomIndex = 0;
int previousSelectTab = 0;
int? userMode;
bool isFilterChanged = false;
ScrollController scrollController = ScrollController();
RemoteMessage? notificationMessage;

String currentAddress = "";
String latitude = "";
String longitude = "";

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

AppStreamController bottomAppStreamController = AppStreamController.instance;

initBackgroundNotifLis(context) async {
  RemoteMessage? terminatedMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (terminatedMessage != null) {
    // this is a function I created to route to a page
    handleRemoteMessage(terminatedMessage, context);
  }
}

initNotificationListener(context) async {
  bottomAppStreamController.handleHomeScreenNotificationAction.listen((event) async {
    print("under initNotification $event");

    handleRemoteMessage(event, context);
  });
}

handleRemoteMessage(RemoteMessage? event, context) async {
  if (event != null) {
    if (event is RemoteMessage) {
      RemoteMessage message = event as RemoteMessage;

      print("handleRefreshHomeScreenAction CheckData   ${message.data}");
      print("handleRefreshHomeScreenAction CheckData 2  $message");
      print("handleRefreshHomeScreenAction Check messageType 2 :::>  ${message.messageType}");
      print("handleRefreshHomeScreenAction Check messageType 2 :::::>  ${message.notification}");
      print("handleRefreshHomeScreenAction Check messageType 2 ::::::>  ${message.senderId}");
      await Future.delayed(const Duration(milliseconds: 500));
      if (message.data['notification_type'] == 'chat_message' || message.data['type'] == 'chat_message') {
        // Get.toNamed(RouteHelper.getChatMessageScreen(
        //     message.data['sender_id'].toString(), "", "", ""));
        Navigator.push(
          context ?? Get.overlayContext!,
          // mContext ?? navigator!.context,
          // Get.overlayContext!,

          MaterialPageRoute(builder: (context) => ChatMessageScreen(receiverId: message.data['sender_id'].toString(), connectionType: "", commonInterest: "", isMeBlocked: "")),
        ).then((value) => appStreamController.handleBottomTab.add(true));
      } else if (message.data['type'] == 'match_notification' || message.data['notification_type'] == 'match_notification') {
        print("under call Notification Screen");
        // Get.toNamed(RouteHelper.getConnectionsPage());
        Navigator.push(
          context ?? Get.overlayContext!,
          // mContext ?? navigator!.context,
          // Get.overlayContext!,

          MaterialPageRoute(builder: (context) => const ConnectionsPage()),
        ).then((value) => appStreamController.handleBottomTab.add(true));
      } else {
        Navigator.push(
            context ?? Get.overlayContext!,

            // mContext ?? navigator!.context,
            // Get.overlayContext!,
            MaterialPageRoute(
              builder: (context) => Notifications(),
            )).then((value) => appStreamController.handleBottomTab.add(true));
      }
    }
  }
}

class BottomNavigation extends StatefulWidget {
  RemoteMessage? notificationMessage;
  BottomNavigation({Key? key, this.notificationMessage}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  //BottomNavController bottomNavController = Get.put(BottomNavController());
  int currentIndex = 0;
  String profilePic = "";
  List<User> userList = [];

  bool showBottomBar = true;

  initStreamListener() {
    appStreamController.handleBottomTabAction.listen((event) {
      debugPrint("under bottom nav stream event $event");
      if (event != null) {
        showBottomBar = event;
        if (mounted) {
          setState(() {});
        }
      }
    });

    appStreamController.handleUpdateBottomTabAction.listen((event) {
      debugPrint("under bottom nav stream event $event");
      if (event != null) {
        if (event is int) {
          onTapNav(event);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    notificationMessage = widget.notificationMessage;
    init();
    initStreamListener();
    selectedBottomIndex = 0;
    pages = [
      // HomePage(),
      // HomePage(),
      HomePage(
        addScrollController: false,
      ),
      HomePage(
        addScrollController: true,
      ),
      const PackagesListScreen(),
      /*MorePage(),*/
      const ProfileSettingPage(),
      //SettingPage(),
      UserProfilePage(callBack: onTabTapped1),
    ];
    updateUserProfile();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState(() {
    userMode = prefs.getInt('userMode') ?? 0;
    // });
  }

  void onTabTapped1(String value) {
    updateUserProfile();
  }

  updateUserProfile() async {
    print("under updateUserProfile --> ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProfileModel model = await CallService().getUserProfile(showLoader: false);
      if (mounted) {
        setState(() {
          userList = model.user!;

          if (userList.isNotEmpty) {
            // prefs.setString(StringConstants.selectedSexualOrientation, userList.first.sexualOrientation!);
            // prefs.setString(StringConstants.selectedGender, userList.first.gender!);
            // prefs.setString(StringConstants.selectedTripStyle, userList.first.tripStyle!);
            // prefs.setString(StringConstants.selectedTripTimeline, userList.first.tripTimeline!);
            // prefs.setString(StringConstants.selectedEthnicity, userList.first.ethinicity == null ? '' : userList.first.ethinicity!);
            //
            // prefs.setInt(StringConstants.selectedIsSubscribe, userList.first.isSubscriber!);
            // prefs.setBool(StringConstants.selectedVisibleOrientation, userList[0].isShowSexualOrientation == 'Yes');
            // prefs.setBool(StringConstants.selectedVisibleGender, userList[0].isShowGender == 'Yes');
            // prefs.setBool(StringConstants.selectedVisibleEthnicity, userList[0].isShowEthnicity == 'Yes');
            // prefs.setString(StringConstants.myAddedBio,    userList[0].bio.toString());
          }

          profilePic = userList[0].userimages!.isNotEmpty ? userList[0].userimages![0].imageName! : "";
          debugPrint("UserProfile $profilePic");
        });
      }
    });
  }

  ListQueue<int> _navigationQueue = ListQueue();
  int indexBack = 0;
  List<Widget>? pages = [];
  final List<GlobalKey<NavigatorState>> states = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> getNavigators() {
    List<Widget> widgets = [];
    pages![1];
    for (int i = 0; i < pages!.length; i++) {
      widgets.add(Navigator(
        // The key in necessary for two reasons:
        // 1 - For the framework to understand that we're replacing the
        // navigator even though its type and location in the tree is
        // the same. For this isolate purpose a simple ValueKey would fit.
        // 2 - Being able to access the Navigator's state inside the onWillPop
        // callback and for emptying its stack when a tab is re-selected.
        // That is why a GlobalKey is needed instead of a simple ValueKey.
        key: states[i],
        // Since this isn't the purpose of this sample, we're not using named
        // routes. Because of that, the onGenerateRoute callback will be
        // called only for the initial route.
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => pages![i],
        ),
      ));
    }
    return widgets;
  }

  bool isHomeReload = false;

  void onTapNav(int index) async {
    debugPrint("index --> $index");
    previousSelectTab = selectedBottomIndex;
    selectedBottomIndex = index;

    print(selectedBottomIndex);

    if (selectedBottomIndex == 1 && scaffoldKey.currentState != null) {
      if (isFilterChanged) {
        // appStreamController.handleRefreshHomeScreen.add(true);
        isFilterChanged = false;
      }
      // isAlreadySelected = 0;

      if (states[selectedBottomIndex].currentState != null) {
        if (states[selectedBottomIndex].currentState!.canPop()) {
          isAlreadySelected = 0;
        } else {
          isAlreadySelected++;
          print(isAlreadySelected);
        }
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);
      }

      if (mounted) {
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 20), () async {
        scaffoldKey.currentState?.openDrawer();
      });

      debugPrint("check on tap 1");
    }
    // setState(() {});

    debugPrint('index==>>$index');
    debugPrint("fxgdfhf∂==>>$isAlreadySelected");
    debugPrint("fxgdfhf∂==>>$selectedBottomIndex");
    if (index == 0) {
      if (isFilterChanged) {
        appStreamController.handleRefreshHomeScreen.add(true);
        isFilterChanged = false;
      }
      if (states[selectedBottomIndex].currentState != null) {
        if (states[selectedBottomIndex].currentState!.canPop()) {
          isAlreadySelected = 0;
        } else {
          isAlreadySelected++;
          print(isAlreadySelected);
        }
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);
      }
      debugPrint("isAlreadySelected==>>$isAlreadySelected");

      if (isAlreadySelected == 0) {
        debugPrint("Xcgcgh==>>$isAlreadySelected");
      }
      /*else if (isAlreadySelected == 1) {
        print("dgdsg==>$isAlreadySelected");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // if (scrollController.hasClients) {
         */ /* await scrollController.animateTo(
            0,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 700),
          );*/ /*
          // }
        });
        _selectedIndex = 0;
        setState(() {});
      }*/
      else if (isAlreadySelected >= 1) {
        debugPrint("dgdsg==>$isAlreadySelected");
        debugPrint("isHomeReload $isHomeReload");
        if (isHomeReload) {
          scrollController.animateTo(
            0,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 700),
          );
        }
        /*WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (scrollController.hasClients) {
            await scrollController.animateTo(
              0,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 700),
            );
          }
          */ /*if(scrollController.hasClients){
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 700), curve: Curves.linear);
          }*/ /*
        });*/
      }
      setState(() {});
    } else if (index == 1) {
      // scaffoldKey.currentState?.openDrawer();
    } else if (index == 2) {
      if (states[selectedBottomIndex].currentState != null) {
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);
        // appStreamController.refreshSettingPageStream();
        // appStreamController.refreshSettingPage.add(true);
      }
      isAlreadySelected = 0;
      //appStreamController.rebuildRefreshBottomNavPageStream();
      //appStreamController.refreshBottomNavPage.add(2);
      setState(() {});
    } else if (index == 3) {
      if (states[selectedBottomIndex].currentState != null) {
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);

        appStreamController.refreshSettingPageStream();
        appStreamController.refreshSettingPage.add(true);
      }
      isAlreadySelected = 0;
      debugPrint("dfgxbgchffgf");
      setState(() {});
    } else if (index == 4) {
      if (states[selectedBottomIndex].currentState != null) {
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);
        appStreamController.refreshProfilePageStream();
        appStreamController.refreshProfilePage.add(true);
      }
      isAlreadySelected = 0;
      debugPrint("dfgxbgchffgf");
      setState(() {});
    }
    printInfo(info: 'tab clicked');

    if (index == 0) {
      isHomeReload = true;
      setState(() {});
    } else {
      isHomeReload = false;
    }
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == selectedBottomIndex) {
        states[selectedBottomIndex].currentState!.popUntil((route) => route.isFirst);
      } else {
        selectedBottomIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("selectedBottomIndex --> $selectedBottomIndex");
    return WillPopScope(
      onWillPop: () async {
        print("under onWillPop");
        if (states[selectedBottomIndex].currentState!.canPop()) {
          print("under onWillPop under  if");

          return !await states[selectedBottomIndex].currentState!.maybePop();
        } else {
          isAlreadySelected++;
          isHomeReload = true;
          print("under onWillPop under  else");

          if (selectedBottomIndex != 0) {
            print("under onWillPop under  else if");

            onTabTapped(0);
            return false;
          } else {
            print("under onWillPop under  else else");

            return true;
          }
        }
      },
      child: Scaffold(
          drawer: selectedBottomIndex == 1 ? DrawerPage() : null,
          // floatingActionButton: FloatingActionButton(onPressed: (){
          //
          //   Get.to(ChatPage());
          // },),
          //extendBody: true,
          // body: Obx(
          //   () => IndexedStack(
          //     index: bottomNavController.selectedIndex.value,
          //     children: screens,
          //   ),
          // ),
          key: scaffoldKey,
          body:

              // getNavigators()[_selectedIndex]

              IndexedStack(
            index: selectedBottomIndex,
            children: getNavigators(),
          ),
          bottomNavigationBar: !showBottomBar
              ? const SizedBox()
              : Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: (BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.black,
                      selectedFontSize: 0,
                      unselectedItemColor: Colors.black,
                      onTap: onTapNav,
                      currentIndex: selectedBottomIndex,
                      items: [
                        BottomNavigationBarItem(
                            activeIcon: SvgPicture.asset("assets/images/svg/home_active.svg"),
                            icon:
                                //Icon(Icons.home_outlined,size: Get.height*0.055,),
                                SvgPicture.asset("assets/images/svg/home.svg"),
                            label: ""),
                        BottomNavigationBarItem(
                            activeIcon: SvgPicture.asset("assets/images/svg/menus_active.svg"),
                            icon:
                                // Icon(Icons.menu,size: Get.height*0.055,),
                                SvgPicture.asset("assets/images/svg/menus.svg"),
                            label: ""),
                        BottomNavigationBarItem(
                            activeIcon: SvgPicture.asset("assets/images/svg/ic_packages_menu_active.svg"),

                            icon:
                                // Icon(Icons.menu,size: Get.height*0.055,),
                                SvgPicture.asset("assets/images/svg/ic_packages_menu.svg"),
                            label: ""),
                        BottomNavigationBarItem(
                            activeIcon: SvgPicture.asset("assets/images/svg/settingHomeIcon_active.svg"),
                            icon: SvgPicture.asset("assets/images/svg/settingHomeIcon.svg"), label: ""),
                        /* BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/icon/settingsss.svg"),
                      label: ""),*/
                        BottomNavigationBarItem(
                            icon: profilePic.isNotEmpty
                                ? Container(
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF74EE15),
                                            Color(0xFF4DEEEA),
                                            Color(0xFF4DEEEA),
                                            Color(0xFFFFE700),
                                            Color(0xFFFFE700),
                                            Color(0xFFFFAE1D),
                                            Color(0xFFFE9D00),
                                            Color(0xFFEB7535),
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      //this padding will be you border size
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: CachedNetworkImage(
                                          imageUrl: profilePic,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                          errorWidget: (context, url, error) => Column(
                                            children: [
                                              //Icon(Icons.error),
                                              Padding(
                                                padding: EdgeInsets.only(bottom: Get.height * 0.005),
                                                child: Image.asset(
                                                  'assets/images/png/profilespic.png',
                                                  fit: BoxFit.fill,
                                                  height: Get.height * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                          imageBuilder: (context, imageProvider) => CircleAvatar(
                                            radius: 13,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        /*CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage:
                                                    NetworkImage(profilePic),
                                                */ /* AssetImage('assets/images/png/profilepic.png'),*/ /*
                                              ),
                                            ),*/
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF74EE15),
                                            Color(0xFF4DEEEA),
                                            Color(0xFF4DEEEA),
                                            Color(0xFFFFE700),
                                            Color(0xFFFFE700),
                                            Color(0xFFFFAE1D),
                                            Color(0xFFFE9D00),
                                            Color(0xFFEB7535),
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      //this padding will be you border size
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: const CircleAvatar(
                                          radius: 13,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 13,
                                            backgroundImage:
                                                //NetworkImage(profilePic),
                                                AssetImage('assets/images/png/dummypic.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            /*Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF74EE15),
                                Color(0xFFF4DEEEA),
                                Color(0xFFF4DEEEA),
                                Color(0xFFFFFE700),
                                Color(0xFFFFFE700),
                                Color(0xFFFFFAE1D),
                                Color(0xFFFFE9D00),
                                Color(0xFFFEB7535),
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                            ),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CachedNetworkImage(
                            imageUrl: profilepic,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Icon(Icons.error),
                                    Image.asset('assets/images/png/profilespic.png',fit: BoxFit.fill,
                                      height: Get.height * 0.03,),
                                  ],
                                ),),
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 13,
                              backgroundImage: imageProvider,
                            ),
                          ),
                          ),
                        ),*/
                            /*Padding(
                          //this padding will be you border size
                          padding: EdgeInsets.all(2.0),
                          child:
                              Container(
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundImage: NetworkImage(profilepic),
                              ),
                            ),
                          ),
                        ),*/
                            label: ""),
                      ],
                    )),
                  ),
                )),
    );
  }
}
