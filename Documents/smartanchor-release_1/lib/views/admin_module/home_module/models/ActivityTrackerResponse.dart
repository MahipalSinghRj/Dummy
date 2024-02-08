class ActivityTrackerResponse {
  String? errorCode;
  String? errorMessage;
  int? newCustomers;
  int? newRetailers;
  int? primaryOrderCount;
  int? secondaryOrderCount;
  double? totalPrimarySales;

  ActivityTrackerResponse(
      {this.errorCode,
        this.errorMessage,
        this.newCustomers,
        this.newRetailers,
        this.primaryOrderCount,
        this.secondaryOrderCount,
        this.totalPrimarySales});

  ActivityTrackerResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    newCustomers = json['newCustomers'];
    newRetailers = json['newRetailers'];
    primaryOrderCount = json['primaryOrderCount'];
    secondaryOrderCount = json['secondaryOrderCount'];
    totalPrimarySales = json['totalPrimarySales'];
  }

}
