class GetCustomerAddressResponse {
  List<CustomerMap>? customerMap;
  String? errorCode;
  String? errorMessage;

  GetCustomerAddressResponse({this.customerMap, this.errorCode, this.errorMessage});

  GetCustomerAddressResponse.fromJson(Map<String, dynamic> json) {
    if (json['customerMap'] != null) {
      customerMap = <CustomerMap>[];
      json['customerMap'].forEach((v) {
        customerMap!.add(CustomerMap.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}

class CustomerMap {
  String? address;
  String? beat;
  String? city;
  String? customerCode;
  String? masterId;
  String? name;
  String? state;

  CustomerMap({this.address, this.beat, this.city, this.customerCode, this.masterId, this.name, this.state});

  CustomerMap.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    beat = json['beat'];
    city = json['city'];
    customerCode = json['customerCode'];
    masterId = json['masterId'];
    name = json['name'];
    state = json['state'];
  }
}


class CustomerMapWithLatLng {
  String? address;
  String? beat;
  String? city;
  String? customerCode;
  String? masterId;
  String? name;
  String? state;
  double? lat;
  double? lag;


  CustomerMapWithLatLng({this.address, this.beat, this.city, this.customerCode, this.masterId, this.name, this.state,
  this.lat, this.lag});

  CustomerMapWithLatLng.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    beat = json['beat'];
    city = json['city'];
    customerCode = json['customerCode'];
    masterId = json['masterId'];
    name = json['name'];
    state = json['state'];
    lat = json['lat'];
    lag = json['lag'];
  }

}

