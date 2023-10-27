class LikeResponseModel {
  bool? status;
  String? message;
  String? notificationType;
  int? connestionStatus;

  LikeResponseModel({this.status, this.message});

  LikeResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notificationType=json['notification_Type'];
    connestionStatus=json['connestion_status'] == null ? null :json['connestion_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['notification_Type']=this.notificationType;
    data['connestion_status']=this.connestionStatus;
    return data;
  }
}