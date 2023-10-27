class SettingsModel {
  bool? success;
  String? message;
  List<Data>? data;
  User? user;

  SettingsModel({this.success, this.message, this.data, this.user});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? isShowAge;
  int? isShowSexualOrientation;
  int? meetNowPassport;
  int? genderPreference;
  int? minAge;
  int? maxAge;
  int? ethinicityPreference;
  int? sexualOrientationPreference;
  int? tripStylePreference;
  int? tripTimelinePreference;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.isShowAge,
        this.meetNowPassport,
        this.isShowSexualOrientation,
        this.genderPreference,
        this.minAge,
        this.maxAge,
        this.ethinicityPreference,
        this.sexualOrientationPreference,
        this.tripStylePreference,
        this.tripTimelinePreference,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isShowAge = json['is_show_age'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
    meetNowPassport=json['meet_now_passport'];
    genderPreference = json['gender_preference'];
    minAge = json['min_age'];
    maxAge = json['max_age'];
    ethinicityPreference = json['ethinicity_preference'];
    sexualOrientationPreference = json['sexual_orientation_preference'];
    tripStylePreference = json['trip_style_preference'];
    tripTimelinePreference = json['trip_timeline_preference'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['is_show_age'] = this.isShowAge;
    data['is_show_sexual_orientation'] = this.isShowSexualOrientation;
    data['gender_preference'] = this.genderPreference;
    data['min_age'] = this.minAge;
    data['max_age'] = this.maxAge;
    data['ethinicity_preference'] = this.ethinicityPreference;
    data['sexual_orientation_preference'] = this.sexualOrientationPreference;
    data['trip_style_preference'] = this.tripStylePreference;
    data['trip_timeline_preference'] = this.tripTimelinePreference;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  String? email;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  String? meetNowAddress;
  String? meetNowLng;
  String? meetNowLat;

  User({this.email, this.avgRating, this.isShowAge, this.isSubscriber});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    meetNowAddress=json['meet_now_address'];
    meetNowLat=json['meet_now_lat'];
    meetNowLng=json['meet_now_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    data['is_subscriber'] = this.isSubscriber;
    data['meet_now_address']=this.meetNowAddress;
    data['meet_now_lat']=this.meetNowLat;
    data['meet_now_lng']=this.meetNowLng;
    return data;
  }
}



