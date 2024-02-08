class OrderTypeListResponse {
  List<OrderTypeList>? orderTypeList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  OrderTypeListResponse({this.orderTypeList, this.lastPage, this.page, this.pageSize, this.totalCount});

  OrderTypeListResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      orderTypeList = <OrderTypeList>[];
      json['items'].forEach((v) {
        orderTypeList!.add(OrderTypeList.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class OrderTypeList {
  String? description;

  OrderTypeList({this.description});

  OrderTypeList.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
  }
}
