// To parse this JSON data, do
//
//     final updateLanguageModel = updateLanguageModelFromJson(jsonString);

import 'dart:convert';

UpdateLanguageModel updateLanguageModelFromJson(String str) => UpdateLanguageModel.fromJson(json.decode(str));

String updateLanguageModelToJson(UpdateLanguageModel data) => json.encode(data.toJson());

class UpdateLanguageModel {
  UpdateLanguageModel({
    this.status,
    this.message,
    this.langId,
  });

  bool? status;
  String? message;
  int? langId;

  factory UpdateLanguageModel.fromJson(Map<String, dynamic> json) => UpdateLanguageModel(
    status: json["status"],
    message: json["message"],
    langId: json["lang_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "lang_id": langId,
  };
}
