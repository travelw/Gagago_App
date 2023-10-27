import 'package:gagagonew/model/package/package_image.dart';

class MyTripsApiModel {
  int? status;
  String? message;
  List<MyTripsModel>? data;

  MyTripsApiModel({this.status, this.message, this.data});

  MyTripsApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyTripsModel>[];
      json['data'].forEach((v) {
        data!.add(MyTripsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyTripsModel {
  int? id;
  int? userId;
  int? packageId;
  int? paidAmount;
  String? paymentStatus;
  String? paymentResponse;
  int? couponId;
  int? isRefundable;
  String? createdAt;
  String? updatedAt;
  Package? package;

  MyTripsModel(
      {this.id,
      this.userId,
      this.packageId,
      this.paidAmount,
      this.paymentStatus,
      this.paymentResponse,
      this.couponId,
      this.createdAt,
      this.updatedAt,
      this.package,
      this.isRefundable});

  MyTripsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    paidAmount = json['paid_amount'];
    paymentStatus = json['payment_status'];
    paymentResponse = json['payment_response'];
    couponId = json['coupon_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isRefundable = json['is_refundable'];
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['package_id'] = packageId;
    data['paid_amount'] = paidAmount;
    data['payment_status'] = paymentStatus;
    data['payment_response'] = paymentResponse;
    data['coupon_id'] = couponId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_refundable'] = isRefundable;
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class Package {
  int? id;
  String? title;
  String? description;
  int? totalPrice;
  String? groupSize;
  String? meals;
  String? startDate;
  String? endDate;
  String? cancellationPolicy;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? averageRating;
  List<Reviews>? reviews;
  List<ImageData>? images;

  Package(
      {this.id,
      this.title,
      this.description,
      this.totalPrice,
      this.groupSize,
      this.meals,
      this.startDate,
      this.endDate,
      this.cancellationPolicy,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.averageRating,
      this.reviews,
      this.images});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    totalPrice = json['total_price'];
    groupSize = json['group_size'];
    meals = json['meals'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    cancellationPolicy = json['cancellation_policy'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    averageRating = json['average_rating'].toString();
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <ImageData>[];
      json['images'].forEach((v) {
        images!.add(ImageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['total_price'] = totalPrice;
    data['group_size'] = groupSize;
    data['meals'] = meals;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['cancellation_policy'] = cancellationPolicy;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['average_rating'] = averageRating;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? id;
  int? packageId;
  int? userId;
  int? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  String? reviewDate;

  Reviews(
      {this.id,
      this.packageId,
      this.userId,
      this.rating,
      this.review,
      this.createdAt,
      this.updatedAt,
      this.reviewDate});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    userId = json['user_id'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewDate = json['review_date'];
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
    return data;
  }
}
