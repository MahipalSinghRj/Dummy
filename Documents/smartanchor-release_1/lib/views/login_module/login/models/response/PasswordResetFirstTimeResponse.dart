class PasswordResetFirstTimeResponse {
  String? password;
  String? restFlag;
  String? errorCode;
  String? errorMessage;

  PasswordResetFirstTimeResponse({this.password, this.restFlag});

  PasswordResetFirstTimeResponse.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    restFlag = json['restFlag'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['restFlag'] = restFlag;
    return data;
  }
}
