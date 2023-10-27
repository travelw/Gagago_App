// To parse this JSON data, do
//
//     final packageListModel = packageListModelFromJson(jsonString);

import 'dart:convert';

import 'package:gagagonew/model/UserDataModel.dart';
import 'package:gagagonew/model/package/package_image.dart';

PackageListModel packageListModelFromJson(String str) => PackageListModel.fromJson(json.decode(str));

String packageListModelToJson(PackageListModel data) => json.encode(data.toJson());

class PackageListModel {
  int? status;
  String? message;
  List<PackageListModelData>? data;

  PackageListModel({
    this.status,
    this.message,
    this.data,
  });

  factory PackageListModel.fromJson(Map<String, dynamic> json) => PackageListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PackageListModelData>.from(json["data"]!.map((x) => PackageListModelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PackageListModelData {
  int? id;
  String? title;
  String? description;
  String? groupSize;
  int? totalPrice;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  String? cancellationPolicy;
  String? meals;
  String? averageRating;
  int? currentIndex;
  int? reviewsCount;
  int? isAlreadyBooked;
  int? isCouponApplied;
  int? firstPaymentAmount;
  int? secondPaymentAmount;
  int? isFirstPaymentDone;
  int? isSecondPaymentDone;
  int? paidAmount;
  int? remainingAmount;
  int? isCancellable;
  int? isRefundable;

  List<ItineraryData>? activities;
  List<ItineraryData>? inclusions;
  List<ItineraryData>? exclusions;
  List<ItineraryData>? itineraries;
  List<ItineraryData>? mapMarkers;
  List<ServiceElement>? services;
  List<VoucherElement>? vouchers;
  List<ImageData>? images;
  List<Reviews>? reviews;
  String? appliedCouponCode;
  int? couponDiscount;

  PackageListModelData({
    this.id,
    this.title,
    this.description,
    this.groupSize,
    this.totalPrice,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.averageRating,
    this.services,
    this.activities,
    this.inclusions,
    this.exclusions,
    this.itineraries,
    this.mapMarkers,
    this.cancellationPolicy,
    this.meals,
    this.vouchers,
    this.images,
    this.currentIndex,
    this.reviewsCount,
    this.reviews,
    this.appliedCouponCode,
    this.couponDiscount,
    this.isAlreadyBooked,
    this.isCouponApplied,
    this.firstPaymentAmount,
    this.secondPaymentAmount,
    this.paidAmount,
    this.remainingAmount,
    this.isFirstPaymentDone,
    this.isSecondPaymentDone,
    this.isCancellable,
    this.isRefundable
  });

  factory PackageListModelData.fromJson(Map<String, dynamic> json) => PackageListModelData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        groupSize: json["group_size"],
        totalPrice: json["total_price"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        status: json["status"].toString(),
        cancellationPolicy: json["cancellation_policy"],
        meals: json["meals"],
        averageRating: json["average_rating"].toString(),
        reviewsCount: json["reviews_count"],
        isAlreadyBooked: json["is_already_booked"],
        isCouponApplied: json["is_coupon_applied"],
        firstPaymentAmount: json["first_payment_amount"],
        secondPaymentAmount: json["second_payment_amount"],
        paidAmount: json["paid_amount"],
        remainingAmount: json["remaining_amount"],
        services: json["services"] == null ? [] : List<ServiceElement>.from(json["services"]!.map((x) => ServiceElement.fromJson(x))),
        activities: json["activities"] == null ? [] : List<ItineraryData>.from(json["activities"]!.map((x) => ItineraryData.fromJson(x))),
        inclusions: json["inclusions"] == null ? [] : List<ItineraryData>.from(json["inclusions"]!.map((x) => ItineraryData.fromJson(x))),
        exclusions: json["exclusions"] == null ? [] : List<ItineraryData>.from(json["exclusions"]!.map((x) => ItineraryData.fromJson(x))),
        itineraries: json["itineraries"] == null ? [] : List<ItineraryData>.from(json["itineraries"]!.map((x) => ItineraryData.fromJson(x))),
        mapMarkers: json["map_markers"] == null ? [] : List<ItineraryData>.from(json["map_markers"]!.map((x) => ItineraryData.fromJson(x))),
        vouchers: json["vouchers"] == null ? [] : List<VoucherElement>.from(json["vouchers"]!.map((x) => VoucherElement.fromJson(x))),
        images: json["images"] == null ? [] : List<ImageData>.from(json["images"]!.map((x) => ImageData.fromJson(x))),
        reviews: json["reviews"] == null ? [] : List<Reviews>.from(json["reviews"]!.map((x) => Reviews.fromJson(x))),
        appliedCouponCode: json["appliedCoupon"],
        isFirstPaymentDone: json["is_first_payment_done"],
        isSecondPaymentDone: json["is_second_payment_done"],
        isCancellable: json["is_cancellable"] == null?0:json["is_cancellable"],
        isRefundable: json["is_refundable"] == null?0:json["is_refundable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "group_size": groupSize,
        "total_price": totalPrice,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "cancellation_policy": cancellationPolicy,
        "meals": meals,
        "average_rating": averageRating,
        "reviews_count": reviewsCount,
        "activities": activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
        "inclusions": inclusions == null ? [] : List<dynamic>.from(inclusions!.map((x) => x.toJson())),
        "exclusions": exclusions == null ? [] : List<dynamic>.from(exclusions!.map((x) => x.toJson())),
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
        "itineraries": itineraries == null ? [] : List<dynamic>.from(itineraries!.map((x) => x.toJson())),
        "map_markers": mapMarkers == null ? [] : List<dynamic>.from(mapMarkers!.map((x) => x.toJson())),
        "vouchers": vouchers == null ? [] : List<dynamic>.from(vouchers!.map((x) => x.toJson())),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "reviews": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "appliedCoupon": appliedCouponCode,
        "is_already_booked": isAlreadyBooked,
        "is_coupon_applied": isCouponApplied,
        "first_payment_amount": firstPaymentAmount,
        "second_payment_amount": secondPaymentAmount,
        "paid_amount": paidAmount,
        "remaining_amount": remainingAmount,
        "is_cancellable": isCancellable,
        "is_refundable": isRefundable ?? 0,
        "is_first_payment_done": isFirstPaymentDone ?? 0,
        "is_second_payment_done": isSecondPaymentDone ?? 0,
      };

  String getTotalCalculate() {
    if (services != null) {
      int price = 0;
      for (int i = 0; i < services!.length; i++) {
        if (services![i].service != null) {
          if (services![i].service!.isSelected) {
            price = price + services![i].service!.price!;
          }
        }
      }

      price = price + (totalPrice ?? 0);
      if (couponDiscount != null) {
        price = (price - couponDiscount!).round();
      }

      return "$price";
    }

    return "$totalPrice";
  }

  String getPayableCalculate() {
    if (services != null) {
      int price = 0;
      for (int i = 0; i < services!.length; i++) {
        if (services![i].service != null) {
          if (services![i].service!.isSelected) {
            price = price + services![i].service!.price!;
          }
        }
      }

      price = price + (totalPrice ?? 0);
      if (couponDiscount != null) {
        price = (price - couponDiscount!).round();
      }

      return "$price";
    }

    return "$totalPrice";
  }

  int getAddonCalculate() {
    int addOnPrice = 0;
    if (services != null) {
      for (int i = 0; i < services!.length; i++) {
        if (services![i].service != null) {
          if (services![i].service!.isSelected) {
            addOnPrice = (addOnPrice + services![i].service!.price!).round();
          }
        }
      }
    }
    return addOnPrice;
  }
}

class ItineraryData {
  int? id;
  String? title;
  String? description;
  String? address;
  String? lat;
  String? lng;
  int? packageId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ItineraryData({
    this.id,
    this.title,
    this.description,
    this.address,
    this.lat,
    this.lng,
    this.packageId,
    this.createdAt,
    this.updatedAt,
  });

  factory ItineraryData.fromJson(Map<String, dynamic> json) => ItineraryData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        packageId: json["package_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "address": address,
        "lat": lat,
        "lng": lng,
        "package_id": packageId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ServiceElement {
  int? id;
  int? packageId;
  int? additionalServiceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ServiceService? service;
  int? isApplied;

  ServiceElement({
    this.id,
    this.packageId,
    this.additionalServiceId,
    this.createdAt,
    this.updatedAt,
    this.service,
    this.isApplied,
  });

  factory ServiceElement.fromJson(Map<String, dynamic> json) => ServiceElement(
        id: json["id"],
        packageId: json["package_id"],
        additionalServiceId: json["additional_service_id"],
        isApplied: json["is_applied"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        service: json["service"] == null ? null : ServiceService.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "is_applied": isApplied,
        "additional_service_id": additionalServiceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service": service?.toJson(),
      };
}

class ServiceService {
  int? id;
  String? title;
  String? description;
  dynamic image;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isSelected = false;

  ServiceService({
    this.id,
    this.title,
    this.description,
    this.image,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceService.fromJson(Map<String, dynamic> json) => ServiceService(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class VoucherElement {
  int? id;
  int? packageId;
  int? voucherId;
  DateTime? createdAt;
  DateTime? updatedAt;
  VoucherVoucher? voucher;

  VoucherElement({
    this.id,
    this.packageId,
    this.voucherId,
    this.createdAt,
    this.updatedAt,
    this.voucher,
  });

  factory VoucherElement.fromJson(Map<String, dynamic> json) => VoucherElement(
        id: json["id"],
        packageId: json["package_id"],
        voucherId: json["voucher_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        voucher: json["voucher"] == null ? null : VoucherVoucher.fromJson(json["voucher"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "voucher_id": voucherId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "voucher": voucher?.toJson(),
      };
}

class VoucherVoucher {
  int? id;
  String? title;
  String? description;
  String? image;
  int? discountType;
  int? discount;
  dynamic startDate;
  dynamic endDate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  VoucherVoucher({
    this.id,
    this.title,
    this.description,
    this.image,
    this.discountType,
    this.discount,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory VoucherVoucher.fromJson(Map<String, dynamic> json) => VoucherVoucher(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        discountType: json["discount_type"],
        discount: json["discount"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "discount_type": discountType,
        "discount": discount,
        "start_date": startDate,
        "end_date": endDate,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Reviews {
  int? id;
  int? packageId;
  int? userId;
  String? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  String? reviewDate;
  UserDataModel? user;

  Reviews({this.id, this.packageId, this.userId, this.rating, this.review, this.createdAt, this.updatedAt, this.reviewDate, this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    userId = json['user_id'];
    rating = json['rating'].toString();
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewDate = json['review_date'];
    user = json['user'] != null ? UserDataModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['user_id'] = userId;
    data['rating'] = rating;
    data['review'] = review;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['review_date'] = reviewDate;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
