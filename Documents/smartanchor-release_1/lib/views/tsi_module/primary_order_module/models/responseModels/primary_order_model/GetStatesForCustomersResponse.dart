class GetStatesForCustomersResponse {
  String? bu;
  List<String>? states;

  GetStatesForCustomersResponse({this.bu, this.states});

  GetStatesForCustomersResponse.fromJson(Map<String, dynamic> json) {
    bu = json['bu'];
    states = json['states'].cast<String>();
  }
}
