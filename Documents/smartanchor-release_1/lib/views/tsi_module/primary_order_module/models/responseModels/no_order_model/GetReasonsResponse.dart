class GetReasonsResponse {
  List<String>? items;
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  GetReasonsResponse({this.items, this.lastPage, this.page, this.pageSize, this.totalCount});

  GetReasonsResponse.fromJson(Map<String, dynamic> json) {
    items = json['items'].cast<String>();
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }
}
