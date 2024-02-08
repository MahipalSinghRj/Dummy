class AdminFilteredAttendanceResponse {
  EmployeeList? employeeList;
  int? totalAbsent;
  int? totalLate;
  int? totalPresent;

  AdminFilteredAttendanceResponse(
      {this.employeeList, this.totalAbsent, this.totalLate, this.totalPresent});

  AdminFilteredAttendanceResponse.fromJson(Map<String, dynamic> json) {
    employeeList = json['employeeList'] != null
        ? new EmployeeList.fromJson(json['employeeList'])
        : null;
    totalAbsent = json['totalAbsent'];
    totalLate = json['totalLate'];
    totalPresent = json['totalPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeList != null) {
      data['employeeList'] = this.employeeList!.toJson();
    }
    data['totalAbsent'] = this.totalAbsent;
    data['totalLate'] = this.totalLate;
    data['totalPresent'] = this.totalPresent;
    return data;
  }
}

class EmployeeList {
  List<EmloyeeDetailsFilter>? empDetails;

  EmployeeList({this.empDetails});

  EmployeeList.fromJson(Map<String, dynamic> json) {
    if (json['empDetails'] != null) {
      empDetails = <EmloyeeDetailsFilter>[];
      json['empDetails'].forEach((v) {
        empDetails!.add(new EmloyeeDetailsFilter.fromJson(v));
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

class EmloyeeDetailsFilter {
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

  EmloyeeDetailsFilter(
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

  EmloyeeDetailsFilter.fromJson(Map<String, dynamic> json) {
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
