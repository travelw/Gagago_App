class NotificationResponseModel {
  bool? status;
  String? message;
  List<Data>? data;
  User? user;
  bool? flag;
  int? page;

  NotificationResponseModel({this.status, this.message, this.data, this.user, this.flag, this.page});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    flag = json['flag'];
    page = json['page'];
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
    data['status'] = this.status;
    data['message'] = this.message;
    data['flag'] = this.flag  ;
    data['page'] = this.page  ;
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
  int? likedByUserId;
  String? message;
  int? isRead;
  String? notificationType;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? connection_type_notification;
  LikedByInfo? likedByInfo;

  Data(
      {this.id,
        this.userId,
        this.likedByUserId,
        this.message,
        this.isRead,
        this.notificationType,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.connection_type_notification,
        this.likedByInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    likedByUserId = json['liked_by_user_id'];
    message = json['message'];
    isRead = json['is_read'];
    notificationType = json['notification_type'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    connection_type_notification = json['connection_type_notification'];
    likedByInfo = json['liked_by_info'] != null
        ? new LikedByInfo.fromJson(json['liked_by_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['liked_by_user_id'] = this.likedByUserId;
    data['message'] = this.message;
    data['is_read'] = this.isRead;
    data['notification_type'] = this.notificationType;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['connection_type_notification'] = this.connection_type_notification;
    if (this.likedByInfo != null) {
      data['liked_by_info'] = this.likedByInfo!.toJson();
    }
    return data;
  }
}

class LikedByInfo {
  int? id;
  String? dob;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  String? isShowSexualOrientation;
  String? isShowGender;
  String? isShowEthinicity;
  List<UserProfile>? userProfile;
  String? commonDest;
  String? commonInterest;
  String? connectionType;
  bool? isNew;

  LikedByInfo(
      {this.id,
        this.dob,
        this.avgRating,
        this.isShowAge,
        this.isSubscriber,
        this.age,
        this.chatMatch,
        this.shareProfileLink,
        this.isShowSexualOrientation,
        this.isShowGender,
        this.isShowEthinicity,
        this.userProfile,
        this.commonDest,
        this.commonInterest,
        this.connectionType,
        this.isNew});

  LikedByInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dob = json['dob'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    age = json['age'];
    chatMatch = json['chat_match'];
    shareProfileLink = json['share_profile_link'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
    isShowGender = json['is_show_gender'];
    isShowEthinicity = json['is_show_ethinicity'];
    if (json['user_profile'] != null) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new UserProfile.fromJson(v));
      });
    }
    commonDest = json['common_dest'];
    commonInterest = json['common_interest'];
    connectionType = json['connection_type'];
    isNew = json['is_new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dob'] = this.dob;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    data['is_subscriber'] = this.isSubscriber;
    data['age'] = this.age;
    data['chat_match'] = this.chatMatch;
    data['share_profile_link'] = this.shareProfileLink;
    data['is_show_sexual_orientation'] = this.isShowSexualOrientation;
    data['is_show_gender'] = this.isShowGender;
    data['is_show_ethinicity'] = this.isShowEthinicity;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    data['common_dest'] = this.commonDest;
    data['common_interest'] = this.commonInterest;
    data['connection_type'] = this.connectionType;
    data['is_new'] = this.isNew;
    return data;
  }
}

class UserProfile {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  String? imageOrder;
  String? tempToken;
  String? deletedAt;
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

class User {
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
  String? emailVerificationToken;
  String? emailVerifiedAt;
  String? isEmailVerified;
  String? phoneNumber;
  String? countryCode;
  int? isOnline;
  String? socketId;
  String? referredBy;
  String? referralKey;
  String? ipAddress;
  String? rememberMe;
  String? tempToken;
  int? notificationEnabled;
  String? messageNotification;
  String? matchNotification;
  String? deviceToken;
  String? loginWith;
  String? userLocked;
  String? userLockedAt;
  int? userMode;
  String? meetNowCity;
  String? meetNowCityType;
  String? meetNowAddress;
  String? meetNowLng;
  String? meetNowLat;
  String? meetNowUpdatedAt;
  int? wrongAttempt;
  String? lastLoginAt;
  String? deletedAt;
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
  String? isShowEthinicity;
  List<UserProfile>? userProfile;
  String? commonDest;
  String? commonInterest;
  String? connectionType;
  bool? isNew;
  List<BlockList>? blockList;
  List<Userinterest>? userinterest;

  User(
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
        this.referredBy,
        this.referralKey,
        this.ipAddress,
        this.rememberMe,
        this.tempToken,
        this.notificationEnabled,
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
        this.meetNowUpdatedAt,
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
        this.isShowEthinicity,
        this.userProfile,
        this.commonDest,
        this.commonInterest,
        this.connectionType,
        this.isNew,
        this.blockList,
        this.userinterest});

  User.fromJson(Map<String, dynamic> json) {
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
    referredBy = json['referred_by'];
    referralKey = json['referral_key'];
    ipAddress = json['ip_address'];
    rememberMe = json['remember_me'];
    tempToken = json['temp_token'];
    notificationEnabled = json['notification_enabled'];

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
    meetNowUpdatedAt = json['meet_now_updated_at'];
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
    isShowEthinicity = json['is_show_ethinicity'];
    if (json['user_profile'] != null) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new UserProfile.fromJson(v));
      });
    }
    commonDest = json['common_dest'];
    commonInterest = json['common_interest'];
    connectionType = json['connection_type'];
    isNew = json['is_new'];
    if (json['block_list'] != null) {
      blockList = <BlockList>[];
      json['block_list'].forEach((v) {
        blockList!.add(new BlockList.fromJson(v));
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
    data['referred_by'] = this.referredBy;
    data['referral_key'] = this.referralKey;
    data['ip_address'] = this.ipAddress;
    data['remember_me'] = this.rememberMe;
    data['temp_token'] = this.tempToken;
    data['notification_enabled'] = this.notificationEnabled;
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
    data['meet_now_updated_at'] = this.meetNowUpdatedAt;
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
    data['is_show_ethinicity'] = this.isShowEthinicity;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    data['common_dest'] = this.commonDest;
    data['common_interest'] = this.commonInterest;
    data['connection_type'] = this.connectionType;
    data['is_new'] = this.isNew;
    if (this.blockList != null) {
      data['block_list'] = this.blockList!.map((v) => v.toJson()).toList();
    }
    if (this.userinterest != null) {
      data['userinterest'] = this.userinterest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockList {
  int? id;
  int? blockedBy;
  int? blockedTo;
  String? blockedAt;
  String? batch;
  String? createdAt;
  String? updatedAt;
  String? status;

  BlockList(
      {this.id,
        this.blockedBy,
        this.blockedTo,
        this.blockedAt,
        this.batch,
        this.createdAt,
        this.updatedAt,
        this.status});

  BlockList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockedBy = json['blocked_by'];
    blockedTo = json['blocked_to'];
    blockedAt = json['blocked_at'];
    batch = json['batch'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['blocked_by'] = this.blockedBy;
    data['blocked_to'] = this.blockedTo;
    data['blocked_at'] = this.blockedAt;
    data['batch'] = this.batch;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}

class Userinterest {
  int? id;
  int? userId;
  int? interestId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? interestName;
  String? interestImage;

  Userinterest(
      {this.id,
        this.userId,
        this.interestId,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.interestName,
        this.interestImage});

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
    return data;
  }
}