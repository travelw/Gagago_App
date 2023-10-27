class TotalRefferalResponseModel {
  bool? status;
  int? total;

  TotalRefferalResponseModel({this.status, this.total});

  TotalRefferalResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total'] = this.total;
    return data;
  }
}