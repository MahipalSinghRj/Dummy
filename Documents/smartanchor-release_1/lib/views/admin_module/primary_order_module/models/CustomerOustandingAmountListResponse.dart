class CustomerOutsandingAmountResponse {
  List<OutstandingList>? outstandingList;
  String? totalCreditLimit;
  String? totalOutstanding;
  String? totalOverdue;

  CustomerOutsandingAmountResponse(
      {this.outstandingList,
        this.totalCreditLimit,
        this.totalOutstanding,
        this.totalOverdue});

  CustomerOutsandingAmountResponse.fromJson(Map<String, dynamic> json) {
    if (json['outstandingList'] != null) {
      outstandingList = <OutstandingList>[];
      json['outstandingList'].forEach((v) {
        outstandingList!.add(new OutstandingList.fromJson(v));
      });
    }
    totalCreditLimit = json['totalCreditLimit'];
    totalOutstanding = json['totalOutstanding'];
    totalOverdue = json['totalOverdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.outstandingList != null) {
      data['outstandingList'] =
          this.outstandingList!.map((v) => v.toJson()).toList();
    }
    data['totalCreditLimit'] = this.totalCreditLimit;
    data['totalOutstanding'] = this.totalOutstanding;
    data['totalOverdue'] = this.totalOverdue;
    return data;
  }
}

class OutstandingList {
  String? bu;
  String? creditLimit;
  String? outstanding;
  String? overdue;

  OutstandingList({this.bu, this.creditLimit, this.outstanding, this.overdue});

  OutstandingList.fromJson(Map<String, dynamic> json) {
    bu = json['Bu'];
    creditLimit = json['creditLimit'];
    outstanding = json['outstanding'];
    overdue = json['overdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bu'] = this.bu;
    data['creditLimit'] = this.creditLimit;
    data['outstanding'] = this.outstanding;
    data['overdue'] = this.overdue;
    return data;
  }
}
