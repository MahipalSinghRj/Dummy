import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/models/responseModels/AllCustomerMapMarkerResponse.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/models/CustomerProfileDetailsResonse.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../configurations/ApiConstants.dart';
import '../../../../../debug/printme.dart';
import '../../../../../services/ApiService.dart';
import '../../../../attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';

class CustomerOnMapController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  ViewLocationOnMapController viewLocationOnMapController =
      Get.put(ViewLocationOnMapController());
  GlobalController globalController = Get.put(GlobalController());
  AllCustomerMapMarkerResponse? allCustomerMapMarkers;
  CustomerProfileDetailsResponse? singleCustomerDetails;
  bool isLoading = false;
  Set<Marker> markers = {};

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  fetchAllMapMarkers() async {
    isLoading = true;
    update();
    final position = await viewLocationOnMapController.getCurrentLocation();
    var map = {
      "Latitude": (position.latitude).toString(),
      "Longitude": position.latitude.toString(),
      "ScreenName": globalController.customerScreenName
    };
    //remove this

    // {
    //   "Latitude": "12.946042",
    //   "Longitude": "77.668837",
    //   "ScreenName": "a07864"
    // };

    final result = await fetchAllMapMarkersAPI(map);

    if (result != null) {
      allCustomerMapMarkers = result;
      if (allCustomerMapMarkers!.items.isNotEmpty) {
        final item = allCustomerMapMarkers!.items.first;
        singleCustomerDetails = CustomerProfileDetailsResponse(
            address: item.address,
            beat: item.beat,
            buName: "",
            city: item.city,
            creditLimit: '',
            customerCode: item.customerCode,
            customerName: item.customerName,
            latitude: item.latitude,
            longitude: item.longitude,
            masterId: item.masterId,
            noOrderCount: "",
            orderCount: "",
            outstanding: "",
            overdue: "",
            phoneNo: "",
            returnOrderCount: "",
            state: item.state,
            totalOrderValue: "");
      }
      markers = allCustomerMapMarkers!.items
          .map((e) => Marker(
              onTap: () {
                final item = e;
                singleCustomerDetails = CustomerProfileDetailsResponse(
                    address: item.address,
                    beat: item.beat,
                    buName: "",
                    city: item.city,
                    creditLimit: '',
                    customerCode: item.customerCode,
                    customerName: item.customerName,
                    latitude: item.latitude,
                    longitude: item.longitude,
                    masterId: item.masterId,
                    noOrderCount: "",
                    orderCount: "",
                    outstanding: "",
                    overdue: "",
                    phoneNo: "",
                    returnOrderCount: "",
                    state: item.state,
                    totalOrderValue: "");
                update();
              },
              markerId: MarkerId(e.masterId),
              position: LatLng(double.tryParse(e.latitude) ?? 0,
                  double.tryParse(e.longitude) ?? 0)))
          .toSet();
      if (markers.isNotEmpty) {
        viewLocationOnMapController.mapController!.moveCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: markers.first.position, zoom: 8)));
        print("My Markers ${markers.length}");
      }
    }

    isLoading = false;
    update();
  }

  Future<AllCustomerMapMarkerResponse?> fetchAllMapMarkersAPI(
      Map<String, dynamic> map) async {
    final data = jsonEncode(map);
    return ApiService.postRequest(
            ApiConstants.getAllCustomerMarkersDetails, data)
        .then((value) {
      try {
        if (value != null) {
          AllCustomerMapMarkerResponse allMarkers =
              AllCustomerMapMarkerResponse.fromJson(value);
          return allMarkers;
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

  Future<void> openMapWithAddress(String address) async {
    final googleUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
