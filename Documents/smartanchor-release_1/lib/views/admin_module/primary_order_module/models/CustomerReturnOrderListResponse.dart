class CustomerReturnOrderListResponse {
  List<GraphDetails>? graphDetails;
  List<OrderDetails>? orderDetails;
  String? returnOrderCount;
  String? totalCustomerVisited;

  CustomerReturnOrderListResponse(
      {this.graphDetails,
        this.orderDetails,
        this.returnOrderCount,
        this.totalCustomerVisited});

  CustomerReturnOrderListResponse.fromJson(Map<String, dynamic> json) {
    if (json['graphDetails'] != null) {
      graphDetails = <GraphDetails>[];
      json['graphDetails'].forEach((v) {
        graphDetails!.add(new GraphDetails.fromJson(v));
      });
    }
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    returnOrderCount = json['returnOrderCount'];
    totalCustomerVisited = json['totalCustomerVisited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.graphDetails != null) {
      data['graphDetails'] = this.graphDetails!.map((v) => v.toJson()).toList();
    }
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    data['returnOrderCount'] = this.returnOrderCount;
    data['totalCustomerVisited'] = this.totalCustomerVisited;
    return data;
  }
}

class GraphDetails {
  String? customerCount;
  String? orderCounnt;

  GraphDetails({this.customerCount, this.orderCounnt});

  GraphDetails.fromJson(Map<String, dynamic> json) {
    customerCount = json['customerCount'];
    orderCounnt = json['orderCounnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCount'] = this.customerCount;
    data['orderCounnt'] = this.orderCounnt;
    return data;
  }
}

class OrderDetails {
  String? customerCode;
  String? customerName;
  String? orderDate;
  String? orderId;
  String? orderQuantity;
  String? orderStatus;
  String? orderValue;

  OrderDetails(
      {this.customerCode,
        this.customerName,
        this.orderDate,
        this.orderId,
        this.orderQuantity,
        this.orderStatus,
        this.orderValue});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    orderDate = json['orderDate'];
    orderId = json['orderId'];
    orderQuantity = json['orderQuantity'];
    orderStatus = json['orderStatus'];
    orderValue = json['orderValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['orderDate'] = this.orderDate;
    data['orderId'] = this.orderId;
    data['orderQuantity'] = this.orderQuantity;
    data['orderStatus'] = this.orderStatus;
    data['orderValue'] = this.orderValue;
    return data;
  }
}
