class CustomerDemoGraphResponse {
  List<int>? customerCount;
  List<String>? customerNames;

  CustomerDemoGraphResponse({this.customerCount, this.customerNames});

  CustomerDemoGraphResponse.fromJson(Map<String, dynamic> json) {
    customerCount = json['customerCount'].cast<int>();
    customerNames = json['customerNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCount'] = this.customerCount;
    data['customerNames'] = this.customerNames;
    return data;
  }
}
