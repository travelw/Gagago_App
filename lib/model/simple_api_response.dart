class SimpleApiResponse {
  int? status;
  bool? success;
  String? message;

  SimpleApiResponse({
    this.status,
    this.message,
    this.success,
  });

  factory SimpleApiResponse.fromJson(Map<String, dynamic> json) =>
      SimpleApiResponse(
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "success": success,
      };
}
