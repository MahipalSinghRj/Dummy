class RetailerNoOrderDetailResponse {
  String? address;
  String? adharNo;
  String? beat;
  String? city;
  String? creditLimit;
  String? district;
  String? errorMessage;
  String? fileName;
  String? fileUrl;
  String? geoCordinator;
  String? gstNo;
  String? mobileNo;
  String? outstanding;
  String? overdue;
  String? panNo;
  String? pincode;
  String? proprietorName;
  String? reason;
  String? remarks;
  String? shopName;
  String? state;

  RetailerNoOrderDetailResponse(
      {this.address,
        this.adharNo,
        this.beat,
        this.city,
        this.creditLimit,
        this.district,
        this.errorMessage,
        this.fileName,
        this.fileUrl,
        this.geoCordinator,
        this.gstNo,
        this.mobileNo,
        this.outstanding,
        this.overdue,
        this.panNo,
        this.pincode,
        this.proprietorName,
        this.reason,
        this.remarks,
        this.shopName,
        this.state});

  RetailerNoOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    adharNo = json['adharNo'];
    beat = json['beat'];
    city = json['city'];
    creditLimit = json['creditLimit'];
    district = json['district'];
    errorMessage = json['errorMessage'];
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    geoCordinator = json['geoCordinator'];
    gstNo = json['gstNo'];
    mobileNo = json['mobileNo'];
    outstanding = json['outstanding'];
    overdue = json['overdue'];
    panNo = json['panNo'];
    pincode = json['pincode'];
    proprietorName = json['proprietorName'];
    reason = json['reason'];
    remarks = json['remarks'];
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
    data['errorMessage'] = this.errorMessage;
    data['fileName'] = this.fileName;
    data['fileUrl'] = this.fileUrl;
    data['geoCordinator'] = this.geoCordinator;
    data['gstNo'] = this.gstNo;
    data['mobileNo'] = this.mobileNo;
    data['outstanding'] = this.outstanding;
    data['overdue'] = this.overdue;
    data['panNo'] = this.panNo;
    data['pincode'] = this.pincode;
    data['proprietorName'] = this.proprietorName;
    data['reason'] = this.reason;
    data['remarks'] = this.remarks;
    data['shopName'] = this.shopName;
    data['state'] = this.state;
    return data;
  }
}
