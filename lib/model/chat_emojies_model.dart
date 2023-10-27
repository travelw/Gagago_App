class ChatEmojiesModel {
  String? emoji;
  String? createdDate;

  ChatEmojiesModel({this.emoji, this.createdDate});

  ChatEmojiesModel.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emoji'] = this.emoji;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
