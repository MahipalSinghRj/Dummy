class SalesWorthResponse {
  List<String>? categoriesList;
  List<double>? ordersList;
  String? errorCode;
  String? errorMessage;

  SalesWorthResponse(
      {this.categoriesList,
        this.ordersList,
        this.errorCode,
        this.errorMessage});

  SalesWorthResponse.fromJson(Map<String, dynamic> json) {
    categoriesList = json['CategoriesList'].cast<String>();
    ordersList = json['OrdersList'].cast<double>();
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoriesList'] = this.categoriesList;
    data['OrdersList'] = this.ordersList;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
