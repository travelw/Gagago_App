class UserDataModel {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;
  int? avgRating;
  String? isShowAge;
  int? isSubscriber;
  int? age;
  int? chatMatch;
  String? shareProfileLink;
  String? isShowSexualOrientation;
  String? isShowGender;
  String? isShowEthinicity;
  String? connectionType;
  bool? isNew;
  bool? checkAlreadyReviewStatus;
  bool? isBlocked;

  UserDataModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.avgRating,
        this.isShowAge,
        this.isSubscriber,
        this.age,
        this.chatMatch,
        this.shareProfileLink,
        this.isShowSexualOrientation,
        this.isShowGender,
        this.isShowEthinicity,
        this.connectionType,
        this.isNew,
        this.checkAlreadyReviewStatus,
        this.isBlocked,
        });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
    avgRating = json['avg_rating'];
    isShowAge = json['is_show_age'];
    isSubscriber = json['is_subscriber'];
    age = json['age'];
    chatMatch = json['chat_match'];
    shareProfileLink = json['share_profile_link'];
    isShowSexualOrientation = json['is_show_sexual_orientation'];
    isShowGender = json['is_show_gender'];
    isShowEthinicity = json['is_show_ethinicity'];
    connectionType = json['connection_type'];
    isNew = json['is_new'];
    checkAlreadyReviewStatus = json['check_already_review_status'];
    isBlocked = json['is_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_picture'] = profilePicture;
    data['avg_rating'] = avgRating;
    data['is_show_age'] = isShowAge;
    data['is_subscriber'] = isSubscriber;
    data['age'] = age;
    data['chat_match'] = chatMatch;
    data['share_profile_link'] = shareProfileLink;
    data['is_show_sexual_orientation'] = isShowSexualOrientation;
    data['is_show_gender'] = isShowGender;
    data['is_show_ethinicity'] = isShowEthinicity;
    data['connection_type'] = connectionType;
    data['is_new'] = isNew;
    data['check_already_review_status'] = checkAlreadyReviewStatus;
    data['is_blocked'] = isBlocked;
    return data;
  }
}