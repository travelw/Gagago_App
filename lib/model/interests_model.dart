class InterestsModel {
  bool? status;
  String? message;
  List<Data>? data;

  InterestsModel({this.status, this.message, this.data});

  InterestsModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? slug;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;
  List<Interest>? interest;

  Data(
      {this.id,
        this.name,
        this.slug,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.interest});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['interest'] != null) {
      interest = <Interest>[];
      json['interest'].forEach((v) {
        interest!.add(new Interest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.interest != null) {
      data['interest'] = this.interest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Interest {
  int? id;
  int? interestId;
  int? interestCategoryId;
  String? name;
  String? image;
  String? slug;
  int? status;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
  bool selected=false;

  Interest(
      {this.id,
        this.interestId,
        this.interestCategoryId,
        this.name,
        this.image,
        this.slug,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,this.selected=false});

  Interest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interestId=0;
    interestCategoryId = json['interest_category_id'];
    name = json['name'];
    image = json['image'];
    slug = json['slug'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selected=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['interest_category_id'] = this.interestCategoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}