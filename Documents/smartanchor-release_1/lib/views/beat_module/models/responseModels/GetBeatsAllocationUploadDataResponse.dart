class GetBeatsAllocationUploadDataResponse {
  List<BeatsAllocationData>? beatsAllocationData = [];

  GetBeatsAllocationUploadDataResponse({this.beatsAllocationData});

  GetBeatsAllocationUploadDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['beatsAllocationData'] != null) {
      beatsAllocationData = <BeatsAllocationData>[];
      json['beatsAllocationData'].forEach((v) {
        beatsAllocationData!.add(new BeatsAllocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.beatsAllocationData != null) {
      data['beatsAllocationData'] = this.beatsAllocationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BeatsAllocationData {
  String? beatAllocationMasterId;
  String? beatCode;
  String? beatDate;
  String? code;
  String? status;
  String? userName;

  BeatsAllocationData({this.beatAllocationMasterId, this.beatCode, this.beatDate, this.code, this.status, this.userName});

  BeatsAllocationData.fromJson(Map<String, dynamic> json) {
    beatAllocationMasterId = json['beatAllocationMasterId'];
    beatCode = json['beatCode'];
    beatDate = json['beatDate'];
    code = json['code'];
    status = json['status'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beatAllocationMasterId'] = this.beatAllocationMasterId;
    data['beatCode'] = this.beatCode;
    data['beatDate'] = this.beatDate;
    data['code'] = this.code;
    data['status'] = this.status;
    data['userName'] = this.userName;
    return data;
  }
}
