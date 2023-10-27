import 'dart:ffi';

class ConnectionsResponseModel {
  bool? status;
  List<Travel>? travel;
  int? travelCount;
  List<MeetMatch>? meetMatch;
  int? meetCount;

  ConnectionsResponseModel(
      {this.status,
        this.travel,
        this.travelCount,
        this.meetMatch,
        this.meetCount});

  ConnectionsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['travel'] != null) {
      travel = <Travel>[];
      json['travel'].forEach((v) {
        travel!.add(new Travel.fromJson(v));
      });
    }
    travelCount = json['travel_count'];
    if (json['meet_match'] != null) {
      meetMatch = <MeetMatch>[];
      json['meet_match'].forEach((v) {
        meetMatch!.add(new MeetMatch.fromJson(v));
      });
    }
    meetCount = json['meet_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.travel != null) {
      data['travel'] = this.travel!.map((v) => v.toJson()).toList();
    }
    data['travel_count'] = this.travelCount;
    if (this.meetMatch != null) {
      data['meet_match'] = this.meetMatch!.map((v) => v.toJson()).toList();
    }
    data['meet_count'] = this.meetCount;
    return data;
  }
}

class Travel {
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
  String? meetNowAddress;
  String? meetNowLng;
  String? meetNowLat;
  int? wrongAttempt;
  dynamic lastLoginAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? suspentionCount;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  String? isShowSexualOrientation;
  String? isShowGender;
  List<UserProfile>? userProfile;
  List<Userdestinations>? userdestinations;
  String? commonDest;
  String? connectionType;
  String? commonInterest;
  bool? isNew;
  bool? isBlocked;

  Travel(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.commonDest,
        this.connectionType,
        this.commonInterest,
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
        this.suspentionCount,
        this.avgRating,
        this.isShowAge,
        this.isSubscriber,
        this.age,
        this.chatMatch,
        this.shareProfileLink,
        this.isShowSexualOrientation,
        this.isShowGender,
        this.userProfile,
        this.isNew,
        this.userdestinations,
        this.isBlocked
      });

  Travel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isNew=json['is_new'];
    commonDest=json['common_dest'];
    connectionType=json['connection_type'];
    commonInterest=json['common_interest'];
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
    suspentionCount = json['suspention_count'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    age = json['age'];
    chatMatch = json['chat_match'];
    shareProfileLink = json['share_profile_link'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
    isShowGender = json['is_show_gender'];
    isBlocked = json['is_blocked'] == null ? false:json['is_blocked'];

    if (json['user_profile'] != null) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new UserProfile.fromJson(v));
      });
    }
    if (json['userdestinations'] != null) {
      userdestinations = <Userdestinations>[];
      json['userdestinations'].forEach((v) {
        userdestinations!.add(new Userdestinations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['common_interest']=this.commonInterest;
    data['common_dest']=this.commonDest;
    data['connection_type']=this.connectionType;
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
    data['suspention_count'] = this.suspentionCount;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    data['is_subscriber'] = this.isSubscriber;
    data['age'] = this.age;
    data['chat_match'] = this.chatMatch;
    data['share_profile_link'] = this.shareProfileLink;
    data['is_show_sexual_orientation'] = this.isShowSexualOrientation;
    data['is_show_gender'] = this.isShowGender;
    data['is_blocked'] = this.isBlocked == null? false :this.isBlocked;

    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    if (this.userdestinations != null) {
      data['userdestinations'] =
          this.userdestinations!.map((v) => v.toJson()).toList();
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

class Userdestinations {
  int? id;
  String? userId;
  String? destId;
  int? status;
  int? type;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? destName;
  String? destImage;
  Destination? destination;

  Userdestinations(
      {this.id,
        this.userId,
        this.destId,
        this.status,
        this.type,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.destName,
        this.destImage,
        this.destination});

  Userdestinations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    destId = json['dest_id'];
    status = json['status'];
    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    destName = json['dest_name'];
    destImage = json['dest_image'];
    destination = json['destination'] != null
        ? new Destination.fromJson(json['destination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dest_id'] = this.destId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['dest_name'] = this.destName;
    data['dest_image'] = this.destImage;
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    return data;
  }
}

class Destination {
  int? id;
  int? countryId;
  String? cityName;
  String? cityImage;
  String? lat;
  String? lng;
  String? cityStatus;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  Destination(
      {this.id,
        this.countryId,
        this.cityName,
        this.cityImage,
        this.lat,
        this.lng,
        this.cityStatus,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Destination.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    cityName = json['city_name'];
    cityImage = json['city_image'];
    lat = json['lat'];
    lng = json['lng'];
    cityStatus = json['city_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['city_name'] = this.cityName;
    data['city_image'] = this.cityImage;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city_status'] = this.cityStatus;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class MeetMatch {
  int? id;
  String? firstName;
  bool? isNew;
  String? lastName;
  String? commonDest;
  String? connectionType;
  String? commonInterest;
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
  String? meetNowAddress;
  String? meetNowLng;
  String? meetNowLat;
  int? wrongAttempt;
  dynamic lastLoginAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? suspentionCount;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  String? isShowSexualOrientation;
  String? isShowGender;
  bool? isBlocked;
  List<UserProfile>? userProfile;
  List<Userinterest>? userinterest;

  MeetMatch(
      {this.id,
        this.firstName,
        this.isNew,
        this.lastName,
        this.commonDest,
        this.connectionType,
        this.commonInterest,
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
        this.isBlocked,
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
        this.suspentionCount,
        this.avgRating,
        this.isShowAge,
        this.isSubscriber,
        this.age,
        this.chatMatch,
        this.shareProfileLink,
        this.isShowSexualOrientation,
        this.isShowGender,
        this.userProfile,
        this.userinterest});

  MeetMatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    isNew=json['is_new'];
    commonDest=json['common_dest'];
    connectionType=json['connection_type'];
    commonInterest=json['common_interest'];
    lastName = json['last_name'];
    email = json['email'];
    isBlocked = json['is_blocked'] == null ? false:json['is_blocked'];
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
    suspentionCount = json['suspention_count'];
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
    if (json['userinterest'] != null) {
      userinterest = <Userinterest>[];
      json['userinterest'].forEach((v) {
        userinterest!.add(new Userinterest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_new']=this.isNew;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['common_interest']=this.commonInterest;
    data['common_dest']=this.commonDest;
    data['connection_type']=this.connectionType;
    data['profile_picture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['is_blocked'] = this.isBlocked == null? false: this.isBlocked;
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
    data['suspention_count'] = this.suspentionCount;
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
    if (this.userinterest != null) {
      data['userinterest'] = this.userinterest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userinterest {
  int? id;
  int? userId;
  int? interestId;
  int? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? interestName;
  String? interestImage;
  Interest? interest;

  Userinterest(
      {this.id,
        this.userId,
        this.interestId,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.interestName,
        this.interestImage,
        this.interest});

  Userinterest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    interestName = json['interest_name'];
    interestImage = json['interest_image'];
    interest = json['interest'] != null
        ? new Interest.fromJson(json['interest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['interest_id'] = this.interestId;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['interest_name'] = this.interestName;
    data['interest_image'] = this.interestImage;
    if (this.interest != null) {
      data['interest'] = this.interest!.toJson();
    }
    return data;
  }
}

class Interest {
  int? id;
  int? interestCategoryId;
  String? name;
  String? image;
  String? slug;
  int? status;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  Interest(
      {this.id,
        this.interestCategoryId,
        this.name,
        this.image,
        this.slug,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Interest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interestCategoryId = json['interest_category_id'];
    name = json['name'];
    image = json['image'];
    slug = json['slug'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['interest_category_id'] = this.interestCategoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}