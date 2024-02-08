class GetAuthenticatePasswordResponse {
  String? custemerFullName;
  String? custermerCode;
  String? errorCode;
  String? errorMessage;
  String? userEmail;
  String? userMobile;

  GetAuthenticatePasswordResponse({this.custemerFullName, this.custermerCode, this.errorCode, this.errorMessage, this.userEmail, this.userMobile});

  GetAuthenticatePasswordResponse.fromJson(Map<String, dynamic> json) {
    custemerFullName = json['custemerFullName'];
    custermerCode = json['custermerCode'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custemerFullName'] = custemerFullName;
    data['custermerCode'] = custermerCode;
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    return data;
  }
}
