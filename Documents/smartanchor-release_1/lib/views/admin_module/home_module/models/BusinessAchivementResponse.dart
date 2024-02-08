class BusinessAchivementResponse {
  List<BusinessData>? businessData;
  String? errorCode;
  String? errorMessage;
  List<String>? labelList;

  BusinessAchivementResponse(
      {this.businessData, this.errorCode, this.errorMessage, this.labelList});

  BusinessAchivementResponse.fromJson(Map<String, dynamic> json) {
    if (json['businessData'] != null) {
      businessData = <BusinessData>[];
      json['businessData'].forEach((v) {
        businessData!.add(new BusinessData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    labelList = json['labelList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessData != null) {
      data['businessData'] = this.businessData!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['labelList'] = this.labelList;
    return data;
  }
}

class BusinessData {
  List<int>? data;
  String? name;
  String? type;

  BusinessData({this.data, this.name, this.type});

  BusinessData.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
