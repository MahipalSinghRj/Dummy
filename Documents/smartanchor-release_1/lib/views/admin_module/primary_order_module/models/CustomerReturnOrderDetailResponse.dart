class CustomerReturnOrderDetailResponse {
  String? orderDate;
  String? orderId;
  String? orderQuantity;
  String? orderStatus;
  String? productCount;
  List<ProductDetails>? productDetails;

  CustomerReturnOrderDetailResponse(
      {this.orderDate,
        this.orderId,
        this.orderQuantity,
        this.orderStatus,
        this.productCount,
        this.productDetails});

  CustomerReturnOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    orderDate = json['orderDate'];
    orderId = json['orderId'];
    orderQuantity = json['orderQuantity'];
    orderStatus = json['orderStatus'];
    productCount = json['productCount'];
    if (json['productDetails'] != null) {
      productDetails = <ProductDetails>[];
      json['productDetails'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDate'] = this.orderDate;
    data['orderId'] = this.orderId;
    data['orderQuantity'] = this.orderQuantity;
    data['orderStatus'] = this.orderStatus;
    data['productCount'] = this.productCount;
    if (this.productDetails != null) {
      data['productDetails'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetails {
  String? dlp;
  String? productName;
  String? quantity;
  String? skuCode;
  String? totalPrice;

  ProductDetails(
      {this.dlp,
        this.productName,
        this.quantity,
        this.skuCode,
        this.totalPrice});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    dlp = json['dlp'];
    productName = json['productName'];
    quantity = json['quantity'];
    skuCode = json['skuCode'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dlp'] = this.dlp;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['skuCode'] = this.skuCode;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
