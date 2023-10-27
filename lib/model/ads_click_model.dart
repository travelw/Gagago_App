// To parse this JSON data, do
//
//     final adsClickModel = adsClickModelFromJson(jsonString);

import 'dart:convert';

AdsClickModel adsClickModelFromJson(String str) => AdsClickModel.fromJson(json.decode(str));

String adsClickModelToJson(AdsClickModel data) => json.encode(data.toJson());

class AdsClickModel {
  AdsClickModel({
    this.url,
    this.status,
    this.message,
  });

  String? url;
  bool? status;
  String? message;

  factory AdsClickModel.fromJson(Map<String, dynamic> json) => AdsClickModel(
    url: json["url"] == null ? null : json["url"],
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
