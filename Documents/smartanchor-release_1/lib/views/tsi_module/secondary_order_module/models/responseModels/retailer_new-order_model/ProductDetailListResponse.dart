import 'dart:ui';

class ProductDetailListResponse {
  List<String>? brandList = [];
  List<String>? categoryList = [];
  List<String>? divisionList = [];
  List<FocusedProductLists>? focusedProductLists = [];
  List<ProductLists>? productLists = [];
  String? totalProductQuantity;

  ProductDetailListResponse({this.brandList, this.categoryList, this.divisionList, this.focusedProductLists, this.productLists, this.totalProductQuantity});

/*  ProductDetailListResponse.fromJson(Map<String, dynamic> json) {
    brandList = json['brandList'].cast<String>();
    categoryList = json['categoryList'].cast<String>();
    divisionList = json['divisionList'].cast<String>();
    if (json['focusedProductLists'] != null) {
      focusedProductLists = <FocusedProductLists>[];
      json['focusedProductLists'].forEach((v) {
        focusedProductLists!.add(FocusedProductLists.fromJson(v));
      });
    }
    if (json['productLists'] != null) {
      productLists = <ProductLists>[];
      json['productLists'].forEach((v) {
        productLists!.add(ProductLists.fromJson(v));
      });
    }
    totalProductQuantity = json['totalProductQuantity'];
  }*/

  ProductDetailListResponse.fromJson(Map<String, dynamic> json) {
    brandList = json['brandList']?.cast<String>() ?? [];
    categoryList = json['categoryList']?.cast<String>() ?? [];
    divisionList = json['divisionList']?.cast<String>() ?? [];

    if (json['focusedProductLists'] != null) {
      focusedProductLists = <FocusedProductLists>[];
      json['focusedProductLists'].forEach((v) {
        focusedProductLists!.add(FocusedProductLists.fromJson(v));
      });
    } else {
      focusedProductLists = [];
    }

    if (json['productLists'] != null) {
      productLists = <ProductLists>[];
      json['productLists'].forEach((v) {
        productLists!.add(ProductLists.fromJson(v));
      });
    } else {
      productLists = [];
    }

    totalProductQuantity = json['totalProductQuantity'];
  }
}

class FocusedProductLists {
  String? lastOrderd;
  String? mq;
  String? productName;
  String? quantity;
  String? rlp;
  String? skuCode;
  String? sq;
  String? distributor;
  Color? cardColor;
  int itemCount = 1;
  double? totalPrice;

  FocusedProductLists({
    this.lastOrderd,
    this.mq,
    this.productName,
    this.quantity,
    this.rlp,
    this.skuCode,
    this.sq,
    this.distributor,
    this.cardColor,
    this.itemCount = 1,
    this.totalPrice,
  });

  FocusedProductLists.fromJson(Map<String, dynamic> json) {
    lastOrderd = json['lastOrderd'];
    mq = json['mq'];
    productName = json['productName'];
    quantity = json['quantity'];
    rlp = json['rlp'];
    skuCode = json['skuCode'];
    sq = json['sq'];
    distributor = json['distributor'];
  }
}

class ProductLists {
  String? lastOrderd;
  String? mq;
  String? productName;
  String? quantity;
  String? rlp;
  String? skuCode;
  String? sq;
  String? distributor;
  Color? cardColor;
  int itemCount = 1;
  double? totalPrice;

  ProductLists({
    this.lastOrderd,
    this.mq,
    this.productName,
    this.quantity,
    this.rlp,
    this.skuCode,
    this.sq,
    this.distributor,
    this.cardColor,
    this.itemCount = 1,
    this.totalPrice,
  });

  ProductLists.fromJson(Map<String, dynamic> json) {
    lastOrderd = json['lastOrderd'];
    mq = json['mq'];
    productName = json['productName'];
    quantity = json['quantity'];
    rlp = json['rlp'];
    skuCode = json['skuCode'];
    sq = json['sq'];
    distributor = json['distributor'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = {
//     'lastOrderd': lastOrderd,
//     'mq': mq,
//     'productName': productName,
//     'quantity': quantity,
//     'rlp': rlp,
//     'skuCode': skuCode,
//     'sq': sq,
//     'distributor': distributor,
//   };
//   return data;
// }
}
