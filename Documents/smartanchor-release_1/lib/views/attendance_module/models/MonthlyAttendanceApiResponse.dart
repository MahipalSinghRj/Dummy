class MonthlyAttendanceApiResponse {
  Actions? actions;

  //todo : add facets  and action and holidays models here
  List<Null>? facets;
  List<Items>? items;
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  MonthlyAttendanceApiResponse({this.actions, this.facets, this.items, this.lastPage, this.page, this.pageSize, this.totalCount});

  MonthlyAttendanceApiResponse.fromJson(Map<String, dynamic> json) {
    actions = json['actions'] != null ? new Actions.fromJson(json['actions']) : null;
    if (json['facets'] != null) {
      facets = <Null>[];
      // json['facets'].forEach((v) { facets!.add(new Null.fromJson(v)); });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.actions != null) {
      data['actions'] = this.actions!.toJson();
    }
    if (this.facets != null) {
      // data['facets'] = this.facets!.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['lastPage'] = this.lastPage;
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Actions {
  // Actions({});

  Actions.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Items {
  List<String>? dates;

  List<String>? holidays;

  String? primaryOrderPunched;

  String? secondaryOrderPunched;

  String? totalVisitedCustomer;

  int? totalWorkedDays;

  String? totalWorkedHour;

  Items({this.dates, this.holidays, this.primaryOrderPunched, this.secondaryOrderPunched, this.totalVisitedCustomer, this.totalWorkedDays, this.totalWorkedHour});

  Items.fromJson(Map<String, dynamic> json) {
    dates = json['dates'].cast<String>();
    if (json['holidays'] != null) {
      holidays = <String>[];
      json['holidays'].forEach((v) {
        // holidays!.add(new Null.fromJson(v));
      });
    }
    primaryOrderPunched = json['primaryOrderPunched'];
    secondaryOrderPunched = json['secondaryOrderPunched'];
    totalVisitedCustomer = json['totalVisitedCustomer'];
    totalWorkedDays = json['totalWorkedDays'];
    totalWorkedHour = json['totalWorkedHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dates'] = this.dates;
    if (this.holidays != null) {
      // data['holidays'] = this.holidays!.map((v) => v.toJson()).toList();
    }
    data['primaryOrderPunched'] = this.primaryOrderPunched;
    data['secondaryOrderPunched'] = this.secondaryOrderPunched;
    data['totalVisitedCustomer'] = this.totalVisitedCustomer;
    data['totalWorkedDays'] = this.totalWorkedDays;
    data['totalWorkedHour'] = this.totalWorkedHour;

    return data;
  }
}
