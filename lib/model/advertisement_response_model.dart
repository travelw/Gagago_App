class AdvertisementResponseModel {
  bool? status;
  List<AdvertisementList>? advertisementList;
  AdvertisementSetting? advertisementSetting;

  AdvertisementResponseModel({this.status, this.advertisementList});

  AdvertisementResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    advertisementSetting = json['advertisement_setting'] != null ? AdvertisementSetting.fromJson(json['advertisement_setting']) : null;

    if (json['advertisement_list'] != null) {
      advertisementList = <AdvertisementList>[];
      json['advertisement_list'].forEach((v) {
        advertisementList!.add(new AdvertisementList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['advertisement_setting'] = this.advertisementSetting!.toJson();

    if (this.advertisementList != null) {
      data['advertisement_list'] = this.advertisementList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdvertisementList {
  int? id;
  String? advTxt;
  String? advDescription;
  String? advImage;
  String? advActionUrl;
  int? advStatus;
  int? advShowArea;
  String? advShowBtw;
  int? addedBy;
  int? marketingUserId;
  int? isApproved;
  int? isBlocked;
  String? createdAt;
  String? updatedAt;

  AdvertisementList(
      {this.id,
        this.advTxt,
        this.advDescription,
        this.advImage,
        this.advActionUrl,
        this.advStatus,
        this.advShowArea,
        this.advShowBtw,
        this.addedBy,
        this.marketingUserId,
        this.isApproved,
        this.isBlocked,
        this.createdAt,
        this.updatedAt});

  AdvertisementList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advTxt = json['adv_txt'];
    advDescription = json['adv_description'];
    advImage = json['adv_image'];
    advActionUrl = json['adv_action_url'];
    advStatus = json['adv_status'];
    advShowArea = json['adv_show_area'];
    advShowBtw = json['adv_show_btw'];
    addedBy = json['added_by'];
    marketingUserId = json['marketing_user_id'];
    isApproved = json['is_approved'];
    isBlocked = json['is_blocked'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adv_txt'] = this.advTxt;
    data['adv_description'] = this.advDescription;
    data['adv_image'] = this.advImage;
    data['adv_action_url'] = this.advActionUrl;
    data['adv_status'] = this.advStatus;
    data['adv_show_area'] = this.advShowArea;
    data['adv_show_btw'] = this.advShowBtw;
    data['added_by'] = this.addedBy;
    data['marketing_user_id'] = this.marketingUserId;
    data['is_approved'] = this.isApproved;
    data['is_blocked'] = this.isBlocked;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AdvertisementSetting {
  AdvertisementSetting({
    this.id,
    this.inDashboardHowAnyUsersAfterShowAdd,
    this.inChatHowAnyMessagesAfterShowAdd,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? inDashboardHowAnyUsersAfterShowAdd;
  String? inChatHowAnyMessagesAfterShowAdd;
  dynamic createdAt;
  DateTime? updatedAt;

  factory AdvertisementSetting.fromJson(Map<String, dynamic> json) => AdvertisementSetting(
    id: json["id"] == null ? null : json["id"],
    inDashboardHowAnyUsersAfterShowAdd: json["in_dashboard_how_any_users_after_show_add"] == null ? null : json["in_dashboard_how_any_users_after_show_add"],
    inChatHowAnyMessagesAfterShowAdd: json["in_chat_how_any_messages_after_show_add"] == null ? null : json["in_chat_how_any_messages_after_show_add"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "in_dashboard_how_any_users_after_show_add": inDashboardHowAnyUsersAfterShowAdd == null ? null : inDashboardHowAnyUsersAfterShowAdd,
    "in_chat_how_any_messages_after_show_add": inChatHowAnyMessagesAfterShowAdd == null ? null : inChatHowAnyMessagesAfterShowAdd,
    "created_at": createdAt,
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
