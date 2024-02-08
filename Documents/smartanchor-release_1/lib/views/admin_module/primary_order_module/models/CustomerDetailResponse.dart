class CustomerDetailResponse {
  String? address;
  String? beat;
  String? city;
  String? creditLimit;
  String? customerCode;
  String? customerName;
  String? noOrder;
  String? orderedValue;
  String? outstanding;
  String? overdue;
  String? phoneNo;
  String? returnOrder;
  String? state;
  String? totalOrdered;

  CustomerDetailResponse(
      {this.address,
        this.beat,
        this.city,
        this.creditLimit,
        this.customerCode,
        this.customerName,
        this.noOrder,
        this.orderedValue,
        this.outstanding,
        this.overdue,
        this.phoneNo,
        this.returnOrder,
        this.state,
        this.totalOrdered});

  CustomerDetailResponse.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    beat = json['beat'];
    city = json['city'];
    creditLimit = json['creditLimit'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    noOrder = json['noOrder'];
    orderedValue = json['orderedValue'];
    outstanding = json['outstanding'];
    overdue = json['overdue'];
    phoneNo = json['phoneNo'];
    returnOrder = json['returnOrder'];
    state = json['state'];
    totalOrdered = json['totalOrdered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['beat'] = this.beat;
    data['city'] = this.city;
    data['creditLimit'] = this.creditLimit;
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['noOrder'] = this.noOrder;
    data['orderedValue'] = this.orderedValue;
    data['outstanding'] = this.outstanding;
    data['overdue'] = this.overdue;
    data['phoneNo'] = this.phoneNo;
    data['returnOrder'] = this.returnOrder;
    data['state'] = this.state;
    data['totalOrdered'] = this.totalOrdered;
    return data;
  }
}
