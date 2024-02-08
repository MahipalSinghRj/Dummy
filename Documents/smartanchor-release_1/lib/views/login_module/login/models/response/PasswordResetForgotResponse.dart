class PasswordResetForgotResponse {
  String? custemerFullName;
  String? custermerCode;
  String? errorCode;
  String? errorMessage;
  String? otpValue;
  String? userEmail;
  String? userMobile;

  PasswordResetForgotResponse({this.custemerFullName, this.custermerCode, this.errorCode, this.errorMessage, this.otpValue, this.userEmail, this.userMobile});

  PasswordResetForgotResponse.fromJson(Map<String, dynamic> json) {
    custemerFullName = json['custemerFullName'];
    custermerCode = json['custermerCode'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    otpValue = json['otpValue'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custemerFullName'] = custemerFullName;
    data['custermerCode'] = custermerCode;
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    data['otpValue'] = otpValue;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    return data;
  }
}
