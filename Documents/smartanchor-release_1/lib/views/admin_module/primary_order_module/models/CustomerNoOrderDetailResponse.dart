class CustomerNoOrderDetailResponse {
  String? date;
  String? fileName;
  String? fileUrl;
  String? noOrderId;
  String? reason;
  String? remarks;

  CustomerNoOrderDetailResponse(
      {this.date,
        this.fileName,
        this.fileUrl,
        this.noOrderId,
        this.reason,
        this.remarks});

  CustomerNoOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    noOrderId = json['noOrderId'];
    reason = json['reason'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['fileName'] = this.fileName;
    data['fileUrl'] = this.fileUrl;
    data['noOrderId'] = this.noOrderId;
    data['reason'] = this.reason;
    data['remarks'] = this.remarks;
    return data;
  }
}
