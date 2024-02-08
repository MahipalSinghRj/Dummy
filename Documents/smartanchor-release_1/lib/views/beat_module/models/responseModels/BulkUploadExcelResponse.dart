class BulkUploadExcelResponse {
  String? errorCode;
  String? errorMessage;

  BulkUploadExcelResponse({this.errorCode, this.errorMessage});

  BulkUploadExcelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}
