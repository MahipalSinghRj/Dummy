class PreviousOrderDetailsResponse {
  List<PreviousOrderDetail>? previousOrderDetail = [];

  PreviousOrderDetailsResponse({this.previousOrderDetail});

  PreviousOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['previousOrderDetail'] != null) {
      previousOrderDetail = <PreviousOrderDetail>[];
      json['previousOrderDetail'].forEach((v) {
        previousOrderDetail!.add(PreviousOrderDetail.fromJson(v));
      });
    }
  }
}

class PreviousOrderDetail {
  String? orderDate;
  String? orderId;
  String? orderValue;
  String? quantity;
  String? status;

  PreviousOrderDetail({this.orderDate, this.orderId, this.orderValue, this.quantity, this.status});

  PreviousOrderDetail.fromJson(Map<String, dynamic> json) {
    orderDate = json['orderDate'];
    orderId = json['orderId'];
    orderValue = json['orderValue'];
    quantity = json['quantity'];
    status = json['status'];
  }
}
