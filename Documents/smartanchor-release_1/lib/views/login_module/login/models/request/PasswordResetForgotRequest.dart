class PasswordResetForgotRequest {
  String? customerScreenName;
  String? instanceName;

  PasswordResetForgotRequest({this.customerScreenName, this.instanceName});

  PasswordResetForgotRequest.fromJson(Map<String, dynamic> json) {
    customerScreenName = json['customerScreenName'];
    instanceName = json['instanceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerScreenName'] = customerScreenName;
    data['instanceName'] = instanceName;
    return data;
  }
}
