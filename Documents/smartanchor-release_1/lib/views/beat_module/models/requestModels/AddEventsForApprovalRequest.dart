class AddEventsForApprovalRequest {
  List<EventsData>? eventsData = [];
  String? screenName;
  String? submittedBy;
  String? submittedTo;
  String? month;
  String? year;

  AddEventsForApprovalRequest({this.eventsData, this.screenName, this.submittedBy, this.submittedTo, this.month, this.year});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eventsData != null) {
      data['eventsData'] = eventsData!.map((v) => v.toJson()).toList();
    }
    data['screenName'] = screenName;
    data['submittedBy'] = submittedBy;
    data['submittedTo'] = submittedTo;
    data['month'] = month;
    data['year'] = year;
    return data;
  }
}

class EventsData {
  String? start;
  String? end;
  String? title;

  EventsData({this.start, this.end, this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    data['title'] = title;
    return data;
  }
}
