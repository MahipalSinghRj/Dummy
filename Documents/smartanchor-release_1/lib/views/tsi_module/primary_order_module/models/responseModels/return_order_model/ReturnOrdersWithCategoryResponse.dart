class ReturnOrdersWithCategoryResponse {
  List<Items>? items;

  ReturnOrdersWithCategoryResponse({this.items});

  ReturnOrdersWithCategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? category;

  Items({this.category});

  Items.fromJson(Map<String, dynamic> json) {
    category = json['Category'];
  }
}
