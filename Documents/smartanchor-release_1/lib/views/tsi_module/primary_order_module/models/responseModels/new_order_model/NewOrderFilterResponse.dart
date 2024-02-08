import 'dart:ui';

class NewOrderFilterResponse {
  List<NewOrderItems>? newOrderItems = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  NewOrderFilterResponse({
    this.newOrderItems,
    this.lastPage,
    this.page,
    this.pageSize,
    this.totalCount,
  });

  NewOrderFilterResponse.fromJson(Map<String, dynamic> json) {
    if (json['newOrderItems'] != null) {
      newOrderItems = <NewOrderItems>[];
      json['newOrderItems'].forEach((v) {
        newOrderItems!.add(NewOrderItems.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class NewOrderItems {
  String? availableQty;
  String? customerCode;
  String? lastOd;
  String? productName;
  String? sKUcode;

  NewOrderItems({this.availableQty, this.customerCode, this.lastOd, this.productName, this.sKUcode});

  NewOrderItems.fromJson(Map<String, dynamic> json) {
    availableQty = json['AvailableQty'];
    customerCode = json['CustomerCode'];
    lastOd = json['LastOd'];
    productName = json['ProductName'];
    sKUcode = json['SKUcode'];
  }
}
