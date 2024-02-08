class DailyAttendanceApiResponse {
  LogIn? logIn;
  LogIn? logOut;
  bool? present;
  String? primeryOrderPunched;
  String? secondaryOrderPunched;
  String? totalVisitedCustomer;
  String? totalWorkedHours;

  DailyAttendanceApiResponse(
      {this.logIn, this.logOut, this.present, this.primeryOrderPunched, this.secondaryOrderPunched,
        this.totalVisitedCustomer, this.totalWorkedHours});

  DailyAttendanceApiResponse.fromJson(Map<String, dynamic> json) {
    logIn = json['logIn'] != null ? new LogIn.fromJson(json['logIn']) : null;
    logOut = json['logOut'] != null ? new LogIn.fromJson(json['logOut']) : null;
    present = json['present'];
    primeryOrderPunched = json['primeryOrderPunched'];
    secondaryOrderPunched = json['secondaryOrderPunched'];
    totalVisitedCustomer = json['totalVisitedCustomer'];
    totalWorkedHours = json['totalWorkedHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logIn != null) {
      data['logIn'] = this.logIn!.toJson();
    }
    if (this.logOut != null) {
      data['logOut'] = this.logOut!.toJson();
    }
    data['present'] = this.present;
    data['primeryOrderPunched'] = this.primeryOrderPunched;
    data['secondaryOrderPunched'] = this.secondaryOrderPunched;
    data['totalVisitedCustomer'] = this.totalVisitedCustomer;
    data['totalWorkedHours'] = this.totalWorkedHours;
    return data;
  }
}

class LogIn {
  List<Details>? details;

  LogIn({this.details});

  LogIn.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? address;
  String? date;
  String? image;
  String? latitude;
  String? longitude;

  Details({this.address, this.date, this.image, this.latitude, this.longitude});

  Details.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    date = json['date'];
    image = json['image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['date'] = this.date;
    data['image'] = this.image;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
//{
//   "logIn" : {
//     "details" : [ {
//       "address" : "",
//       "date" : "",
//       "image" : "",
//       "latitude" : "",
//       "longitude" : ""
//     } ]
//   },
//   "logOut" : {
//     "details" : [ {
//       "address" : "",
//       "date" : "",
//       "image" : "",
//       "latitude" : "",
//       "longitude" : ""
//     } ]
//   },
//   "present" : false,
//   "primeryOrderPunched" : "0",
//   "secondaryOrderPunched" : "",
//   "totalVisitedCustomer" : "",
//   "totalWorkedHours" : 0
// }