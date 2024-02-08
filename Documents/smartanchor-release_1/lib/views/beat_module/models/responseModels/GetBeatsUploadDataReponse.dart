class GetBeatsUploadDataReponse {
  List<BeatsData>? beatsData = [];

  GetBeatsUploadDataReponse({this.beatsData});

  GetBeatsUploadDataReponse.fromJson(Map<String, dynamic> json) {
    if (json['beatsData'] != null) {
      beatsData = <BeatsData>[];
      json['beatsData'].forEach((v) {
        beatsData!.add(new BeatsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.beatsData != null) {
      data['beatsData'] = this.beatsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BeatsData {
  String? beatMasterId;
  String? cityCode;
  String? code;
  String? name;
  String? stateCode;
  String? status;

  BeatsData({this.beatMasterId, this.cityCode, this.code, this.name, this.stateCode, this.status});

  BeatsData.fromJson(Map<String, dynamic> json) {
    beatMasterId = json['beatMasterId'];
    cityCode = json['cityCode'];
    code = json['code'];
    name = json['name'];
    stateCode = json['stateCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beatMasterId'] = this.beatMasterId;
    data['cityCode'] = this.cityCode;
    data['code'] = this.code;
    data['name'] = this.name;
    data['stateCode'] = this.stateCode;
    data['status'] = this.status;
    return data;
  }
}
