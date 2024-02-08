class TopCustomersAdminResponse {
  String? errorCode;
  String? errorMessage;
  List<TopCustomersAdmin>? topCustomers;

  TopCustomersAdminResponse(
      {this.errorCode, this.errorMessage, this.topCustomers});

  TopCustomersAdminResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['topCustomers'] != null) {
      topCustomers = <TopCustomersAdmin>[];
      json['topCustomers'].forEach((v) {
        topCustomers!.add(new TopCustomersAdmin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    if (this.topCustomers != null) {
      data['topCustomers'] = this.topCustomers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopCustomersAdmin {
  String? buName;
  String? customerBeat;
  String? customerCity;
  String? customerCode;
  String? customerCreditLimit;
  String? customerName;
  String? customerOSAmount;
  String? customerOVAmount;
  String? customerState;
  String? cutomerAddress;
  String? masterId;

  TopCustomersAdmin(
      {this.buName,
        this.customerBeat,
        this.customerCity,
        this.customerCode,
        this.customerCreditLimit,
        this.customerName,
        this.customerOSAmount,
        this.customerOVAmount,
        this.customerState,
        this.cutomerAddress,
        this.masterId});

  TopCustomersAdmin.fromJson(Map<String, dynamic> json) {
    buName = json['buName'];
    customerBeat = json['customerBeat'];
    customerCity = json['customerCity'];
    customerCode = json['customerCode'];
    customerCreditLimit = json['customerCreditLimit'];
    customerName = json['customerName'];
    customerOSAmount = json['customerOSAmount'];
    customerOVAmount = json['customerOVAmount'];
    customerState = json['customerState'];
    cutomerAddress = json['cutomerAddress'];
    masterId = json['masterId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buName'] = this.buName;
    data['customerBeat'] = this.customerBeat;
    data['customerCity'] = this.customerCity;
    data['customerCode'] = this.customerCode;
    data['customerCreditLimit'] = this.customerCreditLimit;
    data['customerName'] = this.customerName;
    data['customerOSAmount'] = this.customerOSAmount;
    data['customerOVAmount'] = this.customerOVAmount;
    data['customerState'] = this.customerState;
    data['cutomerAddress'] = this.cutomerAddress;
    data['masterId'] = this.masterId;
    return data;
  }
}
