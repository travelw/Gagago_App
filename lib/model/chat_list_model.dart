class ChatListModel {
  int? status;
  List<Data>? data;
  bool? flag;
  int? page;

  ChatListModel({this.status, this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    flag = json['flag'];
    page = json['page'];
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
    data['flag'] = this.flag;
    data['page'] = this.page;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? senderId;
  int? receiverId;
  int? messageUnreadCount;
  bool? isBlocked;
  bool? isRemoveConnection;
  bool? isMeBlocked;
  dynamic chatDeletedBySenderId;
  dynamic chatDeletedByRecieverId;
  dynamic createdAt;
  dynamic updatedAt;
  String? receiverName;
  String? senderName;
  List<ReceiverImage>? receiverImage;
  List<SenderImage>? senderImage;
  LastMessage? lastMessage;
  String? connectionType;
  String? commonDestination;
  String? commonInterest;
  Data(
      {this.id,
        this.senderId,
        this.receiverId,
        this.isBlocked,
        this.isMeBlocked,
        this.isRemoveConnection,
        this.messageUnreadCount,
        this.chatDeletedBySenderId,
        this.chatDeletedByRecieverId,
        this.commonDestination,
        this.commonInterest,
        this.createdAt,
        this.connectionType,
        this.updatedAt,
        this.receiverName,
        this.senderName,
        this.receiverImage,
        this.senderImage,
        this.lastMessage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    isMeBlocked = json['is_me_blocked'];
    messageUnreadCount = json['message_unread_count'];
    isBlocked = json['is_blocked'];
    isRemoveConnection = json['is_remove_connection'];
    connectionType = json['connection_type'];
    commonDestination = json['common_destination'];
    commonInterest = json['common_interest'];
    chatDeletedBySenderId = json['chat_deleted_by_sender_id'];
    chatDeletedByRecieverId = json['chat_deleted_by_reciever_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    receiverName = json['receiver_name'];
    senderName = json['sender_name'];
    if (json['receiver_image'] != null) {
      receiverImage = <ReceiverImage>[];
      json['receiver_image'].forEach((v) {
        receiverImage!.add(new ReceiverImage.fromJson(v));
      });
    }
    if (json['sender_image'] != null) {
      senderImage = <SenderImage>[];
      json['sender_image'].forEach((v) {
        senderImage!.add(new SenderImage.fromJson(v));
      });
    }
    lastMessage = json['last_message'] != null ? new LastMessage.fromJson(json['last_message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['is_blocked'] = this.isBlocked;
    data['is_me_blocked'] = this.isMeBlocked;
    data['is_remove_connection'] = this.isRemoveConnection;
    data['receiver_id'] = this.receiverId;
    data['connection_type'] = this.connectionType;
    data['common_destination'] = this.commonDestination;
    data['common_interest'] = this.commonInterest;
    data['chat_deleted_by_sender_id'] = this.chatDeletedBySenderId;
    data['chat_deleted_by_reciever_id'] = this.chatDeletedByRecieverId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['receiver_name'] = this.receiverName;
    data['sender_name'] = this.senderName;
    data['message_unread_count'] = this.messageUnreadCount;
    if (this.receiverImage != null) {
      data['receiver_image'] = this.receiverImage!.map((v) => v.toJson()).toList();
    }
    if (this.senderImage != null) {
      data['sender_image'] = this.senderImage!.map((v) => v.toJson()).toList();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    return data;
  }
}

class ReceiverImage {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  dynamic imageOrder;
  dynamic tempToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  ReceiverImage({this.id, this.userId, this.imageName, this.imageUpdatedFrom, this.imageOrder, this.tempToken, this.deletedAt, this.createdAt, this.updatedAt});

  ReceiverImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageName = json['image_name'];
    imageUpdatedFrom = json['image_updated_from'];
    imageOrder = json['image_order'];
    tempToken = json['temp_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image_name'] = this.imageName;
    data['image_updated_from'] = this.imageUpdatedFrom;
    data['image_order'] = this.imageOrder;
    data['temp_token'] = this.tempToken;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SenderImage {
  int? id;
  int? userId;
  String? imageName;
  String? imageUpdatedFrom;
  dynamic imageOrder;
  dynamic tempToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  SenderImage({this.id, this.userId, this.imageName, this.imageUpdatedFrom, this.imageOrder, this.tempToken, this.deletedAt, this.createdAt, this.updatedAt});

  SenderImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageName = json['image_name'];
    imageUpdatedFrom = json['image_updated_from'];
    imageOrder = json['image_order'];
    tempToken = json['temp_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image_name'] = this.imageName;
    data['image_updated_from'] = this.imageUpdatedFrom;
    data['image_order'] = this.imageOrder;
    data['temp_token'] = this.tempToken;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class LastMessage {
  int? id;
  int? senderId;
  int? receiverId;
  int? chatHeadId;
  String? message;
  String? messageType;
  String? userImage;
  int? status;
  int? deleteFlag;
  int? deleteBySender;
  int? deleteByReceiver;
  int? isRead;
  String? messageDate;
  String? createdAt;
  String? updatedAt;

  LastMessage(
      {this.id,
        this.senderId,
        this.receiverId,
        this.chatHeadId,
        this.message,
        this.messageType,
        this.userImage,
        this.status,
        this.deleteFlag,
        this.deleteBySender,
        this.deleteByReceiver,
        this.isRead,
        this.messageDate,
        this.createdAt,
        this.updatedAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    chatHeadId = json['chat_head_id'];
    message = json['message'];
    messageType = json['message_type'];
    userImage = json['user_image'];
    status = json['status'];
    deleteFlag = json['delete_flag'];
    deleteBySender = json['delete_by_sender'];
    deleteByReceiver = json['delete_by_receiver'];
    isRead = json['is_read'];
    messageDate = json['message_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['chat_head_id'] = this.chatHeadId;
    data['message'] = this.message;
    data['message_type'] = this.messageType;
    data['user_image'] = this.userImage;
    data['status'] = this.status;
    data['delete_flag'] = this.deleteFlag;
    data['delete_by_sender'] = this.deleteBySender;
    data['delete_by_receiver'] = this.deleteByReceiver;
    data['is_read'] = this.isRead;
    data['message_date'] = this.messageDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
