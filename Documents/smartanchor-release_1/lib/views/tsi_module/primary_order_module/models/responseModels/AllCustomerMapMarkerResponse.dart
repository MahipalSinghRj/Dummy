class AllCustomerMapMarkerResponse {
  Actions actions;
  List<dynamic> facets;
  List<Item> items;
  int lastPage;
  int page;
  int pageSize;
  int totalCount;

  AllCustomerMapMarkerResponse({
    required this.actions,
    required this.facets,
    required this.items,
    required this.lastPage,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory AllCustomerMapMarkerResponse.fromJson(Map<String, dynamic> json) =>
      AllCustomerMapMarkerResponse(
        actions: Actions.fromJson(json["actions"]),
        facets: List<dynamic>.from(json["facets"].map((x) => x)),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        lastPage: json["lastPage"],
        page: json["page"],
        pageSize: json["pageSize"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "actions": actions.toJson(),
        "facets": List<dynamic>.from(facets.map((x) => x)),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "lastPage": lastPage,
        "page": page,
        "pageSize": pageSize,
        "totalCount": totalCount,
      };
}

class Actions {
  Actions();

  factory Actions.fromJson(Map<String, dynamic> json) => Actions();

  Map<String, dynamic> toJson() => {};
}

class Item {
  String address;
  String beat;
  String city;
  String customerCode;
  String customerName;
  String latitude;
  String longitude;
  String masterId;
  String state;

  Item({
    required this.address,
    required this.beat,
    required this.city,
    required this.customerCode,
    required this.customerName,
    required this.latitude,
    required this.longitude,
    required this.masterId,
    required this.state,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        address: json["Address"],
        beat: json["Beat"],
        city: json["City"],
        customerCode: json["CustomerCode"],
        customerName: json["CustomerName"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        masterId: json["MasterId"],
        state: json["State"],
      );

  Map<String, dynamic> toJson() => {
        "Address": address,
        "Beat": beat,
        "City": city,
        "CustomerCode": customerCode,
        "CustomerName": customerName,
        "Latitude": latitude,
        "Longitude": longitude,
        "MasterId": masterId,
        "State": state,
      };
}
