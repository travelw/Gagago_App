class PrivacyPolicyResponseModel {
  bool? success;
  PrivacyAndPolicy? privacyAndPolicy;

  PrivacyPolicyResponseModel({this.success, this.privacyAndPolicy});

  PrivacyPolicyResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    privacyAndPolicy = json['privacy_and_policy'] != null
        ? new PrivacyAndPolicy.fromJson(json['privacy_and_policy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.privacyAndPolicy != null) {
      data['privacy_and_policy'] = this.privacyAndPolicy!.toJson();
    }
    return data;
  }
}

class PrivacyAndPolicy {
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
  String? lastUpdatedAt;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  PrivacyAndPolicy(
      {this.id,
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
        this.updatedAt});

  PrivacyAndPolicy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    contentEnglish = json['content_english'];
    contentSpanish = json['content_spanish'];
    contentChinease = json['content_chinease'];
    contentPortuguese = json['content_portuguese'];
    contentArabic = json['content_arabic'];
    contentHindi = json['content_hindi'];
    section = json['section'];
    deviceType = json['device_type'];
    lastUpdatedAt = json['last_updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content_english'] = this.contentEnglish;
    data['content_spanish'] = this.contentSpanish;
    data['content_chinease'] = this.contentChinease;
    data['content_portuguese'] = this.contentPortuguese;
    data['content_arabic'] = this.contentArabic;
    data['content_hindi'] = this.contentHindi;
    data['section'] = this.section;
    data['device_type'] = this.deviceType;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


