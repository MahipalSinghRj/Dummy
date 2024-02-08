class ProductFilterResponse {
  List<String>? brand = [];
  List<String>? category = [];
  List<String>? division = [];

  ProductFilterResponse({this.brand, this.category, this.division});

  ProductFilterResponse.fromJson(Map<String, dynamic> json) {
    brand = (json['brand'] as List<dynamic>?)?.map((item) => item.toString()).toList();
    category = (json['category'] as List<dynamic>?)?.map((item) => item.toString()).toList();
    division = (json['division'] as List<dynamic>?)?.map((item) => item.toString()).toList();
  }
}
