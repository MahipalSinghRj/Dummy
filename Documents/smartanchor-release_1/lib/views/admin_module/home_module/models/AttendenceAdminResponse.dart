class AttendenceAdminResponse {
  String? errorCode;
  String? errorMessage;
  int? totalAbsentEmployees;
  int? totalLateComers;
  int? totalPresentEmployees;

  AttendenceAdminResponse(
      {this.errorCode,
        this.errorMessage,
        this.totalAbsentEmployees,
        this.totalLateComers,
        this.totalPresentEmployees});

  AttendenceAdminResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    totalAbsentEmployees = json['totalAbsentEmployees'];
    totalLateComers = json['totalLateComers'];
    totalPresentEmployees = json['totalPresentEmployees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['totalAbsentEmployees'] = this.totalAbsentEmployees;
    data['totalLateComers'] = this.totalLateComers;
    data['totalPresentEmployees'] = this.totalPresentEmployees;
    return data;
  }
}
