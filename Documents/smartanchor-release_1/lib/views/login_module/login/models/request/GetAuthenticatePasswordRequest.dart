class GetAuthenticatePasswordRequest {
  String? customerScreenName;
  String? password;

  GetAuthenticatePasswordRequest({this.customerScreenName, this.password});

  GetAuthenticatePasswordRequest.fromJson(Map<String, dynamic> json) {
    customerScreenName = json['customerScreenName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerScreenName'] = customerScreenName;
    data['password'] = password;
    return data;
  }
}
