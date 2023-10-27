class EditProfileModel {
  bool? success;
  List<User>? user;

  EditProfileModel({this.success, this.user});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  int? isSubscriber;
  String? isShowGender;
  String? isShowEthnicity;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? bio;
  String? isShowSexualOrientation;
  String? gender;
  String? ethinicity;
  String? sexualOrientation;
  String? tripStyle;
  String? tripTimeline;
  num? avgRating;
  String? isShowAge;
  List<Userdestinations>? userdestinations;
  List<Userimages>? userimages;
  List<Userinterest>? userinterest;

  User(
      {this.id,
        this.isSubscriber,
        this.isShowGender,
        this.ethinicity,
        this.isShowEthnicity,
        this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.bio,
        this.isShowSexualOrientation,
        this.sexualOrientation,
        this.tripStyle,
        this.tripTimeline,
        this.avgRating,
        this.gender,
        this.isShowAge,
        this.userdestinations,
        this.userimages,
        this.userinterest});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isShowSexualOrientation=json['is_show_sexual_orientation'];
    gender=json['gender'];
    ethinicity=json['ethinicity'];
    isShowEthnicity=json['is_show_ethinicity'];
    isShowGender=json['is_show_gender'];
    isSubscriber = json['is_subscriber'];
    firstName=json['first_name'];
    lastName=json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    bio = json['bio'];
    sexualOrientation = json['sexual_orientation'];
    tripStyle = json['trip_style'];
    tripTimeline = json['trip_timeline'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['gender']=this.gender;
    data['is_show_ethinicity']=this.isShowEthnicity;
    data['is_show_sexual_orientation']=this.isShowSexualOrientation;
    data['is_show_gender']=this.isShowGender;
    data['phone_number'] = this.phoneNumber;
    data['ethinicity']=this.ethinicity;
    data['bio'] = this.bio;
    data['sexual_orientation'] = this.sexualOrientation;
    data['trip_style'] = this.tripStyle;
    data['trip_timeline'] = this.tripTimeline;
    data['avg_rating'] = this.avgRating;
    data['is_show_age'] = this.isShowAge;
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
    return data;
  }
}

class Userdestinations {
  int? id;
  String? userId;
  String? destId;
  String? slug;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? destName;
  String? destImage;
  int? regionId;
  int? type;
  int selectedCityId=0;
  int selectedContinentId=0;

  Userdestinations(
      {this.id,
        this.userId,
        this.destId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.destName,
        this.destImage,
        this.type,
        this.regionId,
        this.slug,

        this.selectedCityId=0,this.selectedContinentId=0});

  Userdestinations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId = json['region_id'];
    userId = json['user_id'];
    destId = json['dest_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    destName = json['dest_name'];
    destImage = json['dest_image'];
    type = json['type'];
    slug = json['dest_slug'];
    selectedCityId=0;
    selectedContinentId=0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_id'] = this.regionId;
    data['user_id'] = this.userId;
    data['dest_id'] = this.destId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['dest_name'] = this.destName;
    data['dest_image'] = this.destImage;
    data['type'] = this.type;
    data['dest_slug'] = this.slug;
    return data;
  }
}

class Userimages {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  dynamic tempToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Userimages(
      {this.id,
        this.userId,
        this.imageName,
        this.imageUpdatedFrom,
        this.tempToken,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Userimages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageName = json['image_name'];
    imageUpdatedFrom = json['image_updated_from'];
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
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? interestName;
  String? interestImage;

  Userinterest(
      {this.id,
        this.userId,
        this.interestId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.interestName,
        this.interestImage});

  Userinterest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
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
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['interest_name'] = this.interestName;
    data['interest_image'] = this.interestImage;
    return data;
  }
}