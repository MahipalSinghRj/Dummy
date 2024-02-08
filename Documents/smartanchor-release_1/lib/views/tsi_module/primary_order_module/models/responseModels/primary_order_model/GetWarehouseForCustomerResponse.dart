class GetWarehouseForCustomerResponse {
  List<WareHouseData>? wareHouseData = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  GetWarehouseForCustomerResponse({this.wareHouseData, this.lastPage, this.page, this.pageSize, this.totalCount});

  GetWarehouseForCustomerResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      wareHouseData = <WareHouseData>[];
      json['items'].forEach((v) {
        wareHouseData!.add(WareHouseData.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class WareHouseData {
  String? locationId;
  String? organizationId;
  String? organizationName;

  WareHouseData({this.locationId, this.organizationId, this.organizationName});

  WareHouseData.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
  }
}
