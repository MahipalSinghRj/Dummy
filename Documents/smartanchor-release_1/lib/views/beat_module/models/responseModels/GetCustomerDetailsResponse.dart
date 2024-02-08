class GetCustomerDetailsResponse {
  List<CustomerData>? customerData = [];
  String? errorCode;
  String? errorMessage;
  String? totalCustomers;

  GetCustomerDetailsResponse({this.customerData, this.errorCode, this.errorMessage, this.totalCustomers});

  GetCustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['customerData'] != null) {
      customerData = <CustomerData>[];
      json['customerData'].forEach((v) {
        customerData!.add(CustomerData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    totalCustomers = json['totalCustomers'];
  }
}

class CustomerData {
  String? address;
  String? customerCode;
  String? customerName;
  String? email;
  String? latitude;
  String? longitude;
  String? phoneNumber;

  CustomerData({this.address, this.customerCode, this.customerName, this.email, this.latitude, this.longitude, this.phoneNumber});

  CustomerData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phoneNumber = json['phoneNumber'];
  }
}
