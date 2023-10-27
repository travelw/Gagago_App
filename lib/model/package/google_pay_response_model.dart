// To parse this JSON data, do
//
//     final googlePayResponseModel = googlePayResponseModelFromJson(jsonString);

import 'dart:convert';

GooglePayResponseModel googlePayResponseModelFromJson(String str) => GooglePayResponseModel.fromJson(json.decode(str));

String googlePayResponseModelToJson(GooglePayResponseModel data) => json.encode(data.toJson());

class GooglePayResponseModel {
  int? apiVersion;
  int? apiVersionMinor;
  PaymentMethodData? paymentMethodData;

  GooglePayResponseModel({
    this.apiVersion,
    this.apiVersionMinor,
    this.paymentMethodData,
  });

  factory GooglePayResponseModel.fromJson(Map<String, dynamic> json) => GooglePayResponseModel(
    apiVersion: json["apiVersion"],
    apiVersionMinor: json["apiVersionMinor"],
    paymentMethodData: json["paymentMethodData"] == null ? null : PaymentMethodData.fromJson(json["paymentMethodData"]),
  );

  Map<String, dynamic> toJson() => {
    "apiVersion": apiVersion,
    "apiVersionMinor": apiVersionMinor,
    "paymentMethodData": paymentMethodData?.toJson(),
  };
}

class PaymentMethodData {
  String? description;
  Info? info;
  TokenizationData? tokenizationData;
  String? type;

  PaymentMethodData({
    this.description,
    this.info,
    this.tokenizationData,
    this.type,
  });

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) => PaymentMethodData(
    description: json["description"],
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
    tokenizationData: json["tokenizationData"] == null ? null : TokenizationData.fromJson(json["tokenizationData"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "info": info?.toJson(),
    "tokenizationData": tokenizationData?.toJson(),
    "type": type,
  };
}

class Info {
  BillingAddress? billingAddress;
  String? cardDetails;
  String? cardNetwork;

  Info({
    this.billingAddress,
    this.cardDetails,
    this.cardNetwork,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    billingAddress: json["billingAddress"] == null ? null : BillingAddress.fromJson(json["billingAddress"]),
    cardDetails: json["cardDetails"],
    cardNetwork: json["cardNetwork"],
  );

  Map<String, dynamic> toJson() => {
    "billingAddress": billingAddress?.toJson(),
    "cardDetails": cardDetails,
    "cardNetwork": cardNetwork,
  };
}

class BillingAddress {
  String? address1;
  String? address2;
  String? address3;
  String? administrativeArea;
  String? countryCode;
  String? locality;
  String? name;
  String? phoneNumber;
  String? postalCode;
  String? sortingCode;

  BillingAddress({
    this.address1,
    this.address2,
    this.address3,
    this.administrativeArea,
    this.countryCode,
    this.locality,
    this.name,
    this.phoneNumber,
    this.postalCode,
    this.sortingCode,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    address1: json["address1"],
    address2: json["address2"],
    address3: json["address3"],
    administrativeArea: json["administrativeArea"],
    countryCode: json["countryCode"],
    locality: json["locality"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    postalCode: json["postalCode"],
    sortingCode: json["sortingCode"],
  );

  Map<String, dynamic> toJson() => {
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "administrativeArea": administrativeArea,
    "countryCode": countryCode,
    "locality": locality,
    "name": name,
    "phoneNumber": phoneNumber,
    "postalCode": postalCode,
    "sortingCode": sortingCode,
  };
}

class TokenizationData {
  String? token;
  String? type;

  TokenizationData({
    this.token,
    this.type,
  });

  factory TokenizationData.fromJson(Map<String, dynamic> json) => TokenizationData(
    token: json["token"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "type": type,
  };
}
