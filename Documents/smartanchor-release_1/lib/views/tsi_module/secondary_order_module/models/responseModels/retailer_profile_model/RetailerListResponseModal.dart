class RetailersListResponseModal {
  Actions actions;
  List<dynamic> facets;
  List<RetailerListItem> items;
  int lastPage;
  int page;
  int pageSize;
  int totalCount;

  RetailersListResponseModal({
    required this.actions,
    required this.facets,
    required this.items,
    required this.lastPage,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory RetailersListResponseModal.fromJson(Map<String, dynamic> json) =>
      RetailersListResponseModal(
        actions: Actions.fromJson(json["actions"] ?? {}),
        facets: json["facets"] == null
            ? []
            : List<dynamic>.from(json["facets"] ?? []).map((x) => x).toList(),
        items: List<RetailerListItem>.from(
            json["items"]?.map((x) => RetailerListItem.fromJson(x)) ?? []),
        lastPage: json["lastPage"] ?? 0,
        page: json["page"] ?? 0,
        pageSize: json["pageSize"] ?? 0,
        totalCount: json["totalCount"] ?? 0,
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

class RetailerListItem {
  String address;
  String beat;
  String city;
  String code;
  String customerName;
  String latitude;
  String longitude;
  String mobileNo;
  String state;
  String verifyFlag;

  RetailerListItem({
    required this.address,
    required this.beat,
    required this.city,
    required this.code,
    required this.customerName,
    required this.latitude,
    required this.longitude,
    required this.mobileNo,
    required this.state,
    required this.verifyFlag,
  });

  factory RetailerListItem.fromJson(Map<String, dynamic> json) =>
      RetailerListItem(
        address: json["address"] ?? '',
        beat: json["beat"] ?? '',
        city: json["city"] ?? '',
        code: json["code"] ?? '',
        customerName: json["customerName"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
        mobileNo: json["mobileNo"] ?? '',
        state: json["state"] ?? '',
        verifyFlag: json["verifyFlag"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "beat": beat,
        "city": city,
        "code": code,
        "customerName": customerName,
        "latitude": latitude,
        "longitude": longitude,
        "mobileNo": mobileNo,
        "state": state,
        "verifyFlag": verifyFlag,
      };
}
