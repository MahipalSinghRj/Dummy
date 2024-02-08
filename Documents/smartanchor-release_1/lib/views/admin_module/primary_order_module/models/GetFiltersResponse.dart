class GetFiltersResponse {
  List<String>? bu;
  List<String>? city;
  List<String>? state;
  List<String>? zone;

  GetFiltersResponse({this.bu, this.city, this.state, this.zone});

  GetFiltersResponse.fromJson(Map<String, dynamic> json) {
    bu = json['Bu'].cast<String>();
    city = json['City'].cast<String>();
    state = json['State'].cast<String>();
    zone = json['Zone'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bu'] = this.bu;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Zone'] = this.zone;
    return data;
  }
}
