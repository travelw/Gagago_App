import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionResponseModel {
  bool? success;
  List<Message>? message;

  SubscriptionResponseModel({this.success, this.message});

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  String? planName;
  String? planSlug;
  String? planDuration;
  String? planPrice;
  String? planStatus;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
        this.planName,
        this.planSlug,
        this.planDuration,
        this.planPrice,
        this.planStatus,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    planSlug = json['plan_slug'];
    planDuration = json['plan_duration'];
    planPrice = json['plan_price'];
    planStatus = json['plan_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_name'] = this.planName;
    data['plan_slug'] = this.planSlug;
    data['plan_duration'] = this.planDuration;
    data['plan_price'] = this.planPrice;
    data['plan_status'] = this.planStatus;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}




class SubscriptionModal{
  String id = "";
  String rawPrice = "";
  String price = "";
  String title = "";
  String duration = "";
  List<String> des = [];
  ProductDetails productItem;
  bool isSelected = false;

  SubscriptionModal({
    required this.id,
    required this.duration,
    required this.title,
    required this.price,
    required this.rawPrice,
    required this.des,
    required this.productItem,
    required this.isSelected,
  });


/*  Map<String, dynamic> toJson() => {
    "play_store_id": id.toString(),
    "price": rawPrice.toString(),
    "duration": duration.toString(),
    'description': des.toString(),
    "title" : title.toString()
  };*/

}

