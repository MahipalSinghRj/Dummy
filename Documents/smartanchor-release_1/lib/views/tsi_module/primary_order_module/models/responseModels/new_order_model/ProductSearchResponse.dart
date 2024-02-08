class ProductSearchResponse {
  List<ProductSearchItem>? productSearchItemList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  ProductSearchResponse({this.productSearchItemList, this.lastPage, this.page, this.pageSize, this.totalCount});

  ProductSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      productSearchItemList = <ProductSearchItem>[];
      json['items'].forEach((v) {
        productSearchItemList!.add(ProductSearchItem.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class ProductSearchItem {
  String? dLP;
  String? lastOD;
  String? mRP;
  String? sKUCode;
  String? sQ;
  String? availableQty;
  String? color;
  String? itemCode;
  String? masterQuantity;
  String? poductName;
  String? productMasterId;
  String? totalsize;

  ProductSearchItem(
      {this.dLP,
      this.lastOD,
      this.mRP,
      this.sKUCode,
      this.sQ,
      this.availableQty,
      this.color,
      this.itemCode,
      this.masterQuantity,
      this.poductName,
      this.productMasterId,
      this.totalsize});

  ProductSearchItem.fromJson(Map<String, dynamic> json) {
    dLP = json['DLP'];
    lastOD = json['Last_OD'];
    mRP = json['MRP'];
    sKUCode = json['SKU_Code'];
    sQ = json['SQ'];
    availableQty = json['availableQty'];
    color = json['color'];
    itemCode = json['itemCode'];
    masterQuantity = json['masterQuantity'];
    poductName = json['poductName'];
    productMasterId = json['productMasterId'];
    totalsize = json['totalsize'];
  }
}
