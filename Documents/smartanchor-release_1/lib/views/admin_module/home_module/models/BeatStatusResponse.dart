class BeatStatusResponse {
  List<String>? categoriesList;
  List<int>? completedCustomersList;
  String? errorCode;
  String? errorMessage;
  List<int>? pendingCustomersList;
  String? totalAllocatedBeats;
  String? totalBeats;

  BeatStatusResponse({this.categoriesList,
    this.completedCustomersList,
    this.errorCode,
    this.errorMessage,
    this.pendingCustomersList,
    this.totalAllocatedBeats,
    this.totalBeats});

  BeatStatusResponse.fromJson(Map<String, dynamic> json) {
    categoriesList = json['categoriesList'].cast<String>();
    completedCustomersList = json['completedCustomersList'].cast<int>();
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    pendingCustomersList = json['pendingCustomersList'].cast<int>();
    totalAllocatedBeats = json['totalAllocatedBeats'];
    totalBeats = json['totalBeats'];
  }
}
