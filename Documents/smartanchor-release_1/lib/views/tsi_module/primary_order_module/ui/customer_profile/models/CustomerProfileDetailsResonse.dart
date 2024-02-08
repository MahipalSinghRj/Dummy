class CustomerProfileDetailsResponse {
  String address;
  String beat;
  String buName;
  String city;
  String creditLimit;
  String customerCode;
  String customerName;
  String latitude;
  String longitude;
  String masterId;
  String noOrderCount;
  String orderCount;
  String outstanding;
  String overdue;
  String phoneNo;
  String returnOrderCount;
  String state;
  String totalOrderValue;

  CustomerProfileDetailsResponse({
    required this.address,
    required this.beat,
    required this.buName,
    required this.city,
    required this.creditLimit,
    required this.customerCode,
    required this.customerName,
    required this.latitude,
    required this.longitude,
    required this.masterId,
    required this.noOrderCount,
    required this.orderCount,
    required this.outstanding,
    required this.overdue,
    required this.phoneNo,
    required this.returnOrderCount,
    required this.state,
    required this.totalOrderValue,
  });

  factory CustomerProfileDetailsResponse.fromJson(Map<String, dynamic> json) =>
      CustomerProfileDetailsResponse(
        address: json["Address"],
        beat: json["Beat"],
        buName: json["BuName"],
        city: json["City"],
        creditLimit: json["CreditLimit"],
        customerCode: json["CustomerCode"],
        customerName: json["CustomerName"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        masterId: json["MasterId"],
        noOrderCount: json["NoOrderCount"],
        orderCount: json["OrderCount"],
        outstanding: json["Outstanding"],
        overdue: json["Overdue"],
        phoneNo: json["PhoneNo"],
        returnOrderCount: json["ReturnOrderCount"],
        state: json["State"],
        totalOrderValue: json["TotalOrderValue"],
      );

  Map<String, dynamic> toJson() => {
        "Address": address,
        "Beat": beat,
        "BuName": buName,
        "City": city,
        "CreditLimit": creditLimit,
        "CustomerCode": customerCode,
        "CustomerName": customerName,
        "Latitude": latitude,
        "Longitude": longitude,
        "MasterId": masterId,
        "NoOrderCount": noOrderCount,
        "OrderCount": orderCount,
        "Outstanding": outstanding,
        "Overdue": overdue,
        "PhoneNo": phoneNo,
        "ReturnOrderCount": returnOrderCount,
        "State": state,
        "TotalOrderValue": totalOrderValue,
      };
}
