class SalesTsiResponse {
  String? errorCode;
  String? errorMessage;
  String? salesTarget;
  String? salesValueCompleted;

  SalesTsiResponse(
      {this.errorCode,
        this.errorMessage,
        this.salesTarget,
        this.salesValueCompleted});

  SalesTsiResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    salesTarget = json['salesTarget'];
    salesValueCompleted = json['salesValueCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['salesTarget'] = this.salesTarget;
    data['salesValueCompleted'] = this.salesValueCompleted;
    return data;
  }
}
