import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';

// import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/RouteHelper/route_helper.dart';
import 'package:gagagonew/Service/fcm_notification_service.dart';
import 'package:gagagonew/main.dart';
import 'package:gagagonew/model/ads_click_model.dart';
import 'package:gagagonew/model/advertisement_response_model.dart';
import 'package:gagagonew/model/chat_by_user_model.dart';
import 'package:gagagonew/utils/progress_bar.dart';
import 'package:gagagonew/view/chat/OpenFullImage.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

// import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:voice_message_package/voice_message_package.dart';
import '../../Service/call_service.dart';
import '../../audio_chat_widgets/my_voice_message.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/review_controller.dart';
import '../../model/block_user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:path_provider/path_provider.dart';
import '../../model/chat_emojies_model.dart';
import '../../model/connection_remove_model.dart';
import '../../model/upload_file.dart';
import '../../utils/app_network_image.dart';
import '../../utils/common_functions.dart';
import '../../utils/dimensions.dart';
import '../../utils/stream_controller.dart';
import '../app_web_view_screen.dart';
import '../dialogs/common_alert_dialog.dart';
import '../home/setting_page.dart';
import '../take_image_capture_screen.dart';
import 'app_emoji_selection_widget.dart';

class ChatMessageScreen extends StatefulWidget {
  String? receiverId;
  bool? isShown;
  String? connectionType;
  String? commonInterest;
  String? isMeBlocked;
  String? image;
  String? name;

  ChatMessageScreen(
      {this.receiverId,
      this.isShown,
      this.connectionType,
      this.commonInterest,
      this.isMeBlocked,
      this.image,
      this.name,
      Key? key})
      : super(key: key);

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  TextEditingController chatController = TextEditingController();
  AppStreamController appStreamController = AppStreamController.instance;
  var randomBannerIndex = Random();
  final controller = Get.put(ReviewController());
  ScrollController scrollController = ScrollController();

  bool isKeyboardVisibility = false;
  bool isEmojiVissibility = false;

  bool isScreenOpened = false;
  List<Chats> messages = [];
  List<Chats> newMessages = [];
  Socket? socket;
  String userId = '';
  String? receiverName = '';
  String? receiverImage = '';
  List<AdvertisementList> allAdvertisementList = [];
  List<AdvertisementList> advertisementList = [];
  int adsShowIndex = 0;
  int advertisementType = 2;
  bool? isShown;
  final _focusNode = FocusNode();
  bool chatFlag = true;
  bool showingAlertDialog = false;
  bool isComplete = false;
  bool pageFlag = false;
  bool isPagination = false;

  int bannerIndex = 0;
  int pageStartPoint = 0;
  int? addIncAdd = 0;
  Duration duration = const Duration();
  Timer? timer;
  int currentBannerIndex = 0;
  int startPoint = 0;

  int checkPagination = 0;
  List<String> reactEmoji = ["👍", "😊", "😉", "🤣", "😍", "😅", ""];
  List<ChatEmojiesModel> reactEmojiModel = [];

  ///voice message

  loadNextPage() async {
    debugPrint("under loadNextPage");
    setState(() {
      isPagination = true;
    });
    var map = <String, dynamic>{};

    map['user_id'] = widget.receiverId;
    map['start_point'] = pageStartPoint;
    print("Check User ID ${map}");
    debugPrint("map list show $map");
    ChatByUserModel model = await CallService().getChatByUser(map);
    if (mounted) {
      setState(() {
        isPagination = false;
        pageFlag = model.data!.chatFlag!; // only for pagination purposes
        pageStartPoint = model.data!.totalRecords!;
        chatFlag = (model.data!.chats!.isNotEmpty
            ? model.data!.chats![0].chatFlag
            : true)!;
        receiverName =
            '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
        receiverImage = model.data!.user!.userProfile!.isNotEmpty
            ? model.data!.user!.userProfile![0].imageName.toString()
            : "";
        debugPrint("receiverImage $receiverImage");
        debugPrint("receiverName $receiverName");
        debugPrint("pageStartPoint $pageStartPoint");

        List<Chats> rawList = [];
        rawList.addAll(model.data!.chats!.reversed);

        if (advertisementList.isNotEmpty) {
          bool adExist = false;
          int lastAdIndex = 0;
          int pendingMessages = messages.length - lastAdIndex;
          for (int i = 0; i < messages.length; i++) {
            if (messages[i].ads != null) {
              adExist = true;
              lastAdIndex = i;
            }
          }
          debugPrint("adExist $adExist");

          debugPrint(
              "pendingMessages $pendingMessages lastAdIndex $lastAdIndex adsShowIndex $adsShowIndex message.length ${messages.length}");
          for (int i = 0; i < rawList.length; i++) {
            int modules = (i + pendingMessages) % adsShowIndex!;
            debugPrint("modules $modules");
            if (modules == 0) {
              debugPrint(" check pending count ${(i - 1)}");
              if ((i - 1) >= 0) {
                if (addIncAdd! + 1 == advertisementList.length) {
                  addIncAdd = 0;
                } else {
                  addIncAdd = addIncAdd! + 1;
                }
                rawList[i - 1].ads = advertisementList[addIncAdd!];
              }
            }
          }
        }

        // OLD CODE
        messages.addAll(rawList);
        for (int i = 0; i < messages.length; i++) {
          if (messages[i].messageType == '1') {
            messages[i].message = messages[i].message!.contains("https")
                ? messages[i].message.toString()
                : '${CallService().imageBaseUrl}${messages[i].message}';
          }
        }

/*
        for (int i = 0; i < rawList.length; i++) {
          if (rawList[i].messageType == '1') {
            rawList[i].message = rawList[i].message!.contains("https")
                ? rawList[i].message.toString()
                : 'https://api.gagagoapp.com/message_files/${rawList[i].message}';
          }
        }
*/

        // messages.addAll(List.from(rawList));
        //handleAds();
      });
    }
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
    });
    getBadgesCount();
    scrollController.addListener(() {
      debugPrint("under addListener");
      if (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels &&
          pageFlag) {
        loadNextPage();
      }
    });

    try {
      socket = io.io(
        CallService.socketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'forceNew': true
        },
      );
      /* socket!.on('message', (data) {
        debugPrint("SocketMessage2 " + data.toString());
      });*/
      socket!.connect();

      socket!.onConnect((data) async {
        debugPrint('Connected: $data');

        /* socket!.emit('getChatMessages', {
          'my_id': userId,
          'other_user_id': widget.receiverId,
        });*/

        socket!.on('reactedToMessage', (data) async {
          dev.log("under reactedToMessage -> data $data");
          if (data != null) {
            dev.log("under reactedToMessage -> data is List ${data is List}");

            if (data is List) {
              Chats newMessage = Chats.fromJson(data[0]);
              newMessage.chatHeadId = messages.first.chatHeadId;
              dev.log(
                  "${messages.first.chatHeadId} == ${newMessage.chatHeadId}");
              if (
                  // newMessage.senderId.toString() != userId &&
                  // userId.isNotEmpty &&
                  messages.first.chatHeadId == newMessage.chatHeadId) {
                int rawIndex = messages
                    .indexWhere((element) => element.id == newMessage.id);

                dev.log("rawIndex --> $rawIndex");

                setState(() {
                  if (rawIndex >= 0) {
                    if (messages[rawIndex].id == newMessage.id) {
                      dev.log("${messages[rawIndex].id} == ${newMessage.id}");

                      if (newMessage.reactions != null) {
                        messages[rawIndex].reactions = newMessage.reactions;
                      } else {
                        messages[rawIndex].reactions!.clear();
                      }
                    }
                  }
                });
              }
            }
          }
          setState(() {});
        });

        socket!.on('chatReadStatus', (data) async {
          debugPrint("under chatReadStatus $data");

          // if(isScreenOpened) {
          if (messages.isNotEmpty) {
            if (data["chat_head_id"] != null) {
              if (messages.last.chatHeadId.toString() ==
                  data["chat_head_id"].toString()) {
                if (userId.toString() == data["sender_id"].toString()) {
                  _readAllMessage();
                }
              }
            }
            // }
          }
        });

        socket!.on('message', (data) async {
          debugPrint('getChatMessages:=>${data}');
          print('getChatMessages:=>${data}');
          setState(() {
            // if (data is List) {
            //   for (var v in data) {
            //     Chats newMessage = Chats.fromJson(v);
            //     chatFlag = newMessage.chatFlag ?? true;
            //
            //     if (!chatFlag) {
            //       showBlockedChatAlertDialog(this.context, newMessage.message, callback: () {
            //         // Navigator.pop(Get.overlayContext!);
            //         Future.delayed(Duration(milliseconds: 200), () {
            //           Get.offAllNamed(RouteHelper.getBottomSheetPage());
            //         });
            //       });
            //     } else {
            //       if (newMessage.repliedTo != null) {
            //         //startPoint = 0;
            //         pageStartPoint = 0;
            //         hitApi();
            //
            //         // Chats? replyMessage;
            //         //
            //         // for (int i = 0; i < messages.length; i++) {
            //         //   if (newMessage.repliedTo == messages[i].id) {
            //         //     messages[i] = newMessage;
            //         //     replyMessage = messages[i];
            //         //
            //         //   }
            //         // }
            //         // if (replyMessage != null) {
            //         //   messages.insert(0, newMessage);
            //         // }
            //
            //       } else {
            //         int indexMessage = messages.indexWhere((element) => element.id == newMessage.id);
            //         if (indexMessage < 0) {
            //           messages.insert(0, newMessage);
            //         }
            //       }
            //     }
            //   }
            // } else {
            Chats newMessage = Chats.fromJson(data);

            if (newMessage.receiverId.toString() == userId && isScreenOpened) {
              socket!.emit("markAllMessageRead", {
                'sender_id': widget.receiverId,
                'receiver_id': userId,
                //'chat_head_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
                'chat_head_id':
                    messages.isEmpty ? '' : newMessage.chatHeadId.toString(),
              });
              // addNewMessage(messages.toString(), userId!);
            }
            print(
                "under chat listner if  ${newMessage.receiverId.toString()} == $userId && ${widget.receiverId.toString()} == ${newMessage.senderId.toString()}");

            if (newMessage.receiverId.toString() == userId &&
                widget.receiverId.toString() ==
                    newMessage.senderId.toString()) {
              chatFlag = newMessage.chatFlag ?? true;

              if (!chatFlag) {
                showBlockedChatAlertDialog(this.context, newMessage.message,
                    callback: () {
                  Future.delayed(Duration(milliseconds: 200), () {
                    Get.offAllNamed(RouteHelper.getBottomSheetPage());
                  });
                });
              }
              if (newMessage.repliedTo != null) {
                //startPoint = 0;
                pageStartPoint = 0;
                hitApi();

                // Chats? replyMessage;
                // for (int i = 0; i < messages.length; i++) {
                //   if (newMessage.repliedTo == messages[i].id) {
                //     // messages[i] = newMessage;
                //     replyMessage = messages[i];
                //     replyMessage
                //   }
                // }
                // if (replyMessage != null) {
                //
                //   messages.insert(0, newMessage);
                // }
              } else {
                if (newMessage.messageType == '1') {
                  newMessage.message =
                      '${CallService().imageBaseUrl}${newMessage.message}';
                }
                int indexMessage = messages
                    .indexWhere((element) => element.id == newMessage.id);
                if (indexMessage < 0) {
                  addNewMessages(
                      newMessage.id!,
                      newMessage.message.toString(),
                      userId != newMessage.receiverId.toString()
                          ? newMessage.receiverId.toString()
                          : newMessage.senderId.toString(),
                      newMessage.messageType!,
                      audioDuration: newMessage.audioDuration);
                }
              }
            } else if (newMessage.senderId.toString() == userId) {
              print(
                  "under chat listner else  if   ${newMessage.senderId.toString()} $userId");

              chatFlag = newMessage.chatFlag ?? true;

              if (!chatFlag) {
                showBlockedChatAlertDialog(this.context, newMessage.message,
                    callback: () {
                  Future.delayed(Duration(milliseconds: 200), () {
                    Get.offAllNamed(RouteHelper.getBottomSheetPage());
                  });
                });
              }
              setState(() {
                // addNewMessages(
                //     newMessage.id!,
                //     newMessage.message.toString(),
                //     userId != newMessage.receiverId.toString()
                //         ? newMessage.receiverId.toString()
                //         : newMessage.senderId.toString(),
                //     newMessage.messageType!,
                //     audioDuration: newMessage.audioDuration);
                messages.first.id = newMessage.id;
                messages.first.chatHeadId = newMessage.chatHeadId;
                // print("CheckNew Message ${newMessages!.id}");
              });
            }

            // }
          });
        });

        // if(isScreenOpened) {
      }
          // }
          );
      /* */
      socket!.onConnectError((data) {});
    } catch (e) {
      print("Error  $e");
    }
    hitApi();
  }

  int likeCount = 0;
  int chatCount = 0;

  getBadgesCount() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var model = await CallService().getUserProfile(showLoader: false);
      likeCount = model.likeCount ?? 0;
      chatCount = model.chatCount ?? 0;
      FlutterAppBadger.updateBadgeCount(likeCount + chatCount);
      setState(() {});
      appStreamController.rebuildupdateBadgesCountStream();
      appStreamController.updateBadgesCount
          .add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));
    });
  }

  _readAllMessage() {
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].seenAt == null) {
        messages[i].seenAt = DateTime.now().toUtc().toString();
      }
      messages[i].isRead = 1;
    }
    setState(() {});
  }

  hitApi() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var map = <String, dynamic>{};
      map['user_id'] = widget.receiverId;
      map['start_point'] = pageStartPoint;
      print("CheckUser ID ${map}");

      ChatByUserModel model =
          await CallService().getChatByUser(map, showLoader: false);

      setState(() {
        pageFlag = model.data!.chatFlag!; // only for pagination purposes
        pageStartPoint =
            model.data!.totalRecords!; // only for pagination purposes
        chatFlag = (model.data!.chats!.isNotEmpty
            ? model.data!.chats![0].chatFlag
            : true)!;
        receiverName =
            '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
        receiverImage = model.data!.user!.userProfile!.isNotEmpty
            ? model.data!.user!.userProfile![0].imageName.toString()
            : "";
        messages = model.data!.chats!;

        int? chatId;
        for (int i = 0; i < messages.length; i++) {
          if (messages[i].messageType == '1') {
            print("messages[i].message ---?? ${messages[i].message}");
            messages[i].message = messages[i].message!.contains('https')
                ? messages[i].message
                : '${CallService().imageBaseUrl}${messages[i].message}';

            print("messages[i].message ---?? ${messages[i].message}");
          }

          /// Remove after changing it from backend
          // if (messages[i].repliedToInfo != null) {
          //   if (messages[i].repliedToInfo!.messageType != null) {
          //     if (messages[i].repliedToInfo!.messageType == "1") {
          //       String value = messages[i].repliedToInfo!.message!;
          //       value.replaceFirst("api-v2", "api");
          //       messages[i].repliedToInfo!.message = value;
          //       print("-->> ${messages[i].repliedToInfo!.message}");
          //     }
          //   }
          // }

          if (messages[i].chatHeadId != null) {
            chatId = messages[i].chatHeadId;
          }
        }
        if (messages.isNotEmpty) {
          var map = {
            'sender_id': widget.receiverId,
            'receiver_id': userId,
            'chat_head_id': chatId == null ? '' : chatId.toString(),
          };
          print("under markAllMessageRead --> $map");
          socket!.emit("markAllMessageRead", map);
        }

        messages = List.from(messages.reversed);

        // addNewMessage(messages[i].message!,messages[i].id.toString(),messages[i].messageType!);
        if (advertisementList.isNotEmpty) {
          handleAds();
        }
      });

      //etAdvertisementList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // resetFirebaseSettings();
    isScreenOpened = false;

    updateCurrentChatId("", true);
    _focusNode.dispose();
    _timer?.cancel();
    _recordSub?.cancel();
    // _audioPlayer!.stop();
    // _audioPlayer!.release();
    if (socket != null) {
      socket!.clearListeners();
      socket!.disconnect();
      socket!.close();
    }
  }

  bool hasFocus = false;

  addNewMessages(int id, String base64Str, String senderId, String msgId,
      {String? audioDuration}) {
    // if(adsList.length == adsList.length+2){
    //   addInc=0;
    // }else{
    //addInc++;
    // }
    setState(() {
      if (messages.length >= adsShowIndex) {
        bool adExist = false;
        for (int i = 0; i < adsShowIndex - 1; i++) {
          if (messages[i].ads != null) {
            adExist = true;
          }
        }

        if (!adExist) {
          if (addIncAdd! + 1 == advertisementList.length) {
            addIncAdd = 0;
          } else {
            addIncAdd = addIncAdd! + 1;
          }
          messages.insert(
              0,
              Chats(
                  id: id,
                  message: base64Str,
                  messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateTime.now().toUtc()),
                  senderId: int.parse(senderId),
                  messageType: msgId,
                  audioDuration: audioDuration,
                  repliedTo: showReply ? replyMessage?.id : null,
                  repliedToInfo: showReply
                      ? RepliedToInfo(
                          messageType: replyMessage?.messageType,
                          message: replyMessage?.message)
                      : null,
                  ads: advertisementList.isNotEmpty
                      ? advertisementList[addIncAdd!]
                      : null));

          /// add ads
        } else {
          messages.insert(
              0,
              Chats(
                  id: id,
                  message: base64Str,
                  messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateTime.now().toUtc()),
                  senderId: int.parse(senderId),
                  messageType: msgId,
                  audioDuration: audioDuration,
                  repliedTo: showReply ? replyMessage?.id : null,
                  repliedToInfo: showReply
                      ? RepliedToInfo(
                          messageType: replyMessage?.messageType,
                          message: replyMessage?.message)
                      : null));
        }
      } else {
        messages.insert(
            0,
            Chats(
                id: id,
                message: base64Str,
                messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                    .format(DateTime.now().toUtc()),
                senderId: int.parse(senderId),
                messageType: msgId,
                audioDuration: audioDuration,
                repliedTo: showReply ? replyMessage?.id : null,
                repliedToInfo: showReply
                    ? RepliedToInfo(
                        messageType: replyMessage?.messageType,
                        message: replyMessage?.message)
                    : null));
      }

      messages[messages.length - 1].ads =
          advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null;
    });
  }

  handleAds() {
    int addInc = 0;
    if (adsShowIndex == null) {
      return;
    }
    for (int i = 0; i < messages.length; i++) {
      //  if (i % adsShowIndex! == 0) {
      if ((i + 1) % adsShowIndex! == 0) {
        if (addInc + 1 == advertisementList.length) {
          addInc = 0;
        } else {
          addInc++;
        }
        setState(() {
          messages[i].ads = advertisementList[addInc];
        });
      }
    }
  }

  initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // reactEmojiModel = ChatEmojiesModel.fromJson(  json.decode( prefs.getString('selected_emoji')));

    // setState(() {
    //   reactEmoji = prefs.getStringList('selectEmojies') ??
    //       ["😀", "😊", "😉", "🤣", "😍", ""];
    // });
  }

  @override
  void initState() {
    super.initState();
    // initPushNotificationListener();
    initPrefs();
    init();
    receiverName = widget.name;
    debugPrint("receiverName 222 $receiverName");
    receiverImage = widget.image;
    updateCurrentChatId(widget.receiverId.toString(), false);
    _focusNode.addListener(() {
      setState(() {
        hasFocus = _focusNode.hasFocus;
        print("_focusNode.hasFocus-->> ${_focusNode.hasFocus} ");
        isEmojiVissibility = false;
      });
    });
    appStreamController.handleBottomTab.add(false);
    // _recordSub = record.onStateChanged().listen((recordState) {
    //   setState(() => _recordState = recordState);
    // }

    // );

    getAdvertisementList();

    // addInc=advertisementList.length;
    //debugPrint("check addInc init$addInc");
    addIncAdd = 0;
    isScreenOpened = true;

    // _audioPlayer = AudioPlayer();
    // _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
    //   if (state == PlayerState.stopped || state == PlayerState.completed) {
    //     setState(() {
    //       _isPlaying = false;
    //     });
    //   }
    // });
    //refreshEventList();
  }

  initPushNotificationListener() {
    print("under initPushNotificationListener");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("under notification --> chat ${message.data}");

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
      debugPrint("show msgs");
      socket!.emit('getNewConnectionNotification',
          {'other_user_id': 360, 'login_user_id': 372});

      if (message.data['type'] == 'chat_message') {
        if (message.data['sender_id'] != currentChatId) {
          if (isForground) {
            FcmNotificationService.showFlutterNotification(message);
          }
        } else {
          if (showNotification) {
            debugPrint("enter showNotification!  $showNotification");
            if (isForground) {
              FcmNotificationService.showFlutterNotification(message);
            }
          } else {
            debugPrint("enter else showNotification!  $showNotification");
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: false,
              badge: false,
              sound: false,
            );
          }
        }
      } else {
        debugPrint(" enter else");
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        FcmNotificationService.showFlutterNotification(message);
      }
      debugPrint('Handling a foreground message ${message.messageId}');
    });
  }

  initKeyboardListener() {
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisibility = visible;

        print("_focusNode.hasFocus-->> ${_focusNode.hasFocus} ");
        if (isKeyboardVisibility) {
          isEmojiVissibility = false;
        }
      });

      if (isKeyboardVisibility && isEmojiVissibility) {
        setState(() {
          isEmojiVissibility = false;
        });
      }
    });
  }

  Future<void> refreshEventList() async {
    /*await Future.delayed(Duration(seconds: 2));
    setState(() {

    });
    return;*/
  }

  Future getAdvertisementList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AdvertisementResponseModel model =
          await CallService().getAdvertisementList(advertisementType);
      if (mounted) {
        setState(() {
          debugPrint("Advertisement_Response $model");
          allAdvertisementList = model.advertisementList!;
          if (model.advertisementSetting != null) {
            if (model.advertisementSetting!.inChatHowAnyMessagesAfterShowAdd !=
                null) {
              adsShowIndex = int.parse(model
                  .advertisementSetting!.inChatHowAnyMessagesAfterShowAdd!);
              debugPrint("adsShowIndex $adsShowIndex");
            }
          }

          if (allAdvertisementList.isNotEmpty) {
            for (var element in allAdvertisementList) {
              if (element.advShowArea != 1) {
                advertisementList.add(element);
              }
            }

            handleAds();
          }

          // advertisementList.removeWhere((element) {
          //   return element.advShowArea == 1;
          // });

          // advertisementList.reversed;
          handleBannerImage(advertisementList);
          debugPrint("Advertisement_Response ${advertisementList.length}");
        });
      }
    });
  }

  handleBannerImage(List<AdvertisementList> advertisementList) {
    debugPrint("adsShowIndex $adsShowIndex ${allAdvertisementList.length}");
    debugPrint("${allAdvertisementList.length % adsShowIndex == 0}");

    // advertisementList

    /*  timer = Timer.periodic(const Duration(seconds: 2), (_) {
      debugPrint("currentBannerIndex ->  $currentBannerIndex advertisementList.length -> ${advertisementList.length}");
      if (currentBannerIndex < advertisementList.length) {
        debugPrint("Under  ifff");
        currentBannerIndex++;
        if (mounted) setState(() {});
      } else {
        timer!.cancel();
        currentBannerIndex--;
      }
      */ /**/ /*
    });*/
  }

  Future advertisementClick(int adsId, {String? title}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var map = <String, dynamic>{};
      map['advertisement_id'] = adsId;
      CommonDialog.showLoading();
      AdsClickModel model = await CallService().clickAdvertisement(map);
      CommonDialog.hideLoading();
      if (model.status != null) {
        if (model.status == true) {
          if (model.url != null) {
            debugPrint("advertisement ads url ${model.url}");
            /* Get.to(AppWebViewScreen(
              url: model.url,
              title: title ?? "",
            ));*/
            if (!await launchUrl(Uri.parse(model.url!))) {
              throw 'Could not launch ${model.url}';
            }
          }
        }
      }
    });
  }

  _showReactEmojiWidgets(int messageIndex) {
    return Get.bottomSheet(Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.020),
        height: Get.height * 0.3,
        child: Container(
          padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(200)),
              color: Colors.white),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(reactEmoji.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: reactEmoji[index].isNotEmpty
                      ? InkWell(
                          onTap: () {
                            dev.log("hitted");
                            var data = {
                              'message_id': messages[messageIndex].id,
                              'user_id': userId,
                              'reaction':
                                  base64.encode(utf8.encode(reactEmoji[index])),
                            };
                            dev.log("data --> $data");
                            socket!.emit('reactToMessage', data);
                            // messages[messageIndex].reactMessage =
                            //     reactEmoji[index];
                            setState(() {});
                            Get.back();
                          },
                          child: Text(
                            reactEmoji[index],
                            maxLines: 1,
                            style: const TextStyle(
                                color: AppColors.defaultBlack,
                                fontFamily: StringConstants.poppinsRegular,
                                // fontSize: Get.width / 10,
                                fontSize: 30,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Get.back();
                            _showAddReactBottomSheet(messageIndex);
                          },
                          child: SizedBox(
                            // height: Get.width / 10,
                            // width: Get.width / 10,
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                );
              })),
        )));
  }

  _showAddReactBottomSheet(int mainIndex) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height * 0.29,
          child: EmojiSelectionPickerScreen(
            onEmojiSelected: (String? value) {
              var data = {
                'message_id': messages[mainIndex].id,
                'user_id': userId,
                'reaction': base64.encode(utf8.encode(value!)),
              };
              dev.log("data --> $data");
              socket!.emit('reactToMessage', data);
              // messages[messageIndex].reactMessage =
              //     reactEmoji[index];

              setState(() {});
              Get.back();
            },
          ),
        ),
      ),
    );
  }

  void bottomSheet(Chats message, int messageIndex) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.010),
        height: Get.height * 0.3,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white),
                width: Get.width,
                // height: Get.height * 0.2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(reactEmoji.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: reactEmoji[index].isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  dev.log("hitted");
                                  var data = {
                                    'message_id': messages[messageIndex].id,
                                    'user_id': userId,
                                    'reaction': base64
                                        .encode(utf8.encode(reactEmoji[index])),
                                  };
                                  dev.log("data --> $data");
                                  socket!.emit('reactToMessage', data);
                                  // messages[messageIndex].reactMessage =
                                  //     reactEmoji[index];
                                  setState(() {});
                                  Get.back();
                                },
                                child: Text(
                                  reactEmoji[index],
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.defaultBlack,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      // fontSize: Get.width / 10,
                                      fontSize: 30,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Get.back();
                                  _showAddReactBottomSheet(messageIndex);
                                },
                                child: SizedBox(
                                  // height: Get.width / 10,
                                  // width: Get.width / 10,
                                  height: 30,
                                  width: 30,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                      );
                    }))

                // _showReactEmojiWidgets(messageIndex),
                ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Get.height * 0.005,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      setState(() {
                        showReply = true;
                        print("message --> ${message.id}");
                        replyMessage = message;
                        print("message --> ${replyMessage!.id}");
                      });
                    },
                    child: Text(
                      "Reply".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: AppColors.dividerColor,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.back();
                  //     setState(() {
                  //       showReply = false;
                  //     });
                  //     // repl
                  //     _showReactEmojiWidgets(messageIndex);
                  //   },
                  //   child: Text(
                  //     "React".tr,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         fontFamily: StringConstants.poppinsRegular,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: Get.height * 0.018,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  // const Divider(
                  //   color: AppColors.dividerColor,
                  // ),

                  Text(
                    "Report".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: StringConstants.poppinsRegular,
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height * 0.018,
                        color: Colors.red),
                  ),
                  SizedBox(
                    height: Get.height * 0.005,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "under chat_message_screen ${messages.length} ${advertisementList.length}");
    return WillPopScope(
      onWillPop: () async {
        if (isEmojiVissibility) {
          setState(() {
            isEmojiVissibility = false;
          });
          return false;
        }
        appStreamController.handleBottomTab.add(true);

        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     showBlockedChatAlertDialog(this.context, "newMessage.message newMessage.message newMessage.message ", callback: () {
            //       Navigator.pop(Get.overlayContext!);
            //     });
            //   },
            // ),
            body: Column(
          children: [
            _appBar(context),
            _messagesListWidget(context),
            _bottomWidget(context),
            if (Platform.isIOS)
              SizedBox(
                height: 15,
              )
          ],
        )),
      ),
    );
  }

  _appBar(context) {
    return Padding(
      padding: EdgeInsets.only(
          top: Get.width * 0.14,
          left: Get.width * 0.060,
          right: Get.width * 0.060,
          bottom: Get.height * 0.020),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                    onTap: () async {
                      var map = <String, dynamic>{};
                      map['other_user_id'] = widget.receiverId;
                      ConnectionRemoveModel connectionRemove =
                          await CallService().readOtherUserMessage(map,
                              () async {
                        socket!.emit('getNotification', {
                          'my_id': userId,
                        });
                      });
                      if (connectionRemove.status! == true) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                      appStreamController.handleBottomTab.add(true);
                    },
                    child: SvgPicture.asset(
                      "${StringConstants.svgPath}backIcon.svg",
                      height: Get.height * 0.035,
                    )),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      //Get.to(SettingPage(widget.receiverId!.toString()), arguments:"true");

                      Navigator.of(
                        context,
                      )
                          .push(
                        MaterialPageRoute(
                            builder: (context) => SettingPage(
                                  widget.receiverId!.toString(),
                                  isFromDashboard: false,
                                )),
                      )
                          .then((value) {
                        appStreamController.handleBottomTab.add(false);
                      });
                      /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SettingPage(widget.receiverId!.toString(),)),
                            );*/
                      /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SettingPage(widget.receiverId.toString())),
                            );*/
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: Get.width * 0.025),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
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
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: receiverImage != null
                                          ? receiverImage.toString().isNotEmpty
                                              ? Image.network(
                                                  receiverImage.toString(),
                                                  scale: 0.5,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/images/png/dummypic.png',
                                                )
                                          : Image.asset(
                                              'assets/images/png/dummypic.png',
                                            ))

                                  // CircleAvatar(
                                  //   radius: 18,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     backgroundColor: Colors.white,
                                  //     radius: 18,
                                  //     backgroundImage: receiverImage == null
                                  //         ? Image.asset(
                                  //             'assets/images/png/dummypic.png',
                                  //           ).image
                                  //         : receiverImage.toString().isNotEmpty
                                  //             ? NetworkImage(
                                  //                 receiverImage.toString())
                                  //             : Image.asset(
                                  //                 'assets/images/png/dummypic.png',
                                  //               ).image,
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.015,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      receiverName ?? " ",
                                      style: TextStyle(
                                          fontSize: Get.height * 0.020,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.gagagoLogoColor,
                                          fontFamily:
                                              StringConstants.poppinsRegular),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.commonInterest.toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: Get.height * 0.016,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.chatTextColor,
                                            fontFamily:
                                                StringConstants.poppinsRegular),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _openRemoveBlockBottomSheet((value) {
                // Get.back();
                if (value == "remove") {
                  Navigator.pop(context, {'removeConnection': true});
                } else if (value == "block") {
                  Get.offAllNamed(RouteHelper.getBottomSheetPage());
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              size: Get.height * 0.040,
            ),
          )
        ],
      ),
    );
  }

  _openRemoveBlockBottomSheet(Function(String) callback) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.010),
        height: Get.height * 0.3,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                  InkWell(
                    onTap: () async {
                      debugPrint("My User Id $userId");
                      var map = <String, dynamic>{};
                      map['removed_to'] = widget.receiverId;
                      //map['removed_by'] = userId;
                      ConnectionRemoveModel connectionRemove =
                          await CallService().removeConnectionChat(map);
                      if (connectionRemove.status! == true) {
                        Get.back();
                        callback("remove");
                        // Get.back();
                        // Navigator.pop(
                        //     Get.overlayContext!, {'removeConnection': true});
                      } else {
                        CommonDialog.showToastMessage(
                            connectionRemove.message.toString());
                      }
                    },
                    child: Text(
                      "Remove".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      _displayTextInputDialog(Get.overlayContext!,
                          (reasonText) async {
                        Get.back();
                        var map = <String, dynamic>{};
                        //map['blocked_by'] = userId;
                        map['blocked_to'] = widget.receiverId;
                        map['reason_and_comment_report'] = reasonText;
                        BlockUserModel userBlock =
                            await CallService().blockUser(map);
                        if (userBlock.success! == true) {
                          CommonDialog.showToastMessage(
                              'Blocked successfully'.tr);
                          var bytes = utf8.encode(chatController.text);
                          var base64Str = base64.encode(bytes);

                          socket!.emit('sendMessage', {
                            'sender_id': userId,
                            'receiver_id': widget.receiverId,
                            'message': base64Str,
                            'chat_id': messages.isEmpty
                                ? ''
                                : messages[0].chatHeadId.toString(),
                            'avatar': '',
                            // 'replied_to': replyMessage?.id,
                            'message_type': '0',
                            'is_me_blocked': widget.isMeBlocked == 'true',
                            'user_blocked': 'true'
                          });

                          Get.back();
                          callback("block");
                          // Navigator.pop(Get.overlayContext!);
                          // Navigator.pop(Get.overlayContext!);
                        } else {
                          CommonDialog.showToastMessage(
                              userBlock.message.toString());
                        }
                      });
                    },
                    child: Text(
                      "Block & Report".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.020,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: Get.width,
              height: Get.height * 0.016,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimensions.radius15)),
                    color: Colors.white),
                width: Get.width,
                height: Get.height * 0.070,
                child: Center(
                    child: Text(
                  "Cancel".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: StringConstants.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.height * 0.018,
                      color: Colors.black),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _messagesListWidget(context) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.only(
                right: Get.width * 0.03,
                left: Get.width * 0.03,
                bottom: Get.height * 0.02),
            child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: Stack(
                  children: [
                    ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (messages[index].ads != null)
                              //   if (messages.length < adsShowIndex! && index == messages.length - 1 && advertisementList.isNotEmpty)
                              //_bannerAds(index), // old
                              _bannerAds(messages[index].ads!),
                            getChatListItemWidget(context, index),
                          ],
                        );
                      },

                      // separatorBuilder: (context, index) {
                      //   if (adsShowIndex == null) {
                      //     return const SizedBox();
                      //   }
                      //   if (advertisementList.isNotEmpty) {
                      //     if (index < messages.length) {
                      //       if ((index + 1) % adsShowIndex! == 0) {
                      //         int rawIndex = ((index + 1) ~/ adsShowIndex! - 1);
                      //         if (rawIndex >= advertisementList.length) {
                      //           debugPrint("1 advertisementList---???  ${advertisementList.length}");
                      //           advertisementList = [
                      //             ...advertisementList,
                      //             ...advertisementList,
                      //           ];
                      //           // advertisementList.addAll(advertisementList);
                      //           debugPrint("2. advertisementList---???  ${advertisementList.length}");
                      //         }
                      //         if (rawIndex < advertisementList.length) {
                      //           debugPrint(
                      //               "if advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex bannerIndex $bannerIndex modulos ${(index + 1) % 10}");
                      //           bannerIndex = rawIndex;
                      //           return _bannerAds(rawIndex);
                      //         } else {
                      //           int val1 = randomBannerIndex.nextInt(advertisementList.length);
                      //           debugPrint(
                      //               " else advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex bannerIndex $bannerIndex val1 $val1");
                      //           return _bannerAds(val1 == advertisementList.length ? val1 - 1 : val1);
                      //         }
                      //       }
                      //     }
                      //   }
                      //   return const SizedBox();
                      // },
                      itemCount: messages.length,
                    ),
                    if (messages.isEmpty && advertisementList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _bannerAds(advertisementList.first),
                        ],
                      ),
                    if (isPagination)
                      Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                          ))
                  ],
                )

                /*ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return getChatListItemWidget(context, index);
                },

                itemCount: messages.length,
                reverse: true,

              ),
            ),*/
                )));
  }

  _bottomWidget(context) {
    print("sendDeleteRecording -> $sendDeleteRecording");
    return Column(
      children: [
        if (showReply) showReplyBar(replyMessage!),
        chatFlag
            ? sendDeleteRecording
                ? getRecordingWidget(recordingPath)
                : _sendDataWidgets()
            : Container(
                padding: EdgeInsets.all(Get.width * 0.05),
                child: Text(
                  'You cannot send messages to this conversation.',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: StringConstants.poppinsRegular,
                      fontSize: Get.height * 0.020),
                  textAlign: TextAlign.center,
                ),
              )
      ],
    );
  }

  _sendDataWidgets() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: Get.width * 0.03,
        left: Get.width * 0.03,
        bottom: Get.width * 0.03,
        right: Get.width * 0.03,
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isEmojiVissibility = false;
                  });

                  openImageOptions();
                },
                child: _recordState != RecordState.stop
                    ? _buildTimer()
                    : Image.asset(
                        'assets/images/png/attachment.png',
                        width: Get.width * 0.085,
                        height: Get.width * 0.085,
                      ),
              ),
              SizedBox(width: Get.width * 0.01),
              /*if (_recordState == RecordState.stop)
                InkWell(
                  onTap: () {
                    onEmojiClicked();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                    child: isEmojiVissibility
                        ? const Icon(Icons.keyboard_rounded)
                        : Image.asset(
                            "assets/images/png/smile_emoji.png",
                            width: Get.width * 0.065,
                            height: Get.width * 0.065,
                            // 0.045.sw,
                            // 0.035.sh,
                          ),
                  ),
                ),*/
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: Get.width * 0.005, right: 10),
                padding: const EdgeInsets.only(
                    left: 20, top: 8, right: 10, bottom: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppColors.chatInputTextBackgroundColor,
                ),
                child: _recordState != RecordState.stop
                    ? Text(
                        'Recording...',
                        style: TextStyle(
                            color:
                                AppColors.chatBubbleTimeColor.withOpacity(0.7),
                            fontFamily: StringConstants.poppinsRegular,
                            fontSize: Get.height * 0.016),
                      )
                    : TextField(
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        //keyboardType: Platform.isAndroid?TextInputType.multiline:TextInputType.multiline,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          /*if(value.isNotEmpty){
                                         chatController.value = TextEditingValue(
                                          text: capitalize(value),
                                          selection: chatController.selection
                                      );
                                      }*/
                          setState(() {});
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: StringConstants.poppinsRegular,
                            fontSize: Get.height * 0.016),
                        controller: chatController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send Message...'.tr,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: StringConstants.poppinsRegular,
                              fontSize: Get.height * 0.016),
                        )),
              )),
              InkWell(
                onTap: () async {
                  // FocusManager.instance.primaryFocus?.unfocus;

                  print("_recordState --> ${_recordState.name}");

                  //  print('replyMessage? ::: > ${replyMessage!.messageType} }');
                  //
                  print("replyMessage");

                  if (chatController.text.isEmpty) {
                    //CommonDialog.showToastMessage('Please enter message');
                    if (_recordState != RecordState.stop) {
                      // stopRecording();
                    } else {
                      setState(() {
                        isEmojiVissibility = false;
                      });
                      // startRecording();
                    }
                  } else {
                    var bytes = utf8.encode(chatController.text);
                    var base64Str = base64.encode(bytes);

                    if (showReply) {
                      socket!.emit('sendMessage', {
                        'sender_id': userId,
                        'receiver_id': widget.receiverId,
                        'message': base64Str,
                        'chat_id': messages.isEmpty
                            ? ''
                            : messages[0].chatHeadId.toString(),
                        'avatar': '',
                        'replied_to': replyMessage?.id,
                        'message_type': '0',
                        'is_me_blocked': widget.isMeBlocked == 'true',
                        'user_blocked': 'false'
                      });

                      //     print("Chcek Data ${map}");

                      //('sendMessage', map);
                    } else {
                      socket!.emit('sendMessage', {
                        'sender_id': userId,
                        'receiver_id': widget.receiverId,
                        'message': base64Str,
                        'chat_id': messages.isEmpty
                            ? ''
                            : messages[0].chatHeadId.toString(),
                        'avatar': '',
                        // 'replied_to': replyMessage?.id,
                        'message_type': '0',
                        'is_me_blocked': widget.isMeBlocked == 'true',
                        'user_blocked': 'false'
                      });

                      // print("under else Chcek Data ${map}");

                      //  socket!.emit('sendMessage', map);
                    }
                    debugPrint(
                        'sender_id:${userId} receiver_id:${widget.receiverId}');
                    print('replyMessage?.id:${replyMessage?.id} }');
                    setState(() {
                      // addNewMessages(base64Str, userId, "0");
                      messages.insert(
                          0,
                          Chats(
                              message: base64Str,
                              messageDate:
                                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                      .format(DateTime.now().toUtc()),
                              senderId: int.parse(userId),
                              messageType: '0',

                              ///Todo  Tomorrow fix this issue and get reply agai
                              repliedTo: showReply ? replyMessage?.id : null,
                              repliedToInfo: showReply
                                  ? RepliedToInfo(
                                      messageType: replyMessage?.messageType,
                                      message: replyMessage?.message)
                                  : null));

                      showReply = false;
                    });
                    chatController.clear();

                    // scrollController!.jumpTo(scrollController!.position.minScrollExtent);
                  }
                },
                child: Container(
                  child: chatController.text.isEmpty /*&& !hasFocus*/
                      ? _recordState != RecordState.stop
                          ? Icon(
                              Icons.mic_off,
                              size: Get.width * 0.06,
                            )
                          : Image.asset(
                              'assets/images/png/mic.png',
                              width: Get.width * 0.06,
                              height: Get.width * 0.06,
                            )
                      : Image.asset(
                          'assets/images/png/send_icon.png',
                          width: Get.width * 0.08,
                          height: Get.width * 0.08,
                        ),
                ),
              )
            ],
          ),
          Offstage(
            offstage: !isEmojiVissibility,
            child: SingleChildScrollView(
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.29,
                child: EmojiSelectionPickerScreen(
                  onEmojiSelected: (String? value) {
                    onEmojiSelection(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onEmojiSelection(String? emoji) {
    setState(() {
      print('selected emojis are =====>>$emoji');

      chatController.text = chatController.text + emoji.toString();
      print('messageController===>>${chatController.text}');
    });
  }

  void onEmojiClicked() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future.delayed(const Duration(milliseconds: 300));
    await toogleEmojiKeybard();
  }

  Future<void> toogleEmojiKeybard() async {
    if (isKeyboardVisibility) {
      // FocusScope.of(context).unfocus();
    }
    setState(() {
      isEmojiVissibility = !isEmojiVissibility;
    });
  }

  ads() {
    advertisementList = [
      ...advertisementList,
      ...advertisementList,
    ];
    // advertisementList= newList ;
  }

  _bannerAds(AdvertisementList adsData) {
    return InkWell(
      onTap: () async {
        advertisementClick(adsData.id!, title: adsData.advTxt ?? "");
      },
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: 0, vertical: Get.height * 0.015),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          adsData.advTxt ?? "",
                          // advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advTxt ?? "",
                          maxLines: 2,
                          style: TextStyle(
                              color: AppColors.defaultBlack,
                              fontFamily: StringConstants.poppinsRegular,
                              fontSize: Get.height * 0.017,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600),
                        )),
                    Text(
                      // "${advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advDescription ?? ""}",
                      adsData.advDescription ?? "",
                      maxLines: 1,
                      style: TextStyle(
                          color: AppColors.defaultBlack,
                          fontFamily: StringConstants.poppinsRegular,
                          fontSize: Get.height * 0.013,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: Get.height * 0.08,
                    // width: Get.width,
                    maxHeightDiskCache: 1200,
                    maxWidthDiskCache: 1200,

                    imageUrl: adsData.advImage!,
                    // imageUrl: advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advImage!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Icon(Icons.error),
                          Image.asset(
                            'assets/images/png/galleryicon.png',
                            fit: BoxFit.cover,
                            height: Get.height * 0.06,
                          ),
                          //Text("Error! to Load Image"),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bannerAdsOld(int bannerIndexValue) {
    return InkWell(
      onTap: () async {
        advertisementClick(advertisementList[bannerIndexValue].id!,
            title: advertisementList[bannerIndexValue].advTxt ?? "");
      },
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: 0, vertical: Get.height * 0.015),
        child: Container(
          // color: Colors.black,
          // dashedLine: [2, 0],
          // type: GFBorderType.rect,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          advertisementList[bannerIndexValue].advTxt ?? "",
                          // advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advTxt ?? "",
                          maxLines: 2,
                          style: TextStyle(
                              color: AppColors.defaultBlack,
                              fontFamily: StringConstants.poppinsRegular,
                              fontSize: Get.height * 0.017,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600),
                        )),
                    Text(
                      // "${advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advDescription ?? ""}",
                      advertisementList[bannerIndexValue].advDescription ?? "",
                      maxLines: 1,
                      style: TextStyle(
                          color: AppColors.defaultBlack,
                          fontFamily: StringConstants.poppinsRegular,
                          fontSize: Get.height * 0.013,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: Get.height * 0.08,
                    // width: Get.width,
                    maxHeightDiskCache: 1200,
                    maxWidthDiskCache: 1200,
                    imageUrl: advertisementList[bannerIndexValue].advImage!,
                    // imageUrl: advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advImage!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Icon(Icons.error),
                          Image.asset(
                            'assets/images/png/galleryicon.png',
                            fit: BoxFit.cover,
                            height: Get.height * 0.06,
                          ),
                          //Text("Error! to Load Image"),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, Function(String) callbackPositive) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Block & Report'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Get.height * 0.021,
                  fontFamily: StringConstants.poppinsRegular),
            ),
            content: TextField(
              controller: textFieldController,
              minLines: 4,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Share your reason".tr,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Get.height * 0.018,
                    fontFamily: StringConstants.poppinsRegular),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xffF02E65)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(255, 66, 125, 145)),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.060,
                          decoration: const BoxDecoration(
                              color: AppColors.cancelButtonColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Cancel'.tr,
                            style: TextStyle(
                                fontSize: Get.height * 0.016,
                                color: Colors.black,
                                fontFamily: StringConstants.poppinsRegular,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        if (textFieldController.text.trim().isEmpty) {
                          CommonDialog.showToastMessage("Share your reason".tr);
                        } else {
                          callbackPositive(textFieldController.text.trim());
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * 0.060,
                        decoration: const BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          'Submit'.tr,
                          style: TextStyle(
                              fontSize: Get.height * 0.016,
                              color: Colors.white,
                              fontFamily: StringConstants.poppinsRegular,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          );
        });
  }

  bool showReply = false;
  Chats? replyMessage;

  Widget getChatListItemWidget(BuildContext context, int index) {
    print(
        "messages[index].repliedToInfo!.messageType ${messages[index].messageType}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ///Messasge Date Title
        _messageDateTitle(context, index),
        GestureDetector(
          onLongPress: () {
            messages[index].repliedTo != null
                ? null
                : bottomSheet(messages[index], index);
          },
          child: Slidable(
            endActionPane: _messageReadInfoWidget(context, index),
            child: Column(
              children: [
                ///replied messages

                if (messages[index].repliedTo != null)
                  _handleRepliedToWidget(context, index),

                ///live messages
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20
                          // bottom: messages[index].reactions != null
                          //     ? messages[index].reactions!.isNotEmpty && messages[index].senderId.toString() == userId
                          //         ? 22
                          //         : 0
                          //     : 0,
                          // right: messages[index].reactions != null
                          //     ? messages[index].reactions!.isNotEmpty && messages[index].senderId.toString() == userId
                          //         ? 0
                          //         : 0
                          //     : 0
                          ),
                      child: chatBubbleWidget(
                          context,
                          messages[index].senderId.toString() == userId
                              ? true
                              : false,
                          _handleMessageWidget(context, index)),
                    ),

                    /// React Widget for Other User message
                    if (messages[index].reactions != null)
                      if (messages[index].reactions!.isNotEmpty)
                        if (messages[index].senderId.toString() != userId)
                          Positioned(
                              bottom: 0,
                              left: 5,
                              child: _showEmojiMessageReacts(context, index)),

                    /// React Widget for My message
                    if (messages[index].reactions != null)
                      if (messages[index].reactions!.isNotEmpty)
                        if (messages[index].senderId.toString() == userId)
                          Positioned(
                              bottom: 0,
                              right: 10,
                              child: _showEmojiMessageReacts(context, index)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _openReactedEmojiSheet(int messageIndex) {
    Get.bottomSheet(Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.020),
        // height: Get.height * 0.3,
        child: Container(
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Reactions".tr,
                  maxLines: 1,
                  style: const TextStyle(
                      color: AppColors.defaultBlack,
                      fontWeight: FontWeight.bold,
                      fontFamily: StringConstants.poppinsRegular,
                      // fontSize: Get.width / 15,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis),
                ),
                Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages[messageIndex].reactions!.length,
                    itemBuilder: (contxt, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  utf8.decode(base64.decode(
                                      messages[messageIndex]
                                              .reactions![index]
                                              .reaction ??
                                          "")),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.defaultBlack,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      // fontSize: Get.width / 15,
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Text(
                                  userId ==
                                          messages[messageIndex]
                                              .reactions![index]
                                              .userId
                                              .toString()
                                      ? "You"
                                      : "$receiverName",
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.defaultBlack,
                                      fontFamily:
                                          StringConstants.poppinsRegular,
                                      // fontSize: Get.width / 15,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                // Text(
                                //   CommonFunctions.dayDurationToString(
                                //       messages[messageIndex]
                                //               .reactions![index]
                                //               .createdAt ??
                                //           "", contxt),
                                //   // Jiffy(messages[messageIndex]
                                //   //         .reactions![index]
                                //   //         .createdAt)
                                //   //     .yMMMd,
                                //   maxLines: 1,
                                //   style: const TextStyle(
                                //       color: AppColors.defaultBlack,
                                //       fontFamily: StringConstants.poppinsRegular,
                                //       // fontSize: Get.width / 15,
                                //       fontSize: 15,
                                //       overflow: TextOverflow.ellipsis),
                                // ),
                              ],
                            ),
                            // if(index < messages[messageIndex]
                            //     .reactions!.length -1)
                            // Divider(height: 1,
                            // thickness: 0.5,),
                          ],
                        ),
                      );
                    }),
              ],
            ))));
  }

  _showEmojiMessageReacts(context, mainIndex) {
    return InkWell(
        onTap: () {
          _openReactedEmojiSheet(mainIndex);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.all(Platform.isIOS ? 2 : 1),
          decoration: const BoxDecoration(
              // shape: BoxShape.circle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                ),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List<Widget>.generate(
                      messages[mainIndex].reactions!.length, (index) {
                    return Platform.isAndroid
                        ? Text(
                            utf8.decode(base64.decode(messages[mainIndex]
                                    .reactions![index]
                                    .reaction ??
                                "")),
                            maxLines: 1,
                            // strutStyle: StrutStyle(forceStrutHeight: true),
                            style: const TextStyle(
                                fontSize: 15.0,
                                color: AppColors.defaultBlack,
                                fontFamily: StringConstants.poppinsRegular,
                                // fontSize: Get.width / 15,
                                overflow: TextOverflow.ellipsis),
                          )
                        : SizedBox(
                            height: 17.825,
                            width: 17.825,
                            child: Text(
                              utf8.decode(base64.decode(messages[mainIndex]
                                      .reactions![index]
                                      .reaction ??
                                  "")),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 15.5,
                                  height: 1.15,
                                  color: AppColors.defaultBlack,
                                  fontFamily: StringConstants.poppinsRegular,
                                  // fontSize: Get.width / 15,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          );
                  })),
              /*if (messages[mainIndex].reactions != null)
                    if (messages[mainIndex].reactions!.isNotEmpty)
                      if (messages[mainIndex].reactions!.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Text(
                            messages[mainIndex].reactions!.length.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: AppColors.defaultBlack,
                                fontFamily: StringConstants.poppinsRegular,
                                // fontSize: Get.width / 15,
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )*/
              //   ],
              // )
            ],
          ),
        ));
  }

  _handleMessageWidget(context, index) {
    return messages[index].messageType == null ||
            messages[index].messageType == '0'
        ? _handleTextWidget(context, index)
        : messages[index].messageType == '1'
            ? _handleImageWidget(context, index)
            : _audioWidget(
                context,
                message: utf8
                    .decode(base64.decode(messages[index].message.toString())),
                duration: messages[index].audioDuration,
                isMe: messages[index].senderId.toString() == userId,
              );
  }

  _messageReadInfoWidget(context, index) {
    return messages[index].senderId.toString() == userId
        ? ActionPane(
            extentRatio: 0.18,
            closeThreshold: 0.25,
            openThreshold: 0.25,
            dragDismissible: true,
            motion: const ScrollMotion(),
            children: [
              Row(
                children: [
                  messages[index].isRead == 1
                      ? Image.asset(
                          "assets/images/png/all-done.png",
                          color: Colors.blue,
                          height: 20,
                          width: 20,
                        )
                      : Image.asset(
                          "assets/images/png/all-done.png",
                          height: 20,
                          width: 20,
                        ),
                  // if (messages[index].isRead == 1)
                  //   Text(
                  //     Jiffy(messages[index].seenAt != null ? CommonFunctions.getHH_MM(messages[index].seenAt!) : messages[index].messageDate).Hm,
                  //     //  CommonFunctions.getHH_MM24(messages[index].seenAt),
                  //     style: const TextStyle(
                  //       color: AppColors.grayColorNormal,
                  //       fontFamily: StringConstants.poppinsRegular,
                  //     ),
                  //   ),
                ],
              ),
            ],
          )
        : null;
  }

  _messageDateTitle(context, index) {
    return Visibility(
      // visible: index < messages.length - 1 ? Jiffy(messages[index + 1].messageDate).yMMMd != Jiffy(messages[index].messageDate).yMMMd : true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            messages[index].messageDate == null
                ? ""
                : CommonFunctions.dayDurationToString(
                    messages[index].messageDate.toString(), context),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.chatBubbleTimeColor.withOpacity(0.7),
                fontFamily: StringConstants.poppinsRegular,
                fontSize: Get.width * 0.035),
          ),
        ],
      ),
    );
  }

  _handleRepliedToWidget(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: Get.height * 0.02),
          alignment: messages[index].senderId.toString() == userId
              ? Alignment.topRight
              : Alignment.topLeft,
          child: Text(
              CommonFunctions.getLanguageText(
                  englishText: 'Replied To Message',
                  spanishText: 'Respondido al mensaje',
                  portoText: 'Respondeu a mensagem',
                  frenchText: 'Répondu au message'),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: StringConstants.poppinsRegular,
                  fontSize: Get.height * 0.018)),
        ),
        chatBubbleWidget(
            context,
            messages[index].senderId.toString() == userId ? true : false,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                messages[index].repliedToInfo!.messageType == null
                    ? Text(
                        utf8.decode(base64.decode(
                            messages[index].repliedToInfo!.message.toString())),
                        maxLines:
                            (messages[index].repliedTo != null) ? 2 : null,
                        overflow: (messages[index].repliedTo != null)
                            ? TextOverflow.ellipsis
                            : null,
                        style: TextStyle(
                            color: messages[index].senderId.toString() == userId
                                ? Colors.black
                                : Colors.white,
                            fontFamily: StringConstants.poppinsRegular,
                            fontSize: Get.width * 0.035),
                      )
                    : messages[index].repliedToInfo!.messageType == '0'
                        ? Text(
                            utf8.decode(base64.decode(messages[index]
                                .repliedToInfo!
                                .message
                                .toString())),
                            maxLines:
                                (messages[index].repliedTo != null) ? 2 : null,
                            overflow: (messages[index].repliedTo != null)
                                ? TextOverflow.ellipsis
                                : null,
                            style: TextStyle(
                                color: messages[index].senderId.toString() ==
                                        userId
                                    ? Colors.black
                                    : Colors.white,
                                fontFamily: StringConstants.poppinsRegular,
                                fontSize: Get.width * 0.038),
                          )
                        : messages[index].repliedToInfo!.messageType == '1'
                            ? messages[index]
                                    .repliedToInfo!
                                    .message
                                    .toString()
                                    .startsWith('https://')
                                ? InkWell(
                                    onTap: () {
                                      if (messages[index]
                                              .repliedToInfo!
                                              .message !=
                                          null) {
                                        /* showDialog(
                                          context: context, // <<----
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ImagePreviewDialog(imagePath: messages[index].repliedToInfo!.message.toString());
                                          });*/
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OpenFullImage(
                                                        imagePath:
                                                            messages[index]
                                                                .repliedToInfo!
                                                                .message
                                                                .toString())));
                                      }
                                    },
                                    child: AppNetworkImage(
                                      width: 200,
                                      height: 200,
                                      boxFit: BoxFit.fitWidth,
                                      imageUrl: messages[index]
                                          .repliedToInfo!
                                          .message
                                          .toString(),
                                      maxWidth: 1200,
                                      maxHeight: 1200,
                                    ))
                                : Image.file(
                                    File(messages[index]
                                        .repliedToInfo!
                                        .message
                                        .toString()),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.fitWidth)
                            : _audioWidget(
                                context,
                                message: utf8.decode(base64.decode(
                                    messages[index]
                                        .repliedToInfo!
                                        .message
                                        .toString())),
                                duration: messages[index]
                                        .repliedToInfo!
                                        .audioDuration ??
                                    "0",
                                isMe: messages[index].senderId.toString() ==
                                    userId,
                              )

                // new VoiceMessage(
                //                 // key: ValueKey(messages[index].id),
                //                 // formatDuration: (d) {
                //                 //   return CommonFunctions.getMM_ss(d);
                //                 // },
                //                 meBgColor: Colors.blue,
                //                 contactBgColor: Colors.blue,
                //                 audioSrc: utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())),
                //                 played: false,
                //                 // To show played badge or not.
                //                 me: true,
                //                 // Set message side.
                //                 onPlay: () {
                //                   print(
                //                       "utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())) ${utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString()))}");
                //                 }, // Do something when voice played.
                //               ),
              ],
            ))
      ],
    );
  }

  _handleTextWidget(BuildContext context, int index) {
    return Text(
      utf8.decode(base64.decode(messages[index].message.toString())),
      // capitalize(utf8.decode(base64.decode(messages[index].message.toString()))),
      style: TextStyle(
          color: messages[index].senderId.toString() == userId
              ? Colors.black
              : Colors.white,
          fontFamily: StringConstants.poppinsRegular,
          fontSize: Get.width * 0.04),
    );
  }

  _handleImageWidget(BuildContext context, int index) {
    print(
        "------>>>> ${messages[index].message} ${messages[index].message.toString().contains("https")}");
    return messages[index].message.toString().contains("https")
        ? InkWell(
            onTap: () {
              if (messages[index].message != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpenFullImage(
                            imagePath: messages[index].message.toString())));
              }
            },
            child: /*Image.network(
               messages[index].message.toString(),
              width: 200,
              height: 200,)*/

                AppNetworkImage(
              imageUrl: messages[index].message.toString(),
              width: 200,
              height: 200,
              boxFit: BoxFit.fitWidth,
              maxHeight: 1200,
              maxWidth: 1200,
            ),
          )
        : InkWell(
            onTap: () {
              if (messages[index].message != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpenFullImage(
                            imagePath: messages[index].message.toString())));
              }
            },
            child: Image.file(File(messages[index].message.toString()),
                width: 200, height: 200, fit: BoxFit.fitWidth));
  }

  _audioWidget(BuildContext context,
      {required String message,
      required bool isMe,
      required String? duration}) {
    print("duration --> $duration");
    return InkWell(
        onTap: () {
          openPLayDialog(context, message);
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(children: [
            Icon(Icons.mic, color: isMe ? Colors.black : Colors.white),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Voice Message".tr,
                  style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      fontFamily: StringConstants.poppinsRegular,
                      color: isMe ? Colors.black : Colors.white),
                ),
                if (duration != null)
                  _audioTimeView(int.parse(duration),
                      isMe ? AppColors.desColor : AppColors.shadowColor)
              ],
            )
          ]),
        ));
  }

  _audioTimeView(int sec, Color color) {
    final String minutes = CommonFunctions.formatChatTimerNumber(sec ~/ 60);
    final String seconds = CommonFunctions.formatChatTimerNumber(sec % 60);

    return Text(
      '$minutes:$seconds',
      style: TextStyle(
        fontSize: 10,
        color: color,
        fontFamily: StringConstants.poppinsRegular,
      ),
    );
  }

  openPLayDialog(context, url) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Wrap(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    child: VoiceMessage(
                      key: ValueKey(url),
                      // formatDuration: (d) {
                      //   return CommonFunctions.getMM_ss(d);
                      // },
                      meBgColor: Colors.blue,
                      contactBgColor: Colors.blue,
                      audioSrc: url,
                      played: false,
                      // To show played badge or not.
                      me: true,
                      // Set message side.
                      onPlay: () {}, // Do something when voice played.
                    ))
              ],
            ),
          );
        });
  }

  chatBubbleWidget(BuildContext context, bool isMine, Widget widget) {
    return Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
              child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: isMine ? Colors.white : AppColors.blueColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  color: Colors.grey.withOpacity(0.4),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: isMine ? Radius.circular(10) : Radius.circular(10),
                bottomLeft: isMine ? Radius.circular(10) : Radius.circular(0),
                bottomRight: isMine ? Radius.circular(0) : Radius.circular(10),
                topRight: isMine ? Radius.circular(10) : Radius.circular(10),
              ),
            ),
            child: widget,
          )),
        ]);
  }

  void openImageOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        margin: EdgeInsets.only(
            right: Get.width * 0.050,
            left: Get.width * 0.050,
            bottom: Get.height * 0.020),
        height: Get.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                      askPermission(
                        context,
                        type: 'Camera',
                        description:
                            'Please allow camera access to add image.'.tr,
                        callBack: (v) async {
                          Get.to(TakePictureScreen(
                              // camera: camerasAvailable[0],
                              callBack: (XFile? res) async {
                            Get.back();
                            if (res != null) {
                              // var res = await CommonFunctions.compressFile(
                              //     File(mainRes.path));

                              final bytes = File(res.path).readAsBytesSync();
                              print("Chcek Data 1 ${replyMessage?.id}");

                              final bytesImage = File(res.path)
                                  .readAsBytesSync()
                                  .lengthInBytes;
                              double kb = bytesImage / 1024;
                              double dImageSize = kb / 1024;

                              if (showReply) {
                                print("Chcek Data ${replyMessage?.id}");

                                socket!.emit('sendMessage', {
                                  'sender_id': userId,
                                  'receiver_id': widget.receiverId,
                                  'message':
                                      "data:image/png;base64,${base64Encode(bytes)}",
                                  'chat_id': messages.isEmpty
                                      ? ''
                                      : messages[0].chatHeadId.toString(),
                                  'image_backend_compress':
                                      dImageSize > 1 ? true : false,
                                  'avatar': '',
                                  'message_type': '1',
                                  'replied_to': replyMessage?.id,
                                  'is_me_blocked': widget.isMeBlocked == 'true',
                                  'user_blocked': 'false'
                                });
                              } else {
                                socket!.emit('sendMessage', {
                                  'sender_id': userId,
                                  'receiver_id': widget.receiverId,
                                  'message':
                                      "data:image/png;base64,${base64Encode(bytes)}",
                                  'chat_id': messages.isEmpty
                                      ? ''
                                      : messages[0].chatHeadId.toString(),
                                  'image_backend_compress':
                                      dImageSize > 1 ? true : false,
                                  'avatar': '',
                                  'message_type': '1',
                                  //  'replied_to': replyMessage?.id,
                                  'is_me_blocked': widget.isMeBlocked == 'true',
                                  'user_blocked': 'false'
                                });
                              }

                              setState(() {
                                messages.insert(
                                    0,
                                    Chats(
                                        message: res.path,
                                        messageDate: DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                            .format(DateTime.now().toUtc()),
                                        senderId: int.parse(userId),
                                        messageType: '1',
                                        repliedTo:
                                            showReply ? replyMessage?.id : null,
                                        repliedToInfo: showReply
                                            ? RepliedToInfo(
                                                messageType:
                                                    replyMessage?.messageType,
                                                message: replyMessage?.message)
                                            : null));
                                // res.clear();
                                showReply = false;
                                replyMessage = null;
                              });
                            }
                          }));
                          // return;
                          /* final ImagePicker picker = ImagePicker();

                          XFile? res = await picker.pickImage(
                              imageQuality: 25, source: ImageSource.camera);

                          // List<Media>? res = await ImagesPicker.openCamera(
                          //   pickType: PickType.image,
                          // );
                          if (res != null) {
                            final bytes = File(res.path).readAsBytesSync();
                            print("Chcek Data 1 ${replyMessage?.id}");

                            if (showReply) {
                              print("Chcek Data ${replyMessage?.id}");

                              socket!.emit('sendMessage', {
                                'sender_id': userId,
                                'receiver_id': widget.receiverId,
                                'message':
                                    "data:image/png;base64,${base64Encode(bytes)}",
                                'chat_id': messages.isEmpty
                                    ? ''
                                    : messages[0].chatHeadId.toString(),
                                'avatar': '',
                                'message_type': '1',
                                'replied_to': replyMessage?.id,
                                'is_me_blocked': widget.isMeBlocked == 'true'
                              });
                            } else {
                              socket!.emit('sendMessage', {
                                'sender_id': userId,
                                'receiver_id': widget.receiverId,
                                'message':
                                    "data:image/png;base64,${base64Encode(bytes)}",
                                'chat_id': messages.isEmpty
                                    ? ''
                                    : messages[0].chatHeadId.toString(),
                                'avatar': '',
                                'message_type': '1',
                                //  'replied_to': replyMessage?.id,
                                'is_me_blocked': widget.isMeBlocked == 'true'
                              });
                            }

                            setState(() {
                              messages.insert(
                                  0,
                                  Chats(
                                      message: res.path,
                                      messageDate: DateFormat(
                                              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .format(DateTime.now().toUtc()),
                                      senderId: int.parse(userId),
                                      messageType: '1',
                                      repliedTo:
                                          showReply ? replyMessage?.id : null,
                                      repliedToInfo: showReply
                                          ? RepliedToInfo(
                                              messageType:
                                                  replyMessage?.messageType,
                                              message: replyMessage?.message)
                                          : null));
                              // res.clear();
                              showReply = false;
                              replyMessage = null;
                            });
                          }*/
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Camera".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.height * 0.018,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();

                      askPermission(context,
                          type: 'Gallery',
                          description:
                              'Please allow storage access to add image.'.tr,
                          callBack: (v) async {
                        final ImagePicker _picker = ImagePicker();

                        XFile? res = await _picker.pickImage(
                            imageQuality: 70,
                            source: ImageSource.gallery,
                            maxHeight: 1024,
                            maxWidth: 1024);
                        // await CommonFunctions.applyRotationFix(res!.path);
                        // File image = File(res!.path); // Or any other way to get a File instance.
                        // var decodedImage = await decodeImageFromList(image.readAsBytesSync());
                        // if(decodedImage.width > 1000 ){
                        //
                        // }
                        // print(decodedImage.width);
                        // print(decodedImage.height);

                        // List<Media>? res = await ImagesPicker.pick(
                        //   pickType: PickType.image,
                        // );
                        if (res != null) {
                          // var res = await CommonFunctions.compressFile(
                          //     File(mainRes.path));
                          final bytes = File(res.path).readAsBytesSync();
                          print("Chcek Data 1 ${replyMessage?.id}");

                          final bytesImage =
                              File(res.path).readAsBytesSync().lengthInBytes;
                          double kb = bytesImage / 1024;
                          double dImageSize = kb / 1024;

                          if (showReply) {
                            print("Chcek Data ${replyMessage?.id}");

                            socket!.emit('sendMessage', {
                              'sender_id': userId,
                              'receiver_id': widget.receiverId,
                              'message':
                                  "data:image/png;base64,${base64Encode(bytes)}",
                              'chat_id': messages.isEmpty
                                  ? ''
                                  : messages[0].chatHeadId.toString(),
                              'image_backend_compress':
                                  dImageSize > 1 ? true : false,
                              'avatar': '',
                              'message_type': '1',
                              'replied_to': replyMessage?.id,
                              'is_me_blocked': widget.isMeBlocked == 'true',
                              'user_blocked': 'false'
                            });
                          } else {
                            socket!.emit('sendMessage', {
                              'sender_id': userId,
                              'receiver_id': widget.receiverId,
                              'message':
                                  "data:image/png;base64,${base64Encode(bytes)}",
                              'chat_id': messages.isEmpty
                                  ? ''
                                  : messages[0].chatHeadId.toString(),
                              'image_backend_compress':
                                  dImageSize > 1 ? true : false,
                              'avatar': '',
                              'message_type': '1',
                              //      'replied_to': replyMessage?.id,
                              'is_me_blocked': widget.isMeBlocked == 'true',
                              'user_blocked': 'false'
                            });
                          }
                          setState(() {
                            messages.insert(
                                0,
                                Chats(
                                    message: res.path,
                                    messageDate: DateFormat(
                                            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                        .format(DateTime.now().toUtc()),
                                    senderId: userId.isNotEmpty
                                        ? int.parse(userId)
                                        : null,
                                    messageType: '1',
                                    repliedTo:
                                        showReply ? replyMessage?.id : null,
                                    repliedToInfo: showReply
                                        ? RepliedToInfo(
                                            messageType:
                                                replyMessage?.messageType,
                                            message: replyMessage?.message)
                                        : null));
                            // res!.clear();
                            showReply = false;
                            replyMessage = null;
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Gallery".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: StringConstants.poppinsRegular,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.height * 0.018,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: Get.width,
              height: Get.height * 0.016,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimensions.radius15)),
                    color: Colors.white),
                width: Get.width,
                height: Get.height * 0.070,
                child: Center(
                    child: Text(
                  "Cancel".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: StringConstants.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.height * 0.018,
                      color: Colors.black),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // final record = Record();

  Future<String> createFolder(String name) async {
    final dir = Directory(
        '${(Platform.isAndroid ? await getTemporaryDirectory() // getExternalStorageDirectory() //FOR ANDROID
                : await getTemporaryDirectory() //getApplicationDocumentsDirectory()  //  getApplicationSupportDirectory() //FOR IOS
            ).path}/$name');

    // dir.deleteSync(recursive: true);

    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }

  // startRecording() async {
  //   askPermission(
  //     context,
  //     type: "Mic",
  //     description: "Please allow microphone access to send audio message.".tr,
  //     callBack: (v) async {
  //       if (await record.hasPermission()) {
  //         String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //         String path = await createFolder("gagago");
  //         // recordingPath = "$path/$fileName.m4a";
  //         debugPrint("path --> startRecording $path/$fileName.m4a");
  //         await record.start(
  //           path: "$path/$fileName.m4a",
  //           encoder: AudioEncoder.aacLc,
  //           // encoder: AudioEncoder.amrWb,
  //           bitRate: 128000,
  //           samplingRate: 44100,
  //         );
  //       }
  //       _recordDuration = 0;
  //       _startTimer();
  //     },
  //   );
  // }

  // stopRecording() async {
  //   _timer?.cancel();
  //   // _recordDuration = 0;
  //   // String? path = await record.stop();
  //   if (Platform.isIOS) {
  //     dio.FormData form = dio.FormData.fromMap({});
  //     form.files.add(MapEntry(
  //       'audio',
  //       // await dio.MultipartFile.fromFile(path!, filename: basename(path)),
  //     ));
  //     debugPrint("audio form$form");
  //
  //     print("CheckRec $form");
  //     UploadAudio registerModel = await CallService().uploadFile(form);
  //
  //     setState(() {
  //       sendDeleteRecording = true;
  //       recordingPath = registerModel.fileLink ?? "";
  //       debugPrint("path --> stopRecording -> $recordingPath");
  //     });
  //   } else {
  //     setState(() {
  //       sendDeleteRecording = true;
  //       recordingPath = path!;
  //       debugPrint("path --> stopRecording -> $recordingPath");
  //     });
  //   }
  // }

  bool sendDeleteRecording = false;
  String recordingPath = "";

  Widget getRecordingWidget(String path) {
    debugPrint("getRecordingWidget path $path");
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                sendDeleteRecording = false;
                recordingPath = "";
              });
            },
          ),
          VoiceMessage(
            // key: ValueKey(path),
            // formatDuration: (d) {
            //   return CommonFunctions.getMM_ss(d);
            // },
            meBgColor: Colors.blue,
            contactBgColor: Colors.blue,
            audioSrc: path,
            played: false,
            me: true,

            onPlay: () {
              debugPrint("path $path");
            }, // Do something when voice played.
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              // return;

              setState(() {
                sendDeleteRecording = false;
                recordingPath = "";
              });
              var base64Str;
              int? mySenderId;
              if (Platform.isIOS) {
                var bytes = utf8.encode(path);
                base64Str = base64.encode(bytes);
                print("Chcek Data 1 ${replyMessage?.id}");

                if (showReply) {
                  print("Chcek Data ${replyMessage?.id}");

                  socket!.emit('sendMessage', {
                    'sender_id': userId,
                    'receiver_id': widget.receiverId,
                    'message': base64Str,
                    'chat_id': messages.isEmpty
                        ? ''
                        : messages[0].chatHeadId.toString(),
                    'avatar': '',
                    'message_type': '3',
                    'audio_duration': _recordDuration,
                    'replied_to': replyMessage?.id,
                    'is_me_blocked': widget.isMeBlocked == 'true',
                    'user_blocked': 'false'
                  });
                } else {
                  socket!.emit('sendMessage', {
                    'sender_id': userId,
                    'receiver_id': widget.receiverId,
                    'message': base64Str,
                    'chat_id': messages.isEmpty
                        ? ''
                        : messages[0].chatHeadId.toString(),
                    'avatar': '',
                    'message_type': '3',
                    'audio_duration': _recordDuration,
                    // 'replied_to': replyMessage?.id,
                    'is_me_blocked': widget.isMeBlocked == 'true',
                    'user_blocked': 'false'
                  });
                }
              } else {
                dio.FormData form = dio.FormData.fromMap({});
                form.files.add(MapEntry(
                  'audio',
                  await dio.MultipartFile.fromFile(path,
                      filename: basename(path)),
                ));
                UploadAudio registerModel =
                    await CallService().uploadFile(form);
                if (registerModel.status!) {
                  mySenderId = registerModel.senderId;
                  debugPrint(
                      "mySenderId  +==== $mySenderId   ++++++++ $userId");
                  var bytes = utf8.encode(registerModel.fileLink.toString());
                  base64Str = base64.encode(bytes);
                  print("Check Data 1 ${replyMessage?.id}");

                  if (showReply) {
                    print("Check Data ${replyMessage?.id}");

                    socket!.emit('sendMessage', {
                      'sender_id': userId,
                      'receiver_id': widget.receiverId,
                      'message': base64Str,
                      'chat_id': messages.isEmpty
                          ? ''
                          : messages[0].chatHeadId.toString(),
                      'avatar': '',
                      'message_type': '3',
                      'audio_duration': _recordDuration,
                      'replied_to': replyMessage?.id,
                      'is_me_blocked': widget.isMeBlocked == 'true',
                      'user_blocked': 'false'
                    });
                  } else {
                    socket!.emit('sendMessage', {
                      'sender_id': userId,
                      'receiver_id': widget.receiverId,
                      'message': base64Str,
                      'chat_id': messages.isEmpty
                          ? ''
                          : messages[0].chatHeadId.toString(),
                      'avatar': '',
                      'message_type': '3',
                      'audio_duration': _recordDuration,
                      //   'replied_to': replyMessage?.id,
                      'is_me_blocked': widget.isMeBlocked == 'true',
                      'user_blocked': 'false'
                    });
                  }
                }
              }
              setState(() {
                // dynamic rawMessages = [];
                // rawMessages.addAll(messages);
                // messages.clear();
                print("ChReply Message ${replyMessage?.id}");

                messages.insert(
                    0,
                    Chats(
                        message: base64Str,
                        messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                            .format(DateTime.now().toUtc()),
                        senderId: int.parse(userId),
                        messageType: '3',
                        audioDuration: _recordDuration.toString(),

                        ///Todo  Tomorrow fix this issue and get reply agai
                        repliedTo: showReply ? replyMessage?.id : null,
                        repliedToInfo: showReply
                            ? RepliedToInfo(
                                messageType: replyMessage?.messageType,
                                message: replyMessage?.message)
                            : null));

                // messages.addAll(rawMessages);
                // print("messages --> ${messages.length} rawMessages ${rawMessages.length}");
                showReply = false;
                replyMessage = null;
                _recordDuration = 0;
              });
            },
          ),
        ],
      ),
    );
  }

  Timer? _timer;
  int _recordDuration = 0;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<RecordState>? _recordSub;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  Widget _buildTimer() {
    final String minutes =
        CommonFunctions.formatChatTimerNumber(_recordDuration ~/ 60);
    final String seconds =
        CommonFunctions.formatChatTimerNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(
        fontFamily: StringConstants.poppinsRegular,
      ),
    );
  }

  Widget showReplyBar(Chats chat) {
    return Container(
      width: Get.width,
      color: Colors.blue,
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Container(
        margin:
            EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                child: chat.messageType == '0'
                    ? Text(utf8.decode(base64.decode(chat.message.toString())),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: StringConstants.poppinsRegular,
                            fontSize: Get.height * 0.018))
                    : chat.messageType == '1'
                        ? Row(
                            children: [
                              const Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Get.width * 0.008),
                                child: Text(
                                  'Photo'.tr,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: Get.height * 0.018,
                                    fontFamily: StringConstants.poppinsRegular,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Get.width * 0.008),
                                child: Text(
                                  'Voice Message'.tr,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: Get.height * 0.018,
                                    fontFamily: StringConstants.poppinsRegular,
                                  ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    showReply = false;
                    replyMessage = null;
                  });
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  // int count = 0;
// CommonFunctions.getFilePath();

  showBlockedChatAlertDialog(BuildContext context, String? msg,
      {required Function callback}) {
    if (!mounted) {
      return;
    }

    if (showingAlertDialog) {
      return;
    }
    showingAlertDialog = true;
    FocusScope.of(context).requestFocus(FocusNode());

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Close".tr,
        style: const TextStyle(
          fontFamily: StringConstants.poppinsRegular,
        ),
      ),
      onPressed: () {
        showingAlertDialog = false;
        Get.back();
        callback();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert".tr,
        style: const TextStyle(
          color: Colors.red,
          fontFamily: StringConstants.poppinsRegular,
        ),
      ),
      content: Text(
        // "It appears that you have been blocked by the user. When someone blocks you, it means they have chosen to restrict communication from your account.".tr,
        msg ?? "Connection has been removed. You cannot continue chat now.".tr,
        style: const TextStyle(
          fontFamily: StringConstants.poppinsRegular,
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    Get.dialog(
      WillPopScope(onWillPop: () async => false, child: alert),
      barrierDismissible: false,
    );
  }

  debugPrint(String message) {}
  // print(String? message) {
  //
  //   if(message != null) {
  //     print("${message ?? ""}");
  //   }
  // }

  void askPermission(context,
      {required Function(bool) callBack,
      required String type,
      required String description}) async {
    print("type, --> $type");
    late PermissionStatus? status;
    if (type == "Camera") {
      status = await Permission.camera.request();
    } else if (type == "Gallery") {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var release = androidInfo.version.release;
        // Android 9 (SDK 28), Xiaomi Redmi Note 7

        int id;
        if (release.contains(".")) {
          int idx = release.indexOf(".");
          release.substring(0, idx).trim();
          id = release.indexOf(".");
        } else {
          id = int.parse(release);
        }
        if (id < 13) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.storage.request();
      }
    } else if (type == "Location") {
      status = await Permission.location.request();
    } else if (type == "Mic") {
      status = await Permission.microphone.request();
    }
    if (status != null) {
      if (status.isDenied) {
        print("status --> isDenied");
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        //    print("Permission is denied.");
        if (type == "Camera") {
          status = await Permission.camera.request();
        } else if (type == "Gallery") {
          if (Platform.isAndroid) {
            var androidInfo = await DeviceInfoPlugin().androidInfo;
            var release = androidInfo.version.release;
            // Android 9 (SDK 28), Xiaomi Redmi Note 7

            int id;
            if (release.contains(".")) {
              int idx = release.indexOf(".");
              release.substring(0, idx).trim();
              id = release.indexOf(".");
            } else {
              id = int.parse(release);
            }
            if (id < 13) {
              status = await Permission.storage.request();
            } else {
              status = await Permission.photos.request();
            }
          } else {
            status = await Permission.storage.request();
          }
        } else if (type == "Location") {
          status = await Permission.location.request();
        } else if (type == "Mic") {
          status = await Permission.microphone.request();
        }
      } else if (status.isGranted) {
        print("status --> isGranted");
        //permission is already granted.
        callBack(true);
        //  scrollController = widget.scrollController;
      } else if (status.isPermanentlyDenied) {
        print("status --> isPermanentlyDenied");
        //permission is permanently denied.
        // callBack(true);
        openAppBox(context, description: description);
        //   print("Permission is permanently denied");
      } else if (status.isRestricted) {
        print("status --> isRestricted");
        //permission is OS restricted.
        // callBack(true);
        openAppBox(context, description: description);
      } else {
        print("status --> under else");
      }
    }
  }

  bool isDialogShowing = false;

  void openAppBox(context, {required String description}) {
    print("under --> openAppBox ${isDialogShowing}");
    isDialogShowing = false;
    if (isDialogShowing) {
      return;
    }
    isDialogShowing = true;
    showDialog(
        context: Get.overlayContext ?? context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            description: description,
            callback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Alert'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        description.tr,
                        // 'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                        //     .tr,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        isDialogShowing = false;
                        Navigator.pop(context);
                        openAppSettings();
                      },
                      child: Text(
                        "Ok".tr,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class NoisePainter extends CustomPainter {
  final int seed;

  NoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    final paint = Paint()..color = Colors.black;
    final path = Path();

    for (double i = 0; i < size.width; i += 2) {
      final x = i + random.nextDouble() * 2;
      final y = random.nextDouble() * size.height;
      path.moveTo(x, y);
      path.lineTo(x + 1, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NoisePainter oldDelegate) => true;
}
