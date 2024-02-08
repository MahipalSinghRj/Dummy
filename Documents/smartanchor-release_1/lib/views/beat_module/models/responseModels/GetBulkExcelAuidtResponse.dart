class GetBulkExcelAuditResponse {
  List<BulkUpload>? bulkUpload;
  String? errorCode;
  String? errorMessage;
  List<String>? userList;

  GetBulkExcelAuditResponse({this.bulkUpload, this.errorCode, this.errorMessage, this.userList});

  GetBulkExcelAuditResponse.fromJson(Map<String, dynamic> json) {
    if (json['bulkUpload'] != null) {
      bulkUpload = <BulkUpload>[];
      json['bulkUpload'].forEach((v) {
        bulkUpload!.add(new BulkUpload.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    userList = json['userList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bulkUpload != null) {
      data['bulkUpload'] = this.bulkUpload!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['userList'] = this.userList;
    return data;
  }
}

class BulkUpload {
  String? bulkUploadDetailsID;
  String? dateFrom;
  String? dateTo;
  String? downloadUrl;
  String? fileName;
  String? fileTitle;
  String? noOfRecords;
  String? status;
  String? uploadDate;
  String? uploadType;

  BulkUpload(
      {this.bulkUploadDetailsID,
      this.dateFrom,
      this.dateTo,
      this.downloadUrl,
      this.fileName,
      this.fileTitle,
      this.noOfRecords,
      this.status,
      this.uploadDate,
      this.uploadType});

  BulkUpload.fromJson(Map<String, dynamic> json) {
    bulkUploadDetailsID = json['bulkUploadDetailsID'];
    dateFrom = json['dateFrom'];
    dateTo = json['dateTo'];
    downloadUrl = json['downloadUrl'];
    fileName = json['fileName'];
    fileTitle = json['fileTitle'];
    noOfRecords = json['noOfRecords'];
    status = json['status'];
    uploadDate = json['uploadDate'];
    uploadType = json['uploadType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bulkUploadDetailsID'] = this.bulkUploadDetailsID;
    data['dateFrom'] = this.dateFrom;
    data['dateTo'] = this.dateTo;
    data['downloadUrl'] = this.downloadUrl;
    data['fileName'] = this.fileName;
    data['fileTitle'] = this.fileTitle;
    data['noOfRecords'] = this.noOfRecords;
    data['status'] = this.status;
    data['uploadDate'] = this.uploadDate;
    data['uploadType'] = this.uploadType;
    return data;
  }
}
