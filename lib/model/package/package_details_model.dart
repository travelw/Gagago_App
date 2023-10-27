// To parse this JSON data, do
//
//     final packageDetailsModel = packageDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:gagagonew/model/package/package_list_model.dart';

PackageDetailsModel packageDetailsModelFromJson(String str) => PackageDetailsModel.fromJson(json.decode(str));

String packageDetailsModelToJson(PackageDetailsModel data) => json.encode(data.toJson());

class PackageDetailsModel {
  int? status;
  String? message;
  PackageListModelData? data;
  CancellationPolicyModel? cancellationPolicyModel;

  PackageDetailsModel({
    this.status,
    this.message,
    this.data,
    this.cancellationPolicyModel,
  });

  factory PackageDetailsModel.fromJson(Map<String, dynamic> json) => PackageDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : PackageListModelData.fromJson(json["data"]),
        cancellationPolicyModel: json["cancellation_policy"] == null ? null : CancellationPolicyModel.fromJson(json["cancellation_policy"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "cancellation_policy": cancellationPolicyModel?.toJson(),
      };
}

class CancellationPolicyModel {
  final int? id;
  final String? description;
  final String? fullDescription;
  final int? freeCancellationTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CancellationPolicyModel({
    this.id,
    this.description,
    this.fullDescription,
    this.freeCancellationTime,
    this.createdAt,
    this.updatedAt,
  });

  factory CancellationPolicyModel.fromJson(Map<String, dynamic> json) => CancellationPolicyModel(
        id: json["id"],
        description: json["description"],
        fullDescription: json["full_description"],
        freeCancellationTime: json["free_cancellation_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "full_description": fullDescription,
        "free_cancellation_time": freeCancellationTime,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
