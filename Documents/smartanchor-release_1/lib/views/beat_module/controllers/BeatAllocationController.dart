import 'dart:convert';

import 'package:get/get.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../models/responseModels/AddBeatAllocationUploadResponse.dart';
import '../models/responseModels/AddBeatIndividualUploadResponse.dart';
import '../models/responseModels/BulkBeatAllocationUploadResponse.dart';
import '../models/responseModels/BulkBeatUploadsApiReponse.dart';
import '../models/responseModels/GetBeatAllocationTemplateResponse.dart';
import '../models/responseModels/GetBeatTemplateApiResponse.dart';
import '../models/responseModels/GetBeatsAllocationUploadDataResponse.dart';
import '../models/responseModels/GetBeatsUploadDataReponse.dart';

class BeatAllocationController extends GetxController {
//*******************************************
  GlobalController globalController = Get.put(GlobalController());

  ///Business logic

  getBeatsUploadData(String code, String name, String stateCode, String cityCode, String status) {
    getBeatsUploadDataApi(code, name, stateCode, cityCode, status).then((value) {
      if (value != null) {}
    });
  }
  ///API Calls

  Future<GetBeatsUploadDataReponse?> getBeatsUploadDataApi(
    String code,
    String name,
    String stateCode,
    String cityCode,
    String status,
  ) {
    var map = {"customerScreenName": globalController.customerScreenName, "code": code, "name": name, "stateCode": stateCode, "cityCode": cityCode, "status": status};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBeatsUploadData, requestJson).then((value) {
      try {
        if (value != null) {
          GetBeatsUploadDataReponse getBeatsUploadDataReponse = GetBeatsUploadDataReponse.fromJson(value);
          return getBeatsUploadDataReponse;
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

  Future<BulkBeatUploadsApiReponse?> bulkBeatUploadsApi(
    String base64,
  ) {
    var map = {"customerScreenName": globalController.customerScreenName, "base64": base64};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.bulkBeatUploads, requestJson).then((value) {
      try {
        if (value != null) {
          BulkBeatUploadsApiReponse beatUploadsApiReponse = BulkBeatUploadsApiReponse.fromJson(value);
          return beatUploadsApiReponse;
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

  Future<GetBeatTemplateApiResponse?> getBeatTemplateApi() {
    return ApiService.getRequest(
      ApiConstants.getBeatTemplate,
    ).then((value) {
      try {
        if (value != null) {
          GetBeatTemplateApiResponse getBeatTemplateApiResponse = GetBeatTemplateApiResponse.fromJson(value);
          return getBeatTemplateApiResponse;
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

  Future<AddBeatIndividualUploadResponse?> addBeatIndividualUploadApi(
    String code,
    String name,
    String stateCode,
    String cityCode,
    String status,
  ) {
    var map = {"customerScreenName": globalController.customerScreenName, "code": code, "name": name, "stateCode": stateCode, "cityCode": cityCode, "status": status};
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.addBeatIndividualUpload, requestJson).then((value) {
      try {
        if (value != null) {
          AddBeatIndividualUploadResponse addBeatIndividualUploadResponse = AddBeatIndividualUploadResponse.fromJson(value);
          return addBeatIndividualUploadResponse;
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

  Future<AddBeatIndividualUploadResponse?> editBeatIndividualUploadApi(
    String code,
    String name,
    String stateCode,
    String cityCode,
    String status,
    String beatMasterId,
  ) {
    //response for this api is same as AddBeatIndividualUploadResponse
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "code": code,
      "name": name,
      "stateCode": stateCode,
      "cityCode": cityCode,
      "status": status,
      "beatMasterId": beatMasterId
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.editBeatIndividualUpload, requestJson).then((value) {
      try {
        if (value != null) {
          AddBeatIndividualUploadResponse editBeatIndividualUploadResponse = AddBeatIndividualUploadResponse.fromJson(value);
          return editBeatIndividualUploadResponse;
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

  /// beat allocation apis

  Future<GetBeatsAllocationUploadDataResponse?> getBeatsAllocationUploadDataApi(
    String code,
    String userName,
    String beatCode,
    String fromDate,
    String toDate,
    String status,
  ) {
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "code": code,
      "userName": userName,
      "beatCode": beatCode,
      "fromDate": fromDate,
      "toDate": toDate,
      "status": status,
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getBeatsAllocationUploadData, requestJson).then((value) {
      try {
        if (value != null) {
          GetBeatsAllocationUploadDataResponse getBeatsAllocationUploadDataResponse = GetBeatsAllocationUploadDataResponse.fromJson(value);
          return getBeatsAllocationUploadDataResponse;
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

  Future<BulkBeatAllocationUploadResponse?> bulkBeatAllocationUploadApi(
    String base64,
  ) {
    var map = {"customerScreenName": globalController.customerScreenName, "base64": base64};

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.bulkBeatAllocationUpload, requestJson).then((value) {
      try {
        if (value != null) {
          BulkBeatAllocationUploadResponse beatAllocationUploadResponse = BulkBeatAllocationUploadResponse.fromJson(value);
          return beatAllocationUploadResponse;
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

  Future<GetBeatAllocationTemplateResponse?> getBeatAllocationTemplateApi() {
    return ApiService.getRequest(
      ApiConstants.getBeatAllocationTemplate,
    ).then((value) {
      try {
        if (value != null) {
          GetBeatAllocationTemplateResponse getBeatAllocationTemplateResponse = GetBeatAllocationTemplateResponse.fromJson(value);
          return getBeatAllocationTemplateResponse;
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

  Future<AddBeatAllocationUploadResponse?> addBeatAllocationUploadApi(
    String code,
    String userName,
    String beatCode,
    String beatDate,
    String status,
  ) {
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "code": code,
      "userName": userName,
      "beatCode": beatCode,
      "beatDate": beatDate,
      "status": status
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.addBeatAllocationUpload, requestJson).then((value) {
      try {
        if (value != null) {
          AddBeatAllocationUploadResponse addBeatAllocationUploadResponse = AddBeatAllocationUploadResponse.fromJson(value);
          return addBeatAllocationUploadResponse;
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

  Future<AddBeatAllocationUploadResponse?> editBeatAllocationUpload(
    String code,
    String userName,
    String beatCode,
    String beatDate,
    String status,
    String beatAllocationMasterId,
  ) {
    var map = {
      "customerScreenName": globalController.customerScreenName,
      "code": code,
      "userName": userName,
      "beatCode": beatCode,
      "beatDate": beatDate,
      "status": status,
      "beatAllocationMasterId": beatAllocationMasterId
    };

    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.editBeatAllocationUpload, requestJson).then((value) {
      try {
        if (value != null) {
          AddBeatAllocationUploadResponse addBeatAllocationUploadResponse = AddBeatAllocationUploadResponse.fromJson(value);
          return addBeatAllocationUploadResponse;
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
