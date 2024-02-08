class CustomerNoOrderListResponse {
  String? noOrderCount;
  List<NoOrderDetails>? noOrderDetails;
  List<GraphDetails>? graphDetails;
  String? totalCustomerVisited;

  CustomerNoOrderListResponse(
      {this.noOrderCount,
        this.noOrderDetails,
        this.graphDetails,
        this.totalCustomerVisited});

  CustomerNoOrderListResponse.fromJson(Map<String, dynamic> json) {
    noOrderCount = json['NoOrderCount'];
    if (json['NoOrderDetails'] != null) {
      noOrderDetails = <NoOrderDetails>[];
      json['NoOrderDetails'].forEach((v) {
        noOrderDetails!.add(new NoOrderDetails.fromJson(v));
      });
    }
    if (json['graphDetails'] != null) {
      graphDetails = <GraphDetails>[];
      json['graphDetails'].forEach((v) {
        graphDetails!.add(new GraphDetails.fromJson(v));
      });
    }
    totalCustomerVisited = json['totalCustomerVisited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NoOrderCount'] = this.noOrderCount;
    if (this.noOrderDetails != null) {
      data['NoOrderDetails'] =
          this.noOrderDetails!.map((v) => v.toJson()).toList();
    }
    if (this.graphDetails != null) {
      data['graphDetails'] = this.graphDetails!.map((v) => v.toJson()).toList();
    }
    data['totalCustomerVisited'] = this.totalCustomerVisited;
    return data;
  }
}

class NoOrderDetails {
  String? beat;
  String? city;
  String? date;
  String? noOrderId;
  String? reason;
  String? state;
  String? customerCode;
  String? customerName;

  NoOrderDetails(
      {this.beat,
        this.city,
        this.date,
        this.noOrderId,
        this.reason,
        this.state,
        this.customerCode,
        this.customerName});

  NoOrderDetails.fromJson(Map<String, dynamic> json) {
    beat = json['Beat'];
    city = json['City'];
    date = json['Date'];
    noOrderId = json['NoOrderId'];
    reason = json['Reason'];
    state = json['State'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Beat'] = this.beat;
    data['City'] = this.city;
    data['Date'] = this.date;
    data['NoOrderId'] = this.noOrderId;
    data['Reason'] = this.reason;
    data['State'] = this.state;
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    return data;
  }
}

class GraphDetails {
  String? customerCount;
  String? orderCounnt;

  GraphDetails({this.customerCount, this.orderCounnt});

  GraphDetails.fromJson(Map<String, dynamic> json) {
    customerCount = json['customerCount'];
    orderCounnt = json['orderCounnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCount'] = this.customerCount;
    data['orderCounnt'] = this.orderCounnt;
    return data;
  }
}
