class UploadAudio {
  int? senderId;
  bool? status;
  String? fileLink;

  UploadAudio({this.senderId,this.status, this.fileLink});

  UploadAudio.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    status = json['status'];
    fileLink = json['file-link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['status'] = this.status;
    data['file-link'] = this.fileLink;
    return data;
  }
}