class TopProductsResponse {
  String? errorCode;
  String? errorMessage;
  List<TopProductList>? topProductList;

  TopProductsResponse({this.errorCode, this.errorMessage, this.topProductList});

  TopProductsResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['topProductList'] != null) {
      topProductList = <TopProductList>[];
      json['topProductList'].forEach((v) {
        topProductList!.add(new TopProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    if (this.topProductList != null) {
      data['topProductList'] =
          this.topProductList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopProductList {
  String? amount;
  String? itemDescription;
  String? position;

  TopProductList({this.amount, this.itemDescription, this.position});

  TopProductList.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    itemDescription = json['itemDescription'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['itemDescription'] = this.itemDescription;
    data['position'] = this.position;
    return data;
  }
}
