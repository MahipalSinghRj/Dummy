import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/utils/FileUtils.dart';
import 'package:smartanchor/views/attendance_module/models/DeleteReportsModel.dart';
import 'package:smartanchor/views/attendance_module/models/DownloadReportsModel.dart';

import '../../../../configurations/ApiConstants.dart';
import '../../../../configurations/AppConfigs.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../services/ApiService.dart';
import '../../models/DailyAttendanceApiResponse.dart';
import '../../models/LeaveResponse.dart';
import '../../models/MonthlyAttendanceApiResponse.dart';

class ViewAttendanceController extends GetxController {
  GlobalController globalController = Get.put(GlobalController());
  FileUtils fileUtils = Get.put(FileUtils());

//*************************

  Color getBorderColor(String status) {
    switch (status) {
      case 'absent':
        return alizarinCrimson;
      case 'present':
        return malachite;
      case 'holiday':
        return Colors.transparent;
      case 'future':
        return Colors.transparent;
      case 'today':
        return Colors.transparent;
      default:
        return Colors.black;
    }
  }

  Color getTextColor(String status) {
    switch (status) {
      case 'future':
        return Colors.grey;
      case 'holiday':
        print(status);

        return meteorColor;
      case 'absent':
      case 'present':
        return Colors.black;

      case 'today':
        print(status);

        return Colors.black;
      default:
        print('degaut--------------');

        return Colors.black;
    }
  }

  bool isPresentExist(List<String> dates, String dateToCheck) {
    // Convert the input date to the desired format
    DateTime inputDate = DateTime.parse(dateToCheck);

    // Format the input date to match the format in the list
    String formattedInputDate = "${inputDate.year}-${inputDate.month.toString().padLeft(2, '0')}-${inputDate.day.toString().padLeft(2, '0')}";

    // Check if the formatted input date exists in the list
    return dates.contains(formattedInputDate);
  }

//********************
  String getPresentStatus(bool? present) {
    if (present != null) {
      if (present) {
        return 'Present';
      } else {
        return 'Absent/Leave';
      }
    }
    return 'Absent/Leave';
  }

  Color getPresentColor(bool? present) {
    if (present != null) {
      if (present) {
        return malachite;
      } else {
        return alizarinCrimson;
      }
    }
    return alizarinCrimson;
  }

  bool haveValue(String? input) {
    if (input != null && input.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<DailyAttendanceApiResponse?> dailyAttendanceApi(String date) {
    //date : will be a string field and format will be “dd/mm/yyyy”    //      "date": "22/09/2023",
    //image: this will give the link of image
    // Need to append right next to base url
    // Eg. “https://bestportal-uat.anchor-world.com” + image
    // /{"date": "16/10/2023", "userScreenName": "a03581"};
    // {"date":"10/21/2023","userScreenName":"a03581"}
    var map = {
      "date": date,
      "userScreenName": globalController.customerScreenName,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.dailyAttendanceApi, requestJson).then((value) {
      try {
        if (value != null) {
          DailyAttendanceApiResponse dailyAttendanceApiResponse = DailyAttendanceApiResponse.fromJson(value);
          return dailyAttendanceApiResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

//*************************
  bool isDateToday(String dateString) {
    // Parse the date string into a DateTime object
    DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);

    // Get the current date
    DateTime now = DateTime.now();

    // Compare the parsed date with the current date
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool isDateInFuture(String dateString) {
    // Parse the date string into a DateTime object
    DateTime date = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateString);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Compare the parsed date with the current date
    return date.isAfter(now);
  }

  bool isSunday(String dateString) {
    // Parse the date string into a DateTime object
    DateTime date = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateString);

    // Check if the day of the week is Sunday (7 corresponds to Sunday)
    return date.weekday == DateTime.sunday;
  }

  MonthlyAttendanceApiResponse? monthlyAttendanceApiResponse;

  monthlyAttendanceData(
    int month,
    int year,
  ) async {
    await monthlyAttendanceApi(
      month,
      year,
    ).then((value) {
      Get.back();

      monthlyAttendanceApiResponse = value;
      update();
    });
    update();
  }



  Future<void> downloadAndSaveReport(
    int month,
    int year,
  ) async {
    Widgets().loadingDataDialog(loadingText: "Data Uploading, Please wait...");

    await downloadReportsApi(month, year).then((value) async {
      if (value != null && value.base64String != null) {
        await fileUtils.writeXlsxFromBase64(value.base64String.toString(), fileUtils.generateFileName()).then((downLoadedFile) async {
          Get.back();

          if (downLoadedFile != null) {
            //await deleteReportsApi();
            Widgets().showToast("File downloaded successfully !!");
            fileUtils.openDownloadedFile(downLoadedFile);
            //todo show message
          }
        });
      }

//writeXlsxFromBase64
    });
  }

  Future<MonthlyAttendanceApiResponse?> monthlyAttendanceApi(
    int month,
    int year,
  ) {
    var map = {"month": month, "screenName": globalController.customerScreenName, "year": year};
    // var map = {"month": 10, "screenName": "a03581", "year": 2023};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.monthlyAttendanceApi, requestJson).then((value) {
      //todo: update its model class
      try {
        if (value != null) {
          MonthlyAttendanceApiResponse monthlyAttendanceApiResponse = MonthlyAttendanceApiResponse.fromJson(value);
          return monthlyAttendanceApiResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

//*************************

  Future<DownloadReportsModel?> downloadReportsApi(
    int month,
    int year,
  ) {
    var map = {"month": month, "screenName": globalController.customerScreenName, "year": year};
// api will be having changes 06/10  for download report options
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.downloadReports, requestJson).then((value) {
      try {
        if (value != null) {
          DownloadReportsModel downloadReportsModel = DownloadReportsModel.fromJson(value);
          return downloadReportsModel;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<DeleteReportsModel?> deleteReportsApi() {
    var map = {"screenName": globalController.customerScreenName};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.deleteReports, requestJson).then((value) {
      try {
        if (value != null) {
          DeleteReportsModel deleteReportsModel = DeleteReportsModel.fromJson(value);
          return deleteReportsModel;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  String generateImageUrl(String data) {
    //todo : fix this issue via confirmation - add or not
    String prefix = AppConfigs.baseUrl;
    return prefix + data;
  }

  Future<bool?> applyLeave(
    String fromDate,
    String toDate,
    String remark,
  ) async {
    var response = await applyLeaveApi(
      fromDate,
      toDate,
      remark,
    );

    if(response!=null){
      Get.back();
      if (response.statusCode == "200") {
        return true;
      } else {
        return false;
      }
    }
    update();
  }

  Future<LeaveResponse?> applyLeaveApi(
    String fromDate,
    String toDate,
    String remark,
  ) {
    var map = {
      "dateFrom": fromDate,
      "dateTo": toDate,
      "remark": remark,
      "screenName": globalController.customerScreenName
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.userLeaveApplication, requestJson).then((value) {
      //todo: update its model class
      try {
        if (value != null) {
          LeaveResponse leaveResponse = LeaveResponse.fromJson(value);
          return leaveResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }
}
