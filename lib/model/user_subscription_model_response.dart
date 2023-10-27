class UserSubscriptionResponseModel {
  bool? status;
  Plan? plan;

  UserSubscriptionResponseModel({this.status, this.plan});

  UserSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}

class Plan {
  int? id;
  String? userId;
  String? planId;
  String? planStartDate;
  String? planEndDate;
  String? status;
  int? autoRenewal;
  String? cancelAt;
  String? startAt;
  String? endAt;
  String? planDuration;
  String? planPrice;
  String? planName;

  Plan(
      {this.id,
        this.userId,
        this.planId,
        this.planStartDate,
        this.planEndDate,
        this.status,
        this.autoRenewal,
        this.cancelAt,
        this.startAt,
        this.endAt,
        this.planDuration,
        this.planPrice,
        this.planName});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    planStartDate = json['plan_start_date'];
    planEndDate = json['plan_end_date'];
    status = json['status'];
    autoRenewal = json['auto_renewal'];
    cancelAt = json['cancel_at'];
    startAt = json['startAt'];
    endAt = json['endAt'];
    planDuration = json['planDuration'];
    planPrice = json['planPrice'];
    planName = json['planName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['plan_start_date'] = this.planStartDate;
    data['plan_end_date'] = this.planEndDate;
    data['status'] = this.status;
    data['auto_renewal'] = this.autoRenewal;
    data['cancel_at'] = this.cancelAt;
    data['startAt'] = this.startAt;
    data['endAt'] = this.endAt;
    data['planDuration'] = this.planDuration;
    data['planPrice'] = this.planPrice;
    data['planName'] = this.planName;
    return data;
  }
}


