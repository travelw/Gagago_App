// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  bool success;
  String messageTitle;
  String messageCaption;

  ErrorModel({
    required this.success,
    required this.messageTitle,
    required this.messageCaption,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    success: json["success"],
    messageTitle: json["message_title"],
    messageCaption: json["message_caption"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message_title": messageTitle,
    "message_caption": messageCaption,
  };
}
