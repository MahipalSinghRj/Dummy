class SubmitNewOrderResponse {
  int? successCode;
  String? successfulmessage;
  String? cartid;
  String? orderNo;


  SubmitNewOrderResponse({this.successCode, this.successfulmessage});

  SubmitNewOrderResponse.fromJson(Map<String, dynamic> json) {
    successCode = json['successCode'];
    successfulmessage = json['successfulmessage'];
    cartid = json['cartid'];
    orderNo = json['orderNo'];
  }
}
