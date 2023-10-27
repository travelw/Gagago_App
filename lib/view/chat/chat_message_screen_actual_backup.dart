



// ssss
//
//
//
//
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:gagagonew/controller/review_controller.dart';
// import 'package:gagagonew/utils/stream_controller.dart';
// import 'package:get/get.dart';
// import 'package:record/record.dart';
//
// import '../../../constants/string_constants.dart';
// import '../../../model/advertisement_response_model.dart';
// import '../../../model/chat_by_user_model.dart';
// import '../../../utils/common_functions.dart';
// import 'package:path/path.dart';
//
// import 'package:flutter_app_badger/flutter_app_badger.dart';
//
// import 'package:gagagonew/main.dart';
// import 'package:gagagonew/model/ads_click_model.dart';
//
// import 'package:gagagonew/utils/progress_bar.dart';
//
// import 'package:intl/intl.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart';
// import '../../../Service/call_service.dart';
//
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:path_provider/path_provider.dart';
// import '../../../model/upload_file.dart';
//
// import '../../app_web_view_screen.dart';
//
// class ChatController extends GetxController {
//   String? widgetReceiverId;
//   bool? widgetIsShown;
//   String? widgetConnectionType;
//   String? widgetCommonInterest;
//   String? widgetIsMeBlocked;
//   String? widgetImage;
//   String? widgetName;
//
//   BuildContext? context;
//
//
//   var chatController = TextEditingController().obs;
//   AppStreamController appStreamController = AppStreamController.instance;
//   var randomBannerIndex = Random();
//   final controller = Get.put(ReviewController());
//   ScrollController scrollController = ScrollController();
//
//   RxList<DateTime> startTimes = RxList();
//
//   var isScreenOpened = false.obs;
//   RxList<Chats> messages = RxList();
//   RxList<Chats> newMessages = RxList();
//   Socket? socket;
//   var userId = ''.obs;
//   var receiverName = ''.obs;
//   var receiverImage = ''.obs;
//   RxList<AdvertisementList> allAdvertisementList = RxList();
//   RxList<AdvertisementList> advertisementList = RxList();
//   // Rx<int>? adsShowIndex ;
//   var adsShowIndex = 0.obs;
//   var advertisementType = 2.obs;
//   Rx<bool>? isShown;
//   final focusNode = FocusNode();
//   var chatFlag = true.obs;
//   var showingAlertDialog = false.obs;
//   var isComplete = false.obs;
//   var pageFlag = false.obs;
//   var isPagination = false.obs;
//
//   var bannerIndex = 0.obs;
//   var pageStartPoint = 0.obs;
//   var addIncAdd = 0.obs;
//   var duration = const Duration().obs;
//   // Rx< Timer>? timer;
//   var currentBannerIndex = 0.obs;
//   var startPoint = 0.obs;
//
//   var checkPagination = 0.obs;
//   Record record = Record();
//
//   var sendDeleteRecording = false.obs;
//   var recordingPath = "".obs;
//
//   Rx<Timer>? timer;
//   var recordDuration = 0.obs;
//   RecordState recordState = RecordState.stop;
//   StreamSubscription<RecordState>? _recordSub;
//
//   var showReply = false.obs;
//   Rx<Chats>? replyMessage;
//
//   void startTimer() {
//     if(timer != null) {
//       timer!.value.cancel();
//     }
//     timer?.value = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       //OBX used
//       // setState(() =>
//       recordDuration.value++;
//       // );
//     });
//   }
//
//   Widget buildTimer() {
//     final String minutes = CommonFunctions.formatChatTimerNumber(recordDuration.value ~/ 60);
//     final String seconds = CommonFunctions.formatChatTimerNumber(recordDuration.value % 60);
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
//   Future<String> createFolder(String name) async {
//     final dir = Directory('${(Platform.isAndroid ? await getTemporaryDirectory() // getExternalStorageDirectory() //FOR ANDROID
//         : await getTemporaryDirectory() //getApplicationDocumentsDirectory()  //  getApplicationSupportDirectory() //FOR IOS
//     ).path}/$name');
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
//     recordDuration.value = 0;
//     startTimer();
//   }
//
//   stopRecording() async {
//     timer!.value.cancel();
//     recordDuration.value = 0;
//     String? path = await record.stop();
//     if (Platform.isIOS) {
//       final form = FormData({});
//       form.files.add(MapEntry(
//         'audio',
//         MultipartFile(path, filename: basename(path!)),
//       ));
//       debugPrint("audio form$form");
//       UploadAudio registerModel = await CallService().uploadFile(form);
//       //OBX used
//
//       // setState(() {
//       sendDeleteRecording.value = true;
//       recordingPath.value = registerModel.fileLink ?? "";
//       debugPrint("path --> stopRecording -> $recordingPath");
//       // });
//     } else {
//       //OBX used
//       // setState(() {
//       sendDeleteRecording.value = true;
//       recordingPath.value = path!;
//       debugPrint("path --> stopRecording -> $recordingPath");
//       // });
//     }
//   }
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
//   initController() {
//     initData();
//     receiverName.value = widgetName!;
//     debugPrint("receiverName 222 $receiverName");
//     receiverImage.value = widgetImage!;
//     updateCurrentChatId(widgetReceiverId.toString(), false);
//     focusNode.addListener(() {
//       //OBX used
//       // setState(() {
//       hasFocus = focusNode.hasFocus;
//       // });
//     });
//     appStreamController.handleBottomTab.add(false);
//     _recordSub = record.onStateChanged().listen((recordState) {
//       //OBX used
//       // setState(() =>
//       recordState = recordState;
//       // );
//     });
//
//     getAdvertisementList();
//
//     // addInc=advertisementList.length;
//     //debugPrint("check addInc init$addInc");
//     addIncAdd.value = 0;
//     isScreenOpened.value = true;
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
//   loadNextPage() async {
//     debugPrint("under loadNextPage");
//     //OBX used
//     // setState(() {
//     isPagination.value = true;
//     // });
//     var map = <String, dynamic>{};
//
//     map['user_id'] = widgetReceiverId;
//     map['start_point'] = pageStartPoint;
//     debugPrint("map list show $map");
//     ChatByUserModel model = await CallService().getChatByUser(map);
//     // if (mounted) {
//     //OBX used
//
//     // setState(() {
//     isPagination.value = false;
//     pageFlag.value = model.data!.chatFlag!; // only for pagination purposes
//     pageStartPoint.value = model.data!.totalRecords!;
//     chatFlag.value = (model.data!.chats!.isNotEmpty ? model.data!.chats![0].chatFlag : true)!;
//     receiverName.value = '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
//     receiverImage.value = model.data!.user!.userProfile!.isNotEmpty ? model.data!.user!.userProfile![0].imageName.toString() : "";
//     debugPrint("receiverImage $receiverImage");
//     debugPrint("receiverName $receiverName");
//     debugPrint("pageStartPoint $pageStartPoint");
//
//     List<Chats> rawList = [];
//     rawList.addAll(model.data!.chats!.reversed);
//
//     if (advertisementList.isNotEmpty) {
//       bool adExist = false;
//       int lastAdIndex = 0;
//       int pendingMessages = messages.length - lastAdIndex;
//       for (int i = 0; i < messages.length; i++) {
//         if (messages[i].ads != null) {
//           adExist = true;
//           lastAdIndex = i;
//         }
//       }
//       debugPrint("adExist $adExist");
//
//       debugPrint("pendingMessages $pendingMessages lastAdIndex $lastAdIndex adsShowIndex $adsShowIndex message.length ${messages.length}");
//       for (int i = 0; i < rawList.length; i++) {
//         int modules = (i + pendingMessages) % adsShowIndex.value;
//         debugPrint("modules $modules");
//         if (modules == 0) {
//           debugPrint(" check pending count ${(i - 1)}");
//           if ((i - 1) >= 0) {
//             if (addIncAdd.value + 1 == advertisementList.length) {
//               addIncAdd.value = 0;
//             } else {
//               addIncAdd.value = addIncAdd.value + 1;
//             }
//             rawList[i - 1].ads = advertisementList[addIncAdd.value];
//           }
//         }
//       }
//     }
//
//     // OLD CODE
//     messages.addAll(rawList);
//     for (int i = 0; i < messages.length; i++) {
//       if (messages[i].messageType == '1') {
//         messages[i].message = messages[i].message!.contains("https") ? messages[i].message.toString() : 'https://api.gagagoapp.com/message_files/${messages[i].message}';
//       }
//     }
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
//     // messages.addAll(List.from(rawList));
//     //handleAds();
//     // });
//     // }
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
//       AdvertisementResponseModel model = await CallService().getAdvertisementList(advertisementType.value);
//       //OBX used
//
//       // if (mounted) {
//       //   setState(() {
//       debugPrint("Advertisement_Response $model");
//       allAdvertisementList.value = model.advertisementList!;
//       if (model.advertisementSetting != null) {
//         if (model.advertisementSetting!.inChatHowAnyMessagesAfterShowAdd != null) {
//           adsShowIndex.value = int.parse(model.advertisementSetting!.inChatHowAnyMessagesAfterShowAdd!);
//           debugPrint("adsShowIndex $adsShowIndex");
//         }
//       }
//
//       if (allAdvertisementList.isNotEmpty) {
//         for (var element in allAdvertisementList) {
//           if (element.advShowArea != 1) {
//             advertisementList.add(element);
//           }
//         }
//
//         handleAds();
//       }
//
//       // advertisementList.removeWhere((element) {
//       //   return element.advShowArea == 1;
//       // });
//
//       // advertisementList.reversed;
//       handleBannerImage(advertisementList);
//       debugPrint("Advertisement_Response ${advertisementList.length}");
//     });
//     // }
//     // });
//   }
//
//   handleBannerImage(List<AdvertisementList> advertisementList) {
//     debugPrint("adsShowIndex $adsShowIndex ${allAdvertisementList.length}");
//     debugPrint("${allAdvertisementList.length % adsShowIndex.value == 0}");
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
//   ads() {
//     advertisementList.value = [
//       ...advertisementList,
//       ...advertisementList,
//     ];
//     // advertisementList= newList ;
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
//   void initData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //OBX used
//     // setState(() {
//     userId.value = prefs.getString('userId') ?? "";
//     // });
//     getBadgesCount();
//     scrollController.addListener(() {
//       debugPrint("under addListener");
//       if (scrollController.position.maxScrollExtent == scrollController.position.pixels && pageFlag.value) {
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
//           'other_user_id': widgetReceiverId,
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
//           //OBX used
//           // setState(() {
//           if (data is List) {
//             for (var v in data) {
//               Chats newMessage = Chats.fromJson(v);
//               chatFlag.value = newMessage.chatFlag ?? true;
//
//               if (!chatFlag.value) {
//                 showBlockedChatAlertDialog( newMessage.message);
//               } else {
//                 if (newMessage.repliedTo != null) {
//                   //startPoint = 0;
//                   pageStartPoint.value = 0;
//                   hitApi();
//
//                   // Chats? replyMessage;
//                   //
//                   // for (int i = 0; i < messages.length; i++) {
//                   //   if (newMessage.repliedTo == messages[i].id) {
//                   //     messages[i] = newMessage;
//                   //     replyMessage = messages[i];
//                   //
//                   //   }
//                   // }
//                   // if (replyMessage != null) {
//                   //   messages.insert(0, newMessage);
//                   // }
//
//                 } else {
//                   int indexMessage = messages.indexWhere((element) => element.id == newMessage.id);
//                   if (indexMessage < 0) {
//                     messages.insert(0, newMessage);
//                   }
//                 }
//               }
//             }
//           } else {
//             Chats newMessage = Chats.fromJson(data);
//             chatFlag.value = newMessage.chatFlag ?? true;
//
//             if (newMessage.receiverId.toString() == userId.value && isScreenOpened.value) {
//               socket!.emit("markAllMessageRead", {
//                 'sender_id': widgetReceiverId,
//                 'receiver_id': userId.value,
//                 //'chat_head_id': messages.isEmpty ? '' : messages[0].chatHeadId.toString(),
//                 'chat_head_id': messages.isEmpty ? '' : newMessage.chatHeadId.toString(),
//               });
//               // addNewMessage(messages.toString(), userId!);
//             }
//
//             if (!chatFlag.value) {
//               showBlockedChatAlertDialog( newMessage.message);
//             } else {
//               print("${newMessage.receiverId.toString()} == $userId && ${widgetReceiverId.toString()} == ${newMessage.senderId.toString()}");
//               if (newMessage.receiverId.toString() == userId.value && widgetReceiverId.toString() == newMessage.senderId.toString()) {
//                 if (newMessage.repliedTo != null) {
//                   //startPoint = 0;
//                   pageStartPoint.value = 0;
//                   hitApi();
//
//                   // Chats? replyMessage;
//                   // for (int i = 0; i < messages.length; i++) {
//                   //   if (newMessage.repliedTo == messages[i].id) {
//                   //     // messages[i] = newMessage;
//                   //     replyMessage = messages[i];
//                   //     replyMessage
//                   //   }
//                   // }
//                   // if (replyMessage != null) {
//                   //
//                   //   messages.insert(0, newMessage);
//                   // }
//                 } else {
//                   if (newMessage.messageType == '1') {
//                     newMessage.message = 'https://api.gagagoapp.com/message_files/${newMessage.message}';
//                   }
//                   int indexMessage = messages.indexWhere((element) => element.id == newMessage.id);
//                   if (indexMessage < 0) {
//                     addNewMessages(newMessage.message.toString(), userId.value != newMessage.receiverId.toString() ? newMessage.receiverId.toString() : newMessage.senderId.toString(),
//                         newMessage.messageType!);
//                   }
//                 }
//               }
//             }
//           }
//         });
//       });
//       // });
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
//       //OBX used
//       // setState(() {});
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
//     //OBX used
//     // setState(() {});
//   }
//
//   hitApi() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var map = <String, dynamic>{};
//       map['user_id'] = widgetReceiverId;
//       map['start_point'] = pageStartPoint.value;
//       debugPrint("list of map show data $map");
//       ChatByUserModel model = await CallService().getChatByUser(map);
//
//       //OBX used
//       // setState(() {
//       pageFlag.value = model.data!.chatFlag!; // only for pagination purposes
//       pageStartPoint.value = model.data!.totalRecords!; // only for pagination purposes
//       chatFlag.value = (model.data!.chats!.isNotEmpty ? model.data!.chats![0].chatFlag : true)!;
//       receiverName.value = '${model.data!.user!.firstName} ${model.data!.user!.lastName}';
//       receiverImage.value = model.data!.user!.userProfile!.isNotEmpty ? model.data!.user!.userProfile![0].imageName.toString() : "";
//       debugPrint("receiverImage $receiverImage");
//       debugPrint("receiverName 1111 $receiverName");
//       debugPrint("pageStartPoint 1111 $pageStartPoint");
//
//       messages.value = model.data!.chats!;
//
//       int? chatId;
//       for (int i = 0; i < messages.length; i++) {
//         if (messages[i].messageType == '1') {
//           messages[i].message = 'https://api.gagagoapp.com/message_files/${messages[i].message}';
//         }
//         debugPrint("messages[i].chatHeadId -->> ${messages[i].chatHeadId}");
//         if (messages[i].chatHeadId != null) {
//           chatId = messages[i].chatHeadId;
//         }
//       }
//       if (messages.isNotEmpty) {
//         socket!.emit("markAllMessageRead", {
//           'sender_id': widgetReceiverId,
//           'receiver_id': userId.value,
//           'chat_head_id': chatId == null ? '' : chatId.toString(),
//         });
//         debugPrint("chat_head_id 2 ${chatId.toString()}");
//       }
//
//       messages.value = List.from(messages.reversed);
//
//       // addNewMessage(messages[i].message!,messages[i].id.toString(),messages[i].messageType!);
//       if (advertisementList.isNotEmpty) {
//         handleAds();
//       }
//     });
//
//     //etAdvertisementList();
//     // });
//   }
//
//   disposeCall() {
//     isScreenOpened.value = false;
//     debugPrint("under dispose  $isScreenOpened");
//
//     updateCurrentChatId("", true);
//     focusNode.dispose();
//     timer?.value.cancel();
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
//     //OBX used
//     // setState(() {
//     if (messages.length >= adsShowIndex.value) {
//       bool adExist = false;
//       for (int i = 0; i < adsShowIndex.value - 1; i++) {
//         if (messages[i].ads != null) {
//           adExist = true;
//         }
//       }
//
//       if (!adExist) {
//         if (addIncAdd.value + 1 == advertisementList.length) {
//           addIncAdd.value = 0;
//         } else {
//           addIncAdd.value = addIncAdd.value + 1;
//         }
//         messages.insert(
//             0,
//             Chats(
//                 message: base64Str,
//                 messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                 senderId: int.parse(senderId),
//                 messageType: msgId,
//                 repliedTo: showReply.value ? replyMessage!.value.id : null,
//                 repliedToInfo: showReply.value ? RepliedToInfo(messageType: replyMessage!.value.messageType, message: replyMessage!.value.message) : null,
//                 ads: advertisementList.isNotEmpty ? advertisementList[addIncAdd.value] : null));
//
//         /// add ads
//       } else {
//         messages.insert(
//             0,
//             Chats(
//                 message: base64Str,
//                 messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//                 senderId: int.parse(senderId),
//                 messageType: msgId,
//                 repliedTo: showReply.value ? replyMessage!.value.id : null,
//                 repliedToInfo: showReply.value ? RepliedToInfo(messageType: replyMessage!.value.messageType, message: replyMessage!.value.message) : null));
//       }
//     } else {
//       messages.insert(
//           0,
//           Chats(
//               message: base64Str,
//               messageDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
//               senderId: int.parse(senderId),
//               messageType: msgId,
//               repliedTo: showReply.value ? replyMessage!.value.id : null,
//               repliedToInfo: showReply.value ? RepliedToInfo(messageType: replyMessage!.value.messageType, message: replyMessage!.value.message) : null));
//     }
//
//     messages[messages.length - 1].ads = advertisementList.isNotEmpty ? advertisementList[addIncAdd.value] : null;
//     // });
//   }
//
//   handleAds() {
//     debugPrint("enter in handleAds");
//     int addInc = 0;
//     if (adsShowIndex.value == null) {
//       return;
//     }
//     for (int i = 0; i < messages.length; i++) {
//       //  if (i % adsShowIndex! == 0) {
//       if ((i + 1) % adsShowIndex.value == 0) {
//         debugPrint("handleAds adsShowIndex ${i % adsShowIndex.value} ");
//         if (addInc + 1 == advertisementList.length) {
//           addInc = 0;
//           debugPrint("check addInc 1 $addInc");
//         } else {
//           addInc++;
//           debugPrint("check addInc 2 $addInc");
//         }
//         //OBX used
//         // setState(() {
//         messages[i].ads = advertisementList[addInc];
//         // });
//       }
//     }
//   }
//
//
//   showBlockedChatAlertDialog(String? msg) {
//     // if (!mounted) {
//     //   return
//     // }
//
//     if (showingAlertDialog.value) {
//       return;
//     }
//     showingAlertDialog.value = true;
//     FocusScope.of(context!).requestFocus(FocusNode());
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
//         showingAlertDialog.value = false;
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
//       context: context!,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
