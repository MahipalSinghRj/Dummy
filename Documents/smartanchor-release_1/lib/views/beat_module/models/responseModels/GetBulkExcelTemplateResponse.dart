class GetBulkExcelTemplateResponse {
  String? base64;
  String? errorCode;
  String? errorMessage;

  GetBulkExcelTemplateResponse({this.base64, this.errorCode, this.errorMessage});

  GetBulkExcelTemplateResponse.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}
