class RetailersByBeatResponse {
  List<RetailerDetails>? retailerDetailsData = [];

  RetailersByBeatResponse({this.retailerDetailsData});

  RetailersByBeatResponse.fromJson(Map<String, dynamic> json) {
    if (json['colorLists'] != null) {
      retailerDetailsData = <RetailerDetails>[];
      json['colorLists'].forEach((v) {
        retailerDetailsData!.add(RetailerDetails.fromJson(v));
      });
    }
  }
}

class RetailerDetails {
  String? color;
  String? retailerCode;
  String? retailerName;

  RetailerDetails({this.color, this.retailerCode, this.retailerName});

  RetailerDetails.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    retailerCode = json['retailerCode'];
    retailerName = json['retailerName'];
  }
}
