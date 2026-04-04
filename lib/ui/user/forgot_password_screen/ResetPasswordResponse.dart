class ResetPasswordResponse {
  String? message;

  ResetPasswordResponse({this.message});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() => {'message': message};
}