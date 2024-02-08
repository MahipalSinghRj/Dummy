class SalesActivityGraphResponse {
  String? errorCode;
  String? errorMessage;
  List<String>? primaryCategoriesList;
  List<double>? primaryOrdersList;
  List<String>? secondaryCategoriesList;
  List<double>? secondaryOrdersList;

  SalesActivityGraphResponse(
      {this.errorCode,
        this.errorMessage,
        this.primaryCategoriesList,
        this.primaryOrdersList,
        this.secondaryCategoriesList,
        this.secondaryOrdersList});

  SalesActivityGraphResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    primaryCategoriesList = json['primaryCategoriesList'].cast<String>();
    primaryOrdersList = json['primaryOrdersList'].cast<double>();
    secondaryCategoriesList = json['secondaryCategoriesList'].cast<String>();

    secondaryOrdersList = json['secondaryOrdersList'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['primaryCategoriesList'] = this.primaryCategoriesList;
    data['primaryOrdersList'] = this.primaryOrdersList;

    data['secondaryCategoriesList'] =this.secondaryCategoriesList;


    data['secondaryOrdersList'] =this.secondaryOrdersList;


    return data;
  }
}
