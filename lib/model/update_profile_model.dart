class UpdateProfileModel {
  bool? success;
  String? message;
  List<UpdatedUser>? user;

  UpdateProfileModel({this.success, this.message, this.user});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['user'] != null) {
      user = <UpdatedUser>[];
      json['user'].forEach((v) {
        user!.add(new UpdatedUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdatedUser {
  int? id;
  String? email;
  String? phoneNumber;
  String? bio;
  String? sexualOrientation;
  int? styleType;
  int? travellingDuration;
  List<Userdest>? userdestinations;
  List<Userimages>? userimages;
  List<Userinter>? userinterest;

  UpdatedUser(
      {this.id,
        this.email,
        this.phoneNumber,
        this.bio,
        this.sexualOrientation,
        this.styleType,
        this.travellingDuration,
        this.userdestinations,
        this.userimages,
        this.userinterest});

  UpdatedUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    bio = json['bio'];
    sexualOrientation = json['sexual_orientation'];
    styleType = json['style_type'];
    travellingDuration = json['travelling_duration'];
    if (json['userdestinations'] != null) {
      userdestinations = <Userdest>[];
      json['userdestinations'].forEach((v) {
        userdestinations!.add(new Userdest.fromJson(v));
      });
    }
    if (json['userimages'] != null) {
      userimages = <Userimages>[];
      json['userimages'].forEach((v) {
        userimages!.add(new Userimages.fromJson(v));
      });
    }
    if (json['userinterest'] != null) {
      userinterest = <Userinter>[];
      json['userinterest'].forEach((v) {
        userinterest!.add(new Userinter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['bio'] = this.bio;
    data['sexual_orientation'] = this.sexualOrientation;
    data['style_type'] = this.styleType;
    data['travelling_duration'] = this.travellingDuration;
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

class Userdest {
  int? id;
  String? userId;
  String? destId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Userdest(
      {this.id,
        this.userId,
        this.destId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Userdest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    destId = json['dest_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dest_id'] = this.destId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

class Userinter {
  int? id;
  int? userId;
  int? interestId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Userinter(
      {this.id,
        this.userId,
        this.interestId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Userinter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['interest_id'] = this.interestId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}