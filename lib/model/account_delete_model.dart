class AccountDeleteModel {
  bool? success;
  String? message;
  String? messageTitle;
  String? messageCaption;

  AccountDeleteModel({this.success, this.message});

  AccountDeleteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    messageTitle = json['message_title'];
    messageCaption = json['message_caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['message_title'] = this.messageTitle;
    data['message_caption'] = this.messageCaption;
    return data;
  }
}