class PaymentTermListResponse {
  List<PaymentTermList>? paymentTermList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  PaymentTermListResponse({this.paymentTermList, this.lastPage, this.page, this.pageSize, this.totalCount});

  PaymentTermListResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      paymentTermList = <PaymentTermList>[];
      json['items'].forEach((v) {
        paymentTermList!.add(PaymentTermList.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}

class PaymentTermList {
  String? description;
  String? lastUpdateDate;
  String? paymentTermId;
  String? paymentTermName;

  PaymentTermList({this.description, this.lastUpdateDate, this.paymentTermId, this.paymentTermName});

  PaymentTermList.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    lastUpdateDate = json['LastUpdateDate'];
    paymentTermId = json['PaymentTermId'];
    paymentTermName = json['PaymentTermName'];
  }
}
