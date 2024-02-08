class ForgotPasswordResponse {
  String? oTPId;
  String? phoneNumber;
  String? customerFullName;
  String? emailAddress;

  ForgotPasswordResponse({this.oTPId, this.phoneNumber, this.customerFullName, this.emailAddress});

  ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    oTPId = json['OTPId'];
    phoneNumber = json['PhoneNumber'];
    customerFullName = json['customerFullName'];
    emailAddress = json['emailAddress'];
  }
}
