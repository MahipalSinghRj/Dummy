class CustomerNewOrderListResponse {
  int? newOrderCount;
  String? orderSales;
  List<Orders>? orders;
  int? totalCustomerVisited;
  String? errorMessage;

  CustomerNewOrderListResponse({this.newOrderCount, this.orderSales, this.orders, this.totalCustomerVisited,this.errorMessage});

  CustomerNewOrderListResponse.fromJson(Map<String, dynamic> json) {
    newOrderCount = json['newOrderCount'];
    orderSales = json['orderSales'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    totalCustomerVisited = json['totalCustomerVisited'];

    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newOrderCount'] = this.newOrderCount;
    data['orderSales'] = this.orderSales;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['totalCustomerVisited'] = this.totalCustomerVisited;
    data['errorMessage'] = this.errorMessage;

    return data;
  }
}

class Orders {
  String? createDate;
  String? customerName;
  String? customerNumber;
  int? orderCartId;
  String? orderValue;
  int? quantity;
  String? status;

  Orders({this.createDate, this.customerName, this.customerNumber, this.orderCartId, this.orderValue, this.quantity, this.status});

  Orders.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    customerName = json['customerName'];
    customerNumber = json['customerNumber'];
    orderCartId = json['orderCartId'];
    orderValue = json['orderValue'];
    quantity = json['quantity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['customerName'] = this.customerName;
    data['customerNumber'] = this.customerNumber;
    data['orderCartId'] = this.orderCartId;
    data['orderValue'] = this.orderValue;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    return data;
  }
}
