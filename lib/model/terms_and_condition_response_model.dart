class TermsAndConditionResponseModel {
  bool? success;
  TermsAndCondition? termsAndCondition;

  TermsAndConditionResponseModel({this.success, this.termsAndCondition});

  TermsAndConditionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    termsAndCondition = json['terms_and_condition'] != null
        ? new TermsAndCondition.fromJson(json['terms_and_condition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.termsAndCondition != null) {
      data['terms_and_condition'] = this.termsAndCondition!.toJson();
    }
    return data;
  }
}

class TermsAndCondition {
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
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  TermsAndCondition(
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

  TermsAndCondition.fromJson(Map<String, dynamic> json) {
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