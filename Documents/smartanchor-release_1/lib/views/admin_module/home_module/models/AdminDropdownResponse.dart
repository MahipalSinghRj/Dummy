class AdminDropdownResponse {
  List<String>? brand;
  List<String>? bu;
  List<String>? category;
  List<String>? city;
  List<String>? division;
  String? errorCode;
  String? errorMessage;
  List<String>? state;
  List<String>? zone;

  AdminDropdownResponse({this.brand, this.bu, this.category, this.city, this.division, this.errorCode, this.errorMessage, this.state, this.zone});

  AdminDropdownResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    brand = json['brand'].cast<String>();
    bu = json['bu'].cast<String>();
    category = json['category'].cast<String>();
    city = json['city'].cast<String>();
    division = json['division'].cast<String>();
    state = json['state'].cast<String>();
    zone = json['zone'].cast<String>();
  }
}
