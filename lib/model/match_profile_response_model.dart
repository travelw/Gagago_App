class MatchUserResponseModel {
  bool? status;
  String? message;
  List<Matches>? matches;

  MatchUserResponseModel({this.status, this.message, this.matches});

  MatchUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(new Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.matches != null) {
      data['matches'] = this.matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matches {
  int? id;
  String? name;
  int? age;
  String? address;
  String? image;

  Matches({this.id, this.name, this.age, this.address, this.image});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    address = json['address'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['address'] = this.address;
    data['image'] = this.image;
    return data;
  }
}