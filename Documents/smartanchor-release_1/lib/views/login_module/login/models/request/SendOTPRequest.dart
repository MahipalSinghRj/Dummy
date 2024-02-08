class SendOTPRequest {
  String? customerCode;
  String? requestType;
  String? remarks;
  String? instanceName;

  SendOTPRequest({this.customerCode, this.requestType, this.remarks, this.instanceName});

  SendOTPRequest.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    requestType = json['requestType'];
    remarks = json['remarks'];
    instanceName = json['instanceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerCode'] = customerCode;
    data['requestType'] = requestType;
    data['remarks'] = remarks;
    data['instanceName'] = instanceName;
    return data;
  }
}
