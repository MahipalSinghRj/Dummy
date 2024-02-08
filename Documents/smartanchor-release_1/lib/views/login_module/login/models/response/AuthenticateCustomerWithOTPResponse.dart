class AuthenticateCustomerWithOTPResponse {
  String? custemerFullName;
  String? custermerCode;
  String? userEmail;
  String? userMobile;
  String? errorCode;
  String? errorMessage;
  int? userId;

  AuthenticateCustomerWithOTPResponse(
      {this.custemerFullName,
      this.custermerCode,
      this.userEmail,
      this.userMobile});

  AuthenticateCustomerWithOTPResponse.fromJson(Map<String, dynamic> json) {
    custemerFullName = json['custemerFullName'];
    custermerCode = json['custermerCode'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custemerFullName'] = custemerFullName;
    data['custermerCode'] = custermerCode;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['userId'] = userId;
    return data;
  }
}
