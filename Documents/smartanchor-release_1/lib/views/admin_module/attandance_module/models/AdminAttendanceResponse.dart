class AdminAttendanceResponse {
  EmployeeList? employeeList;
  List<String>? placeList;
  int? totalAbsent;
  int? totalLate;
  int? totalPresent;

  AdminAttendanceResponse(
      {this.employeeList,
        this.placeList,
        this.totalAbsent,
        this.totalLate,
        this.totalPresent});

  AdminAttendanceResponse.fromJson(Map<String, dynamic> json) {
    employeeList = json['employeeList'] != null
        ? new EmployeeList.fromJson(json['employeeList'])
        : null;
    placeList = json['placeList'].cast<String>();
    totalAbsent = json['totalAbsent'];
    totalLate = json['totalLate'];
    totalPresent = json['totalPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeList != null) {
      data['employeeList'] = this.employeeList!.toJson();
    }
    data['placeList'] = this.placeList;
    data['totalAbsent'] = this.totalAbsent;
    data['totalLate'] = this.totalLate;
    data['totalPresent'] = this.totalPresent;
    return data;
  }
}

class EmployeeList {
  List<EmpDetails>? empDetails;

  EmployeeList({this.empDetails});

  EmployeeList.fromJson(Map<String, dynamic> json) {
    if (json['empDetails'] != null) {
      empDetails = <EmpDetails>[];
      json['empDetails'].forEach((v) {
        empDetails!.add(new EmpDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.empDetails != null) {
      data['empDetails'] = this.empDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmpDetails {
  String? bu;
  String? city;
  String? date;
  String? empCode;
  String? loginTime;
  String? logoutTime;
  String? name;
  String? state;
  String? userType;
  String? zone;

  EmpDetails(
      {this.bu,
        this.city,
        this.date,
        this.empCode,
        this.loginTime,
        this.logoutTime,
        this.name,
        this.state,
        this.userType,
        this.zone});

  EmpDetails.fromJson(Map<String, dynamic> json) {
    bu = json['bu'];
    city = json['city'];
    date = json['date'];
    empCode = json['empCode'];
    loginTime = json['loginTime'];
    logoutTime = json['logoutTime'];
    name = json['name'];
    state = json['state'];
    userType = json['userType'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bu'] = this.bu;
    data['city'] = this.city;
    data['date'] = this.date;
    data['empCode'] = this.empCode;
    data['loginTime'] = this.loginTime;
    data['logoutTime'] = this.logoutTime;
    data['name'] = this.name;
    data['state'] = this.state;
    data['userType'] = this.userType;
    data['zone'] = this.zone;
    return data;
  }
}
