class TopCustomersResponse {
  String? errorCode;
  List<TopCustomerList>? topCustomerList;

  TopCustomersResponse({this.errorCode, this.topCustomerList});

  TopCustomersResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    if (json['topCustomerList'] != null) {
      topCustomerList = <TopCustomerList>[];
      json['topCustomerList'].forEach((v) {
        topCustomerList!.add(new TopCustomerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.topCustomerList != null) {
      data['topCustomerList'] =
          this.topCustomerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopCustomerList {
  String? amount;
  String? customerNo;
  String? position;

  TopCustomerList({this.amount, this.customerNo, this.position});

  TopCustomerList.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    customerNo = json['customerNo'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['customerNo'] = this.customerNo;
    data['position'] = this.position;
    return data;
  }
}
