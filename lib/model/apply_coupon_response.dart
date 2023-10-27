// To parse this JSON data, do
//
//     final applyCouponResponse = applyCouponResponseFromJson(jsonString);

import 'dart:convert';

ApplyCouponResponse applyCouponResponseFromJson(String str) => ApplyCouponResponse.fromJson(json.decode(str));

String applyCouponResponseToJson(ApplyCouponResponse data) => json.encode(data.toJson());

class ApplyCouponResponse {
  int? status;
  String? message;
  int? discount;
  String? discountType;

  ApplyCouponResponse({
    this.status,
    this.message,
    this.discount,
    this.discountType,
  });

  factory ApplyCouponResponse.fromJson(Map<String, dynamic> json) => ApplyCouponResponse(
    status: json["status"],
    message: json["message"],
    discount: json["discount"],
    discountType: json["discount_type"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "discount": discount,
    "discount_type": discountType,
  };
}
