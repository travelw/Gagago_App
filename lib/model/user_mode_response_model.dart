class UserModeResponseModel {
  bool? success;
  int? userMode;

  UserModeResponseModel({this.success, this.userMode});

  UserModeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userMode = json['user_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['user_mode'] = this.userMode;
    return data;
  }
}