class GetActionEventApprovalDataResponse {
  List<ApprovalData>? approvalData;
  String? errorCode;
  String? errorMessage;
  List<String>? headerList;
  List<String>? userList;

  GetActionEventApprovalDataResponse({this.approvalData, this.errorCode, this.errorMessage, this.headerList, this.userList});

  GetActionEventApprovalDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['approvalData'] != null) {
      approvalData = <ApprovalData>[];
      json['approvalData'].forEach((v) {
        approvalData!.add(new ApprovalData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    headerList = json['headerList'].cast<String>();
    userList = json['userList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.approvalData != null) {
      data['approvalData'] = this.approvalData!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['headerList'] = this.headerList;
    data['userList'] = this.userList;
    return data;
  }
}

class ApprovalData {
  String? approve;
  String? approveId;
  List<String>? beatList;
  String? employeeName;
  String? userName;

  ApprovalData({this.approve, this.approveId, this.beatList, this.employeeName, this.userName});

  ApprovalData.fromJson(Map<String, dynamic> json) {
    approve = json['approve'];
    approveId = json['approveId'];
    beatList = json['beatList'].cast<String>();
    employeeName = json['employeeName'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approve'] = this.approve;
    data['approveId'] = this.approveId;
    data['beatList'] = this.beatList;
    data['employeeName'] = this.employeeName;
    data['userName'] = this.userName;
    return data;
  }
}
