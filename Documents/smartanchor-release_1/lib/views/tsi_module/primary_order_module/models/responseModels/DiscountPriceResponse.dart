class DiscountPriceResponse {

  List<Items>? items;

  DiscountPriceResponse({this.items});

  DiscountPriceResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) { items!.add(new Items.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Items {
  String? orderValue;
  String? discount;
  String? tax;
  String? totalOrderValue;
  Items({
    this.orderValue,
    this.discount,
    this.tax,
    this.totalOrderValue,
  });

  Items.fromJson(Map<String, dynamic> json) {
    orderValue = json['orderValue'];
    discount = json['discount'];
    tax = json['tax'];
    totalOrderValue = json['totalOrderValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderValue'] = this.orderValue;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['totalOrderValue'] = this.totalOrderValue;
    return data;
  }
}
