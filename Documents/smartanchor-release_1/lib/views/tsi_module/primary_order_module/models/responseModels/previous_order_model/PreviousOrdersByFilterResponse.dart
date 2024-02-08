class PreviousOrdersByFilterResponse {
  List<PreviousOrderItems>? previousOrderItems = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  PreviousOrdersByFilterResponse({this.previousOrderItems, this.lastPage, this.page, this.pageSize, this.totalCount});

  PreviousOrdersByFilterResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      previousOrderItems = <PreviousOrderItems>[];
      json['items'].forEach((v) {
        previousOrderItems!.add(PreviousOrderItems.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class PreviousOrderItems {
  String? sTATUSFLAG;
  int? cartStatus;
  String? color;
  String? costumerName;
  String? customerId;
  String? customerNo;
  String? orderInstance;
  String? orderDate;
  int? orderId;
  String? orderValue;
  String? OrderQty;
  String? orderNo;
  String? BU;

  PreviousOrderItems(
      {this.sTATUSFLAG,
      this.cartStatus,
      this.color,
      this.costumerName,
      this.customerId,
      this.customerNo,
      this.orderInstance,
      this.orderDate,
      this.orderId,
      this.orderValue,
      this.OrderQty,
      this.orderNo,
      this.BU,
      });

  PreviousOrderItems.fromJson(Map<String, dynamic> json) {
    sTATUSFLAG = json['STATUS_FLAG'];
    cartStatus = json['cart_status'];
    color = json['color'];
    costumerName = json['costumer_name'];
    customerId = json['customer_id'];
    customerNo = json['customer_no'];
    orderInstance = json['orderInstance'];
    orderDate = json['order_date'];
    orderId = json['order_id'];
    orderValue = json['order_value'];
    OrderQty = json['OrderQty'];
    orderNo = json['orderNo'];
    BU = json['BU'];
  }
}
