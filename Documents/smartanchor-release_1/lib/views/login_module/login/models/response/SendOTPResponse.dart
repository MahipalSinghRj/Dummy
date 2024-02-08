class SendOTPResponse {
  String? oTPId;
  String? oTPSendingStatus;
  String? errorCode;
  String? errorMessage;

  SendOTPResponse({this.oTPId, this.oTPSendingStatus});

  SendOTPResponse.fromJson(Map<String, dynamic> json) {
    oTPId = json['OTPId'];
    oTPSendingStatus = json['OTPSendingStatus'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OTPId'] = oTPId;
    data['OTPSendingStatus'] = oTPSendingStatus;
    return data;
  }
}
