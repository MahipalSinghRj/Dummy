class RetailerNewOrderListResponse {
  List<NewOrderLists>? newOrderLists;
  int? orderCount;
  int? successfullRetailer;
  int? totalVisitedRetailers;

  RetailerNewOrderListResponse(
      {this.newOrderLists,
        this.orderCount,
        this.successfullRetailer,
        this.totalVisitedRetailers});

  RetailerNewOrderListResponse.fromJson(Map<String, dynamic> json) {
    if (json['newOrderLists'] != null) {
      newOrderLists = <NewOrderLists>[];
      json['newOrderLists'].forEach((v) {
        newOrderLists!.add(new NewOrderLists.fromJson(v));
      });
    }
    orderCount = json['orderCount'];
    successfullRetailer = json['successfullRetailer'];
    totalVisitedRetailers = json['totalVisitedRetailers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newOrderLists != null) {
      data['newOrderLists'] =
          this.newOrderLists!.map((v) => v.toJson()).toList();
    }
    data['orderCount'] = this.orderCount;
    data['successfullRetailer'] = this.successfullRetailer;
    data['totalVisitedRetailers'] = this.totalVisitedRetailers;
    return data;
  }
}

class NewOrderLists {
  String? code;
  String? orderDate;
  String? orderId;
  int? orderQuantity;
  String? orderStatus;
  int? orderValue;
  String? retailerName;

  NewOrderLists(
      {this.code,
        this.orderDate,
        this.orderId,
        this.orderQuantity,
        this.orderStatus,
        this.orderValue,
        this.retailerName});

  NewOrderLists.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    orderDate = json['orderDate'];
    orderId = json['orderId'];
    orderQuantity = json['orderQuantity'];
    orderStatus = json['orderStatus'];
    orderValue = json['orderValue'];
    retailerName = json['retailerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['orderDate'] = this.orderDate;
    data['orderId'] = this.orderId;
    data['orderQuantity'] = this.orderQuantity;
    data['orderStatus'] = this.orderStatus;
    data['orderValue'] = this.orderValue;
    data['retailerName'] = this.retailerName;
    return data;
  }
}
