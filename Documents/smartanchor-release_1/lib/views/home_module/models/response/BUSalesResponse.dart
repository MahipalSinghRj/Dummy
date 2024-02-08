class BUSalesResponse {
  List<String>? categoriesList;
  String? errorCode;
  String? errorMessage;
  List<String>? filtersList;
  List<SalesDataBu>? salesData;

  BUSalesResponse(
      {this.categoriesList,
        this.errorCode,
        this.errorMessage,
        this.filtersList,
        this.salesData});

  BUSalesResponse.fromJson(Map<String, dynamic> json) {
    categoriesList = json['categoriesList'].cast<String>();
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    filtersList = json['filtersList'].cast<String>();
    if (json['salesData'] != null) {
      salesData = <SalesDataBu>[];
      json['salesData'].forEach((v) {
        salesData!.add(new SalesDataBu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoriesList'] = this.categoriesList;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['filtersList'] = this.filtersList;
    if (this.salesData != null) {
      data['salesData'] = this.salesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesDataBu {
  List<int>? data;
  String? name;
  String? type;

  SalesDataBu({this.data, this.name, this.type});

  SalesDataBu.fromJson(Map<String, dynamic> json) {
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
