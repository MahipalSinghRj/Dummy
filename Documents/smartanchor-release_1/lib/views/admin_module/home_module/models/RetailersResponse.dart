class RetailersResponse {
  String? errorCode;
  String? errorMessage;
  List<Retailers>? retailers;

  RetailersResponse({this.errorCode, this.errorMessage, this.retailers});

  RetailersResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['retailers'] != null) {
      retailers = <Retailers>[];
      json['retailers'].forEach((v) {
        retailers!.add(new Retailers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    if (this.retailers != null) {
      data['retailers'] = this.retailers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Retailers {
  String? beat;
  String? city;
  String? retailerAddress;
  String? retailerCode;
  String? retailerId;
  String? retailerName;
  String? state;

  Retailers(
      {this.beat,
        this.city,
        this.retailerAddress,
        this.retailerCode,
        this.retailerId,
        this.retailerName,
        this.state});

  Retailers.fromJson(Map<String, dynamic> json) {
    beat = json['beat'];
    city = json['city'];
    retailerAddress = json['retailerAddress'];
    retailerCode = json['retailerCode'];
    retailerId = json['retailerId'];
    retailerName = json['retailerName'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beat'] = this.beat;
    data['city'] = this.city;
    data['retailerAddress'] = this.retailerAddress;
    data['retailerCode'] = this.retailerCode;
    data['retailerId'] = this.retailerId;
    data['retailerName'] = this.retailerName;
    data['state'] = this.state;
    return data;
  }
}
