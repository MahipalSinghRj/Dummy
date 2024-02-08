class RetailerProfileDetailResponse {
  String? address;
  String? adharNo;
  String? beat;
  String? city;
  String? creditLimit;
  String? district;
  String? geoCordinator;
  String? gstNo;
  String? iaqDealer;
  String? lightingDealer;
  String? mobileNo;
  int? noOrderCount;
  int? orderValue;
  String? outstanding;
  String? overdue;
  String? panNo;
  String? pincode;
  String? powerDealer;
  String? proprietorName;
  String? shopName;
  String? state;
  int? totalOrderItems;

  RetailerProfileDetailResponse(
      {this.address,
        this.adharNo,
        this.beat,
        this.city,
        this.creditLimit,
        this.district,
        this.geoCordinator,
        this.gstNo,
        this.iaqDealer,
        this.lightingDealer,
        this.mobileNo,
        this.noOrderCount,
        this.orderValue,
        this.outstanding,
        this.overdue,
        this.panNo,
        this.pincode,
        this.powerDealer,
        this.proprietorName,
        this.shopName,
        this.state,
        this.totalOrderItems});

  RetailerProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    adharNo = json['adharNo'];
    beat = json['beat'];
    city = json['city'];
    creditLimit = json['creditLimit'];
    district = json['district'];
    geoCordinator = json['geoCordinator'];
    gstNo = json['gstNo'];
    iaqDealer = json['iaqDealer'];
    lightingDealer = json['lightingDealer'];
    mobileNo = json['mobileNo'];
    noOrderCount = json['noOrderCount'];
    orderValue = json['orderValue'];
    outstanding = json['outstanding'];
    overdue = json['overdue'];
    panNo = json['panNo'];
    pincode = json['pincode'];
    powerDealer = json['powerDealer'];
    proprietorName = json['proprietorName'];
    shopName = json['shopName'];
    state = json['state'];
    totalOrderItems = json['totalOrderItems'];
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
    data['iaqDealer'] = this.iaqDealer;
    data['lightingDealer'] = this.lightingDealer;
    data['mobileNo'] = this.mobileNo;
    data['noOrderCount'] = this.noOrderCount;
    data['orderValue'] = this.orderValue;
    data['outstanding'] = this.outstanding;
    data['overdue'] = this.overdue;
    data['panNo'] = this.panNo;
    data['pincode'] = this.pincode;
    data['powerDealer'] = this.powerDealer;
    data['proprietorName'] = this.proprietorName;
    data['shopName'] = this.shopName;
    data['state'] = this.state;
    data['totalOrderItems'] = this.totalOrderItems;
    return data;
  }
}
