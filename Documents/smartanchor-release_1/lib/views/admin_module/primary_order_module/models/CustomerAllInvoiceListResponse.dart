class CustomerAllInvoiceListResponse {
  List<InvoiceLists>? invoiceLists;
  List<String>? buList;
  String? errorMessage;

  CustomerAllInvoiceListResponse({this.invoiceLists, this.buList,this.errorMessage});

  CustomerAllInvoiceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['InvoiceLists'] != null) {
      invoiceLists = <InvoiceLists>[];
      json['InvoiceLists'].forEach((v) {
        invoiceLists!.add(new InvoiceLists.fromJson(v));
      });
    }
    buList = json['buList'].cast<String>();
    errorMessage=json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoiceLists != null) {
      data['InvoiceLists'] = this.invoiceLists!.map((v) => v.toJson()).toList();
    }
    data['buList'] = this.buList;
    data['errorMessage']=this.errorMessage;
    return data;
  }
}

class InvoiceLists {
  String? bu;
  String? date;
  String? referenceNo;
  String? salesOrder;
  String? transactionType;

  InvoiceLists(
      {this.bu,
        this.date,
        this.referenceNo,
        this.salesOrder,
        this.transactionType});

  InvoiceLists.fromJson(Map<String, dynamic> json) {
    bu = json['bu'];
    date = json['date'];
    referenceNo = json['referenceNo'];
    salesOrder = json['salesOrder'];
    transactionType = json['transactionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bu'] = this.bu;
    data['date'] = this.date;
    data['referenceNo'] = this.referenceNo;
    data['salesOrder'] = this.salesOrder;
    data['transactionType'] = this.transactionType;
    return data;
  }
}
