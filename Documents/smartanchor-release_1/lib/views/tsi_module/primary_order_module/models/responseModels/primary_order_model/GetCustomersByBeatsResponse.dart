class GetCustomersByBeatsResponse {
  List<CustomerSearchWithBeats>? customerSearchWithBeatsList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  GetCustomersByBeatsResponse({this.customerSearchWithBeatsList, this.lastPage, this.page, this.pageSize, this.totalCount});

  GetCustomersByBeatsResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      customerSearchWithBeatsList = <CustomerSearchWithBeats>[];
      json['items'].forEach((v) {
        customerSearchWithBeatsList!.add(CustomerSearchWithBeats.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class CustomerSearchWithBeats {
  String? colour;
  String? customerCode;
  String? customerName;

  CustomerSearchWithBeats({this.colour, this.customerCode, this.customerName});

  CustomerSearchWithBeats.fromJson(Map<String, dynamic> json) {
    colour = json['colour'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
  }
}
