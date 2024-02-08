import 'package:flutter/material.dart';

class GetUserListDataResponse {
  String? errorCode;
  String? errorMessage;
  List<String>? userList;
  List<String>? userNamesList;
  Color? color;
  int? size;

  GetUserListDataResponse({this.errorCode, this.errorMessage, this.userList, this.userNamesList, this.color, this.size});

  GetUserListDataResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    userList = json['userList'].cast<String>();
    userNamesList = json['userNamesList'].cast<String>();
  }
}
