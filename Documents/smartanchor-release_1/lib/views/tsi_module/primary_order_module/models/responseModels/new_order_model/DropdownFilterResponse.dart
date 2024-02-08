/*class DropdownFilterResponse {
  List<String>? selectBrand;
  List<String>? selectCategory;
  List<String>? selectDivision;

  DropdownFilterResponse({this.selectBrand, this.selectCategory, this.selectDivision});

  DropdownFilterResponse.fromJson(Map<String, dynamic> json) {
    selectBrand = json['SelectBrand'];
    selectCategory = json['SelectCategory'];
    selectDivision = json['SelectDivision'];
  }
}*/

class DropdownFilterResponse {
  List<String>? selectBrand;
  List<String>? selectCategory;
  List<String>? selectDivision;

  DropdownFilterResponse({this.selectBrand, this.selectCategory, this.selectDivision});

  DropdownFilterResponse.fromJson(Map<String, dynamic> json) {
    // Check for null or missing keys in JSON response
    selectBrand = (json['SelectBrand'] as List<dynamic>?)?.map((item) => item.toString()).toList();
    selectCategory = (json['SelectCategory'] as List<dynamic>?)?.map((item) => item.toString()).toList();
    selectDivision = (json['SelectDivision'] as List<dynamic>?)?.map((item) => item.toString()).toList();
  }
}
