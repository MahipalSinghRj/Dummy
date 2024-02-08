class AllInvoiceResponseModal {
  Actions actions;
  List<dynamic> facets;
  List<Item> items;
  int lastPage;
  int page;
  int pageSize;
  int totalCount;

  AllInvoiceResponseModal({
    required this.actions,
    required this.facets,
    required this.items,
    required this.lastPage,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory AllInvoiceResponseModal.fromJson(Map<String, dynamic> json) =>
      AllInvoiceResponseModal(
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
  String bu;
  String date;
  String referenceCode;
  String salesOrder;
  String transactionType;
  bool isSelected;

  Item(
      {required this.bu,
      required this.date,
      required this.referenceCode,
      required this.salesOrder,
      required this.transactionType,
      this.isSelected = false});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        bu: json["Bu"],
        date: json["Date"],
        referenceCode: json["ReferenceCode"],
        salesOrder: json["SalesOrder"],
        transactionType: json["TransactionType"],
      );

  Map<String, dynamic> toJson() => {
        "Bu": bu,
        "Date": date,
        "ReferenceCode": referenceCode,
        "SalesOrder": salesOrder,
        "TransactionType": transactionType,
      };
}
