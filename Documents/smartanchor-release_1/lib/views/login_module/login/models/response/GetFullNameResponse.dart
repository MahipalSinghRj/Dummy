class GetFullNameResponse {
  String? oTPId;
  String? phoneNumber;
  String? customerFullName;
  String? emailAddress;
  String? customerScreenName;
  String? errorCode;
  String? errorMessage;

  GetFullNameResponse({this.oTPId, this.phoneNumber, this.customerFullName, this.emailAddress});

  GetFullNameResponse.fromJson(Map<String, dynamic> json) {
    oTPId = json['OTPId'];
    phoneNumber = json['PhoneNumber'];
    customerFullName = json['customerFullName'];
    customerScreenName = json['screenName'];
    emailAddress = json['emailAddress'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['OTPId'] = this.oTPId;
//   data['PhoneNumber'] = this.phoneNumber;
//   data['customerFullName'] = this.customerFullName;
//   data['emailAddress'] = this.emailAddress;
//   return data;
// }
}
