// To parse this JSON data, do
//
//     final termsAndConditionsModel = termsAndConditionsModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionsModel termsAndConditionsModelFromJson(String str) => TermsAndConditionsModel.fromJson(json.decode(str));

String termsAndConditionsModelToJson(TermsAndConditionsModel data) => json.encode(data.toJson());

class TermsAndConditionsModel {
  TermsAndConditionsModel({
    this.success,
    this.termsAndCondition,
  });

  bool? success;
  TermsAndCondition? termsAndCondition;

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) => TermsAndConditionsModel(
    success: json["success"] == null ? null : json["success"],
    termsAndCondition: json["terms_and_condition"] == null ? null : TermsAndCondition.fromJson(json["terms_and_condition"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "terms_and_condition": termsAndCondition == null ? null : termsAndCondition!.toJson(),
  };
}

class TermsAndCondition {
  TermsAndCondition({
    this.id,
    this.title,
    this.contentEnglish,
    this.contentSpanish,
    this.contentChinease,
    this.contentPortuguese,
    this.contentArabic,
    this.contentHindi,
    this.section,
    this.deviceType,
    this.lastUpdatedAt,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? contentEnglish;
  String? contentSpanish;
  String? contentChinease;
  String? contentPortuguese;
  String? contentArabic;
  String? contentHindi;
  String? section;
  String? deviceType;
  DateTime? lastUpdatedAt;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TermsAndCondition.fromJson(Map<String, dynamic> json) => TermsAndCondition(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    contentEnglish: json["content_english"] == null ? null : json["content_english"],
    contentSpanish: json["content_spanish"] == null ? null : json["content_spanish"],
    contentChinease: json["content_chinease"] == null ? null : json["content_chinease"],
    contentPortuguese: json["content_portuguese"] == null ? null : json["content_portuguese"],
    contentArabic: json["content_arabic"] == null ? null : json["content_arabic"],
    contentHindi: json["content_hindi"] == null ? null : json["content_hindi"],
    section: json["section"] == null ? null : json["section"],
    deviceType: json["device_type"] == null ? null : json["device_type"],
    lastUpdatedAt: json["last_updated_at"] == null ? null : DateTime.parse(json["last_updated_at"]),
    status: json["status"] == null ? null : json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "content_english": contentEnglish == null ? null : contentEnglish,
    "content_spanish": contentSpanish == null ? null : contentSpanish,
    "content_chinease": contentChinease == null ? null : contentChinease,
    "content_portuguese": contentPortuguese == null ? null : contentPortuguese,
    "content_arabic": contentArabic == null ? null : contentArabic,
    "content_hindi": contentHindi == null ? null : contentHindi,
    "section": section == null ? null : section,
    "device_type": deviceType == null ? null : deviceType,
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt!.toIso8601String(),
    "status": status == null ? null : status,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
