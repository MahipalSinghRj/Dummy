class BulkBeatAllocationUploadResponse {
  String? base64;
  String? errorMessage;
  String? errorCode;

  BulkBeatAllocationUploadResponse({this.base64, this.errorMessage, this.errorCode});

  BulkBeatAllocationUploadResponse.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64'] = this.base64;
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    return data;
  }
}
