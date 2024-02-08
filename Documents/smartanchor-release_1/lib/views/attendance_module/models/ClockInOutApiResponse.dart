class ClockInOutApiResponse {
  String? status;

  ClockInOutApiResponse({this.status});

  ClockInOutApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Status'] = status;
    return data;
  }
}
