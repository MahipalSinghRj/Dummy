class AddBeatIndividualUploadResponse {
  String? errorCode;
  String? errorMessage;

  AddBeatIndividualUploadResponse({this.errorCode, this.errorMessage});

  AddBeatIndividualUploadResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
