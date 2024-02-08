class ProductPerformanceResponse {
  List<BusinessProductData>? businessData;
  String? errorCode;
  String? errorMessage;
  List<String>? filterList;
  List<String>? labelList;

  ProductPerformanceResponse(
      {this.businessData,
        this.errorCode,
        this.errorMessage,
        this.filterList,
        this.labelList});

  ProductPerformanceResponse.fromJson(Map<String, dynamic> json) {
    if (json['businessData'] != null) {
      businessData = <BusinessProductData>[];
      json['businessData'].forEach((v) {
        businessData!.add(new BusinessProductData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    filterList = json['filterList'].cast<String>();
    labelList = json['labelList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessData != null) {
      data['businessData'] = this.businessData!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['filterList'] = this.filterList;
    data['labelList'] = this.labelList;
    return data;
  }
}

class BusinessProductData {
  List<int>? data;
  String? name;
  String? type;

  BusinessProductData({this.data, this.name, this.type});

  BusinessProductData.fromJson(Map<String, dynamic> json) {
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
