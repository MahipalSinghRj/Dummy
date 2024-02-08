class SalesActivityResponse {
  String? errorCode;
  String? errorMessage;
  String? newCustomers;
  String? orderCount;
  String? percentageDifference;
  String? todayOrderValue;
  String? yesterdaysOrderValue;

  SalesActivityResponse(
      {this.errorCode,
        this.errorMessage,
        this.newCustomers,
        this.orderCount,
        this.percentageDifference,
        this.todayOrderValue,
        this.yesterdaysOrderValue});

  SalesActivityResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    newCustomers = json['newCustomers'];
    orderCount = json['orderCount'];
    percentageDifference = json['percentageDifference'];
    todayOrderValue = json['todayOrderValue'];
    yesterdaysOrderValue = json['yesterdaysOrderValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['newCustomers'] = this.newCustomers;
    data['orderCount'] = this.orderCount;
    data['percentageDifference'] = this.percentageDifference;
    data['todayOrderValue'] = this.todayOrderValue;
    data['yesterdaysOrderValue'] = this.yesterdaysOrderValue;
    return data;
  }
}
