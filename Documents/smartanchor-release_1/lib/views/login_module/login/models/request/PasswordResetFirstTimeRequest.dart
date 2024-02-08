class PasswordResetFirstTimeRequest {
  String? customerScreenName;
  String? password;

  PasswordResetFirstTimeRequest({this.customerScreenName, this.password});

  PasswordResetFirstTimeRequest.fromJson(Map<String, dynamic> json) {
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
