class RetailerDetailsResponse {
  String? address;
  String? beat;
  String? lastOrder;
  String? mobile;
  String? remark;
  String? retailerName;
  String? emailId;

  RetailerDetailsResponse({this.address, this.beat, this.lastOrder,
    this.mobile, this.remark, this.retailerName, this.emailId});

  RetailerDetailsResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    beat = json['beat'];
    lastOrder = json['lastOrder'];
    mobile = json['mobile'];
    remark = json['remark'];
    retailerName = json['retailerName'];
    emailId = json['emailId'];
  }
}
