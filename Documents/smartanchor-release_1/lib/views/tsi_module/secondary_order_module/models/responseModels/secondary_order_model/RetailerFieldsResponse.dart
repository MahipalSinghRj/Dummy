class RetailerFieldsResponse {
  List<String>? beatList = [];
  String? bu;
  String? city;
  List<NewRetailersDetails>? retailersDetailsData = [];
  String? state;

  RetailerFieldsResponse({this.beatList, this.bu, this.city, this.retailersDetailsData, this.state});

  RetailerFieldsResponse.fromJson(Map<String, dynamic> json) {
    beatList = json['beatList'] != null ? List<String>.from(json['beatList']) : [];
    bu = json['bu'];
    city = json['city'];
    if (json['colorLists'] != null) {
      retailersDetailsData = <NewRetailersDetails>[];
      json['colorLists'].forEach((v) {
        retailersDetailsData!.add(NewRetailersDetails.fromJson(v));
      });
    }
    state = json['state'];
  }
}

class NewRetailersDetails {
  String? color;
  String? retailerCode;
  String? retailerName;

  NewRetailersDetails({this.color, this.retailerCode, this.retailerName});

  NewRetailersDetails.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    retailerCode = json['retailerCode'];
    retailerName = json['retailerName'];
  }
}
