class DestinationModel {
  bool? status;
  String? message;
  List<Data>? data;

  DestinationModel({this.status, this.message, this.data});

  DestinationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? regionName;
  String? slug;
  String? regionStatus;
  String? createdAt;
  String? updatedAt;
  List<Countries>? countries;

  Data(
      {this.id,
        this.regionName,
        this.slug,
        this.regionStatus,
        this.createdAt,
        this.updatedAt,
        this.countries});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionName = json['region_name'];
    slug = json['slug'];
    regionStatus = json['region_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_name'] = this.regionName;
    data['slug'] = this.slug;
    data['region_status'] = this.regionStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  int? id;
  int? destId;
  String? countryName;
  String? countryImage;
  String? countryStatus;
  int? regionId;
  int? type = 0;
  dynamic deletedAt;
  dynamic createdAt;
  String? updatedAt;
  String? slug;
  List<Cities>? cities;
  bool selected=false;
  int selectedCityId=0;
  int selectedContinentId=0;
  int selectedCityIndex=-1;


  Countries(
      {this.id,
        this.destId,
        this.slug,
        this.countryName,
        this.countryImage,
        this.countryStatus,
        this.regionId,
        this.type,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.selected=false,
        this.selectedCityId=0,
        this.selectedContinentId=0,
        this.selectedCityIndex=-1,
        this.cities});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destId=0;
    type=0;
    selectedCityIndex=-1;
    countryName = json['country_name'];
    slug = json['slug'];
    countryImage = json['country_image'];
    countryStatus = json['country_status'];
    regionId = json['region_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selected=false;
    selectedCityId=0;
    selectedContinentId=0;
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['slug'] = this.slug;
    data['country_image'] = this.countryImage;
    data['country_status'] = this.countryStatus;
    data['region_id'] = this.regionId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int? id;
  int? countryId;
  String? cityName;
  String? slug;
  String? cityImage;
  String? lat;
  String? lng;
  String? cityStatus;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Cities(
      {this.id,
        this.countryId,
        this.cityName,
        this.slug,
        this.cityImage,
        this.lat,
        this.lng,
        this.cityStatus,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    cityName = json['city_name'];
    slug = json['slug'];
    cityImage = json['city_image'];
    lat = json['lat'];
    lng = json['lng'];
    cityStatus = json['city_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['city_name'] = this.cityName;
    data['slug'] = this.slug;
    data['city_image'] = this.cityImage;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city_status'] = this.cityStatus;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}