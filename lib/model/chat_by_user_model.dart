import 'package:gagagonew/model/advertisement_response_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert' as convert;

class ChatByUserModel {
  int? status;
  Data? data;

  ChatByUserModel({
    this.status,
    this.data,
  });

  ChatByUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  List<Chats>? chats;
  bool? chatFlag;
  int? totalRecords = 0;

  Data({this.user, this.chats, this.chatFlag, this.totalRecords});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    chatFlag = json['flag'] == null ? false : json['flag'];
    totalRecords = json['total_records'] == null ? false : json['total_records'];

    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(new Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.chatFlag != null ? chatFlag : false;
    data['total_records'] = this.totalRecords != null ? totalRecords : 0;

    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
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
  String? meetNowAddress;
  String? meetNowLng;
  String? meetNowLat;
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

  UserProfile({this.id, this.userId, this.imageName, this.imageUpdatedFrom, this.imageOrder, this.tempToken, this.deletedAt, this.createdAt, this.updatedAt});

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

class Chats {
  int? id;
  int? senderId;
  int? receiverId;
  int? chatHeadId;
  String? message;
  String? messageType;
  String? userImage;
  int? status;
  String? audioDuration;
  int? deleteFlag;
  int? deleteBySender;
  int? deleteByReceiver;
  int? isRead;
  String? messageDate;
  String? seenAt;
  String? createdAt;
  String? updatedAt;
  RepliedToInfo? repliedToInfo;
  int? repliedTo;
  bool? chatFlag;
  bool? chatStopped;
  AdvertisementList? ads;

  AudioPlayer? audioPlayer;
  Duration? duration;
  Duration? position;
  bool? isPlaying;
  bool? isLoading;
  bool? isPause;
  List<ReactionsData>? reactions;

  Chats(
      {this.id,
      this.senderId,
      this.chatFlag,
      this.receiverId,
      this.repliedTo,
      this.chatHeadId,
      this.message,
      this.messageType,
      this.userImage,
      this.status,
      this.deleteFlag,
      this.deleteBySender,
      this.deleteByReceiver,
      this.isRead,
      this.messageDate,
      this.audioDuration,
      this.seenAt,
      this.repliedToInfo,
      this.createdAt,
      this.updatedAt,
      this.chatStopped,
      this.ads,
      this.audioPlayer,
      this.duration,
      this.position,
      this.isPlaying,
      this.isLoading,
      this.isPause,
      this.reactions});

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'] == null
        ? null
        : json['sender_id'] is int
            ? json['sender_id']
            : int.parse(json['sender_id']);
    chatFlag = json['chat_flag'] == null ? true : json['chat_flag'];

    receiverId = json['receiver_id'] == null
        ? null
        : json['receiver_id'] is int
            ? json['receiver_id']
            : int.parse(json['receiver_id']);
    chatHeadId = json['chat_head_id'];
    repliedTo = json['replied_to'];
    message = json['message'];
    messageType = json['message_type'];
    userImage = json['user_image'];
    status = json['status'];
    audioDuration = json['audio_duration'] == null ? null : json['audio_duration'];

    deleteFlag = json['delete_flag'];
    deleteBySender = json['delete_by_sender'];
    deleteByReceiver = json['delete_by_receiver'];
    isRead = json['is_read'];
    messageDate = json['message_date'];
    seenAt = json['seen_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    chatStopped = json['chat_stopped'] == null ? false : json['chat_stopped'];
    if (json['reactions'] != null) {
      reactions = <ReactionsData>[];

      if (json['reactions'] is List) {
        json['reactions'].forEach((v) {
          reactions!.add(ReactionsData.fromJson(v));
        });
      } else {
        convert.json.decode(json['reactions']).forEach((v) {
          reactions!.add(ReactionsData.fromJson(convert.json.decode(convert.json.encode(v))));
        });
      }
      /*  var rawReactions = <ReactionsData>[];

      for (int i = 0; i <reactions!.length; i++) {
        if(rawReactions.isEmpty){
          rawReactions.add(reactions![i]);

        } else {
          for (var element in rawReactions) {
            if(element.reaction != reactions![i].reaction){
              rawReactions.add(reactions![i]);
            }
          }
        }
      }

      reactions!.clear();

      reactions!.addAll(rawReactions);*/
    }

    if (json['replied_to_info'] != null) {
      print(" ---------- >    ${json['replied_to_info'].toString()}");
      if (json['replied_to_info'] is List) {
        print("under iffff   ${json['replied_to_info'].first}");
        repliedToInfo = RepliedToInfo.fromJson(json['replied_to_info'].first);
      } else {
        print("under else   ${json['replied_to_info']}");

        repliedToInfo = RepliedToInfo.fromJson(json['replied_to_info']);
      }
    }

    /*   if (json['chat_head'] != null) {
      print(" chat_head ---------- >    ${json['chat_head'].toString()}");
      chatHead = ChatHeadModel.fromJson(json['chat_head']);
      print(" chatHead ---------- >    ${chatHead.toString()}");
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['chat_flag'] = this.chatFlag == null ? true : this.chatFlag;
    data['receiver_id'] = this.receiverId;
    data['chat_head_id'] = this.chatHeadId;
    data['replied_to'] = this.repliedTo;
    data['message'] = this.message;
    data['message_type'] = this.messageType;
    data['user_image'] = this.userImage;
    data['status'] = this.status;
    data['audio_duration'] = this.audioDuration;
    data['delete_flag'] = this.deleteFlag;
    data['delete_by_sender'] = this.deleteBySender;
    data['delete_by_receiver'] = this.deleteByReceiver;
    data['is_read'] = this.isRead;
    data['message_date'] = this.messageDate;
    data['seen_at'] = this.seenAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['chat_stopped'] = this.chatStopped == null ? false : this.chatStopped;
    data['reactions'] = this.reactions!.map((v) => v.toJson()).toList();

    if (this.repliedToInfo != null) {
      data['replied_to_info'] = this.repliedToInfo!.toJson();
    }
/*    if (this.chatHead != null) {
      data['chat_head'] = this.chatHead!.toJson();
    }*/
    return data;
  }
}

class ChatHeadModel {
  int? id;
  int? senderId;
  int? receiverId;

  ChatHeadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    return data;
  }
}

class ReactionsData {
  String? id;
  String? senderId;
  String? messageId;
  String? reaction;
  String? userId;
  String? createdAt;

  ReactionsData({this.id, this.senderId, this.messageId, this.reaction, this.createdAt, this.userId});

  ReactionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    senderId = json['senderId'];
    userId = json['user_id'].toString();
    messageId = json['messageId'];
    reaction = json['reaction'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['messageId'] = this.messageId;
    data['reaction'] = this.reaction;
    data['user_id'] = this.userId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class RepliedToInfo {
  String? message;
  String? messageType;
  String? audioDuration;

  RepliedToInfo({this.message, this.messageType});

  RepliedToInfo.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    audioDuration = json['audio_duration'];
    messageType = json['message_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['audio_duration'] = this.audioDuration;
    data['message_type'] = this.messageType;
    return data;
  }
}
