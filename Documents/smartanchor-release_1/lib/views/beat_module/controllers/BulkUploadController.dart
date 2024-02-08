import 'dart:convert';

import 'package:get/get.dart';

import '../../../common/Drawer.dart';
import '../../../common/widgets.dart';
import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../../../utils/FileUtils.dart';
import '../../../utils/PermissionController.dart';
import '../models/responseModels/BeatAllocationModel.dart';
import '../models/responseModels/BulkUploadExcelResponse.dart';
import '../models/responseModels/GetBulkExcelAuidtResponse.dart';
import '../models/responseModels/GetBulkExcelTemplateResponse.dart';
import '../models/responseModels/GetUserListDataResponse.dart';

class BulkUploadController extends GetxController {
  PermissionController permissionController = Get.put(PermissionController());
  FileUtils fileUtils = Get.put(FileUtils());
  String startDate = '';
  String endDate = '';
  List<String> userList = [];
  List<String> userNameList = [];
  FileDataModel? uploadedExcelFile;

  List<BeatAllocationModel> selectedItemList = [];

  deleteExcelFile() {
    uploadedExcelFile = null;
    update();
  }

  updateSearchSelection(String selectedOption, bool onChangedValue) {
    for (int i = 0; i < selectedItemList.length; i++) {
      if (selectedItemList[i].selectedLAS == selectedOption) {
        selectedItemList[i].isSelected = onChangedValue;
      }
    }
    update();
  }

  bool isSelectedValue(String selectedOption) {
    bool isSelected = false;
    for (int i = 0; i < selectedItemList.length; i++) {
      if (selectedItemList[i].selectedLAS == selectedOption) {
        isSelected = selectedItemList[i].isSelected;
      }
    }

    return isSelected;
  }

  List<String> getSelectedValues() {
    List<String> itemList = [];
    List<String> itemsSelectedList = [];
    for (int i = 0; i < selectedItemList.length; i++) {
      if (selectedItemList[i].isSelected) {
        itemList.add(selectedItemList[i].selectedLAS);
      }
    }
    for (String item in userList) {
      for (var selectedItem in itemList) {
        if (selectedItem.contains(item)) {
          itemsSelectedList.add(item);
        }
      }
    }

    return itemsSelectedList;
  }

  getUserListData({
    required String customerCode,
  }) async {
    update();
    Widgets().loadingDataDialog(loadingText: "Loading data, Please wait!");
    try {
      await getUserListDataApi(customerCode: customerCode).then((value) {
        Get.back();

        if (value != null) {
          userList = [];
          userNameList = [];
          userList = value.userList ?? [];
          userNameList = value.userNamesList ?? [];
          selectedItemList = [];

          for (var item in userNameList) {
            selectedItemList.add(BeatAllocationModel(selectedLAS: item, isSelected: false));
          }

          update();
        } else {
          Widgets().showToast("User list is empty!");
        }
      });
    } catch (e) {
      printErrors("Error: $e");
      Get.back();
      return [];
    }
  }

  pickExcel() async {
    bool permissionGranted = await permissionController.isStoragePermissionGranted();

    if (!permissionGranted) {
      Widgets().showToast("Permission to access storage denied.");

      return null;
    }

    await fileUtils.pickXlsxFile().then((file) async {
      if (file != null) {
        String fileName = fileUtils.getFileNameFromPath(file.path);
        String base64 = await fileUtils.xlsxToFileBase64(file);
        FileDataModel fileDataModel = FileDataModel(fileName, base64);

        uploadedExcelFile = fileDataModel;
      } else {
        uploadedExcelFile = null;
      }
    });
    update();

    // Get.back();
  }

  uploadExcel() async {
    if (uploadedExcelFile?.base64 != null && uploadedExcelFile!.base64!.isNotEmpty) {
      Widgets().loadingDataDialog(loadingText: "Data Uploading, Please wait...");

      //Add loader
      await bulkUploadExcelApi(base64: uploadedExcelFile?.base64 ?? '').then((value) {
        Get.back();
        uploadedExcelFile = null;
        if (value != null && value.errorMessage != null) {
          Widgets().showToast(value.errorMessage.toString());
        } else {
          Widgets().showToast('Something went wrong !!');
        }

        getBulkExcelAudit();

        Get.back();
      });
    } else {
      Widgets().showToast('please pick a file to upload !!');
    }
  }

  downloadExcel({
    required String startDate,
    required String endDate,
    required List<String> userList,
  }) async {
    bool permissionGranted = await permissionController.isStoragePermissionGranted();

    if (!permissionGranted) {
      Widgets().showToast("Permission to access storage denied.");

      return null;
    }
    Widgets().loadingDataDialog(loadingText: "Data Uploading, Please wait...");

    getBulkExcelTemplateApi(startDate: startDate, endDate: endDate, userList: userList).then((value) async {
      Get.back();

      if (value != null && value.base64 != null) {
        await fileUtils.writeXlsxFromBase64(value.base64.toString(), fileUtils.generateFileName()).then((downLoadedFile) async {
          if (downLoadedFile != null) {
            Widgets().showToast("File downloaded successfully !!");
            fileUtils.openDownloadedFile(downLoadedFile);
            //todo show message
          }
        });
      }

      Get.back();
    });
  }

  downloadIndividualExcel({
    required String base64,
    required String fileName,
  }) async {
    bool permissionGranted = await permissionController.isStoragePermissionGranted();

    if (!permissionGranted) {
      Widgets().showToast("Permission to access storage denied.");

      return null;
    }

    try {
      await fileUtils.writeXlsxFromBase64(base64.toString(), fileName).then((downLoadedFile) async {
        if (downLoadedFile != null) {
          Widgets().showToast("File downloaded successfully !!");
          fileUtils.openDownloadedFile(downLoadedFile);
        }
      });
    } catch (e, r) {
      Widgets().showToast("Something Went Wrong, please try Again !!");

      printErrors(e);
      printErrors(r);
    }
  }

  List<BulkUpload>? bulkUploadList = [];

  getBulkExcelAudit() async {
    Widgets().loadingDataDialog(loadingText: "Loading data, Please wait!");
    await getBulkExcelAuditApi().then((value) {
      bulkUploadList = [];
      Get.back();
      if (value != null && value.bulkUpload != null) {
        bulkUploadList = value.bulkUpload?.reversed.toList();
      }
    });

    update();
  }

//--------------------------------
  //Bulk Upload Excel
  Future<BulkUploadExcelResponse?> bulkUploadExcelApi({required String base64}) {
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "base64": base64,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.bulkUploadExcel, requestJson).then((value) {
      try {
        if (value != null) {
          BulkUploadExcelResponse bulkUploadExcelResponse = BulkUploadExcelResponse.fromJson(value);
          return bulkUploadExcelResponse;
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

  //Get Bulk Excel Template Data
  Future<GetBulkExcelTemplateResponse?> getBulkExcelTemplateApi({
    required String startDate,
    required String endDate,
    required List<String> userList,
  }) {
    // var map = {
    //   "customerScreenName": "a07530",
    //   "startDate": "01/10/2023",
    //   "endDate": "30/10/2023",
    //   "userList": ["a07864", "a07962", "a08322", "a04638"]
    // };
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "startDate": startDate,
      "endDate": endDate,
      "userList": userList,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBulkExcelTemplate, requestJson).then((value) {
      try {
        if (value != null) {
          GetBulkExcelTemplateResponse getBulkExcelTemplateResponse = GetBulkExcelTemplateResponse.fromJson(value);
          return getBulkExcelTemplateResponse;
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

  //-------------------------------------------------------------------------[

  //Get Bulk Excel Auidt Data
  Future<GetBulkExcelAuditResponse?> getBulkExcelAuditApi() {
    var map = {
      "customerScreenName": globalController.customerScreenName,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBulkExcelAuidt, requestJson).then((value) {
      try {
        if (value != null) {
          GetBulkExcelAuditResponse getBulkExcelAuditResponse = GetBulkExcelAuditResponse.fromJson(value);
          return getBulkExcelAuditResponse;
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

  Future<GetUserListDataResponse?> getUserListDataApi({
    required String customerCode,
  }) {
    //TODO : add this map when response coming properly
    // var map = {
    //   "customerScreenName": globalController.customerScreenName,
    // };

    var map = {
      "customerScreenName": customerCode,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getUserListData, requestJson).then((value) {
      try {
        if (value != null) {
          GetUserListDataResponse getUserListDataResponse = GetUserListDataResponse.fromJson(value);
          return getUserListDataResponse;
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

//--------------------------------------------------------------------------------
}

class FileDataModel {
  String? name;
  String? base64;

  FileDataModel(this.name, this.base64);
}
