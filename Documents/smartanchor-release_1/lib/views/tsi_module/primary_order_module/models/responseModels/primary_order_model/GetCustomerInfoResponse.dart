class GetCustomerInfoResponse {
  String? address;
  String? creditLimit;
  String? customerCode;
  String? customerName;
  String? mobileNo;
  String? outstanding;
  String? overdue;
  String? lastOrderDate;
  String? remarks;

  GetCustomerInfoResponse(
      {this.address, this.creditLimit, this.customerCode, this.customerName, this.mobileNo, this.outstanding, this.overdue, this.lastOrderDate, this.remarks});

  GetCustomerInfoResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    creditLimit = json['creditLimit'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    mobileNo = json['mobileNo'];
    outstanding = json['outstanding'];
    overdue = json['overdue'];
    lastOrderDate = json['lastOrderDate'];
    remarks = json['remarks'];
  }
}
