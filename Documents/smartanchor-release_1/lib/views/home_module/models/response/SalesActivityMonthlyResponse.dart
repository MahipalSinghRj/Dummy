class SalesActivityMonthlyResponse {
  String? errorCode;
  String? errorMessage;
  String? totalMonthlyOrdersCount;
  String? totalMonthlyOrdersValue;

  SalesActivityMonthlyResponse(
      {this.errorCode,
        this.errorMessage,
        this.totalMonthlyOrdersCount,
        this.totalMonthlyOrdersValue});

  SalesActivityMonthlyResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    totalMonthlyOrdersCount = json['totalMonthlyOrdersCount'];
    totalMonthlyOrdersValue = json['totalMonthlyOrdersValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['totalMonthlyOrdersCount'] = this.totalMonthlyOrdersCount;
    data['totalMonthlyOrdersValue'] = this.totalMonthlyOrdersValue;
    return data;
  }
}
