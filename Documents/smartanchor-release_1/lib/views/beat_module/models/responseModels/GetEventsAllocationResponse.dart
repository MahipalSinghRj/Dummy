class GetEventsAllocationResponse {
  List<String>? customerOrdered;
  List<BeatsData>? beatsData = [];
  List<BeatsEventData>? beatsEventData = [];
  List<String>? categories;
  String? completedCustomers;
  String? disableButton;
  String? errorCode;
  String? errorMessage;
  String? pendingCustomers;
  String? totalBeats;
  String? totalCustomers;

  GetEventsAllocationResponse(
      {this.customerOrdered,
      this.beatsData,
      this.beatsEventData,
      this.categories,
      this.completedCustomers,
      this.disableButton,
      this.errorCode,
      this.errorMessage,
      this.pendingCustomers,
      this.totalBeats,
      this.totalCustomers});

  GetEventsAllocationResponse.fromJson(Map<String, dynamic> json) {
    customerOrdered = json['CustomerOrdered'].cast<String>();
    if (json['beatsData'] != null) {
      beatsData = <BeatsData>[];
      json['beatsData'].forEach((v) {
        beatsData!.add(BeatsData.fromJson(v));
      });
    }
    if (json['beatsEventData'] != null) {
      beatsEventData = <BeatsEventData>[];
      json['beatsEventData'].forEach((v) {
        if (v != null) {
          beatsEventData!.add(BeatsEventData.fromJson(v));
        }
      });
    }
    categories = json['categories'].cast<String>();
    completedCustomers = json['completedCustomers'];
    disableButton = json['disableButton'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    pendingCustomers = json['pendingCustomers'];
    totalBeats = json['totalBeats'];
    totalCustomers = json['totalCustomers'];
  }
}

class BeatsData {
  String? bEATDATE;
  String? uSERNAME;
  String? beatCode;
  String? beateatAllocationMasterId;
  String? status;
  String? noOfCustomers;
  bool? isSelected;

  BeatsData(
      {this.bEATDATE,
      this.uSERNAME,
      this.beatCode,
      this.beateatAllocationMasterId,
      this.noOfCustomers,
      this.status,
      this.isSelected});

  BeatsData.fromJson(Map<String, dynamic> json) {
    bEATDATE = json['BEAT_DATE'];
    uSERNAME = json['USER_NAME'];
    noOfCustomers = json['noOfCustomers'];
    beatCode = json['beatCode'];
    beateatAllocationMasterId = json['beateatAllocationMasterId'];
    status = json['status'];
    isSelected = false;
  }
}

class BeatsEventData {
  String? approvedStatus;
  String? asmScreenName;
  String? beatCode;
  String? beatEventApprovalId;
  String? beatEventId;
  String? editable;
  String? end;
  String? month;
  String? noOfCustomers;
  String? screenName;
  String? start;
  String? submittedStatus;
  String? title;
  String? year;
  bool? initiallyExpanded;

  BeatsEventData({
    this.approvedStatus,
    this.asmScreenName,
    this.beatCode,
    this.beatEventApprovalId,
    this.beatEventId,
    this.editable,
    this.end,
    this.month,
    this.noOfCustomers,
    this.screenName,
    this.start,
    this.submittedStatus,
    this.title,
    this.year,
    this.initiallyExpanded,
  });

  BeatsEventData.fromJson(Map<String, dynamic> json) {
    approvedStatus = json['approvedStatus'];
    asmScreenName = json['asmScreenName'];
    beatCode = json['beatCode'];
    beatEventApprovalId = json['beatEventApprovalId'];
    beatEventId = json['beatEventId'];
    editable = json['editable'];
    end = json['end'];
    month = json['month'];
    noOfCustomers = json['noOfCustomers'];
    screenName = json['screenName'];
    start = json['start'];
    submittedStatus = json['submittedStatus'];
    title = json['title'];
    year = json['year'];
    initiallyExpanded = false;
  }
}
