class DistributeResponse {
  List<Distributor>? distributor;
  List<String>? reasons;

  DistributeResponse({this.distributor, this.reasons});

  DistributeResponse.fromJson(Map<String, dynamic> json) {
    if (json['distributor'] != null) {
      distributor = <Distributor>[];
      json['distributor'].forEach((v) {
        distributor!.add(new Distributor.fromJson(v));
      });
    }
    reasons = json['reasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distributor != null) {
      data['distributor'] = this.distributor!.map((v) => v.toJson()).toList();
    }
    data['reasons'] = this.reasons;
    return data;
  }
}

class Distributor {
  String? dealerCode;
  String? dealerName;

  Distributor({this.dealerCode, this.dealerName});

  Distributor.fromJson(Map<String, dynamic> json) {
    dealerCode = json['DealerCode'];
    dealerName = json['DealerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DealerCode'] = this.dealerCode;
    data['DealerName'] = this.dealerName;
    return data;
  }
}
