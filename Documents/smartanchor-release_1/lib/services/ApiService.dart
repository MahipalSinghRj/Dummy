import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dioAPI;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smartanchor/debug/printme.dart';
import '../configurations/AppConfigs.dart';
import '../utils/CustomException.dart';
import 'BasicAuth.dart';

class ApiService {
  ///Post requests  *******************************

  static Future<dynamic> postRequest(
      String apiEndpoint, String requestJson) async {
    printMe("Api Endpoint : $apiEndpoint");
    log("Request Json: $requestJson");
    try {
      final response = await postApiCall(apiEndpoint, requestJson);

      if (response != null) {
        printResponse("request :${response.request}");
        printResponse("Status Code :${response.statusCode}");
        printResponse("[√]Response :");
        if (kDebugMode) {
          log(response.body);
        }
        return responseHandling(response);
      } else {
        return null;
      }
    } catch (e, stacktrace) {
      printErrors("ExceptionHandling at post api request : $apiEndpoint$e");
      printErrors("Stacktrace $apiEndpoint: ");
      printErrors(stacktrace);

      rethrow;
    }
  }

  //////Post requests with Multipart File  *******************************

  static Future<dynamic> postRequestWithMultipart(
      String apiEndpoint, String filename, File file) async {
    printMe("Api Endpoint : $apiEndpoint");

    try {
      dioAPI.Response? response =
          await postMultipartApiCall(apiEndpoint, filename, file);

      if (response != null) {
        // printResponse("request :${response.request}");
        printResponse("Status Code :${response.statusCode}");
        printResponse("[√]Response :");
        if (kDebugMode) {
          log(response.data.toString());
        }
        final http.Response httpResponse = http.Response(
          json.encode(response.data), // Convert Dio response data to String
          response.statusCode ?? 0, // Copy status code
          headers: {}, // Copy headers
        );
        return responseHandling(httpResponse);
      } else {
        return null;
      }
    } catch (e, stacktrace) {
      printErrors("ExceptionHandling at post api request : $apiEndpoint$e");
      printErrors("Stacktrace $apiEndpoint: ");
      printErrors(stacktrace);

      rethrow;
    }
  }

  ///********************************************

  static Future<dynamic> getRequest(
    String apiEndpoint, [
    String? data,
  ]) async {
    try {
      final response = await getApiCall(apiEndpoint, data);

      print("request :" + response!.request.toString());
      print("Status Code :" + response.statusCode.toString());
      print("[√]Response :");
      if (kDebugMode) {
        log(response.body);
      }
      return responseHandling(response);
    } catch (e, stacktrace) {
      print("ExceptionHandling at Get api request : $apiEndpoint $e");
      print("Stacktrace $apiEndpoint: ");
      print(stacktrace);

      rethrow;
    }
  }

  ///***********************************Api calls*********************************************
  ///Post Api Calls

  static Future<http.Response?> postApiCall(
    String apiEndpoint,
    String requestJson,
  ) async {
    try {
      final uri = Uri.parse(AppConfigs.baseUrl + apiEndpoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };

      return await post(
        uri,
        headers: headers,
        body: requestJson,
      );
    } catch (e) {
      printErrors("ExceptionHandling at post api call: $apiEndpoint$e");

      return null;
    }
  }

  ///Post Multipart Api Calls

  static Future<dioAPI.Response?> postMultipartApiCall(
    String apiEndpoint,
    String fileName,
    File file,
  ) async {
    final uri = AppConfigs.baseUrl + apiEndpoint;
    try {
      final formData = dioAPI.FormData.fromMap({
        'file':
            await dioAPI.MultipartFile.fromFile(file.path, filename: fileName),
      });
      dioAPI.Response response = await dioAPI.Dio().post(uri,
          data: formData,
          options: dioAPI.Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': basicAuth
          }));

      return response;
    } catch (e) {
      printErrors(
          "ExceptionHandling at post multipart api call: $apiEndpoint$e");

      return null;
    }
  }

  ///***************Get Api Call*****************************

  static Future<http.Response?> getApiCall(String apiEndpoint,
      [String? data]) async {
    String args = data ?? '';
    try {
      final uri = Uri.parse(AppConfigs.baseUrl + apiEndpoint + args);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };
      return await get(
        uri,
        headers: headers,
      );
    } catch (e, stackTrace) {
      print("ExceptionHandling at Get api call: $apiEndpoint$e");
      print("Stacktrace $apiEndpoint: ");
      print(stackTrace);

      return null;
    }
  }

  static dynamic responseHandling(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException("403");
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
