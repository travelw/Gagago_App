// To parse this JSON data, do
//
//     final checkEmailModel = checkEmailModelFromJson(jsonString);

import 'dart:convert';

CheckEmailModel checkEmailModelFromJson(String str) =>
    CheckEmailModel.fromJson(json.decode(str));

String checkEmailModelToJson(CheckEmailModel data) =>
    json.encode(data.toJson());

class CheckEmailModel {
  // bool? success;
  bool? deactivation;
  String? message;
  String? messageTitle;
  bool? status;

  CheckEmailModel({
    // this.success,
    this.deactivation,
    this.message,
    this.messageTitle,
    this.status,
  });

  factory CheckEmailModel.fromJson(Map<String, dynamic> json) =>
      CheckEmailModel(
        // success: json["success"],
        deactivation: json["deactivation"],
        message: json["message"],
        messageTitle: json["message_title"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        // "success": success,
        "deactivation": deactivation,
        "message": message,
        "message_title": messageTitle,
        "status": status,
      };
}
