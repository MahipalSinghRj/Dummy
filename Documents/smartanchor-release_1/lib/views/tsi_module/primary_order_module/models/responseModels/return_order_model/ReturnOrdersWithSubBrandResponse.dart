class ReturnOrdersWithSubBrandResponse {
  List<Items>? items;

  ReturnOrdersWithSubBrandResponse({this.items});

  ReturnOrdersWithSubBrandResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? subBrand;

  Items({this.subBrand});

  Items.fromJson(Map<String, dynamic> json) {
    subBrand = json['SubBrand'];
  }
}
