class CustomerListResponse {
  String? focusedCustomer;
  String? newCustomer;
  String? totalCustomer;
  List<CustomerLists>? customerLists;


  CustomerListResponse(
      {this.focusedCustomer,
        this.newCustomer,
        this.totalCustomer,
        this.customerLists});

  CustomerListResponse.fromJson(Map<String, dynamic> json) {
    focusedCustomer = json['FocusedCustomer'];
    newCustomer = json['NewCustomer'];
    totalCustomer = json['TotalCustomer'];
    if (json['customerLists'] != null) {
      customerLists = <CustomerLists>[];
      json['customerLists'].forEach((v) {
        customerLists!.add(new CustomerLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FocusedCustomer'] = this.focusedCustomer;
    data['NewCustomer'] = this.newCustomer;
    data['TotalCustomer'] = this.totalCustomer;
    if (this.customerLists != null) {
      data['customerLists'] =
          this.customerLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerLists {
  String? address;
  String? beat;
  String? city;
  String? creditLimit;
  String? customerCode;
  String? customerName;
  String? outstanding;
  String? overdue;
  String? phoneNo;
  String? state;

  CustomerLists(
      {this.address,
        this.beat,
        this.city,
        this.creditLimit,
        this.customerCode,
        this.customerName,
        this.outstanding,
        this.overdue,
        this.phoneNo,
        this.state});

  CustomerLists.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    beat = json['Beat'];
    city = json['City'];
    creditLimit = json['CreditLimit'];
    customerCode = json['CustomerCode'];
    customerName = json['CustomerName'];
    outstanding = json['Outstanding'];
    overdue = json['Overdue'];
    phoneNo = json['PhoneNo'];
    state = json['State'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['Beat'] = this.beat;
    data['City'] = this.city;
    data['CreditLimit'] = this.creditLimit;
    data['CustomerCode'] = this.customerCode;
    data['CustomerName'] = this.customerName;
    data['Outstanding'] = this.outstanding;
    data['Overdue'] = this.overdue;
    data['PhoneNo'] = this.phoneNo;
    data['State'] = this.state;
    return data;
  }
}
