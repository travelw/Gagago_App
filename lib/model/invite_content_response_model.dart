// To parse this JSON data, do
//
//     final inviteContentResponseModel = inviteContentResponseModelFromJson(jsonString);

import 'dart:convert';

InviteContentResponseModel? inviteContentResponseModelFromJson(String str) => InviteContentResponseModel.fromJson(json.decode(str));

String inviteContentResponseModelToJson(InviteContentResponseModel? data) => json.encode(data!.toJson());

class InviteContentResponseModel {
  InviteContentResponseModel({
    this.success,
    this.inviteFriendText,
  });

  bool? success;
  InviteFriendText? inviteFriendText;

  factory InviteContentResponseModel.fromJson(Map<String, dynamic> json) => InviteContentResponseModel(
    success: json["success"],
    inviteFriendText: InviteFriendText.fromJson(json["invite_friend_text"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "invite_friend_text": inviteFriendText!.toJson(),
  };
}

class InviteFriendText {
  InviteFriendText({
    this.contentEnglish,
  });

  String? contentEnglish;

  factory InviteFriendText.fromJson(Map<String, dynamic> json) => InviteFriendText(
    contentEnglish: json["content_english"],
  );

  Map<String, dynamic> toJson() => {
    "content_english": contentEnglish,
  };
}
