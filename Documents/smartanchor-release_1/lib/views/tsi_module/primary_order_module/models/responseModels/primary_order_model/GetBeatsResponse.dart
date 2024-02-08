class GetBeatsResponse {
  List<String>? getBeatsList = [];
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  GetBeatsResponse({this.getBeatsList, this.lastPage, this.page, this.pageSize, this.totalCount});

  GetBeatsResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('items') && json['items'] is List) {
      getBeatsList = List<String>.from(json['items'] as List<dynamic>);
    } else {
      getBeatsList = [];
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}
