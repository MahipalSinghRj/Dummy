class ForgotPasswordRequest {
  String? customerScreenName;

  ForgotPasswordRequest({this.customerScreenName});

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    customerScreenName = json['customerScreenName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerScreenName'] = customerScreenName;
    return data;
  }
}
