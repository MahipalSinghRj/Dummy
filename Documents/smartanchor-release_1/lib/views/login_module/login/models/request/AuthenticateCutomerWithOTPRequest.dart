class AuthenticateCutomerWithOTPRequest {
  String? customerCode;
  String? oTP;
  String? oTPId;
  String? instanceName;

  AuthenticateCutomerWithOTPRequest({this.customerCode, this.oTP, this.oTPId, this.instanceName});

  AuthenticateCutomerWithOTPRequest.fromJson(Map<String, dynamic> json) {
    customerCode = json['CustomerCode'];
    oTP = json['OTP'];
    oTPId = json['OTPId'];
    instanceName = json['instanceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerCode'] = customerCode;
    data['OTP'] = oTP;
    data['OTPId'] = oTPId;
    data['instanceName'] = instanceName;
    return data;
  }
}
