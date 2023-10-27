import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gagagonew/CommonWidgets/no_message_found_screen.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:gagagonew/constants/string_constants.dart';
import 'package:gagagonew/model/chat_list_model.dart';
import 'package:gagagonew/view/chat/chat_message_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import '../../Service/call_service.dart';
import '../../model/connection_remove_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/progress_bar.dart';
import '../../utils/stream_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  bool isPageActive = true;
  AppStreamController appStreamController = AppStreamController.instance;
  TextEditingController editingController = TextEditingController();

  List<Data>? chats = [];
  String? userId = '', profilepic = "";
  bool? isShown;
  Socket? socket;

  // pagination purposes
  ScrollController scrollController = ScrollController();
  bool isPagination = false;
  int page = 0;
  int totalPage = 1;
  bool pageFlag = false;

  @override
  void initState() {
    // appStreamController.updateBadgesCount.add(BadgesCountModel(chatCount: 0));
    isPageActive = true;
    init();
    isLoading = true;
    initSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ChatListModel model = await CallService().getChatList(true, page, 0);
      setState(() {
        page = model.page ?? 0;
        pageFlag = model.flag ?? false;

        isLoading = false;
        chats = model.data!;
        debugPrint("chat model list${model.data!.length}");
      });
    });
    super.initState();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
    setState(() {});
    scrollController.addListener(() {
      debugPrint("under scroll");
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && pageFlag) {
        // loadNextPage();
      }
    });
  }

  loadNextPage() async {
    setState(() {
      isPagination = true;
    });
    ChatListModel model = await CallService().getChatList(false, page, 0);

    setState(() {
      isPagination = false;
      chats!.addAll(model.data!);
      page = model.page ?? 0;
      pageFlag = model.flag ?? false;
    });
  }

  void initSocket() async {
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
        print('Connected: $data');
        /* socket!.emit('getChatMessages', {
          'my_id': userId,
          'other_user_id': widget.receiverId,
        });*/
        socket!.on('chatReadStatus', (data) async {
          print("under chat_page chatReadStatus $data");
          debugPrint("under chat_page chatReadStatus userId $userId messages ${chats!.length}");
          debugPrint("under chat_page chatReadStatus userId $userId data[sender_id].toString() ${data["sender_id"].toString()}");

          if (chats!.isNotEmpty) {
            if (data["chat_head_id"] != null) {
              for (var element in chats!) {
                if (element.id.toString() == data["chat_head_id"].toString()) {
                  if (userId.toString() == data["sender_id"].toString()) {
                    element.lastMessage!.isRead = 1;
                  }
                }
                if (mounted) {
                  setState(() {});
                }
              }
            }
          }
        });
        socket!.on('chatHeadnotification', (data) async {
          print("chatHeadnotification chat_page ${data.toString()}");
          if (data != null) {
            if (data is List) {
              Map<String, dynamic> json = data[0];

              // String? receiverID;
              // String? senderID;
              String? chatID;
              // if (json.containsKey("receiver_id")) {
              //   receiverID = json["receiver_id"];
              // }
              if (json.containsKey("chat_head_id")) {
                chatID = json["chat_head_id"].toString();
              }

              // if (json.containsKey("sender_id")) {
              //   chatID = json["sender_id"];
              // }

              if (chats == null) {
                return;
              }
              if (chats!.isEmpty) {
                return;
              }

              int index = chats!.indexWhere((element) {
                debugPrint("  ${element.id}  $chatID ${element.receiverId}  $userId  ${element.senderId.toString()}");

                return (element.id.toString() == chatID && int.parse(json['count'].toString()) > 0);
                // return (element.id.toString() == chatID && element.receiverId.toString() == userId);
              });
              debugPrint("index $index");
              if (index >= 0) {
                if (chats![index].messageUnreadCount != null) {
                  // chats![index].messageUnreadCount = int.parse(json['count'].toString());
                  debugPrint("chats![index].messageUnreadCount ${chats![index].messageUnreadCount}");

                  updateMessageCount(index, json['count'], json['message'], json['message_type']);
                  chats![index].messageUnreadCount = 0;
                  chats![index].messageUnreadCount = json['count'];
                  chats![index].lastMessage!.message = json['message'].toString();
                  chats![index].lastMessage!.messageType = json['message_type'].toString();
                  chats![index].lastMessage!.senderId = json['sender_id'];
                  debugPrint("under updateMessageCount ${chats![index].messageUnreadCount}");
                  //if(controller.checkChatPage==false){
                  if (isPageActive) {
                    ChatListModel model = await CallService().getChatList(true, page, 1);
                    if (mounted) {
                      setState(() {
                        page = model.page ?? 0;
                        pageFlag = model.flag ?? false;
                        isLoading = false;
                        chats = model.data!;
                        debugPrint("chat model list${model.data!.length}");
                      });
                    }
                  }
                  //  }
                  /*Future.delayed(Duration(milliseconds: 200), () {
                    if (mounted) {
                      setState(() {});
                    }
                  });*/

                }
              }
            }
          }
        });

/*
        socket!.on('message', (data) async {
          debugPrint('chat_page getChatMessages:=> chat_page ${data.toString()}');

          Map<String, dynamic> json = data;

          // String? receiverID;
          // String? senderID;
          String? chatID;
          // if (json.containsKey("receiver_id")) {
          //   receiverID = json["receiver_id"];
          // }
          if (json.containsKey("chat_head_id")) {
            chatID = json["chat_head_id"].toString();
          }

          // if (json.containsKey("sender_id")) {
          //   chatID = json["sender_id"];
          // }

          if (chats == null) {
            return;
          }
          if (chats!.isEmpty) {
            return;
          }

          int index = chats!.indexWhere((element) {
            debugPrint("  ${element.id}  $chatID ${element.receiverId}  $userId  ${element.senderId.toString()}");

            return (element.id.toString() == chatID && element.receiverId.toString() == userId);
          });
          if (index >= 0) {
            if (chats![index].messageUnreadCount != null) {
              chats![index].messageUnreadCount = chats![index].messageUnreadCount! + 1;
            }
          }
          if (mounted) {
            setState(() {});
          }

          //   Chats newMessage = Chats.fromJson(data);
          //   if (newMessage.receiverId.toString() == userId &&
          //       widget.receiverId.toString() == newMessage.senderId.toString()) {
          //     setState(() {
          //       if (newMessage.messageType == '1') {
          //         newMessage.message =
          //             'https://server3.rvtechnologies.in/Jessica-Travel-Buddy-Mobile-app/public/message_files/' +
          //                 newMessage.message.toString();
          //       }
          //       messages.insert(0, newMessage);
          //     });
          //   }
        });
*/

        socket!.on('newnotification', (data) async {
          print("under chat_page newnotification data $data");

          if (data is List) {
            if (data[0]['receiver_id'].toString() == userId) {
              // updateChatCount(data[0]['count']);
            }
          } else {
            if (data['receiver_id'].toString() == userId) {
              // updateChatCount(data['count']);
            }
          }

          debugPrint('dattta$data');
        });
      });

      /* */
      socket!.onConnectError((data) {
        debugPrint('Error: $data');
      });
    } catch (e) {
      debugPrint('Error$e');
    }
  }

  updateMessageCount(index, count, message, messageType) {}

  updateList() {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ChatListModel model = await CallService().getChatList(true, page, 0);
      setState(() {
        isLoading = false;
        chats = model.data!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("under chat_page ");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //SvgPicture.asset( StringConstants.svgPath+ "backIcon.svg",),
        Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: Get.width * 0.14, right: Get.width * 0.050, left: Get.width * 0.050, bottom: Get.height * 0.014),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                headingText(context),
                const Spacer(),
                SizedBox(
                  width: Get.width * 0.5,
                  height: Get.height * 0.050,
                  child: TextField(
                    controller: editingController,
                    onChanged: (value) async {
                      // if (value.isNotEmpty) {
                      ChatListModel model = await CallService().getChatList(false, page, searchKeyword: value, 0);
                      chats!.clear();
                      setState(() {
                        page = model.page ?? 0;
                        pageFlag = model.flag ?? false;
                        isLoading = false;
                        chats = model.data!;
                      });
                      // }
                    },
                    decoration: InputDecoration(
                        iconColor: Colors.black,
                        contentPadding: EdgeInsets.zero,
                        labelText: "Search...".tr,
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                  ),
                ),
                const SizedBox(width: 0)
              ],
            ),
          ),
        ),
        //s  SizedBox(height: Get.height * 0.02),
        isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.transparent,
              ))
            : chats!.isEmpty || isAllBlocked()
                ? const Expanded(child: NoMessageFoundScreen())
                : messageList(),
      ]),
    );
  }

  Widget headingText(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: SvgPicture.asset(
            "${StringConstants.svgPath}backIcon.svg",
          ),
        ),
        SizedBox(width: Get.width * 0.030),
        Text(
          "Chat".tr,
          style: TextStyle(fontSize: Get.height * 0.022, color: AppColors.gagagoLogoColor, fontWeight: FontWeight.w600, fontFamily: StringConstants.poppinsRegular),
        ),
      ],
    );
  }

  bool isAllBlocked() {
    bool allBlocked = false;
    for (int i = 0; i < chats!.length; i++) {
      if (!chats![i].isRemoveConnection! && !chats![i].isBlocked! && !chats![i].isMeBlocked!) {
        allBlocked = false;
        break;
      } else {
        allBlocked = true;
      }
    }
    return allBlocked;
  }

  messageList() {
    return Expanded(
      child: Stack(
        children: [
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: refreshEventList,
            child: ListView.builder(
              padding: EdgeInsets.only(top: Get.width * 0.04, bottom: Get.width * 0.04, right: Get.width * 0.045, left: Get.width * 0.040),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              // shrinkWrap: true,
              itemCount: chats!.length,
              itemBuilder: (context, index) {
                debugPrint("chat length count : ${chats!.length} ${chats![index].lastMessage!.messageDate}");
                return (!chats![index].isRemoveConnection! && !chats![index].isBlocked! && !chats![index].isMeBlocked!) ? _messageListItem(context, index) : SizedBox();
              },
            ),
          ),
          // if (isPagination)
          //   Positioned(
          //       bottom: 0,
          //       right: 0,
          //       left: 0,
          //       child: Container(
          //         width: double.infinity,
          //         height: 40,
          //         alignment: Alignment.center,
          //         color: Colors.white,
          //         child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
          //       ))
        ],
      ),
    );
  }

  _messageListItem(context, index) {
    String commonInterest = "";
    print("under _messageListItem --> $index ${chats![index].commonDestination} --> ${chats![index].connectionType}");

    if ((chats![index].connectionType == 'travell' || chats![index].connectionType == 'Both')) {
      if (chats![index].commonDestination != "destination") {
        commonInterest = 'Gagagoing to '.tr + chats![index].commonDestination.toString();
      }
    } else if (chats![index].commonInterest != "hobby" && chats![index].commonInterest!.isNotEmpty) {
      commonInterest = 'Gagago ${chats![index].commonInterest}';
    }

/*
    if (selectTab == true) {
      if (travelUserList[index].connectionType == "travell" && travelUserList[index].commonDest != "destination") {
        commonInterest = "${"Gagagoing to ".tr}${travelUserList[index].commonDest ?? ""}";
      }
    } else {
      if (meetNewMatchList[index].connectionType == "meetnow" && meetNewMatchList[index].commonInterest != "hobby") {
        commonInterest = "Gagago ${meetNewMatchList[index].commonInterest ?? ""}";
      }
    }*/

    return GestureDetector(
      onTap: () async {
        if (userId == chats![index].senderId.toString()) {
          _handleClickedForMe(index: index, commonInterest: commonInterest);
        } else {
          _handleClickedForOtherUser(index: index, commonInterest: commonInterest);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey,
        child: Container(
          padding: EdgeInsets.all(Get.width * 0.015),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  backgroundImage: userId == chats![index].senderId.toString()
                      ? (chats![index].receiverImage!.isNotEmpty
                          ? NetworkImage(chats![index].receiverImage![0].imageName.toString())
                          : Image.asset(
                              'assets/images/png/dummypic.png',
                            ).image)
                      : (chats![index].senderImage!.isNotEmpty
                          ? NetworkImage(chats![index].senderImage![0].imageName.toString())
                          : Image.asset(
                              'assets/images/png/dummypic.png',
                            ).image),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: Get.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userId == chats![index].senderId.toString() ? chats![index].receiverName.toString() : chats![index].senderName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: Get.height * 0.018,
                              fontFamily: StringConstants.poppinsRegular,
                            ),
                          ),
                          Text(
                            chats![index].lastMessage!.messageDate == null ? "" : CommonFunctions.dayDurationToString(chats![index].lastMessage!.messageDate.toString(), context, toLocal: true),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontSize: Get.height * 0.013,
                              fontFamily: StringConstants.poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          chats![index].lastMessage!.messageType.toString() == '1'
                              ? Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/png/photos.png',
                                      fit: BoxFit.fill,
                                      height: Get.height * 0.03,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: Get.width * 0.008),
                                      child: Text(
                                        'Photo'.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0) ? Colors.black : AppColors.grayColorNormal,
                                          fontSize: Get.height * 0.018,
                                          fontFamily: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0)
                                              ? StringConstants.poppinsBold
                                              : StringConstants.poppinsRegular,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : chats![index].lastMessage!.messageType.toString() == '3'
                                  ? Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/png/mic.png',
                                          fit: BoxFit.fill,
                                          height: Get.height * 0.02,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: Get.width * 0.008),
                                          child: Text(
                                            'Voice Message'.tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0) ? Colors.black : AppColors.grayColorNormal,
                                              fontSize: Get.height * 0.018,
                                              fontFamily: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0)
                                                  ? StringConstants.poppinsBold
                                                  : StringConstants.poppinsRegular,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Expanded(
                                      child: Text(
                                        // capitalize(utf8.decode(base64.decode(chats![index].lastMessage!.message.toString()))),
                                        utf8.decode(base64.decode(chats![index].lastMessage!.message.toString())),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0) ? Colors.black : AppColors.grayColorNormal,
                                          fontSize: Get.height * 0.018,
                                          fontFamily: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0)
                                              ? StringConstants.poppinsBold
                                              : StringConstants.poppinsRegular,
                                        ),
                                      ),
                                    ),
                          (chats![index].lastMessage!.senderId.toString() == userId)
                              ? (chats![index].lastMessage!.isRead == 1)
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
                                    )
                              : Visibility(
                                  visible: chats![index].messageUnreadCount! > 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: Get.width * 0.052,
                                    height: Get.height * 0.052,
                                    //padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                                    child: Text(
                                      (chats![index].messageUnreadCount.toString().length > 2) ? "99+" : chats![index].messageUnreadCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: (chats![index].messageUnreadCount.toString().length > 2) ? Get.height * 0.012 : Get.height * 0.016,
                                        fontFamily: StringConstants.poppinsRegular,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.002,
                      ),

                      ///amit change
                      Text(
                        commonInterest,
                        style: TextStyle(
                          color: (chats![index].lastMessage!.senderId.toString() != userId && chats![index].messageUnreadCount! > 0) ? Colors.blue : AppColors.grayColorNormal,
                          fontFamily: StringConstants.poppinsRegular,
                          fontSize: Get.height * 0.016,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleClickedForMe({required int index, required String commonInterest}) async {
    var map = <String, dynamic>{};
    map['other_user_id'] = chats![index].receiverId.toString();
    ConnectionRemoveModel connectionRemove = await CallService().readOtherUserMessage(map, () {
      socket!.emit('getNotification', {
        'my_id': userId,
      });
    });
    if (connectionRemove.status! == true) {
      //await Get.toNamed(RouteHelper.getChatMessageScreen(chats![index].receiverId.toString()));

      isPageActive = false;

      await Navigator.of(
        context,
      )
          .push(        MaterialPageRoute(
          builder: (context) => ChatMessageScreen(
            receiverId: chats![index].receiverId.toString(),
            isShown: false,
            connectionType: chats![index].connectionType,
            isMeBlocked: chats![index].isMeBlocked.toString(),
            commonInterest: commonInterest,
            image: chats![index].receiverImage!.isNotEmpty ? chats![index].receiverImage![0].imageName : "",
            name: userId == chats![index].senderId.toString() ? chats![index].receiverName.toString() : chats![index].senderName.toString(),
          ),
        ),
      )
          .then((value) {
        isPageActive = true;
        appStreamController.handleBottomTab.add(true);
      });
      /*Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                          builder: (_) =>  ChatMessageScreen(receiverId: chats![index].receiverId.toString(),isShown: false),
                            ),);*/
      ChatListModel model = await CallService().getChatList(true, page, 0);
      if (mounted) {
        setState(() {
          chats = model.data!;
        });
      }
    } else {
      CommonDialog.showToastMessage(connectionRemove.message.toString());
    }
  }

  _handleClickedForOtherUser({required int index, required String commonInterest}) async {
    var map = <String, dynamic>{};
    map['other_user_id'] = chats![index].senderId.toString();
    ConnectionRemoveModel connectionRemove = await CallService().readOtherUserMessage(map, () {
      socket!.emit('getNotification', {
        'my_id': userId,
      });
    });
    if (connectionRemove.status! == true) {
      await Navigator.of(
        context,
      )
          .push(
        MaterialPageRoute(
          builder: (context) => ChatMessageScreen(
            receiverId: chats![index].senderId.toString(),
            isShown: false,
            connectionType: chats![index].connectionType,
            isMeBlocked: chats![index].isMeBlocked.toString(),
            commonInterest: commonInterest,
            image: userId == chats![index].senderId.toString()
                ? chats![index].receiverImage!.isNotEmpty
                    ? chats![index].receiverImage![0].imageName
                    : ""
                : "",
            name: userId == chats![index].senderId.toString() ? chats![index].receiverName.toString() : chats![index].senderName.toString(),
          ),
        ),
      )
          .then((value) {
        appStreamController.handleBottomTab.add(true);
      });
/*await  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatMessageScreen(receiverId: chats![index].senderId.toString()),),
                                  );*/
//Get.toNamed(RouteHelper.getChatMessageScreen(chats![index].senderId.toString()));
      ChatListModel model = await CallService().getChatList(true, page, 0);
      if (mounted) {
        setState(() {
          chats = model.data!;
        });
      }
    } else {
      CommonDialog.showToastMessage(connectionRemove.message.toString());
    }
  }
  /*String capitalize(String text) {
    return text.replaceAllMapped(RegExp(r'\.\s+[a-z]|^[a-z]'), (m) {
      final String match = m[0] ?? '';
      return match.toUpperCase();
    });
  }*/

/*  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool caps = false;
    bool start = true;

    for (int i = 1; i < value.length; i++) {
      if(start == true){

        if (value[i - 1] == " " && value[i] != " "){
          result = result + value[i];
          start = false;
        }else{
          result = result + value[i];
        }
      }else{
        if (value[i - 1] == " " && caps == true) {
          result = result + value[i];
          caps = false;
        } else {
          if(caps && value[i] != " "){
            result = result + value[i];
            caps = false;
          }else{
            result = result + value[i];
          }
        }

        if(value[i] == "."){
          caps = true;
        }
        if(value[i] == "?"){
          caps = true;
        }
        if(value[i] == "!"){
          caps = true;
        }
      }
    }
    return result;
  }

  String capitalizeAllSentence(String value) {
    var result = value[0].toUpperCase();
    bool caps = false;
    bool start = true;

    for (int i = 1; i < value.length; i++) {
      if(start == true){
        if (value[i - 1] == " " && value[i] != " "){
          result = result + value[i].toUpperCase();
          start = false;
        }else{
          result = result + value[i];
        }
      }else{
        if (value[i - 1] == " " && caps == true) {
          result = result + value[i].toUpperCase();
          caps = false;
        } else {
          if(caps && value[i] != " "){
            result = result + value[i].toUpperCase();
            caps = false;
          }else{
            result = result + value[i];
          }
        }

        if(value[i] == "."){
          caps = true;
        }
      }
    }
    return result;
  }*/

  Future<void> refreshEventList() async {
    debugPrint("under Pull Down");
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      updateList();
    });
    return;
  }
}
