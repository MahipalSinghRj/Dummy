class RetailerNewOrderDetailResponse {
  String? address;
  String? adharNo;
  String? beat;
  String? city;
  String? creditLimit;
  String? district;
  String? geoCordinator;
  String? gstNo;
  String? mobileNo;
  List<NewOrderDetailsLists>? newOrderDetailsLists;
  String? outstanding;
  String? overdue;
  String? panNo;
  String? pincode;
  String? proprietorName;
  String? shopName;
  String? state;

  RetailerNewOrderDetailResponse(
      {this.address,
      this.adharNo,
      this.beat,
      this.city,
      this.creditLimit,
      this.district,
      this.geoCordinator,
      this.gstNo,
      this.mobileNo,
      this.newOrderDetailsLists,
      this.outstanding,
      this.overdue,
      this.panNo,
      this.pincode,
      this.proprietorName,
      this.shopName,
      this.state});

  RetailerNewOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    adharNo = json['adharNo'];
    beat = json['beat'];
    city = json['city'];
    creditLimit = json['creditLimit'];
    district = json['district'];
    geoCordinator = json['geoCordinator'];
    gstNo = json['gstNo'];
    mobileNo = json['mobileNo'];
    if (json['newOrderDetailsLists'] != null) {
      newOrderDetailsLists = <NewOrderDetailsLists>[];
      json['newOrderDetailsLists'].forEach((v) {
        newOrderDetailsLists!.add(new NewOrderDetailsLists.fromJson(v));
      });
    }
    outstanding = json['outstanding'];
    overdue = json['overdue'];
    panNo = json['panNo'];
    pincode = json['pincode'];
    proprietorName = json['proprietorName'];
    shopName = json['shopName'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['adharNo'] = this.adharNo;
    data['beat'] = this.beat;
    data['city'] = this.city;
    data['creditLimit'] = this.creditLimit;
    data['district'] = this.district;
    data['geoCordinator'] = this.geoCordinator;
    data['gstNo'] = this.gstNo;
    data['mobileNo'] = this.mobileNo;
    if (this.newOrderDetailsLists != null) {
      data['newOrderDetailsLists'] =
          this.newOrderDetailsLists!.map((v) => v.toJson()).toList();
    }
    data['outstanding'] = this.outstanding;
    data['overdue'] = this.overdue;
    data['panNo'] = this.panNo;
    data['pincode'] = this.pincode;
    data['proprietorName'] = this.proprietorName;
    data['shopName'] = this.shopName;
    data['state'] = this.state;
    return data;
  }
}

class NewOrderDetailsLists {
  String? productName;
  String? rlp;
  String? skuCode;
  String? totalQuantity;

  NewOrderDetailsLists(
      {this.productName, this.rlp, this.skuCode, this.totalQuantity});

  NewOrderDetailsLists.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    rlp = json['rlp'];
    skuCode = json['skuCode'];
    totalQuantity = json['totalQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['rlp'] = this.rlp;
    data['skuCode'] = this.skuCode;
    data['totalQuantity'] = this.totalQuantity;
    return data;
  }
}
