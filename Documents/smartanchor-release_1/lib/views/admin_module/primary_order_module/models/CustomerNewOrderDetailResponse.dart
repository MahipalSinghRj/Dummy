class CustomerNewOrderDetailResponse {
  String? discount;
  String? orderDate;
  String? orderQTY;
  String? orderStatus;
  List<ProductLists>? productLists;
  String? tax;
  String? totalOrderValueAfterDiscount;
  String? totalOrderValueBeforeDiscount;

  CustomerNewOrderDetailResponse(
      {this.discount,
        this.orderDate,
        this.orderQTY,
        this.orderStatus,
        this.productLists,
        this.tax,
        this.totalOrderValueAfterDiscount,
        this.totalOrderValueBeforeDiscount});

  CustomerNewOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    orderDate = json['orderDate'];
    orderQTY = json['orderQTY'];
    orderStatus = json['orderStatus'];
    if (json['productLists'] != null) {
      productLists = <ProductLists>[];
      json['productLists'].forEach((v) {
        productLists!.add(new ProductLists.fromJson(v));
      });
    }
    tax = json['tax'];
    totalOrderValueAfterDiscount = json['totalOrderValueAfterDiscount'];
    totalOrderValueBeforeDiscount = json['totalOrderValueBeforeDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['orderDate'] = this.orderDate;
    data['orderQTY'] = this.orderQTY;
    data['orderStatus'] = this.orderStatus;
    if (this.productLists != null) {
      data['productLists'] = this.productLists!.map((v) => v.toJson()).toList();
    }
    data['tax'] = this.tax;
    data['totalOrderValueAfterDiscount'] = this.totalOrderValueAfterDiscount;
    data['totalOrderValueBeforeDiscount'] = this.totalOrderValueBeforeDiscount;
    return data;
  }
}

class ProductLists {
  String? dLP;
  String? price;
  String? productName;
  String? quantity;
  String? skuCode;

  ProductLists(
      {this.dLP, this.price, this.productName, this.quantity, this.skuCode});

  ProductLists.fromJson(Map<String, dynamic> json) {
    dLP = json['DLP'];
    price = json['price'];
    productName = json['productName'];
    quantity = json['quantity'];
    skuCode = json['skuCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DLP'] = this.dLP;
    data['price'] = this.price;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['skuCode'] = this.skuCode;
    return data;
  }
}
