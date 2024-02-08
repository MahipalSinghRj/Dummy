class CustomerUnderTsiResponse {
  List<CustomerNameAndCodeList>? customerNameAndCodeList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  CustomerUnderTsiResponse({this.customerNameAndCodeList, this.lastPage, this.page, this.pageSize, this.totalCount});

  CustomerUnderTsiResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      customerNameAndCodeList = <CustomerNameAndCodeList>[];
      json['items'].forEach((v) {
        customerNameAndCodeList!.add(CustomerNameAndCodeList.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class CustomerNameAndCodeList {
  String? customerCode;
  String? customerName;

  CustomerNameAndCodeList({this.customerCode, this.customerName});

  CustomerNameAndCodeList.fromJson(Map<String, dynamic> json) {
    customerCode = json['CustomerCode'];
    customerName = json['CustomerName'];
  }
}
