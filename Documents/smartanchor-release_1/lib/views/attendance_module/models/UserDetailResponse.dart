class UserDetailResponse {
  String? attendanceStatus;
  String? roleType;
  String? userName;

  UserDetailResponse({this.attendanceStatus, this.roleType, this.userName});

  UserDetailResponse.fromJson(Map<String, dynamic> json) {
    attendanceStatus = json['attendanceStatus'];
    roleType = json['roleType'];
    userName = json['userName'];
  }
}
