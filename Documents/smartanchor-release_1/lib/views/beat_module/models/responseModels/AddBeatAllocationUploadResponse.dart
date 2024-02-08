class AddBeatAllocationUploadResponse {
  String? errorCode;
  String? errorMessage;

  AddBeatAllocationUploadResponse({this.errorCode, this.errorMessage});

  AddBeatAllocationUploadResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    return data;
  }
}
