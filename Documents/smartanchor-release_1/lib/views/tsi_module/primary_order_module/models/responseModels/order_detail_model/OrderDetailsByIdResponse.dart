/*class OrderDetailsByIdResponse {
  String? orderDate;
  String? orderId;
  String? orderQty;
  String? sTATUSFLAG;
  List<ProductDetailsbodies>? productDetailsbodies = [];

  OrderDetailsByIdResponse({this.orderDate, this.orderId, this.orderQty, this.sTATUSFLAG, this.productDetailsbodies});

  OrderDetailsByIdResponse.fromJson(Map<String, dynamic> json) {
    orderDate = json['OrderDate'];
    orderId = json['OrderId'];
    orderQty = json['OrderQty'];
    sTATUSFLAG = json['STATUS_FLAG'];
    if (json['productDetailsbodies'] != null) {
      productDetailsbodies = <ProductDetailsbodies>[];
      json['productDetailsbodies'].forEach((v) {
        productDetailsbodies!.add(ProductDetailsbodies.fromJson(v));
      });
    }
  }
}

class ProductDetailsbodies {
  String? productName;
  String? productQty;
  String? unitPriceList;
  String? productMasterId;
  double? totalPrice;
  int itemCount = 1;

  ProductDetailsbodies({this.productName, this.productQty, this.unitPriceList, this.totalPrice, this.itemCount = 1, this.productMasterId});

  ProductDetailsbodies.fromJson(Map<String, dynamic> json) {
    productName = json['ProductName'];
    productQty = json['ProductQty'];
    unitPriceList = json['UnitPriceList'];
    productMasterId = json['SkuCode'];
  }
}*/

class OrderDetailsByIdResponse {
  String? orderDate;
  String? orderId;
  String? orderQty;
  String? sTATUSFLAG;
  String? PAYMENT_TERM_ID;
  String? PAYMENT_TERM_NAME;

  List<ProductDetailsbodies>? productDetailsbodies = [];

  OrderDetailsByIdResponse({this.orderDate, this.orderId, this.orderQty, this.sTATUSFLAG, this.productDetailsbodies});

  OrderDetailsByIdResponse.fromJson(Map<String, dynamic> json) {
    orderDate = json['OrderDate'];
    orderId = json['OrderId'];
    orderQty = json['OrderQty'];
    sTATUSFLAG = json['STATUS_FLAG'];
    PAYMENT_TERM_ID = json['PAYMENT_TERM_ID'];
    PAYMENT_TERM_NAME = json['PAYMENT_TERM_NAME'];
    if (json['productDetailsbodies'] != null) {
      productDetailsbodies = <ProductDetailsbodies>[];
      json['productDetailsbodies'].forEach((v) {
        productDetailsbodies!.add(ProductDetailsbodies.fromJson(v));
      });
    }
  }
}

class ProductDetailsbodies {
  String? dLP;
  String? lastOD;
  String? productName;
  String? productQty;
  String? sQ;
  String? skuCode;
  String? unitPriceList;
  String? availableQty;
  String? color;
  String? itemCode;
  String? masterQuantity;
  String? productMasterId;
  String? punchedQty;
  int itemCount = 1;
  double? totalPrice;
  String? mrp;

  ProductDetailsbodies({
    this.dLP,
    this.lastOD,
    this.productName,
    this.productQty,
    this.sQ,
    this.skuCode,
    this.unitPriceList,
    this.availableQty,
    this.color,
    this.itemCode,
    this.masterQuantity,
    this.productMasterId,
    this.itemCount = 1,
    this.totalPrice,
    this.punchedQty,
    this.mrp,
  });

  ProductDetailsbodies.fromJson(Map<String, dynamic> json) {
    dLP = json['DLP'];
    lastOD = json['Last_OD'];
    productName = json['ProductName'];
    productQty = json['ProductQty'];
    sQ = json['SQ'];
    punchedQty = json['PunchedQty'];
    skuCode = json['SkuCode'];
    unitPriceList = json['UnitPriceList'];
    availableQty = json['availableQty'];
    color = json['color'];
    itemCode = json['itemCode'];
    masterQuantity = json['masterQuantity'];
    productMasterId = json['productMasterId'];
    mrp = json['MRP'];
  }
}
