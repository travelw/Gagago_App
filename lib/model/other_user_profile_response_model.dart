import 'package:gagagonew/model/user_dashboard_response_model.dart';

class OtherUserResponseModel {
  bool? status;
  OtherUser? otherUser;
  String? message;
  bool? isMeBlocked;
  int? chatCount;
  int? likeCount;
  int? notificationCount;

  OtherUserResponseModel({this.status, this.otherUser, this.message,this.isMeBlocked});

  OtherUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otherUser = json['other_user'] != null
        ? new OtherUser.fromJson(json['other_user'])
        : null;
    message = json['message'];
    isMeBlocked=json['is_me_blocked'];
    chatCount=json['chatCount'] == null? 0:json['chatCount'];
    likeCount=json['likeCount'] == null? 0: json['likeCount'];
    notificationCount=json['notificationCount'] == null? 0: json['notificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.otherUser != null) {
      data['other_user'] = this.otherUser!.toJson();
    }
    data['is_me_blocked']=this.isMeBlocked;
    data['message'] = this.message;
    data['chatCount'] = this.chatCount??0;
    data['likeCount'] = this.likeCount??0;
    data['notificationCount'] = this.notificationCount??0;
    return data;
  }
}



class OtherUser {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;
  String? gender;
  String? sexualOrientation;
  String? isShowSexualOrientation;
  String? isShowEthinicity;
  String? isShowGender;
  String? ethinicity;
  String? tripStyle;
  String? tripTimeline;
  dynamic lat;
  dynamic lng;
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
  String? ipAddress;
  String? rememberMe;
  dynamic deviceToken;
  String? loginWith;
  String? userLocked;
  String? userLockedAt;
  int? userMode;
  int? wrongAttempt;
  dynamic lastLoginAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? isLikedCount;
  num? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  List<Userdestinations>? userdestinations;
  List<Userimages>? userimages;
  List<Userinterest>? userinterest;
  List<ViewReviewStatus>? viewReviewStatus;
  UserSetting? userSetting;
  String?  commonInterest;
  String?  commonDest;
  String? connectionType;
  int? chatCountCount;
  bool? checkAlreadyReviewStatus;
  bool? isBlocked;


  OtherUser(
      {this.id,
        this.firstName,
        this.isBlocked,
        this.viewReviewStatus,
        this.commonInterest,
        this.chatCountCount,
        this.connectionType,
        this.checkAlreadyReviewStatus,
        this.commonDest,
        this.lastName,
        this.email,
        this.profilePicture,
        this.isShowSexualOrientation,
        this.isShowEthinicity,
        this.isShowGender,
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
        this.ipAddress,
        this.rememberMe,
        this.deviceToken,
        this.loginWith,
        this.userLocked,
        this.userLockedAt,
        this.userMode,
        this.wrongAttempt,
        this.lastLoginAt,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.isLikedCount,
        this.avgRating,
        this.isShowAge,
        this.isSubscriber,
        this.age,
        this.chatMatch,
        this.shareProfileLink,
        this.userdestinations,
        this.userimages,
        this.userinterest,
        this.userSetting});

  OtherUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatCountCount=json['chat_count'];
    isBlocked=json['is_blocked'];
    firstName = json['first_name'];
    isShowGender=json['is_show_gender'];
    connectionType=json['connection_type'];
    commonInterest=json['common_interest'];
    checkAlreadyReviewStatus=json['check_already_review_status'];
    commonDest=json['common_dest'];
    isShowSexualOrientation=json['is_show_sexual_orientation'];
    isShowEthinicity=json['is_show_ethinicity'];
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
    ipAddress = json['ip_address'];
    rememberMe = json['remember_me'];
    deviceToken = json['device_token'];
    loginWith = json['login_with'];
    userLocked = json['user_locked'];
    userLockedAt = json['user_locked_at'];
    userMode = json['user_mode'];
    wrongAttempt = json['wrong_attempt'];
    lastLoginAt = json['last_login_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isLikedCount = json['is_liked_count'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    age = json['age'];
    chatMatch = json['chat_match'];
    shareProfileLink = json['share_profile_link'];
    if (json['view_review_status'] != null) {
      viewReviewStatus = <ViewReviewStatus>[];
      json['view_review_status'].forEach((v) {
        viewReviewStatus!.add(new ViewReviewStatus.fromJson(v));
      });
    }
    if (json['userdestinations'] != null) {
      userdestinations = <Userdestinations>[];
      json['userdestinations'].forEach((v) {
        userdestinations!.add(new Userdestinations.fromJson(v));
      });
    }
    if (json['userimages'] != null) {
      userimages = <Userimages>[];
      json['userimages'].forEach((v) {
        userimages!.add(new Userimages.fromJson(v));
      });
    }
    if (json['userinterest'] != null) {
      userinterest = <Userinterest>[];
      json['userinterest'].forEach((v) {
        userinterest!.add(new Userinterest.fromJson(v));
      });
    }
    userSetting = json['user_setting'] != null
        ? new UserSetting.fromJson(json['user_setting'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_count']=this.chatCountCount;
    data['is_blocked']=this.isBlocked;
    data['common_interest'] = this.commonInterest;
    data['check_already_review_status']=this.checkAlreadyReviewStatus;
    data['common_dest'] = this.commonDest;
    data['is_show_sexual_orientation']=this.isShowSexualOrientation;
    data['connection_type']=this.connectionType;
    data['is_show_ethinicity']=this.isShowEthinicity;
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
    data['ip_address'] = this.ipAddress;
    data['remember_me'] = this.rememberMe;
    data['device_token'] = this.deviceToken;
    data['login_with'] = this.loginWith;
    data['user_locked'] = this.userLocked;
    data['user_locked_at'] = this.userLockedAt;
    data['user_mode'] = this.userMode;
    data['wrong_attempt'] = this.wrongAttempt;
    data['last_login_at'] = this.lastLoginAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_liked_count'] = this.isLikedCount;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
    data['is_subscriber'] = this.isSubscriber;
    data['age'] = this.age;
    data['chat_match'] = this.chatMatch;
    data['share_profile_link'] = this.shareProfileLink;
    if (this.userdestinations != null) {
      data['userdestinations'] =
          this.userdestinations!.map((v) => v.toJson()).toList();
    }
    if (this.userimages != null) {
      data['userimages'] = this.userimages!.map((v) => v.toJson()).toList();
    }
    if (this.userinterest != null) {
      data['userinterest'] = this.userinterest!.map((v) => v.toJson()).toList();
    }
    if (this.userSetting != null) {
      data['user_setting'] = this.userSetting!.toJson();
    }
    if (this.viewReviewStatus != null) {
      data['view_review_status'] =
          this.viewReviewStatus!.map((v) => v.toJson()).toList();
    }
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
        this.destImage});

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
    return data;
  }
}

class Userimages {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  dynamic imageOrder;
  dynamic tempToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Userimages(
      {this.id,
        this.userId,
        this.imageName,
        this.imageUpdatedFrom,
        this.imageOrder,
        this.tempToken,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Userimages.fromJson(Map<String, dynamic> json) {
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

class UserSetting {
  int? id;
  int? userId;
  int? isShowAge;
  int? isShowSexualOrientation;
  dynamic genderPreference;
  dynamic minAge;
  dynamic maxAge;
  dynamic ethinicityPreference;
  dynamic sexualOrientationPreference;
  dynamic tripStylePreference;
  dynamic tripTimelinePreference;
  String? createdAt;
  String? updatedAt;

  UserSetting(
      {this.id,
        this.userId,
        this.isShowAge,
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

  UserSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isShowAge = json['is_show_age'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
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



