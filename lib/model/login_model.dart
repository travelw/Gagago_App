class LoginModel {
  bool? success;
  String? message;
  String? messageTitle;
  Data? data;
  String? accessToken;
  bool? deactivation;

  LoginModel(
      {this.success,
      this.message,
      this.messageTitle,
      this.data,
      this.accessToken,
      this.deactivation});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    messageTitle = json['message_title'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    accessToken = json['access_token'];
    deactivation = json['deactivation'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['message_title'] = this.messageTitle;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['access_token'] = this.accessToken;
    data['deactivation'] = deactivation;
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;
  String? gender;
  String? sexualOrientation;
  String? ethinicity;
  String? tripStyle;
  String? tripTimeline;
  String? lat;
  String? lng;
  String? currentAddress;
  String? dob;
  String? preferredLang;
  String? bio;
  String? profileUpdatedFrom;
  dynamic emailVerificationToken;
  String? emailVerifiedAt;
  String? isEmailVerified;
  String? phoneNumber;
  String? countryCode;
  int? isOnline;
  dynamic socketId;
  int? notificationEnabled;
  dynamic referredBy;
  String? referralKey;
  String? ipAddress;
  dynamic rememberMe;
  dynamic tempToken;
  String? messageNotification;
  String? matchNotification;
  dynamic deviceToken;
  String? loginWith;
  String? userLocked;
  dynamic userLockedAt;
  int? userMode;
  dynamic meetNowCity;
  dynamic meetNowCityType;
  int? wrongAttempt;
  dynamic lastLoginAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  String? isShowSexualOrientation;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.profilePicture,
      this.gender,
      this.sexualOrientation,
      this.ethinicity,
      this.tripStyle,
      this.tripTimeline,
      this.lat,
      this.lng,
      this.currentAddress,
      this.dob,
      this.preferredLang,
      this.bio,
      this.profileUpdatedFrom,
      this.emailVerificationToken,
      this.emailVerifiedAt,
      this.isEmailVerified,
      this.phoneNumber,
      this.countryCode,
      this.isOnline,
      this.socketId,
      this.notificationEnabled,
      this.referredBy,
      this.referralKey,
      this.ipAddress,
      this.rememberMe,
      this.tempToken,
      this.messageNotification,
      this.matchNotification,
      this.deviceToken,
      this.loginWith,
      this.userLocked,
      this.userLockedAt,
      this.userMode,
      this.meetNowCity,
      this.meetNowCityType,
      this.wrongAttempt,
      this.lastLoginAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.avgRating,
      this.isShowAge,
      this.isSubscriber,
      this.age,
      this.chatMatch,
      this.shareProfileLink,
      this.isShowSexualOrientation});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
    gender = json['gender'];
    sexualOrientation = json['sexual_orientation'];
    ethinicity = json['ethinicity'];
    tripStyle = json['trip_style'];
    tripTimeline = json['trip_timeline'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    currentAddress = json['current_address'];
    dob = json['dob'];
    preferredLang = json['preferred_lang'];
    bio = json['bio'];
    profileUpdatedFrom = json['profile_updated_from'];
    emailVerificationToken = json['email_verification_token'];
    emailVerifiedAt = json['email_verified_at'];
    isEmailVerified = json['is_email_verified'];
    phoneNumber = json['phone_number'];
    countryCode = json['country_code'];
    isOnline = json['is_online'];
    socketId = json['socket_id'];
    notificationEnabled = json['notification_enabled'];
    referredBy = json['referred_by'];
    referralKey = json['referral_key'];
    ipAddress = json['ip_address'];
    rememberMe = json['remember_me'];
    tempToken = json['temp_token'];
    messageNotification = json['message_notification'];
    matchNotification = json['match_notification'];
    deviceToken = json['device_token'];
    loginWith = json['login_with'];
    userLocked = json['user_locked'];
    userLockedAt = json['user_locked_at'];
    userMode = json['user_mode'];
    meetNowCity = json['meet_now_city'];
    meetNowCityType = json['meet_now_city_type'];
    wrongAttempt = json['wrong_attempt'];
    lastLoginAt = json['last_login_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    age = json['age'];
    chatMatch = json['chat_match'];
    shareProfileLink = json['share_profile_link'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_picture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['sexual_orientation'] = this.sexualOrientation;
    data['ethinicity'] = this.ethinicity;
    data['trip_style'] = this.tripStyle;
    data['trip_timeline'] = this.tripTimeline;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['current_address'] = this.currentAddress;
    data['dob'] = this.dob;
    data['preferred_lang'] = this.preferredLang;
    data['bio'] = this.bio;
    data['profile_updated_from'] = this.profileUpdatedFrom;
    data['email_verification_token'] = this.emailVerificationToken;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['is_email_verified'] = this.isEmailVerified;
    data['phone_number'] = this.phoneNumber;
    data['country_code'] = this.countryCode;
    data['is_online'] = this.isOnline;
    data['socket_id'] = this.socketId;
    data['notification_enabled'] = this.notificationEnabled;
    data['referred_by'] = this.referredBy;
    data['referral_key'] = this.referralKey;
    data['ip_address'] = this.ipAddress;
    data['remember_me'] = this.rememberMe;
    data['temp_token'] = this.tempToken;
    data['message_notification'] = this.messageNotification;
    data['match_notification'] = this.matchNotification;
    data['device_token'] = this.deviceToken;
    data['login_with'] = this.loginWith;
    data['user_locked'] = this.userLocked;
    data['user_locked_at'] = this.userLockedAt;
    data['user_mode'] = this.userMode;
    data['meet_now_city'] = this.meetNowCity;
    data['meet_now_city_type'] = this.meetNowCityType;
    data['wrong_attempt'] = this.wrongAttempt;
    data['last_login_at'] = this.lastLoginAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    data['is_subscriber'] = this.isSubscriber;
    data['age'] = this.age;
    data['chat_match'] = this.chatMatch;
    data['share_profile_link'] = this.shareProfileLink;
    data['is_show_sexual_orientation'] = this.isShowSexualOrientation;
    return data;
  }
}
