// import 'dart:async';
// import 'dart:convert';
//
// import 'dart:io';
// import 'dart:math';
// import 'package:audioplayers/audioplayers.dart';
//
// import 'package:chat_bubbles/chat_bubbles.dart';
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_chat_bubble/bubble_type.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gagagonew/main.dart';
// import 'package:gagagonew/model/ads_click_model.dart';
// import 'package:gagagonew/model/advertisement_response_model.dart';
// import 'package:gagagonew/model/chat_by_user_model.dart';
// import 'package:gagagonew/utils/progress_bar.dart';
// import 'package:gagagonew/view/chat/OpenFullImage.dart';
// import 'package:get/get.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:images_picker/images_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:path/path.dart';
// import 'package:record/record.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart';
// // import 'package:voice_message_package/voice_message_package.dart';
// import '../../Service/call_service.dart';
// import '../../audio_chat_widgets/my_voice_message.dart';
// import '../../constants/color_constants.dart';
// import '../../constants/string_constants.dart';
// import '../../controller/review_controller.dart';
// import '../../model/block_user_model.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:path_provider/path_provider.dart';
// import '../../model/connection_remove_model.dart';
// import '../../model/upload_file.dart';
// import '../../utils/common_functions.dart';
// import '../../utils/dimensions.dart';
// import '../../utils/stream_controller.dart';
// import '../app_web_view_screen.dart';
//
// import '../home/setting_page.dart';
// import 'audiochat/chat_audio_bubble.dart';
//
// class ChatMessageScreen extends StatefulWidget {
//   String? receiverId;
//   bool? isShown;
//   String? connectionType;
//   String? commonInterest;
//   String? isMeBlocked;
//   String? image;
//   String? name;
//
//   ChatMessageScreen({this.receiverId, this.isShown, this.connectionType, this.commonInterest, this.isMeBlocked, this.image, this.name, Key? key}) : super(key: key);
//
//   @override
//   State<ChatMessageScreen> createState() => _ChatMessageScreenState();
// }
//
// class _ChatMessageScreenState extends State<ChatMessageScreen> {
//   TextEditingController chatController = TextEditingController();
//   AppStreamController appStreamController = AppStreamController.instance;
//   var randomBannerIndex = Random();
//   final controller = Get.put(ReviewController());
//   ScrollController scrollController = ScrollController();
//
//   bool isScreenOpened = false;
//   List<Chats> messages = [];
//   List<Chats> newMessages = [];
//   Socket? socket;
//   String userId = '';
//   String? receiverName = '';
//   String? receiverImage = '';
//   List<AdvertisementList> allAdvertisementList = [];
//   List<AdvertisementList> advertisementList = [];
//   int? adsShowIndex;
//   int advertisementType = 2;
//   bool? isShown;
//   final _focusNode = FocusNode();
//   bool chatFlag = true;
//   bool showingAlertDialog = false;
//   bool isComplete = false;
//   bool pageFlag = false;
//   bool isPagination = false;
//
//   int bannerIndex = 0;
//   int pageStartPoint = 0;
//   int? addIncAdd = 0;
//   Duration duration = const Duration();
//   Timer? timer;
//   int currentBannerIndex = 0;
//   int startPoint = 0;
//
//   int checkPagination = 0;
//
//   AudioPlayer currentAudioPlayer = new AudioPlayer();
//   Duration currentDuration = new Duration();
//   Duration currentPosition = new Duration();
//   bool isCurrentPlaying = false;
//   bool isCurrentLoading = false;
//   bool isCurrentPause = false;
//
//   ///voice message
//   // bool _isPlaying = false;
//   // AudioPlayer? _audioPlayer;
//   // int _noiseSeed = DateTime.now().millisecondsSinceEpoch;
//   //
//   // void _playAudio(String filePath) async {
//   //   await _audioPlayer!.play(UrlSource(filePath));
//   //   setState(() {
//   //     _isPlaying = true;
//   //   });
//   // }
//   //
//   // void _stopAudio() async {
//   //   await _audioPlayer!.stop();
//   //   setState(() {
//   //     _isPlaying = false;
//   //   });
//   // }
//
//   loadNextPage() async {
//     debugPrint("under loadNextPage");
//     setState(() {
//       isPagination = true;
//     });
//     var map = <String, dynamic>{};
//
//     map['user_id'] = widget.receiverId;
//     map['start_point'] = pageStartPoint;
//     debugPrint("map list show $map");
//     ChatByUserModel model = await CallService().getChatByUser(map);
//     if (mounted) {
//       setState(() {
//         isPagination = false;
//         pageFlag = model.data!.chatFlag!; // only for pagination purposes
//         pageStartPoint = model.data!.totalRecords!;
//         chatFlag = (model.data!.chats!.isNotEmpty ? model.data!.chats![0].chatFlag : true)!;
//         receiverName = '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
//         receiverImage = model.data!.user!.userProfile!.isNotEmpty ? model.data!.user!.userProfile![0].imageName.toString() : "";
//         debugPrint("receiverImage $receiverImage");
//         debugPrint("receiverName $receiverName");
//         debugPrint("pageStartPoint $pageStartPoint");
//
//         List<Chats> rawList = [];
//         rawList.addAll(model.data!.chats!.reversed);
//
//         if (advertisementList.isNotEmpty) {
//           bool adExist = false;
//           int lastAdIndex = 0;
//           int pendingMessages = messages.length - lastAdIndex;
//           for (int i = 0; i < messages.length; i++) {
//             if (messages[i].ads != null) {
//               adExist = true;
//               lastAdIndex = i;
//             }
//           }
//           debugPrint("adExist $adExist");
//
//           debugPrint("pendingMessages $pendingMessages lastAdIndex $lastAdIndex adsShowIndex $adsShowIndex message.length ${messages.length}");
//           for (int i = 0; i < rawList.length; i++) {
//             int modules = (i + pendingMessages) % adsShowIndex!;
//             debugPrint("modules $modules");
//             if (modules == 0) {
//               debugPrint(" check pending count ${(i - 1)}");
//               if ((i - 1) >= 0) {
//                 if (addIncAdd! + 1 == advertisementList.length) {
//                   addIncAdd = 0;
//                 } else {
//                   addIncAdd = addIncAdd! + 1;
//                 }
//                 rawList[i - 1].ads = advertisementList[addIncAdd!];
//               }
//             }
//           }
//         }
//
//         // OLD CODE
//         messages.addAll(rawList);
//         for (int i = 0; i < messages.length; i++) {
//           if (messages[i].messageType == '1') {
//             messages[i].message = messages[i].message!.contains("https") ? messages[i].message.toString() : 'https://api.gagagoapp.com/message_files/${messages[i].message}';
//           }
//         }
//
// /*
//         for (int i = 0; i < rawList.length; i++) {
//           if (rawList[i].messageType == '1') {
//             rawList[i].message = rawList[i].message!.contains("https")
//                 ? rawList[i].message.toString()
//                 : 'https://api.gagagoapp.com/message_files/${rawList[i].message}';
//           }
//         }
// */
//
//         // messages.addAll(List.from(rawList));
//         //handleAds();
//       });
//     }
//   }
//
// /*  addNewPaginationMessage(String base64Str, String userId, String msgId) {
//     // if(adsList.length == adsList.length+2){
//     //   addInc=0;
//     // }else{
//     //addInc++;
//     // }
//     if (messages.length >= adsShowIndex!) {
//       bool adExist = false;
//       for (int i = 0; i < adsShowIndex! - 1; i++) {
//         if (messages[i].ads != null) {
//           adExist = true;
//         }
//       }
//
//       if (!adExist) {
//         if (addIncAdd! + 1 == advertisementList.length) {
//           addIncAdd = 0;
//         } else {
//           addIncAdd = addIncAdd! + 1;
//         }
//         messages.insert(
//             0,
//             Chats(
//                 message: base64Str,
//                 messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                     .format(DateTime.now()),
//                 senderId: int.parse(userId),
//                 messageType: msgId,
//                 repliedTo: showReply ? replyMessage!.id : null,
//                 repliedToInfo: showReply
//                     ? RepliedToInfo(
//                         messageType: replyMessage!.messageType,
//                         message: replyMessage!.message)
//                     : null,
//                 ads: advertisementList.isNotEmpty
//                     ? advertisementList[addIncAdd!]
//                     : null));
//       } else {
//
//         messages.insert(
//             0,
//             Chats(
//                 message: base64Str,
//                 messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                     .format(DateTime.now()),
//                 senderId: int.parse(userId),
//                 messageType: msgId,
//                 repliedTo: showReply ? replyMessage!.id : null,
//                 repliedToInfo: showReply
//                     ? RepliedToInfo(
//                         messageType: replyMessage!.messageType,
//                         message: replyMessage!.message)
//                     : null));
//       }
//     } else {
//       messages.insert(
//           0,
//           Chats(
//               message: base64Str,
//               messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                   .format(DateTime.now()),
//               senderId: int.parse(userId),
//               messageType: msgId,
//               repliedTo: showReply ? replyMessage!.id : null,
//               repliedToInfo: showReply
//                   ? RepliedToInfo(
//                       messageType: replyMessage!.messageType,
//                       message: replyMessage!.message)
//                   : null));
//     }
//
//     messages[messages.length - 1].ads =
//         advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null;
//
//     setState(() {});
//   }*/
//
//   void init() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId') ?? "";
//     });
//     getBadgesCount();
//     scrollController.addListener(() {
//       debugPrint("under addListener");
//       if (scrollController.position.maxScrollExtent == scrollController.position.pixels && pageFlag) {
//         loadNextPage();
//       }
//     });
//
//     try {
//       socket = io.io(
//         //'http://chat.gagagoapp.com/',
//         'https://chat.gagagoapp.com/',
//         <String, dynamic>{
//           'transports': ['websocket'],
//           'forceNew': true
//         },
//       );
//       /* socket!.on('message', (data) {
//         debugPrint("SocketMessage2 " + data.toString());
//       });*/
//       socket!.connect();
//       socket!.onConnect((data) async {
//         debugPrint('Connected: $data');
//
//         /* socket!.emit('getChatMessages', {
//           'my_id': userId,
//           'other_user_id': widget.receiverId,
//         });*/
//         socket!.on('chatReadStatus', (data) async {
//           debugPrint("under chatReadStatus $data");
//
//           if (messages.isNotEmpty) {
//             if (data["chat_head_id"] != null) {
//               if (messages.last.chatHeadId.toString() == data["chat_head_id"].toString()) {
//                 if (userId.toString() == data["sender_id"].toString()) {
//                   _readAllMessage();
//                 }
//               }
//             }
//           }
//         });
//
//         socket!.on('message', (data) async {
//           debugPrint('getChatMessages:=>$data');
//           setState(() {
//             if (data is List) {
//               for (var v in data) {
//                 Chats newMessage = Chats.fromJson(v);
//                 chatFlag = newMessage.chatFlag ?? true;
//
//                 if (!chatFlag) {
//                   showBlockedChatAlertDialog(this.context, newMessage.message);
//                 } else {
//                   if (newMessage.repliedTo != null) {
//                     //startPoint = 0;
//                     pageStartPoint = 0;
//                     hitApi();
//
//                     // Chats? replyMessage;
//                     //
//                     // for (int i = 0; i < messages.length; i++) {
//                     //   if (newMessage.repliedTo == messages[i].id) {
//                     //     messages[i] = newMessage;
//                     //     replyMessage = messages[i];
//                     //
//                     //   }
//                     // }
//                     // if (replyMessage != null) {
//                     //   messages.insert(0, newMessage);
//                     // }
//
//                   } else {
//                     int indexMessage = messages.indexWhere((element) => element.id == newMessage.id);
//                     if (indexMessage < 0) {
//                       messages.insert(0, newMessage);
//                     }
//                   }
//                 }
//               }
//             } else {
//               Chats newMessage = Chats.fromJson(data);
//               chatFlag = newMessage.chatFlag ?? true;
//
//               if (newMessage.receiverId.toString() == userId && isScreenOpened) {
//                 socket!.emit("markAllMessageRead", {
//                   'sender_id': widget.receiverId,
//                   'receiver_id': userId,
//                   //'chat_head_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                   'chat_head_id': messages.isEmpty ? '' : newMessage.chatHeadId.toString(),
//                 });
//                 // addNewMessage(messages.toString(), userId!);
//               }
//
//               if (!chatFlag) {
//                 showBlockedChatAlertDialog(this.context, newMessage.message);
//               } else {
//                 if (newMessage.receiverId.toString() == userId && widget.receiverId.toString() == newMessage.senderId.toString()) {
//                   if (newMessage.repliedTo != null) {
//                     //startPoint = 0;
//                     pageStartPoint = 0;
//                     hitApi();
//
//                     // Chats? replyMessage;
//                     // for (int i = 0; i < messages.length; i++) {
//                     //   if (newMessage.repliedTo == messages[i].id) {
//                     //     // messages[i] = newMessage;
//                     //     replyMessage = messages[i];
//                     //     replyMessage
//                     //   }
//                     // }
//                     // if (replyMessage != null) {
//                     //
//                     //   messages.insert(0, newMessage);
//                     // }
//                   } else {
//                     if (newMessage.messageType == '1') {
//                       newMessage.message = 'https://api.gagagoapp.com/message_files/${newMessage.message}';
//                     }
//                     int indexMessage = messages.indexWhere((element) => element.id == newMessage.id);
//                     if (indexMessage < 0) {
//                       addNewMessages(newMessage.message.toString(), userId != newMessage.receiverId.toString() ? newMessage.receiverId.toString() : newMessage.senderId.toString(),
//                           newMessage.messageType!);
//                     }
//                   }
//                 }
//               }
//             }
//           });
//         });
//       });
//       /* */
//       socket!.onConnectError((data) {
//         debugPrint('Error: $data');
//       });
//     } catch (e) {
//       debugPrint('Error$e');
//     }
//
//     hitApi();
//   }
//
//   int likeCount = 0;
//   int chatCount = 0;
//
//   getBadgesCount() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var model = await CallService().getUserProfile(showLoader: false);
//       likeCount = model.likeCount ?? 0;
//       chatCount = model.chatCount ?? 0;
//       FlutterAppBadger.updateBadgeCount(likeCount + chatCount);
//       setState(() {});
//       appStreamController.rebuildupdateBadgesCountStream();
//       appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: chatCount, likeCount: likeCount));
//     });
//   }
//
//   _readAllMessage() {
//     for (int i = 0; i < messages.length; i++) {
//       if (messages[i].seenAt == null) {
//         messages[i].seenAt = DateTime.now().toUtc().toString();
//       }
//       messages[i].isRead = 1;
//       debugPrint("messages[i].isRead ${messages[i].isRead}");
//     }
//     setState(() {});
//   }
//
//   hitApi() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var map = <String, dynamic>{};
//       map['user_id'] = widget.receiverId;
//       map['start_point'] = pageStartPoint;
//       debugPrint("list of map show data $map");
//       ChatByUserModel model = await CallService().getChatByUser(map);
//
//       setState(() {
//         pageFlag = model.data!.chatFlag!; // only for pagination purposes
//         pageStartPoint = model.data!.totalRecords!; // only for pagination purposes
//         chatFlag = (model.data!.chats!.isNotEmpty ? model.data!.chats![0].chatFlag : true)!;
//         receiverName = '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
//         receiverImage = model.data!.user!.userProfile!.isNotEmpty ? model.data!.user!.userProfile![0].imageName.toString() : "";
//         debugPrint("receiverImage $receiverImage");
//         debugPrint("receiverName 1111 $receiverName");
//         debugPrint("pageStartPoint 1111 $pageStartPoint");
//
//         messages = model.data!.chats!;
//
//         int? chatId;
//         for (int i = 0; i < messages.length; i++) {
//           if (messages[i].messageType == '1') {
//             messages[i].message = 'https://api.gagagoapp.com/message_files/${messages[i].message}';
//           }
//           debugPrint("messages[i].chatHeadId -->> ${messages[i].chatHeadId}");
//           if (messages[i].chatHeadId != null) {
//             chatId = messages[i].chatHeadId;
//           }
//         }
//         if (messages.isNotEmpty) {
//           socket!.emit("markAllMessageRead", {
//             'sender_id': widget.receiverId,
//             'receiver_id': userId,
//             'chat_head_id': chatId == null ? '' : chatId.toString(),
//           });
//           debugPrint("chat_head_id 2 ${chatId.toString()}");
//         }
//
//         messages = List.from(messages.reversed);
//
//         // addNewMessage(messages[i].message!,messages[i].id.toString(),messages[i].messageType!);
//         if (advertisementList.isNotEmpty) {
//           handleAds();
//         }
//       });
//
//       //etAdvertisementList();
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     isScreenOpened = false;
//     debugPrint("under dispose  $isScreenOpened");
//
//     updateCurrentChatId("", true);
//     _focusNode.dispose();
//     _timer?.cancel();
//     _recordSub?.cancel();
//     // _audioPlayer!.stop();
//     // _audioPlayer!.release();
//     if (socket != null) {
//       socket!.clearListeners();
//       socket!.disconnect();
//       socket!.close();
//     }
//   }
//
//   bool hasFocus = false;
//
//   addNewMessages(String base64Str, String senderId, String msgId) {
//     // if(adsList.length == adsList.length+2){
//     //   addInc=0;
//     // }else{
//     //addInc++;
//     // }
//     setState(() {
//       if (messages.length >= adsShowIndex!) {
//         bool adExist = false;
//         for (int i = 0; i < adsShowIndex! - 1; i++) {
//           if (messages[i].ads != null) {
//             adExist = true;
//           }
//         }
//
//         if (!adExist) {
//           if (addIncAdd! + 1 == advertisementList.length) {
//             addIncAdd = 0;
//           } else {
//             addIncAdd = addIncAdd! + 1;
//           }
//           if (msgId == "0") {
//             messages.insert(
//                 0,
//                 Chats(
//                     message: base64Str,
//                     messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                     senderId: int.parse(senderId),
//                     messageType: msgId,
//                     repliedTo: showReply ? replyMessage!.id : null,
//                     repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null,
//                     ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null,
//                     audioPlayer: new AudioPlayer(),
//                     duration: new Duration(),
//                     position: new Duration(),
//                     isPlaying: false,
//                     isLoading: false,
//                     isPause: false));
//           } else {
//             if (msgId == "0") {
//               messages.insert(
//                   0,
//                   Chats(
//                       message: base64Str,
//                       messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                       senderId: int.parse(senderId),
//                       messageType: msgId,
//                       repliedTo: showReply ? replyMessage!.id : null,
//                       repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null,
//                       ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null,
//                       audioPlayer: new AudioPlayer(),
//                       duration: new Duration(),
//                       position: new Duration(),
//                       isPlaying: false,
//                       isLoading: false,
//                       isPause: false));
//             } else {
//               messages.insert(
//                   0,
//                   Chats(
//                       message: base64Str,
//                       messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                       senderId: int.parse(senderId),
//                       messageType: msgId,
//                       repliedTo: showReply ? replyMessage!.id : null,
//                       repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null,
//                       ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null));
//             }
//           }
//
//           /// add ads
//         } else {
//           if (msgId == "0") {
//             messages.insert(
//                 0,
//                 Chats(
//                     message: base64Str,
//                     messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                     senderId: int.parse(senderId),
//                     messageType: msgId,
//                     repliedTo: showReply ? replyMessage!.id : null,
//                     repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null,
//                     ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null,
//                     audioPlayer: new AudioPlayer(),
//                     duration: new Duration(),
//                     position: new Duration(),
//                     isPlaying: false,
//                     isLoading: false,
//                     isPause: false));
//           } else {
//             messages.insert(
//                 0,
//                 Chats(
//                     message: base64Str,
//                     messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                     senderId: int.parse(senderId),
//                     messageType: msgId,
//                     repliedTo: showReply ? replyMessage!.id : null,
//                     repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null));
//           }
//         }
//       } else {
//         if (msgId == "0") {
//           messages.insert(
//               0,
//               Chats(
//                   message: base64Str,
//                   messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                   senderId: int.parse(senderId),
//                   messageType: msgId,
//                   repliedTo: showReply ? replyMessage!.id : null,
//                   repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null,
//                   ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null,
//                   audioPlayer: new AudioPlayer(),
//                   duration: new Duration(),
//                   position: new Duration(),
//                   isPlaying: false,
//                   isLoading: false,
//                   isPause: false));
//         } else {
//           messages.insert(
//               0,
//               Chats(
//                   message: base64Str,
//                   messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                   senderId: int.parse(senderId),
//                   messageType: msgId,
//                   repliedTo: showReply ? replyMessage!.id : null,
//                   repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null));
//         }
//       }
//
//       messages[messages.length - 1].ads = advertisementList.isNotEmpty ? advertisementList[addIncAdd!] : null;
//     });
//   }
//
//   handleAds() {
//     debugPrint("enter in handleAds");
//     int addInc = 0;
//     if (adsShowIndex == null) {
//       return;
//     }
//     for (int i = 0; i < messages.length; i++) {
//       //  if (i % adsShowIndex! == 0) {
//       if ((i + 1) % adsShowIndex! == 0) {
//         debugPrint("handleAds adsShowIndex ${i % adsShowIndex!} ");
//         if (addInc + 1 == advertisementList.length) {
//           addInc = 0;
//           debugPrint("check addInc 1 $addInc");
//         } else {
//           addInc++;
//           debugPrint("check addInc 2 $addInc");
//         }
//         setState(() {
//           messages[i].ads = advertisementList[addInc];
//         });
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//     receiverName = widget.name;
//     debugPrint("receiverName 222 $receiverName");
//     receiverImage = widget.image;
//     updateCurrentChatId(widget.receiverId.toString(), false);
//     _focusNode.addListener(() {
//       setState(() {
//         hasFocus = _focusNode.hasFocus;
//       });
//     });
//     appStreamController.handleBottomTab.add(false);
//     _recordSub = record.onStateChanged().listen((recordState) {
//       setState(() => _recordState = recordState);
//     });
//
//     getAdvertisementList();
//
//     // addInc=advertisementList.length;
//     //debugPrint("check addInc init$addInc");
//     addIncAdd = 0;
//     isScreenOpened = true;
//
//     // _audioPlayer = AudioPlayer();
//     // _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
//     //   if (state == PlayerState.stopped || state == PlayerState.completed) {
//     //     setState(() {
//     //       _isPlaying = false;
//     //     });
//     //   }
//     // });
//     //refreshEventList();
//   }
//
//   Future<void> refreshEventList() async {
//     /*await Future.delayed(Duration(seconds: 2));
//     setState(() {
//
//     });
//     return;*/
//   }
//
//   Future getAdvertisementList() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       AdvertisementResponseModel model = await CallService().getAdvertisementList(advertisementType);
//       if (mounted) {
//         setState(() {
//           debugPrint("Advertisement_Response $model");
//           allAdvertisementList = model.advertisementList!;
//           if (model.advertisementSetting != null) {
//             if (model.advertisementSetting!.inChatHowAnyMessagesAfterShowAdd != null) {
//               adsShowIndex = int.parse(model.advertisementSetting!.inChatHowAnyMessagesAfterShowAdd!);
//               debugPrint("adsShowIndex $adsShowIndex");
//             }
//           }
//
//           if (allAdvertisementList.isNotEmpty) {
//             for (var element in allAdvertisementList) {
//               if (element.advShowArea != 1) {
//                 advertisementList.add(element);
//               }
//             }
//
//             handleAds();
//           }
//
//           // advertisementList.removeWhere((element) {
//           //   return element.advShowArea == 1;
//           // });
//
//           // advertisementList.reversed;
//           handleBannerImage(advertisementList);
//           debugPrint("Advertisement_Response ${advertisementList.length}");
//         });
//       }
//     });
//   }
//
//   handleBannerImage(List<AdvertisementList> advertisementList) {
//     debugPrint("adsShowIndex $adsShowIndex ${allAdvertisementList.length}");
//     debugPrint("${allAdvertisementList.length % adsShowIndex! == 0}");
//
//     // advertisementList
//
//     /*  timer = Timer.periodic(const Duration(seconds: 2), (_) {
//       debugPrint("currentBannerIndex ->  $currentBannerIndex advertisementList.length -> ${advertisementList.length}");
//       if (currentBannerIndex < advertisementList.length) {
//         debugPrint("Under  ifff");
//         currentBannerIndex++;
//         if (mounted) setState(() {});
//       } else {
//         timer!.cancel();
//         currentBannerIndex--;
//       }
//       */ /**/ /*
//     });*/
//   }
//
//   Future advertisementClick(int adsId, {String? title}) async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var map = <String, dynamic>{};
//       map['advertisement_id'] = adsId;
//       CommonDialog.showLoading();
//       AdsClickModel model = await CallService().clickAdvertisement(map);
//       CommonDialog.hideLoading();
//       if (model.status != null) {
//         if (model.status == true) {
//           if (model.url != null) {
//             debugPrint("advertisement ads url ${model.url}");
//             Get.to(AppWebViewScreen(
//               url: model.url,
//               title: title ?? "",
//             ));
//             // if (!await launchUrl(Uri.parse(model.url!))) {
//             //   throw 'Could not launch ${model.url}';
//             // }
//           }
//         }
//       }
//     });
//   }
//
//   void bottomSheet(Chats message) {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
//         margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
//         height: Get.height * 0.3,
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
//               width: Get.width,
//               height: Get.height * 0.2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     height: Get.height * 0.020,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                       setState(() {
//                         showReply = true;
//                         replyMessage = message;
//                       });
//                     },
//                     child: Text(
//                       "Reply".tr,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                     ),
//                   ),
//                   const Divider(
//                     color: AppColors.dividerColor,
//                   ),
//                   Text(
//                     "Report",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.red),
//                   ),
//                   SizedBox(
//                     height: Get.height * 0.020,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("under chat_message_screen ${messages.length} ${advertisementList.length}");
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//           body: Column(
//         children: [_appBar(context), _messagesListWidget(context), _bottomWidget(context)],
//       )),
//     );
//   }
//
//   _appBar(context) {
//     return Padding(
//       padding: EdgeInsets.only(top: Get.width * 0.14, left: Get.width * 0.060, right: Get.width * 0.060, bottom: Get.height * 0.020),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               InkWell(
//                   onTap: () async {
//                     var map = <String, dynamic>{};
//                     map['other_user_id'] = widget.receiverId;
//                     ConnectionRemoveModel connectionRemove = await CallService().readOtherUserMessage(map, () async {
//                       socket!.emit('getNotification', {
//                         'my_id': userId,
//                       });
//                     });
//                     if (connectionRemove.status! == true) {
//                       Navigator.pop(context);
//                     } else {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: SvgPicture.asset(
//                     "${StringConstants.svgPath}backIcon.svg",
//                     height: Get.height * 0.035,
//                   )),
//               InkWell(
//                 onTap: () {
//                   //Get.to(SettingPage(widget.receiverId!.toString()), arguments:"true");
//
//                   Navigator.of(
//                     context,
//                   )
//                       .push(
//                     MaterialPageRoute(
//                         builder: (context) => SettingPage(
//                               widget.receiverId!.toString(),
//                               isFromDashboard: false,
//                             )),
//                   )
//                       .then((value) {
//                     appStreamController.handleBottomTab.add(false);
//                   });
//                   /*Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   SettingPage(widget.receiverId!.toString(),)),
//                         );*/
//                   /*Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   SettingPage(widget.receiverId.toString())),
//                         );*/
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(left: Get.width * 0.025),
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xFF74EE15),
//                                 Color(0xFF4DEEEA),
//                                 Color(0xFF4DEEEA),
//                                 Color(0xFFFFE700),
//                                 Color(0xFFFFE700),
//                                 Color(0xFFFFAE1D),
//                                 Color(0xFFFE9D00),
//                                 Color(0xFFEB7535),
//                               ],
//                               begin: FractionalOffset.topCenter,
//                               end: FractionalOffset.bottomCenter,
//                             ),
//                             shape: BoxShape.circle),
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Container(
//                             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//                             child: CircleAvatar(
//                               radius: 18,
//                               backgroundColor: Colors.white,
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 radius: 18,
//                                 backgroundImage: receiverImage!.isNotEmpty
//                                     ? NetworkImage(receiverImage.toString())
//                                     : Image.asset(
//                                         'assets/images/png/dummypic.png',
//                                       ).image,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: Get.width * 0.015,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 receiverName.toString(),
//                                 style: TextStyle(fontSize: Get.height * 0.020, fontWeight: FontWeight.w600, color: AppColors.gagagoLogoColor, fontFamily: StringConstants.poppinsRegular),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 widget.commonInterest.toString(),
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                     fontSize: Get.height * 0.016,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.chatTextColor,
//                                     fontFamily: StringConstants.poppinsRegular),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           IconButton(
//             onPressed: () {
//               Get.bottomSheet(
//                 Container(
//                   decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
//                   margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.010),
//                   height: Get.height * 0.3,
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
//                         width: Get.width,
//                         height: Get.height * 0.2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               height: Get.height * 0.020,
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 debugPrint("My User Id $userId");
//                                 var map = <String, dynamic>{};
//                                 map['removed_to'] = widget.receiverId;
//                                 //map['removed_by'] = userId;
//                                 ConnectionRemoveModel connectionRemove = await CallService().removeConnectionChat(map);
//                                 if (connectionRemove.status! == true) {
//                                   Get.back();
//                                   Navigator.pop(context, {'removeConnection': true});
//                                 } else {
//                                   CommonDialog.showToastMessage(connectionRemove.message.toString());
//                                 }
//                               },
//                               child: Text(
//                                 "Remove".tr,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                               ),
//                             ),
//                             const Divider(
//                               color: AppColors.dividerColor,
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 Get.back();
//                                 _displayTextInputDialog(context, (reasonText) async {
//                                   Get.back();
//                                   var map = <String, dynamic>{};
//                                   //map['blocked_by'] = userId;
//                                   map['blocked_to'] = widget.receiverId;
//                                   map['reason_and_comment_report'] = reasonText;
//                                   BlockUserModel userBlock = await CallService().blockUser(map);
//                                   if (userBlock.success! == true) {
//                                     Get.back();
//                                     Navigator.pop(context);
//                                     Navigator.pop(context);
//                                   } else {
//                                     CommonDialog.showToastMessage(userBlock.message.toString());
//                                   }
//                                 });
//                               },
//                               child: Text(
//                                 "Block & Report".tr,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.red),
//                               ),
//                             ),
//                             SizedBox(
//                               height: Get.height * 0.020,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Colors.transparent,
//                         width: Get.width,
//                         height: Get.height * 0.016,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)), color: Colors.white),
//                           width: Get.width,
//                           height: Get.height * 0.070,
//                           child: Center(
//                               child: Text(
//                             "Cancel".tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                           )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             icon: Icon(
//               Icons.more_vert,
//               size: Get.height * 0.040,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   _messagesListWidget(context) {
//     return Expanded(
//         child: Container(
//             margin: EdgeInsets.only(right: Get.width * 0.03, left: Get.width * 0.03, bottom: Get.height * 0.02),
//             child: MediaQuery.removePadding(
//                 context: context,
//                 removeBottom: true,
//                 child: Stack(
//                   children: [
//                     ListView.builder(
//                       reverse: true,
//                       controller: scrollController,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           children: [
//                             if (messages[index].ads != null)
//                               //   if (messages.length < adsShowIndex! && index == messages.length - 1 && advertisementList.isNotEmpty)
//                               //_bannerAds(index), // old
//                               _bannerAds(messages[index].ads!),
//                             getChatListItemWidget(context, index),
//                           ],
//                         );
//                       },
//
//                       // separatorBuilder: (context, index) {
//                       //   if (adsShowIndex == null) {
//                       //     return const SizedBox();
//                       //   }
//                       //   if (advertisementList.isNotEmpty) {
//                       //     if (index < messages.length) {
//                       //       if ((index + 1) % adsShowIndex! == 0) {
//                       //         int rawIndex = ((index + 1) ~/ adsShowIndex! - 1);
//                       //         if (rawIndex >= advertisementList.length) {
//                       //           debugPrint("1 advertisementList---???  ${advertisementList.length}");
//                       //           advertisementList = [
//                       //             ...advertisementList,
//                       //             ...advertisementList,
//                       //           ];
//                       //           // advertisementList.addAll(advertisementList);
//                       //           debugPrint("2. advertisementList---???  ${advertisementList.length}");
//                       //         }
//                       //         if (rawIndex < advertisementList.length) {
//                       //           debugPrint(
//                       //               "if advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex bannerIndex $bannerIndex modulos ${(index + 1) % 10}");
//                       //           bannerIndex = rawIndex;
//                       //           return _bannerAds(rawIndex);
//                       //         } else {
//                       //           int val1 = randomBannerIndex.nextInt(advertisementList.length);
//                       //           debugPrint(
//                       //               " else advertisementList --> ${advertisementList.length} index $index rawIndex $rawIndex bannerIndex $bannerIndex val1 $val1");
//                       //           return _bannerAds(val1 == advertisementList.length ? val1 - 1 : val1);
//                       //         }
//                       //       }
//                       //     }
//                       //   }
//                       //   return const SizedBox();
//                       // },
//                       itemCount: messages.length,
//                     ),
//                     if (messages.isEmpty && advertisementList.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           _bannerAds(advertisementList.first),
//                         ],
//                       ),
//                     if (isPagination)
//                       Positioned(
//                           top: 0,
//                           right: 0,
//                           left: 0,
//                           child: Container(
//                             width: double.infinity,
//                             height: 40,
//                             alignment: Alignment.center,
//                             color: Colors.white,
//                             child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
//                           ))
//                   ],
//                 )
//
//                 /*ListView.builder(
//                 controller: scrollController,
//                 itemBuilder: (context, index) {
//                   return getChatListItemWidget(context, index);
//                 },
//
//                 itemCount: messages.length,
//                 reverse: true,
//
//               ),
//             ),*/
//                 )));
//   }
//
//   _bottomWidget(context) {
//     print("sendDeleteRecording -> $sendDeleteRecording");
//     return Column(
//       children: [
//         if (showReply) showReplyBar(replyMessage!),
//         chatFlag
//             ? sendDeleteRecording
//                 ? getRecordingWidget(recordingPath)
//                 : _sendDataWidgets()
//             : Container(
//                 padding: EdgeInsets.all(Get.width * 0.05),
//                 child: Text(
//                   'You cannot send messages to this conversation.',
//                   style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.020),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//       ],
//     );
//   }
//
//   _sendDataWidgets() {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.only(
//         top: Get.width * 0.06,
//         left: Get.width * 0.04,
//         bottom: Get.width * 0.08,
//         right: Get.width * 0.03,
//       ),
//       child: Row(
//         children: [
//           InkWell(
//             onTap: () {
//               openImageOptions();
//             },
//             child: _recordState != RecordState.stop
//                 ? _buildTimer()
//                 : Image.asset(
//                     'assets/images/png/attachment.png',
//                     width: Get.width * 0.085,
//                     height: Get.width * 0.085,
//                   ),
//           ),
//           Expanded(
//               child: Container(
//             margin: const EdgeInsets.only(left: 10, right: 10),
//             padding: const EdgeInsets.only(left: 20, top: 8, right: 10, bottom: 8),
//             decoration: const BoxDecoration(
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               color: AppColors.chatInputTextBackgroundColor,
//             ),
//             child: _recordState != RecordState.stop
//                 ? Text(
//                     'Recording...',
//                     style: TextStyle(color: AppColors.chatBubbleTimeColor.withOpacity(0.7), fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//                   )
//                 : TextField(
//                     enableSuggestions: true,
//                     textCapitalization: TextCapitalization.sentences,
//                     autocorrect: true,
//                     //keyboardType: Platform.isAndroid?TextInputType.multiline:TextInputType.multiline,
//                     keyboardType: TextInputType.multiline,
//                     textInputAction: TextInputAction.newline,
//                     minLines: 1,
//                     maxLines: 5,
//                     focusNode: _focusNode,
//                     onChanged: (value) {
//                       /*if(value.isNotEmpty){
//                                      chatController.value = TextEditingValue(
//                                       text: capitalize(value),
//                                       selection: chatController.selection
//                                   );
//                                   }*/
//                       setState(() {});
//                     },
//                     style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//                     controller: chatController,
//                     decoration: InputDecoration.collapsed(
//                       hintText: 'Send Message...'.tr,
//                       border: InputBorder.none,
//                       hintStyle: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.016),
//                     )),
//           )),
//           InkWell(
//             onTap: () async {
//               print("_recordState --> ${_recordState.name}");
//               if (chatController.text.isEmpty) {
//                 //CommonDialog.showToastMessage('Please enter message');
//                 if (_recordState != RecordState.stop) {
//                   stopRecording();
//                 } else {
//                   startRecording();
//                 }
//               } else {
//                 var bytes = utf8.encode(chatController.text);
//                 var base64Str = base64.encode(bytes);
//                 if (showReply) {
//                   socket!.emit('sendMessage', {
//                     'sender_id': userId,
//                     'receiver_id': widget.receiverId,
//                     'message': base64Str,
//                     'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                     'avatar': '',
//                     'replied_to': replyMessage!.id,
//                     'message_type': '0',
//                     'is_me_blocked': widget.isMeBlocked == 'true'
//                   });
//                 } else {
//                   socket!.emit('sendMessage', {
//                     'sender_id': userId,
//                     'receiver_id': widget.receiverId,
//                     'message': base64Str,
//                     'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                     'avatar': '',
//                     'message_type': '0',
//                     'is_me_blocked': widget.isMeBlocked == 'true'
//                   });
//                 }
//                 debugPrint('sender_id:${userId}receiver_id:${widget.receiverId}');
//                 setState(() {
//                   addNewMessages(base64Str, userId, "0");
//                   // messages.insert(
//                   //     0,
//                   //     Chats(
//                   //         message: base64Str,
//                   //         messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
//                   //         senderId: int.parse(userId),
//                   //         messageType: '0',
//                   //         repliedTo: showReply ? replyMessage!.id : null,
//                   //         repliedToInfo: showReply
//                   //             ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message)
//                   //             : null));
//                 });
//                 chatController.clear();
//                 // scrollController!.jumpTo(scrollController!.position.minScrollExtent);
//               }
//             },
//             child: Container(
//               child: chatController.text.isEmpty /*&& !hasFocus*/
//                   ? _recordState != RecordState.stop
//                       ? Icon(
//                           Icons.mic_off,
//                           size: Get.width * 0.06,
//                         )
//                       : Image.asset(
//                           'assets/images/png/mic.png',
//                           width: Get.width * 0.06,
//                           height: Get.width * 0.06,
//                         )
//                   : Image.asset(
//                       'assets/images/png/send_icon.png',
//                       width: Get.width * 0.08,
//                       height: Get.width * 0.08,
//                     ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   ads() {
//     advertisementList = [
//       ...advertisementList,
//       ...advertisementList,
//     ];
//     // advertisementList= newList ;
//   }
//
//   _bannerAds(AdvertisementList adsData) {
//     return InkWell(
//       onTap: () async {
//         advertisementClick(adsData.id!, title: adsData.advTxt ?? "");
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(horizontal: 0, vertical: Get.height * 0.015),
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.only(bottom: 5.0),
//                         child: Text(
//                           adsData.advTxt ?? "",
//                           // advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advTxt ?? "",
//                           maxLines: 2,
//                           style: TextStyle(
//                               color: AppColors.defaultBlack,
//                               fontFamily: StringConstants.poppinsRegular,
//                               fontSize: Get.height * 0.017,
//                               overflow: TextOverflow.ellipsis,
//                               fontWeight: FontWeight.w600),
//                         )),
//                     Text(
//                       // "${advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advDescription ?? ""}",
//                       adsData.advDescription ?? "",
//                       maxLines: 1,
//                       style: TextStyle(color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.013, overflow: TextOverflow.ellipsis),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 15,
//               ),
//               Expanded(
//                 flex: 3,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(5.0),
//                   child: CachedNetworkImage(
//                     fit: BoxFit.cover,
//                     height: Get.height * 0.08,
//                     // width: Get.width,
//
//                     imageUrl: adsData.advImage!,
//                     // imageUrl: advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advImage!,
//                     progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
//                     errorWidget: (context, url, error) => Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           //Icon(Icons.error),
//                           Image.asset(
//                             'assets/images/png/galleryicon.png',
//                             fit: BoxFit.cover,
//                             height: Get.height * 0.06,
//                           ),
//                           //Text("Error! to Load Image"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   bannerAdsOld(int bannerIndexValue) {
//     return InkWell(
//       onTap: () async {
//         advertisementClick(advertisementList[bannerIndexValue].id!, title: advertisementList[bannerIndexValue].advTxt ?? "");
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(horizontal: 0, vertical: Get.height * 0.015),
//         child: Container(
//           // color: Colors.black,
//           // dashedLine: [2, 0],
//           // type: GFBorderType.rect,
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.only(bottom: 5.0),
//                         child: Text(
//                           advertisementList[bannerIndexValue].advTxt ?? "",
//                           // advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advTxt ?? "",
//                           maxLines: 2,
//                           style: TextStyle(
//                               color: AppColors.defaultBlack,
//                               fontFamily: StringConstants.poppinsRegular,
//                               fontSize: Get.height * 0.017,
//                               overflow: TextOverflow.ellipsis,
//                               fontWeight: FontWeight.w600),
//                         )),
//                     Text(
//                       // "${advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advDescription ?? ""}",
//                       advertisementList[bannerIndexValue].advDescription ?? "",
//                       maxLines: 1,
//                       style: TextStyle(color: AppColors.defaultBlack, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.013, overflow: TextOverflow.ellipsis),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 15,
//               ),
//               Expanded(
//                 flex: 3,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(5.0),
//                   child: CachedNetworkImage(
//                     fit: BoxFit.cover,
//                     height: Get.height * 0.08,
//                     // width: Get.width,
//
//                     imageUrl: advertisementList[bannerIndexValue].advImage!,
//                     // imageUrl: advertisementList[bannerIndex == advertisementList.length ? bannerIndex - 1 : bannerIndex].advImage!,
//                     progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
//                     errorWidget: (context, url, error) => Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           //Icon(Icons.error),
//                           Image.asset(
//                             'assets/images/png/galleryicon.png',
//                             fit: BoxFit.cover,
//                             height: Get.height * 0.06,
//                           ),
//                           //Text("Error! to Load Image"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _displayTextInputDialog(BuildContext context, Function(String) callbackPositive) async {
//     TextEditingController textFieldController = TextEditingController();
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: Text(
//               'Block & Report'.tr,
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: Get.height * 0.021, fontFamily: StringConstants.poppinsRegular),
//             ),
//             content: TextField(
//               controller: textFieldController,
//               minLines: 4,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: "Share your reason".tr,
//                 hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.height * 0.018, fontFamily: StringConstants.poppinsRegular),
//                 enabledBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Colors.grey),
//                 ),
//                 focusedBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Color(0xffF02E65)),
//                 ),
//                 errorBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 66, 125, 145)),
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: Get.height * 0.060,
//                           decoration: const BoxDecoration(color: AppColors.cancelButtonColor, borderRadius: BorderRadius.all(Radius.circular(10))),
//                           child: Text(
//                             'Cancel'.tr,
//                             style: TextStyle(fontSize: Get.height * 0.016, color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         onTap: () {
//                           Get.back();
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: InkWell(
//                       onTap: () async {
//                         if (textFieldController.text.trim().isEmpty) {
//                           CommonDialog.showToastMessage("Share your reason".tr);
//                         } else {
//                           callbackPositive(textFieldController.text.trim());
//                         }
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: Get.height * 0.060,
//                         decoration: const BoxDecoration(color: AppColors.buttonColor, borderRadius: BorderRadius.all(Radius.circular(10))),
//                         child: Text(
//                           'Submit'.tr,
//                           style: TextStyle(fontSize: Get.height * 0.016, color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ))
//                   ],
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   bool showReply = false;
//   Chats? replyMessage;
//
//   Widget getChatListItemWidget(BuildContext context, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Visibility(
//           visible: index < messages.length - 1 ? Jiffy(messages[index + 1].messageDate).yMMMd != Jiffy(messages[index].messageDate).yMMMd : true,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 messages[index].messageDate == null ? "" : CommonFunctions.dayDurationToString(messages[index].messageDate.toString(), context),
//                 textAlign: TextAlign.center,
//                 // Jiffy().yMMMd == Jiffy(messages[index].messageDate).yMMMd
//                 //     ? 'Today'.tr
//                 //     : Jiffy().subtract(days: 1).yMMMd == Jiffy(messages[index].messageDate).yMMMd
//                 //         ? 'Yesterday'
//                 //         : Jiffy(messages[index].messageDate).yMMMd,
//                 style: TextStyle(color: AppColors.chatBubbleTimeColor.withOpacity(0.7), fontFamily: StringConstants.poppinsRegular, fontSize: Get.width * 0.035),
//               ),
//               // if(messages[index].type == 1)
//               //   Container(child: Image.asset("assets/images/png/all-done.png"),margin: EdgeInsets.only(left: 3),)
//             ],
//           ),
//         ),
//         GestureDetector(
//           onLongPress: () {
//             messages[index].repliedTo != null ? null : bottomSheet(messages[index]);
//           },
//           child: Slidable(
//             endActionPane: messages[index].senderId.toString() == userId
//                 ? ActionPane(
//                     extentRatio: 0.18,
//                     closeThreshold: 0.25,
//                     openThreshold: 0.25,
//                     dragDismissible: true,
//                     motion: const ScrollMotion(),
//                     children: [
//                       Row(
//                         children: [
//                           messages[index].isRead == 1
//                               ? Image.asset(
//                                   "assets/images/png/all-done.png",
//                                   color: Colors.blue,
//                                   height: 20,
//                                   width: 20,
//                                 )
//                               : Image.asset(
//                                   "assets/images/png/all-done.png",
//                                   height: 20,
//                                   width: 20,
//                                 ),
//                           if (messages[index].isRead == 1)
//                             Text(
//                               Jiffy(messages[index].seenAt != null ? CommonFunctions.getHH_MM(messages[index].seenAt!) : messages[index].messageDate).Hm,
//                               style: const TextStyle(
//                                 color: AppColors.grayColorNormal,
//                                 fontFamily: StringConstants.poppinsRegular,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   )
//                 : null,
//             child: Column(
//               children: [
//                 ///replied messages
//                 if (messages[index].repliedTo != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: Get.height * 0.02),
//                         alignment: messages[index].senderId.toString() == userId ? Alignment.topRight : Alignment.topLeft,
//                         child: Text('Replied To Message', style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.018)),
//                       ),
//                       chatBubbleWidget(
//                           context,
//                           messages[index].senderId.toString() == userId ? true : false,
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               messages[index].repliedToInfo!.messageType == null
//                                   ? Text(
//                                       utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())),
//                                       maxLines: (messages[index].repliedTo != null) ? 2 : null,
//                                       overflow: (messages[index].repliedTo != null) ? TextOverflow.ellipsis : null,
//                                       style: TextStyle(
//                                           color: messages[index].senderId.toString() == userId ? Colors.white : Colors.black,
//                                           fontFamily: StringConstants.poppinsRegular,
//                                           fontSize: Get.width * 0.035),
//                                     )
//                                   : messages[index].repliedToInfo!.messageType == '0'
//                                       ? Text(
//                                           utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())),
//                                           maxLines: (messages[index].repliedTo != null) ? 2 : null,
//                                           overflow: (messages[index].repliedTo != null) ? TextOverflow.ellipsis : null,
//                                           style: TextStyle(
//                                               color: messages[index].senderId.toString() == userId ? Colors.white : Colors.black,
//                                               fontFamily: StringConstants.poppinsRegular,
//                                               fontSize: Get.width * 0.035),
//                                         )
//                                       : messages[index].repliedToInfo!.messageType == '1'
//                                           ? messages[index].repliedToInfo!.message.toString().startsWith('https://')
//                                               ? InkWell(
//                                                   onTap: () {
//                                                     if (messages[index].repliedToInfo!.message != null) {
//                                                       /* showDialog(
//                                           context: context, // <<----
//                                           barrierDismissible: true,
//                                           builder: (BuildContext context) {
//                                             return ImagePreviewDialog(imagePath: messages[index].repliedToInfo!.message.toString());
//                                           });*/
//                                                       Navigator.push(
//                                                           context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].repliedToInfo!.message.toString())));
//                                                     }
//                                                   },
//                                                   child: Image.network(
//                                                     messages[index].repliedToInfo!.message.toString(),
//                                                     width: 200,
//                                                     height: 200,
//                                                     fit: BoxFit.fitWidth,
//                                                   ))
//                                               : Image.file(File(messages[index].repliedToInfo!.message.toString()), width: 200, height: 200, fit: BoxFit.fitWidth)
//                                           : VoiceMessage(
//                                               key: ValueKey(messages[index].id),
//                                               // formatDuration: (d) {
//                                               //   return CommonFunctions.getMM_ss(d);
//                                               // },
//                                               meBgColor: Colors.blue,
//                                               contactBgColor: Colors.blue,
//                                               audioSrc: utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())),
//                                               played: false,
//                                               // To show played badge or not.
//                                               me: true,
//                                               // Set message side.
//                                               onPlay: () {
//                                                 print(
//                                                     "utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString())) ${utf8.decode(base64.decode(messages[index].repliedToInfo!.message.toString()))}");
//                                               }, // Do something when voice played.
//                                             )
//                             ],
//                           ))
//                     ],
//                   ),
//
//                 ///live messages
//                 /* messages[index].senderId.toString() == userId
//                     ? getSenderView(context, index)
//                     : getReceiverView(context, index),*/
//                 chatBubbleWidget(
//                   context,
//                   messages[index].senderId.toString() == userId ? true : false,
//                   messages[index].messageType == null || messages[index].messageType == '0'
//                       ? Text(
//                           utf8.decode(base64.decode(messages[index].message.toString())),
//                           // capitalize(utf8.decode(base64.decode(messages[index].message.toString()))),
//                           style: TextStyle(
//                               color: messages[index].senderId.toString() == userId ? Colors.black : Colors.white, fontFamily: StringConstants.poppinsRegular, fontSize: Get.width * 0.04),
//                         )
//                       : messages[index].messageType == '1'
//                           ? (messages[index].message.toString().contains("https")
//                               ? InkWell(
//                                   onTap: () {
//                                     if (messages[index].message != null) {
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                                     }
//                                   },
//                                   child: Image.network(
//                                     messages[index].message.toString(),
//                                     width: 200,
//                                     height: 200,
//                                     fit: BoxFit.fitWidth,
//                                   ),
//                                 )
//                               : InkWell(
//                                   onTap: () {
//                                     if (messages[index].message != null) {
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                                     }
//                                   },
//                                   child: Image.file(File(messages[index].message.toString()), width: 200, height: 200, fit: BoxFit.fitWidth)))
//                           : ChatAudioBubble(
//                               path: utf8.decode(base64.decode(messages[index].message.toString())),
//                             ),
//
//                   /*BubbleNormalAudio(
//                     color: Color(0xFFE8E8EE),
//                     duration: messages[index].duration == null ? 0.0 : messages[index].duration!.inSeconds.toDouble(),
//                     position: messages[index].position == null ? 0.0 : messages[index].position!.inSeconds.toDouble(),
//                     isPlaying: messages[index].isPlaying ?? false,
//                     isLoading: messages[index].isLoading ?? false,
//                     isPause: messages[index].isPause ?? false,
//                     onSeekChanged: (double value) {
//                       print("value --> $value");
//                       setState(() {
//                         if (messages[index].audioPlayer != null) {
//                           messages[index].audioPlayer!.seek(Duration(seconds: value.toInt()));
//                         }
//                       });
//                     },
//                     onPlayPauseButtonClick: () {
//                       _messagePlayAudio(index);
//                       // _currentPlayAudio(utf8.decode(base64.decode(messages[index].message.toString())));
//                     },
//                     sent: true,
//                   ),*/ /* VoiceMessage(
//                               key: ValueKey(messages[index].id),
//                               // formatDuration: (d) {
//                               //   return CommonFunctions.getMM_ss(d);
//                               // },
//                               meBgColor: Colors.blue,
//                               contactBgColor: Colors.blue,
//                               audioSrc: utf8.decode(base64.decode(messages[index].message.toString())),
//                               played: false,
//                               // To show played badge or not.
//                               me: true,
//                               // Set message side.
//                               onPlay: () {}, // Do something when voice played.
//                             ),*/
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   getSenderView(BuildContext context, int index) {
//     return ChatBubble(
// /*      padding: EdgeInsets.only(
//           top: Get.width * 0.015,
//           bottom: Get.width * 0.015,
//           right: Get.width * 0.04,
//           left: Get.width * 0.02),*/
//       clipper: ChatBubbleClipper2(
//         type: BubbleType.sendBubble,
//         radius: Get.width * 0.02,
//         nipWidth: Get.width * 0.02,
//         nipHeight: Get.width * 0.02,
//         nipRadius: 1,
//       ),
//       alignment: Alignment.topRight,
//       backGroundColor: AppColors.chatBubbleColor,
//       margin: EdgeInsets.all(Get.width * 0.01),
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.5,
//         ),
//         child: messages[index].messageType == null || messages[index].messageType == '0'
//             ? Text(
//                 utf8.decode(base64.decode(messages[index].message.toString())),
//                 // capitalize(utf8.decode(base64.decode(messages[index].message.toString()))),
//                 style: TextStyle(color: Colors.black, fontFamily: StringConstants.poppinsRegular, fontSize: Get.width * 0.04),
//               )
//             : messages[index].messageType == '1'
//                 ? (messages[index].message.toString().contains("https")
//                     ? InkWell(
//                         onTap: () {
//                           if (messages[index].message != null) {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                           }
//                         },
//                         child: Image.network(
//                           messages[index].message.toString(),
//                           width: 200,
//                           height: 200,
//                           fit: BoxFit.fitWidth,
//                         ),
//                       )
//                     : InkWell(
//                         onTap: () {
//                           if (messages[index].message != null) {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                           }
//                         },
//                         child: Image.file(File(messages[index].message.toString()), width: 200, height: 200, fit: BoxFit.fitWidth)))
//                 : VoiceMessage(
//                     key: ValueKey(messages[index].id),
//                     // formatDuration: (d) {
//                     //   return CommonFunctions.getMM_ss(d);
//                     // },
//                     meBgColor: Colors.blue,
//                     contactBgColor: Colors.blue,
//                     audioSrc: utf8.decode(base64.decode(messages[index].message.toString())),
//                     played: false,
//                     // To show played badge or not.
//                     me: true,
//                     // Set message side.
//                     onPlay: () {}, // Do something when voice played.
//                   ),
//       ),
//     );
//   }
//
//   getReceiverView(BuildContext context, int index) {
//     return ChatBubble(
//       /*   padding: EdgeInsets.only(
//           top: Get.width * 0.015,
//           bottom: Get.width * 0.015,
//           right: Get.width * 0.02,
//           left: Get.width * 0.04),*/
//       clipper: ChatBubbleClipper2(
//         type: BubbleType.receiverBubble,
//         radius: Get.width * 0.02,
//         nipWidth: Get.width * 0.02,
//         nipHeight: Get.width * 0.02,
//         nipRadius: 1,
//       ),
//       // alignment: Alignment.topLeft,
//       backGroundColor: AppColors.blueColor,
//       margin: EdgeInsets.all(Get.width * 0.01),
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.5,
//         ),
//         child: messages[index].messageType == null || messages[index].messageType == '0'
//             ? Text(
//                 utf8.decode(base64.decode(messages[index].message.toString())),
//                 style: TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontSize: Get.width * 0.04),
//               )
//             : messages[index].messageType == '1'
//                 ? (messages[index].message.toString().contains("https")
//                     ? InkWell(
//                         onTap: () {
//                           if (messages[index].message != null) {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                           }
//                         },
//                         child: Image.network(
//                           messages[index].message.toString(),
//                           width: 200,
//                           height: 200,
//                           fit: BoxFit.fitWidth,
//                         ),
//                       )
//                     : InkWell(
//                         onTap: () {
//                           if (messages[index].message != null) {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFullImage(imagePath: messages[index].message.toString())));
//                           }
//                         },
//                         child: Image.file(File(messages[index].message.toString()), width: 200, height: 200, fit: BoxFit.fitWidth)))
//                 : VoiceMessage(
//                     key: ValueKey(messages[index].id),
//
//                     // formatDuration: (d) {
//                     //   return CommonFunctions.getMM_ss(d);
//                     // },
//                     meBgColor: Colors.blue,
//                     contactBgColor: Colors.blue,
//                     audioSrc: utf8.decode(base64.decode(messages[index].message.toString())),
//                     played: false,
//                     // To show played badge or not.
//                     me: true,
//                     // Set message side.
//                     onPlay: () {}, // Do something when voice played.
//                   ),
//       ),
//     );
//   }
//
//   chatBubbleWidget(BuildContext context, bool isMine, Widget widget) {
//     return Row(mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
//       IntrinsicWidth(
//           child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.65,
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         decoration: BoxDecoration(
//           color: isMine ? Colors.white : AppColors.blueColor,
//           boxShadow: [
//             BoxShadow(
//               offset: const Offset(0, 0),
//               blurRadius: 0.5,
//               spreadRadius: 0.5,
//               color: Colors.grey.withOpacity(0.4),
//             ),
//           ],
//           borderRadius: BorderRadius.only(
//             topLeft: isMine ? Radius.circular(10) : Radius.circular(10),
//             bottomLeft: isMine ? Radius.circular(10) : Radius.circular(0),
//             bottomRight: isMine ? Radius.circular(0) : Radius.circular(10),
//             topRight: isMine ? Radius.circular(10) : Radius.circular(10),
//           ),
//         ),
//         child: widget,
//       )),
//     ]);
//   }
//
//   void openImageOptions() {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
//         margin: EdgeInsets.only(right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.020),
//         height: Get.height * 0.4,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
//               width: Get.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       Get.back();
//                       List<Media>? res = await ImagesPicker.openCamera(
//                         pickType: PickType.image,
//                       );
//                       if (res!.isNotEmpty) {
//                         final bytes = File(res[0].path).readAsBytesSync();
//                         if (showReply) {
//                           socket!.emit('sendMessage', {
//                             'sender_id': userId,
//                             'receiver_id': widget.receiverId,
//                             'message': "data:image/png;base64,${base64Encode(bytes)}",
//                             'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                             'avatar': '',
//                             'message_type': '1',
//                             'replied_to': replyMessage!.id,
//                             'is_me_blocked': widget.isMeBlocked == 'true'
//                           });
//                         } else {
//                           socket!.emit('sendMessage', {
//                             'sender_id': userId,
//                             'receiver_id': widget.receiverId,
//                             'message': "data:image/png;base64,${base64Encode(bytes)}",
//                             'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                             'avatar': '',
//                             'message_type': '1',
//                             'is_me_blocked': widget.isMeBlocked == 'true'
//                           });
//                         }
//                         setState(() {
//                           messages.insert(
//                               0,
//                               Chats(
//                                   message: res[0].path,
//                                   messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                                   senderId: int.parse(userId),
//                                   messageType: '1',
//                                   repliedTo: showReply ? replyMessage!.id : null,
//                                   repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null));
//                           res.clear();
//                           showReply = false;
//                           replyMessage = null;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Camera".tr,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   const Divider(
//                     color: AppColors.dividerColor,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       Get.back();
//                       List<Media>? res = await ImagesPicker.pick(
//                         pickType: PickType.image,
//                       );
//                       if (res!.isNotEmpty) {
//                         final bytes = File(res[0].path).readAsBytesSync();
//                         if (showReply) {
//                           socket!.emit('sendMessage', {
//                             'sender_id': userId,
//                             'receiver_id': widget.receiverId,
//                             'message': "data:image/png;base64,${base64Encode(bytes)}",
//                             'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                             'avatar': '',
//                             'message_type': '1',
//                             'replied_to': replyMessage!.id,
//                             'is_me_blocked': widget.isMeBlocked == 'true'
//                           });
//                         } else {
//                           socket!.emit('sendMessage', {
//                             'sender_id': userId,
//                             'receiver_id': widget.receiverId,
//                             'message': "data:image/png;base64,${base64Encode(bytes)}",
//                             'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                             'avatar': '',
//                             'message_type': '1',
//                             'is_me_blocked': widget.isMeBlocked == 'true'
//                           });
//                         }
//                         setState(() {
//                           messages.insert(
//                               0,
//                               Chats(
//                                   message: res[0].path,
//                                   messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                                   senderId: userId.isNotEmpty ? int.parse(userId) : null,
//                                   messageType: '1',
//                                   repliedTo: showReply ? replyMessage!.id : null,
//                                   repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null));
//                           res.clear();
//                           showReply = false;
//                           replyMessage = null;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Gallery".tr,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.transparent,
//               width: Get.width,
//               height: Get.height * 0.016,
//             ),
//             InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)), color: Colors.white),
//                 width: Get.width,
//                 height: Get.height * 0.070,
//                 child: Center(
//                     child: Text(
//                   "Cancel".tr,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontFamily: StringConstants.poppinsRegular, fontWeight: FontWeight.w600, fontSize: Get.height * 0.018, color: Colors.black),
//                 )),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   final record = Record();
//
//   Future<String> createFolder(String name) async {
//     final dir = Directory('${(Platform.isAndroid ? await getTemporaryDirectory() // getExternalStorageDirectory() //FOR ANDROID
//             : await getTemporaryDirectory() //getApplicationDocumentsDirectory()  //  getApplicationSupportDirectory() //FOR IOS
//         ).path}/$name');
//
//     // dir.deleteSync(recursive: true);
//
//     // var status = await Permission.storage.status;
//     // if (!status.isGranted) {
//     //   await Permission.storage.request();
//     // }
//     if ((await dir.exists())) {
//       return dir.path;
//     } else {
//       dir.create();
//       return dir.path;
//     }
//   }
//
//   startRecording() async {
//     if (await record.hasPermission()) {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       String path = await createFolder("gagago");
//       // recordingPath = "$path/$fileName.m4a";
//       debugPrint("path --> startRecording $path/$fileName.m4a");
//       await record.start(
//         path: "$path/$fileName.m4a",
//         encoder: AudioEncoder.aacLc,
//         bitRate: 128000,
//         samplingRate: 44100,
//       );
//     }
//     _recordDuration = 0;
//     _startTimer();
//   }
//
//   stopRecording() async {
//     _timer?.cancel();
//     _recordDuration = 0;
//     String? path = await record.stop();
//     if (Platform.isIOS) {
//       final form = FormData({});
//       form.files.add(MapEntry(
//         'audio',
//         MultipartFile(path, filename: basename(path!)),
//       ));
//       debugPrint("audio form$form");
//       UploadAudio registerModel = await CallService().uploadFile(form);
//
//       setState(() {
//         sendDeleteRecording = true;
//         recordingPath = registerModel.fileLink ?? "";
//         debugPrint("path --> stopRecording -> $recordingPath");
//       });
//     } else {
//       setState(() {
//         sendDeleteRecording = true;
//         recordingPath = path!;
//         debugPrint("path --> stopRecording -> $recordingPath");
//       });
//     }
//   }
//
//   bool sendDeleteRecording = false;
//   String recordingPath = "";
//
//   Widget getRecordingWidget(String path) {
//     debugPrint("getRecordingWidget path $path");
//     return Container(
//       padding: const EdgeInsets.all(10),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               setState(() {
//                 sendDeleteRecording = false;
//                 recordingPath = "";
//               });
//             },
//           ),
//
//           Expanded(
//             child: BubbleNormalAudio(
//               color: Color(0xFFE8E8EE),
//               duration: currentDuration.inSeconds.toDouble(),
//               position: currentPosition.inSeconds.toDouble(),
//               isPlaying: isCurrentPlaying,
//               isLoading: isCurrentLoading,
//               isPause: isCurrentPause,
//               onSeekChanged: (double value) {
//                 setState(() {
//                   currentAudioPlayer.seek(Duration(seconds: value.toInt()));
//                 });
//               },
//               onPlayPauseButtonClick: () {
//                 _currentPlayAudio(recordingPath);
//               },
//               sent: true,
//             ),
//           ),
//
//           // VoiceMessage(
//           //   key: ValueKey(path),
//           //   // formatDuration: (d) {
//           //   //   return CommonFunctions.getMM_ss(d);
//           //   // },
//           //   meBgColor: Colors.blue,
//           //   contactBgColor: Colors.blue,
//           //   audioSrc: path,
//           //   played: false,
//           //   me: true,
//           //
//           //   onPlay: () {
//           //     debugPrint("path $path");
//           //   }, // Do something when voice played.
//           // ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: () async {
//               setState(() {
//                 sendDeleteRecording = false;
//                 recordingPath = "";
//               });
//               var base64Str;
//               int? mySenderId;
//               if (Platform.isIOS) {
//                 var bytes = utf8.encode(path);
//                 base64Str = base64.encode(bytes);
//                 if (showReply) {
//                   socket!.emit('sendMessage', {
//                     'sender_id': userId,
//                     'receiver_id': widget.receiverId,
//                     'message': base64Str,
//                     'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                     'avatar': '',
//                     'message_type': '3',
//                     'replied_to': replyMessage!.id,
//                     'is_me_blocked': widget.isMeBlocked == 'true'
//                   });
//                 } else {
//                   socket!.emit('sendMessage', {
//                     'sender_id': userId,
//                     'receiver_id': widget.receiverId,
//                     'message': base64Str,
//                     'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                     'avatar': '',
//                     'message_type': '3',
//                     'is_me_blocked': widget.isMeBlocked == 'true'
//                   });
//                 }
//               } else {
//                 final form = FormData({});
//                 form.files.add(MapEntry(
//                   'audio',
//                   MultipartFile(path, filename: basename(path)),
//                 ));
//                 UploadAudio registerModel = await CallService().uploadFile(form);
//                 if (registerModel.status!) {
//                   mySenderId = registerModel.senderId;
//                   debugPrint("mySenderId  +==== $mySenderId   ++++++++ $userId");
//                   var bytes = utf8.encode(registerModel.fileLink.toString());
//                   base64Str = base64.encode(bytes);
//                   if (showReply) {
//                     socket!.emit('sendMessage', {
//                       'sender_id': userId,
//                       'receiver_id': widget.receiverId,
//                       'message': base64Str,
//                       'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                       'avatar': '',
//                       'message_type': '3',
//                       'replied_to': replyMessage!.id,
//                       'is_me_blocked': widget.isMeBlocked == 'true'
//                     });
//                   } else {
//                     socket!.emit('sendMessage', {
//                       'sender_id': userId,
//                       'receiver_id': widget.receiverId,
//                       'message': base64Str,
//                       'chat_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                       'avatar': '',
//                       'message_type': '3',
//                       'is_me_blocked': widget.isMeBlocked == 'true'
//                     });
//                   }
//                 }
//               }
//               setState(() {
//                 // dynamic rawMessages = [];
//                 // rawMessages.addAll(messages);
//                 // messages.clear();
//
//                 messages.insert(
//                     0,
//                     Chats(
//                         message: base64Str,
//                         messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                         senderId: int.parse(userId),
//                         messageType: '3',
//                         repliedTo: showReply ? replyMessage!.id : null,
//                         repliedToInfo: showReply ? RepliedToInfo(messageType: replyMessage!.messageType, message: replyMessage!.message) : null));
//
//                 // messages.addAll(rawMessages);
//                 // print("messages --> ${messages.length} rawMessages ${rawMessages.length}");
//                 showReply = false;
//                 replyMessage = null;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _currentPlayAudio(String url) async {
//     // final url =
//     //     'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
//     if (isCurrentPause) {
//       await currentAudioPlayer.resume();
//       setState(() {
//         isCurrentPlaying = true;
//         isCurrentPause = false;
//       });
//     } else if (isCurrentPlaying) {
//       await currentAudioPlayer.pause();
//       setState(() {
//         isCurrentPlaying = false;
//         isCurrentPause = true;
//       });
//     } else {
//       setState(() {
//         isCurrentLoading = true;
//       });
//
//       await currentAudioPlayer.play(
//         UrlSource(url),
//       );
//       setState(() {
//         isCurrentPlaying = true;
//       });
//     }
//
//     currentAudioPlayer.onDurationChanged.listen((Duration d) {
//       setState(() {
//         currentDuration = d;
//         isCurrentLoading = false;
//       });
//     });
//
//     currentAudioPlayer.onPositionChanged.listen((event) {
//       setState(() {
//         currentPosition = event;
//       });
//     });
//
//     currentAudioPlayer.onPlayerComplete.listen((event) {
//       setState(() {
//         isCurrentPlaying = false;
//         currentDuration = new Duration();
//         currentPosition = new Duration();
//       });
//     });
//   }
//
//   void _messagePlayAudio(
//     int index,
//   ) async {
//     for (var element in messages) {
//       element.isPlaying = false;
//       element.isLoading = false;
//       element.isPause = false;
//       element.isPause = false;
//     }
//
//     // final url =
//     //     'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
//     if (messages[index].isPause ?? false) {
//       print("Harry under ifPaused");
//       await messages[index].audioPlayer!.resume();
//       setState(() {
//         messages[index].isPlaying = true;
//         messages[index].isPause = false;
//       });
//     } else if (messages[index].isPlaying ?? false) {
//       print("Harry under isPlaying");
//
//       await messages[index].audioPlayer!.pause();
//       setState(() {
//         messages[index].isPlaying = false;
//         messages[index].isPause = true;
//       });
//     } else {
//       print("Harry under else");
//
//       setState(() {
//         messages[index].isLoading = true;
//       });
//
//       await currentAudioPlayer.play(
//         UrlSource(utf8.decode(base64.decode(messages[index].message.toString()))),
//       );
//       setState(() {
//         messages[index].isPlaying = true;
//       });
//     }
//
//     messages[index].audioPlayer!.onDurationChanged.listen((Duration d) {
//       print("Harry under  onDurationChanged $d");
//       setState(() {
//         messages[index].duration = d;
//         messages[index].isLoading = false;
//       });
//     });
//
//     messages[index].audioPlayer!.onPositionChanged.listen((event) {
//       print("Harry under  onPositionChanged $event");
//
//       setState(() {
//         messages[index].position = event;
//       });
//     });
//
//     messages[index].audioPlayer!.onPlayerComplete.listen((event) {
//       print("Harry under  onPlayerComplete");
//
//       setState(() {
//         messages[index].isPlaying = false;
//         messages[index].duration = new Duration();
//         messages[index].position = new Duration();
//       });
//     });
//   }
//
//   Timer? _timer;
//   int _recordDuration = 0;
//   RecordState _recordState = RecordState.stop;
//   StreamSubscription<RecordState>? _recordSub;
//
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() => _recordDuration++);
//     });
//   }
//
//   Widget _buildTimer() {
//     final String minutes = CommonFunctions.formatChatTimerNumber(_recordDuration ~/ 60);
//     final String seconds = CommonFunctions.formatChatTimerNumber(_recordDuration % 60);
//
//     return Text(
//       '$minutes : $seconds',
//       style: const TextStyle(
//         color: Colors.red,
//         fontFamily: StringConstants.poppinsRegular,
//       ),
//     );
//   }
//
//   Widget showReplyBar(Chats chat) {
//     return Container(
//       width: Get.width,
//       color: Colors.blue,
//       padding: EdgeInsets.all(Get.width * 0.01),
//       child: Container(
//         margin: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Container(
//                 child: chat.messageType == '0'
//                     ? Text(utf8.decode(base64.decode(chat.message.toString())),
//                         maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: StringConstants.poppinsRegular, fontSize: Get.height * 0.018))
//                     : chat.messageType == '1'
//                         ? Row(
//                             children: [
//                               const Icon(
//                                 Icons.photo,
//                                 color: Colors.white,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: Get.width * 0.008),
//                                 child: Text(
//                                   'Photo'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                     fontSize: Get.height * 0.018,
//                                     fontFamily: StringConstants.poppinsRegular,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               const Icon(
//                                 Icons.mic,
//                                 color: Colors.white,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: Get.width * 0.008),
//                                 child: Text(
//                                   'Voice Message'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                     fontSize: Get.height * 0.018,
//                                     fontFamily: StringConstants.poppinsRegular,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     showReply = false;
//                     replyMessage = null;
//                   });
//                 },
//                 icon: const Icon(
//                   Icons.cancel_outlined,
//                   color: Colors.white,
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   // int count = 0;
// // CommonFunctions.getFilePath();
//
//   showBlockedChatAlertDialog(BuildContext context, String? msg) {
//     if (!mounted) {
//       return;
//     }
//
//     if (showingAlertDialog) {
//       return;
//     }
//     showingAlertDialog = true;
//     FocusScope.of(context).requestFocus(FocusNode());
//
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Close".tr,
//         style: const TextStyle(
//           fontFamily: StringConstants.poppinsRegular,
//         ),
//       ),
//       onPressed: () {
//         showingAlertDialog = false;
//
//         Get.back();
//       },
//     );
//
//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Alert".tr,
//         style: const TextStyle(
//           color: Colors.red,
//           fontFamily: StringConstants.poppinsRegular,
//         ),
//       ),
//       content: Text(
//         msg ?? "Connection has been removed. You cannot continue chat now.".tr,
//         style: const TextStyle(
//           fontFamily: StringConstants.poppinsRegular,
//         ),
//       ),
//       actions: [
//         cancelButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
//
// class NoisePainter extends CustomPainter {
//   final int seed;
//
//   NoisePainter({required this.seed});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final random = Random(seed);
//     final paint = Paint()..color = Colors.black;
//     final path = Path();
//
//     for (double i = 0; i < size.width; i += 2) {
//       final x = i + random.nextDouble() * 2;
//       final y = random.nextDouble() * size.height;
//       path.moveTo(x, y);
//       path.lineTo(x + 1, y);
//     }
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(NoisePainter oldDelegate) => true;
// }
