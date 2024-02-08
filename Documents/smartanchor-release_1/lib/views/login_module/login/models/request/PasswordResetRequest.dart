class PasswordResetRequest {
  String? customerScreenName;
  String? password;
  String? confirm;

  PasswordResetRequest({this.customerScreenName, this.password, this.confirm});

  PasswordResetRequest.fromJson(Map<String, dynamic> json) {
    customerScreenName = json['customerScreenName'];
    password = json['password'];
    confirm = json['confirm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerScreenName'] = customerScreenName;
    data['password'] = password;
    data['confirm'] = confirm;
    return data;
  }
}
