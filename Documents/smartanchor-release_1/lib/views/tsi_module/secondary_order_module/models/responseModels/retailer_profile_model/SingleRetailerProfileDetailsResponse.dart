class SingleRetailerProfileDetailResponse {
  String iaqDealer;
  String lightingDealer;
  String noOrderCount;
  String orderValue;
  String powerDealer;
  RetailerDetail retailerDetail;
  String totalOrderedItem;

  SingleRetailerProfileDetailResponse({
    required this.iaqDealer,
    required this.lightingDealer,
    required this.noOrderCount,
    required this.orderValue,
    required this.powerDealer,
    required this.retailerDetail,
    required this.totalOrderedItem,
  });

  factory SingleRetailerProfileDetailResponse.fromJson(
          Map<String, dynamic> json) =>
      SingleRetailerProfileDetailResponse(
        iaqDealer: json["iaqDealer"] ?? '',
        lightingDealer: json["lightingDealer"] ?? '',
        noOrderCount: json["noOrderCount"] ?? '',
        orderValue: json["orderValue"] ?? '',
        powerDealer: json["powerDealer"] ?? '',
        retailerDetail: RetailerDetail.fromJson(json["retailerDetail"] ?? {}),
        totalOrderedItem: json["totalOrderedItem"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "iaqDealer": iaqDealer,
        "lightingDealer": lightingDealer,
        "noOrderCount": noOrderCount,
        "orderValue": orderValue,
        "powerDealer": powerDealer,
        "retailerDetail": retailerDetail.toJson(),
        "totalOrderedItem": totalOrderedItem,
      };
}

class RetailerDetail {
  String address;
  String beat;
  String city;
  String code;
  String creditLimit;
  String customerName;
  String latitude;
  String longitude;
  String mobileNo;
  String outstanding;
  String overdue;
  String state;
  String verifyFlag;

  RetailerDetail({
    required this.address,
    required this.beat,
    required this.city,
    required this.code,
    required this.creditLimit,
    required this.customerName,
    required this.latitude,
    required this.longitude,
    required this.mobileNo,
    required this.outstanding,
    required this.overdue,
    required this.state,
    required this.verifyFlag,
  });

  factory RetailerDetail.fromJson(Map<String, dynamic> json) => RetailerDetail(
        address: json["address"] ?? '',
        beat: json["beat"] ?? '',
        city: json["city"] ?? '',
        code: json["code"] ?? '',
        creditLimit: json["creditLimit"] ?? '',
        customerName: json["customerName"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
        mobileNo: json["mobileNo"] ?? '',
        outstanding: json["outstanding"] ?? '',
        overdue: json["overdue"] ?? '',
        state: json["state"] ?? '',
        verifyFlag: json["verifyFlag"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "beat": beat,
        "city": city,
        "code": code,
        "creditLimit": creditLimit,
        "customerName": customerName,
        "latitude": latitude,
        "longitude": longitude,
        "mobileNo": mobileNo,
        "outstanding": outstanding,
        "overdue": overdue,
        "state": state,
        "verifyFlag": verifyFlag,
      };
}
