class GetReturnOrderwithDropDownResponse {
  List<String>? catgeory;
  List<String>? subBrand;

  GetReturnOrderwithDropDownResponse({this.catgeory, this.subBrand});

  GetReturnOrderwithDropDownResponse.fromJson(Map<String, dynamic> json) {
    catgeory = json['Catgeory'].cast<String>();
    subBrand = json['SubBrand'].cast<String>();
  }
}
