class GetCustomersByStateResponse {
  List<String>? cities;
  List<CustomerInfos>? customerInfos = [];

  GetCustomersByStateResponse({this.cities, this.customerInfos});

  GetCustomersByStateResponse.fromJson(Map<String, dynamic> json) {
    cities = json['cities'].cast<String>();
    if (json['customerInfos'] != null) {
      customerInfos = <CustomerInfos>[];
      json['customerInfos'].forEach((v) {
        if (v != null) {
          customerInfos!.add(CustomerInfos.fromJson(v));
        }
      });
    }
  }
}

class CustomerInfos {
  String? city;
  String? customerCode;
  String? customerName;
  String? colour;

  CustomerInfos({this.city, this.customerCode, this.customerName, this.colour});

  CustomerInfos.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    colour = json['colour'];
  }
}
