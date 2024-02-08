class SaveOrderResponse {
  String? message;
  String? orderNo;

  SaveOrderResponse({
    this.message,
    this.orderNo,
  });

  SaveOrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    orderNo = json['orderNo'];
  }
}
