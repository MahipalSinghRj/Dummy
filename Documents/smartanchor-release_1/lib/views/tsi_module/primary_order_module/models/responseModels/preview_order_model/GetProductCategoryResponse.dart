class GetProductCategoryResponse {
  List<GetProductCategoryList>? getProductCategoryList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  GetProductCategoryResponse({this.getProductCategoryList, this.lastPage, this.page, this.pageSize, this.totalCount});

  GetProductCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      getProductCategoryList = <GetProductCategoryList>[];
      json['items'].forEach((v) {
        getProductCategoryList!.add(GetProductCategoryList.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class GetProductCategoryList {
  String? itemName;
  String? sfaProductUploadId;
  int? groupValue;
  GetProductCategoryList({this.itemName, this.sfaProductUploadId, this.groupValue = 0});

  GetProductCategoryList.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    sfaProductUploadId = json['sfaProductUploadId'];
  }
}
