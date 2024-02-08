class GetBeatAllocationTemplateResponse {
  String? base64;
  String? errorCode;
  String? errorMessage;

  GetBeatAllocationTemplateResponse({this.base64, this.errorCode, this.errorMessage});

  GetBeatAllocationTemplateResponse.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64'] = this.base64;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
