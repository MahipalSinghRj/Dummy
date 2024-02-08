class PrimarySecondaryResponse {
  String? errorCode;
  String? errorMessage;
  List<String>? primaryCategoriesList;
  List<double>? primaryOrdersList;
  List<String>? secondaryCategoriesList;
  List<double>? secondaryOrdersList;

  PrimarySecondaryResponse(
      {this.errorCode,
        this.errorMessage,
        this.primaryCategoriesList,
        this.primaryOrdersList,
        this.secondaryCategoriesList,
        this.secondaryOrdersList});

  PrimarySecondaryResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    primaryCategoriesList = json['primaryCategoriesList'].cast<String>();
    primaryOrdersList = json['primaryOrdersList'].cast<double>();
    secondaryCategoriesList = json['secondaryCategoriesList'].cast<String>();
    secondaryOrdersList = json['secondaryOrdersList'].cast<double>();
  }

}
