// To parse this JSON data, do
//
//     final cancellationPolicyResponse = cancellationPolicyResponseFromJson(jsonString);

import 'dart:convert';

CancellationPolicyResponse cancellationPolicyResponseFromJson(String str) => CancellationPolicyResponse.fromJson(json.decode(str));

String cancellationPolicyResponseToJson(CancellationPolicyResponse data) => json.encode(data.toJson());

class CancellationPolicyResponse {
  int? status;
  String? message;
  CancellationPolicyData? data;

  CancellationPolicyResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CancellationPolicyResponse.fromJson(Map<String, dynamic> json) => CancellationPolicyResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : CancellationPolicyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CancellationPolicyData {
  int? id;
  String? description;
  String? fullDescription;
  int? freeCancellationTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  CancellationPolicyData({
    this.id,
    this.description,
    this.fullDescription,
    this.freeCancellationTime,
    this.createdAt,
    this.updatedAt,
  });

  factory CancellationPolicyData.fromJson(Map<String, dynamic> json) => CancellationPolicyData(
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
