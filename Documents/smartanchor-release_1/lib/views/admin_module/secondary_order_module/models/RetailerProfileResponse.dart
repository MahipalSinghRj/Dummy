class RetailerProfileResponse {
  String? newRetailer;
  int? retailerCount;
  List<RetailerProfileLists>? retailerProfileLists;
  String? totalRetailerVisited;

  RetailerProfileResponse(
      {this.newRetailer,
        this.retailerCount,
        this.retailerProfileLists,
        this.totalRetailerVisited});

  RetailerProfileResponse.fromJson(Map<String, dynamic> json) {
    newRetailer = json['newRetailer'];
    retailerCount = json['retailerCount'];
    if (json['retailerProfileLists'] != null) {
      retailerProfileLists = <RetailerProfileLists>[];
      json['retailerProfileLists'].forEach((v) {
        retailerProfileLists!.add(new RetailerProfileLists.fromJson(v));
      });
    }
    totalRetailerVisited = json['totalRetailerVisited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newRetailer'] = this.newRetailer;
    data['retailerCount'] = this.retailerCount;
    if (this.retailerProfileLists != null) {
      data['retailerProfileLists'] =
          this.retailerProfileLists!.map((v) => v.toJson()).toList();
    }
    data['totalRetailerVisited'] = this.totalRetailerVisited;
    return data;
  }
}

class RetailerProfileLists {
  String? address;
  String? beat;
  String? city;
  String? code;
  String? retailerName;
  String? state;

  RetailerProfileLists(
      {this.address,
        this.beat,
        this.city,
        this.code,
        this.retailerName,
        this.state});

  RetailerProfileLists.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    beat = json['beat'];
    city = json['city'];
    code = json['code'];
    retailerName = json['retailerName'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['beat'] = this.beat;
    data['city'] = this.city;
    data['code'] = this.code;
    data['retailerName'] = this.retailerName;
    data['state'] = this.state;
    return data;
  }
}
