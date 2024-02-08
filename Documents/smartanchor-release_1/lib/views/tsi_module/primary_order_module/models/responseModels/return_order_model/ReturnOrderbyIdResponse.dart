/*class ReturnOrderByIdResponse {
  List<ReturnOrderByIdListData>? returnOrderByIdListData = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  ReturnOrderByIdResponse({this.returnOrderByIdListData, this.lastPage, this.page, this.pageSize, this.totalCount});

  ReturnOrderByIdResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      returnOrderByIdListData = <ReturnOrderByIdListData>[];
      json['items'].forEach((v) {
        returnOrderByIdListData!.add(ReturnOrderByIdListData.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class ReturnOrderByIdListData {
  int? availableQty;
  String? customerCode;
  String? customerName;
  String? dLP;
  String? mRP;
  String? productName;
  String? sKUCode;
  bool isSelected = false;
  double? totalPrice;
  int itemCount = 1;

  ReturnOrderByIdListData({
    this.availableQty,
    this.customerCode,
    this.customerName,
    this.dLP,
    this.mRP,
    this.productName,
    this.sKUCode,
    this.isSelected = false,
    this.totalPrice,
    this.itemCount = 1,
  });

  ReturnOrderByIdListData.fromJson(Map<String, dynamic> json) {
    availableQty = json['AvailableQty'];
    customerCode = json['CustomerCode'];
    customerName = json['CustomerName'];
    dLP = json['DLP'];
    mRP = json['MRP'];
    productName = json['ProductName'];
    sKUCode = json['SKUCode'];
  }
}*/

class ReturnOrderByIdResponse {
  List<ReturnOrderByIdListData>? returnOrderByIdListData = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  ReturnOrderByIdResponse({this.returnOrderByIdListData, this.lastPage, this.page, this.pageSize, this.totalCount});

  ReturnOrderByIdResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      returnOrderByIdListData = <ReturnOrderByIdListData>[];
      json['items'].forEach((v) {
        returnOrderByIdListData!.add(ReturnOrderByIdListData.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class ReturnOrderByIdListData {
  String? dLP;
  String? lastOD;
  String? mRP;
  String? sKUCode;
  String? sQ;
  String? availableQty;
  String? color;
  String? customerCode;
  String? customerName;
  String? masterQuantity;
  String? poductName;
  String? productMasterId;
  bool isSelected = false;
  double? totalPrice;
  int itemCount = 1;

  ReturnOrderByIdListData({
    this.dLP,
    this.lastOD,
    this.mRP,
    this.sKUCode,
    this.sQ,
    this.availableQty,
    this.color,
    this.customerCode,
    this.customerName,
    this.masterQuantity,
    this.poductName,
    this.productMasterId,
    this.isSelected = false,
    this.totalPrice,
    this.itemCount = 1,
  });

  ReturnOrderByIdListData.fromJson(Map<String, dynamic> json) {
    dLP = json['DLP'];
    lastOD = json['Last_OD'];
    mRP = json['MRP'];
    sKUCode = json['SKU_Code'];
    sQ = json['SQ'];
    availableQty = json['availableQty'];
    color = json['color'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    masterQuantity = json['masterQuantity'];
    poductName = json['poductName'];
    productMasterId = json['productMasterId'];
  }
}
