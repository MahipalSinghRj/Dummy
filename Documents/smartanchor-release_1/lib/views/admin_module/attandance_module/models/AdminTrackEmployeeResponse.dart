class AdminTrackEmployeeResponse {
  List<Coordinates>? coordinates;

  AdminTrackEmployeeResponse({this.coordinates});

  AdminTrackEmployeeResponse.fromJson(Map<String, dynamic> json) {
    if (json['Coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['Coordinates'].forEach((v) {
        coordinates!.add(new Coordinates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['Coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coordinates {
  String? latitude;
  String? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
