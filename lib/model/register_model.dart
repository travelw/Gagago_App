class RegisterModel {
  bool? success;
  String? message;
  String? accessToken;
  Data? data;

  RegisterModel({this.success, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    accessToken = json['access_token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  String? accessToken;

  Data({this.user, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? ipAddress;
  String? dob;
  String? sexualOrientation;
  String? ethinicity;
  dynamic tripStyle;
  String? tripTimeline;
  String? bio;
  String? updatedAt;
  String? createdAt;
  int? id;
  num? avgRating;
  String? isShowAge;

  User(
      {this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.countryCode,
        this.ipAddress,
        this.dob,
        this.sexualOrientation,
        this.ethinicity,
        this.tripStyle,
        this.tripTimeline,
        this.bio,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.avgRating,
        this.isShowAge});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    countryCode = json['country_code'];
    ipAddress = json['ip_address'];
    dob = json['dob'];
    sexualOrientation = json['sexual_orientation'];
    ethinicity = json['ethinicity'];
    tripStyle = json['trip_style'];
    tripTimeline = json['trip_timeline'];
    bio = json['bio'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['country_code'] = this.countryCode;
    data['ip_address'] = this.ipAddress;
    data['dob'] = this.dob;
    data['sexual_orientation'] = this.sexualOrientation;
    data['ethinicity'] = this.ethinicity;
    data['trip_style'] = this.tripStyle;
    data['trip_timeline'] = this.tripTimeline;
    data['bio'] = this.bio;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    return data;
  }
}