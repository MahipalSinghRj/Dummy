import 'dart:ui';

/*class ProductByBUResponse {
  List<ProductByBUItems>? productByBUItems = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  ProductByBUResponse({this.productByBUItems, this.lastPage, this.page, this.pageSize, this.totalCount});

  ProductByBUResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      productByBUItems = <ProductByBUItems>[];
      json['items'].forEach((v) {
        productByBUItems!.add(ProductByBUItems.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class ProductByBUItems {
  String? dLP;
  String? lastOD;
  String? mRP;
  String? sKUCode;
  String? sQ;
  String? warehouse;
  String? availableQty;
  String? itemCode;
  String? masterQuantity;
  String? poductName;
  String? productMasterId;
  bool? isSelected;
  Color? cardColor;
  int itemCount = 1;
  double? totalPrice;
  int? selectedQty;

  ProductByBUItems(
      {this.dLP,
      this.lastOD,
      this.mRP,
      this.sKUCode,
      this.sQ,
      this.warehouse,
      this.availableQty,
      this.itemCode,
      this.masterQuantity,
      this.poductName,
      this.productMasterId,
      this.isSelected,
      this.cardColor,
      this.itemCount = 1,
      this.totalPrice,
      this.selectedQty});

  ProductByBUItems.fromJson(Map<String, dynamic> json) {
    dLP = json['DLP'];
    lastOD = json['Last_OD'];
    mRP = json['MRP'];
    sKUCode = json['SKU_Code'];
    sQ = json['SQ'];
    warehouse = json['Warehouse'];
    availableQty = json['availableQty'];
    itemCode = json['itemCode'];
    masterQuantity = json['masterQuantity'];
    poductName = json['poductName'];
    productMasterId = json['productMasterId'];
  }

}*/

//============================================
class ProductByBUResponse {
  List<ProductByBUItems>? productByBUItems = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  ProductByBUResponse({this.productByBUItems, this.lastPage, this.page, this.pageSize, this.totalCount});

  ProductByBUResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      productByBUItems = <ProductByBUItems>[];
      json['items'].forEach((v) {
        productByBUItems!.add(ProductByBUItems.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class ProductByBUItems {
  String? brand;
  String? buName;
  String? category;
  String? dLP;
  String? division;
  String? lastOD;
  String? mRP;
  String? retailPrice;
  String? sKUCode;
  String? sQ;
  String? availableQty;
  String? color;
  String? itemCode;
  String? itemstatus;
  String? masterQuantity;
  String? poductName;
  String? productMasterId;
  String? totalsize;
  bool? isSelected;
  Color? cardColor;
  int itemCount = 1;
  double? totalPrice;
  int? selectedQty;

  ProductByBUItems({
    this.brand,
    this.buName,
    this.category,
    this.dLP,
    this.division,
    this.lastOD,
    this.mRP,
    this.retailPrice,
    this.sKUCode,
    this.sQ,
    this.availableQty,
    this.color,
    this.itemCode,
    this.itemstatus,
    this.masterQuantity,
    this.poductName,
    this.productMasterId,
    this.totalsize,
    this.isSelected,
    this.cardColor,
    this.itemCount = 1,
    this.totalPrice,
    this.selectedQty,
  });

  ProductByBUItems.fromJson(Map<String, dynamic> json) {
    brand = json['Brand'];
    buName = json['BuName'];
    category = json['Category'];
    dLP = json['DLP'];
    division = json['Division'];
    lastOD = json['Last_OD'];
    mRP = json['MRP'];
    retailPrice = json['RetailPrice'];
    sKUCode = json['SKU_Code'];
    sQ = json['SQ'];
    availableQty = json['availableQty'];
    color = json['color'];
    itemCode = json['itemCode'];
    itemstatus = json['itemstatus'];
    masterQuantity = json['masterQuantity'];
    poductName = json['poductName'];
    productMasterId = json['productMasterId'];
    totalsize = json['totalsize'];
  }
}
