class GetFullNameRequest {
  String? customerScreenName;

  GetFullNameRequest({this.customerScreenName});

  GetFullNameRequest.fromJson(Map<String, dynamic> json) {
    customerScreenName = json['customerScreenName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['customerScreenName'] = customerScreenName;
    return data;
  }
}
