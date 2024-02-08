class ViewPreviousOrderResponse {
  String? orderDate;
  List<OrderDetailProductList>? orderDetailProductList = [];
  String? status;
  String? totalQuantity;

  ViewPreviousOrderResponse({this.orderDate, this.orderDetailProductList, this.status, this.totalQuantity});

  ViewPreviousOrderResponse.fromJson(Map<String, dynamic> json) {
    orderDate = json['orderDate'];
    if (json['productList'] != null) {
      orderDetailProductList = <OrderDetailProductList>[];
      json['productList'].forEach((v) {
        orderDetailProductList!.add(OrderDetailProductList.fromJson(v));
      });
    }
    status = json['status'];
    totalQuantity = json['totalQuantity'];
  }
}

class OrderDetailProductList {
  String? productName;
  String? quantity;
  String? rlp;
  String? skuCode;
  int itemCount = 1;
  double? totalPrice;

  OrderDetailProductList({this.productName, this.quantity, this.rlp, this.skuCode, this.itemCount = 1, this.totalPrice});

  OrderDetailProductList.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    quantity = json['quantity'];
    rlp = json['rlp'];
    skuCode = json['skuCode'];
  }
}
