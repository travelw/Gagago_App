class ReviewListModel {
  bool? success;
  List<AverageRateListing>? averageRateListing;
  num? overallAverageRating;
  int? toalReviews;
  List<ReviewListing>? reviewListing;
  String? message;

  ReviewListModel(
      {this.success,
        this.averageRateListing,
        this.overallAverageRating,
        this.toalReviews,
        this.reviewListing,
        this.message});

  ReviewListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['average_rate_listing'] != null) {
      averageRateListing = <AverageRateListing>[];
      json['average_rate_listing'].forEach((v) {
        averageRateListing!.add(new AverageRateListing.fromJson(v));
      });
    }
    overallAverageRating = json['overall_average_rating'];
    toalReviews = json['toal_reviews'];
    if (json['review_listing'] != null) {
      reviewListing = <ReviewListing>[];
      json['review_listing'].forEach((v) {
        reviewListing!.add(new ReviewListing.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.averageRateListing != null) {
      data['average_rate_listing'] =
          this.averageRateListing!.map((v) => v.toJson()).toList();
    }
    data['overall_average_rating'] = this.overallAverageRating;
    data['toal_reviews'] = this.toalReviews;
    if (this.reviewListing != null) {
      data['review_listing'] =
          this.reviewListing!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AverageRateListing {
  String? rate;
  String? text;

  AverageRateListing({this.rate, this.text});

  AverageRateListing.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['text'] = this.text;
    return data;
  }
}

class ReviewListing {
  int? id;
  ReportedBy? reportedBy;
  int? reportedTo;
  int? flexibilityRate;
  int? positivityRate;
  int? senseOfHumorRate;
  int? respectfulRate;
  int? honestyRate;
  int? openMindRate;
  String? comment;
  String? createdAt;
  String? updatedAt;

  ReviewListing(
      {this.id,
        this.reportedBy,
        this.reportedTo,
        this.flexibilityRate,
        this.positivityRate,
        this.senseOfHumorRate,
        this.respectfulRate,
        this.honestyRate,
        this.openMindRate,
        this.comment,
        this.createdAt,
        this.updatedAt});

  ReviewListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportedBy = json['reported_by'] != null
        ? new ReportedBy.fromJson(json['reported_by'])
        : null;
    reportedTo = json['reported_to'];
    flexibilityRate = json['flexibility_rate'];
    positivityRate = json['positivity_rate'];
    senseOfHumorRate = json['sense_of_humor_rate'];
    respectfulRate = json['respectful_rate'];
    honestyRate = json['honesty_rate'];
    openMindRate = json['open_mind_rate'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.reportedBy != null) {
      data['reported_by'] = this.reportedBy!.toJson();
    }
    data['reported_to'] = this.reportedTo;
    data['flexibility_rate'] = this.flexibilityRate;
    data['positivity_rate'] = this.positivityRate;
    data['sense_of_humor_rate'] = this.senseOfHumorRate;
    data['respectful_rate'] = this.respectfulRate;
    data['honesty_rate'] = this.honestyRate;
    data['open_mind_rate'] = this.openMindRate;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ReportedBy {
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
  double? lat;
  double? lng;
  String? currentAddress;
  String? dob;
  String? preferredLang;
  String? bio;
  dynamic profileUpdatedFrom;
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
  String? rememberMe;
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
  dynamic meetNowAddress;
  dynamic meetNowLng;
  dynamic meetNowLat;
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
  String? isShowGender;
  List<UserProfile>? userProfile;

  ReportedBy(
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
        this.meetNowAddress,
        this.meetNowLng,
        this.meetNowLat,
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
        this.isShowSexualOrientation,
        this.isShowGender,
        this.userProfile});

  ReportedBy.fromJson(Map<String, dynamic> json) {
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
    lat = json['lat'];
    lng = json['lng'];
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
    meetNowAddress = json['meet_now_address'];
    meetNowLng = json['meet_now_lng'];
    meetNowLat = json['meet_now_lat'];
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
    isShowGender = json['is_show_gender'];
    if (json['user_profile'] != null) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new UserProfile.fromJson(v));
      });
    }
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
    data['meet_now_address'] = this.meetNowAddress;
    data['meet_now_lng'] = this.meetNowLng;
    data['meet_now_lat'] = this.meetNowLat;
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
    data['is_show_gender'] = this.isShowGender;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  dynamic imageOrder;
  dynamic tempToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  UserProfile(
      {this.id,
        this.userId,
        this.imageName,
        this.imageUpdatedFrom,
        this.imageOrder,
        this.tempToken,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageName = json['image_name'];
    imageUpdatedFrom = json['image_updated_from'];
    imageOrder = json['image_order'];
    tempToken = json['temp_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image_name'] = this.imageName;
    data['image_updated_from'] = this.imageUpdatedFrom;
    data['image_order'] = this.imageOrder;
    data['temp_token'] = this.tempToken;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}





