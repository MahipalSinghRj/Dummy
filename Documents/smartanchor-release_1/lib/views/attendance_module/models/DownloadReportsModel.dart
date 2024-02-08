class DownloadReportsModel {
  String? base64String;

  DownloadReportsModel({this.base64String});

  DownloadReportsModel.fromJson(Map<String, dynamic> json) {
    base64String = json['base64String'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64String'] = this.base64String;
    return data;
  }
}
