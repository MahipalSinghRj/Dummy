class RetailerNoOrderListResponse {
  String? noOrderCount;
  List<NoOrderGraphLists>? noOrderGraphLists;
  List<NoOrderLists>? noOrderLists;
  int? ordercount;
  String? totalRetailerVisited;

  RetailerNoOrderListResponse(
      {this.noOrderCount,
        this.noOrderGraphLists,
        this.noOrderLists,
        this.ordercount,
        this.totalRetailerVisited});

  RetailerNoOrderListResponse.fromJson(Map<String, dynamic> json) {
    noOrderCount = json['noOrderCount'];
    if (json['noOrderGraphLists'] != null) {
      noOrderGraphLists = <NoOrderGraphLists>[];
      json['noOrderGraphLists'].forEach((v) {
        noOrderGraphLists!.add(new NoOrderGraphLists.fromJson(v));
      });
    }
    if (json['noOrderLists'] != null) {
      noOrderLists = <NoOrderLists>[];
      json['noOrderLists'].forEach((v) {
        noOrderLists!.add(new NoOrderLists.fromJson(v));
      });
    }
    ordercount = json['ordercount'];
    totalRetailerVisited = json['totalRetailerVisited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noOrderCount'] = this.noOrderCount;
    if (this.noOrderGraphLists != null) {
      data['noOrderGraphLists'] =
          this.noOrderGraphLists!.map((v) => v.toJson()).toList();
    }
    if (this.noOrderLists != null) {
      data['noOrderLists'] = this.noOrderLists!.map((v) => v.toJson()).toList();
    }
    data['ordercount'] = this.ordercount;
    data['totalRetailerVisited'] = this.totalRetailerVisited;
    return data;
  }
}

class NoOrderGraphLists {
  int? customerVisitedCount;
  int? monthhNo;
  int? noOrdersCount;

  NoOrderGraphLists(
      {this.customerVisitedCount, this.monthhNo, this.noOrdersCount});

  NoOrderGraphLists.fromJson(Map<String, dynamic> json) {
    customerVisitedCount = json['customerVisitedCount'];
    monthhNo = json['monthhNo'];
    noOrdersCount = json['noOrdersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerVisitedCount'] = this.customerVisitedCount;
    data['monthhNo'] = this.monthhNo;
    data['noOrdersCount'] = this.noOrdersCount;
    return data;
  }
}

class NoOrderLists {
  String? beat;
  String? city;
  String? code;
  String? date;
  String? noOrderId;
  String? reason;
  String? retailerName;
  String? state;

  NoOrderLists(
      {this.beat,
        this.city,
        this.code,
        this.date,
        this.noOrderId,
        this.reason,
        this.retailerName,
        this.state});

  NoOrderLists.fromJson(Map<String, dynamic> json) {
    beat = json['beat'];
    city = json['city'];
    code = json['code'];
    date = json['date'];
    noOrderId = json['noOrderId'];
    reason = json['reason'];
    retailerName = json['retailerName'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beat'] = this.beat;
    data['city'] = this.city;
    data['code'] = this.code;
    data['date'] = this.date;
    data['noOrderId'] = this.noOrderId;
    data['reason'] = this.reason;
    data['retailerName'] = this.retailerName;
    data['state'] = this.state;
    return data;
  }
}
