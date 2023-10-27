import 'package:flutter/cupertino.dart';

class ChatModel {
  String UserImage;
  String headerText;
  String? iconVideoAudio;
  String text;
  String bottomText;
  String timeText;
  String? statusIocn;

  ChatModel(
      {required this.UserImage,
        required this.headerText,
        this.iconVideoAudio,
        required this.text,
        required this.bottomText,
        required this.timeText,
        this.statusIocn});
}
