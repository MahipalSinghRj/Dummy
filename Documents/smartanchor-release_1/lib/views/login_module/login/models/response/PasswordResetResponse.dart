class PasswordResetResponse {
  String? resultCode;
  String? resultMessage;
  String? errorCode;
  String? errorMessage;

  PasswordResetResponse({this.resultCode, this.resultMessage});

  PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultMessage = json['resultMessage'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultMessage'] = resultMessage;
    return data;
  }
}
