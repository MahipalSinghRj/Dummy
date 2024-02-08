class DashBoardBannerResponse {
  List<BannerItems>? items;
  int? lastPage;
  int? page;
  int? pageSize;
  int? totalCount;

  DashBoardBannerResponse(
      {this.items, this.lastPage, this.page, this.pageSize, this.totalCount});

  DashBoardBannerResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <BannerItems>[];
      json['items'].forEach((v) {
        items!.add(new BannerItems.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class BannerItems {
  int? imageSequenceId;
  String? imageURL;
  String? redirectURL;

  BannerItems({this.imageSequenceId, this.imageURL, this.redirectURL});

  BannerItems.fromJson(Map<String, dynamic> json) {
    imageSequenceId = json['imageSequenceId'];
    imageURL = json['imageURL'];
    redirectURL = json['redirectURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageSequenceId'] = this.imageSequenceId;
    data['imageURL'] = this.imageURL;
    data['redirectURL'] = this.redirectURL;
    return data;
  }
}
