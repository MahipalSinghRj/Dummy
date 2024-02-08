class AddEventsForApprovalResponse {
  String? errorCode;
  String? errorMessage;

  AddEventsForApprovalResponse({this.errorCode, this.errorMessage});

  AddEventsForApprovalResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}
