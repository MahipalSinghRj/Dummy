import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/models/responseModels/retailer_profile_model/RetailerDropDownResponseModal.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../configurations/ApiConstants.dart';
import '../../../../../services/ApiService.dart';

class AddNewRetailerController extends GetxController {
  ViewLocationOnMapController locationController = Get.put(ViewLocationOnMapController());
  GlobalController globalController = Get.put(GlobalController());
  bool isLoading = false;
  final TextEditingController shopeNameController = TextEditingController();
  final TextEditingController proprietorController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController gstNoController = TextEditingController();
  final TextEditingController aadharNumberController = TextEditingController();
  final TextEditingController panCardNoController = TextEditingController();
  final TextEditingController areaAddressController = TextEditingController();
  final TextEditingController apartmentAddressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cordinatesController = TextEditingController();

  List<String> state = [];
  List<String> cities = [];
  List<String> district = [];
  List<String> beat = [];
  List<Dealer> iaqDelar = [];
  List<Dealer> lightingDealer = [];
  List<Dealer> powerDealer = [];

  String? selectedState;
  String? selectedDistrict;
  String? selectedCity;
  String? selectedBeat;
  Dealer? selectedPowerDealer;
  Dealer? selectedIaqDealer;
  Dealer? selectedLightingDealer;
  GlobalKey<FormState> addRetailerFormKey = GlobalKey<FormState>();
  Position? position;

  @override
  onInit() async {
    super.onInit();
  }

  Future<void> getCurrentPosition() async {
    position = await locationController.getCurrentLocation();
    if (position != null) {
      cordinatesController.text = "${position?.latitude ?? ''} , ${position?.longitude ?? ''}";
    }
    update();
  }

  Future<void> getDropdownValues() async {
    isLoading = true;
    update();

    try {
      final requestMap = {"role": globalController.role, "screenName": globalController.customerScreenName};
      final requestJson = jsonEncode(requestMap);
      final response = await ApiService.postRequest(ApiConstants.getDropDownValuesForRetailer, requestJson);
      if (response != null) {
        RetailerDropDownResponseModal dropDownResponseModal = RetailerDropDownResponseModal.fromJson(response);
        dropDownResponseModal.beat.removeWhere((element) => element.isEmpty);
        dropDownResponseModal.district.removeWhere((element) => element.isEmpty);
        state = [dropDownResponseModal.state];
        Set<String> stateSet = Set.from(state);
        state = stateSet.toList();

        district = dropDownResponseModal.district;
        Set<String> districtSet = Set.from(district);
        district = districtSet.toList();

        beat = dropDownResponseModal.beat;
        Set<String> beatSet = Set.from(beat);
        beat = beatSet.toList();

        iaqDelar = dropDownResponseModal.iaqDealer;
        Set<Dealer> iaqDelarSet = Set.from(iaqDelar);
        iaqDelar = iaqDelarSet.toList();

        lightingDealer = dropDownResponseModal.lightingDealer;
        Set<Dealer> lightingDealerSet = Set.from(lightingDealer);
        lightingDealer = lightingDealerSet.toList();

        powerDealer = dropDownResponseModal.powerDealer;
        Set<Dealer> powerDealerSet = Set.from(powerDealer);
        powerDealer = powerDealerSet.toList();
      }
    } catch (e) {
      redPrint("Exception ==> $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  getCitiesFromDistrict(String district) async {
    isLoading = true;
    update();

    try {
      final requestMap = {"district": district, "role": globalController.role, "screenName": globalController.customerScreenName};
      final requestJson = jsonEncode(requestMap);
      final response = await ApiService.postRequest(ApiConstants.getCitiesFromDistrict, requestJson);
      if (response != null) {
        cities = List.castFrom((response["city"] ?? []).map((e) => e).toList());
        Set<String> uniqueSet = Set.from(cities);

        cities = uniqueSet.toList();
      }
    } catch (e) {
      redPrint("Exception ==> $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> submitForm() async {
    if (addRetailerFormKey.currentState!.validate() && dropDownValidation()) {
      return await addRetailer();
    }
    return Future.value(false);
  }

  Future<bool> addRetailer() async {
    isLoading = true;
    update();

    try {
      final requestMap = {
        "email": emailController.text,
        "aadharNo": aadharNumberController.text,
        "area": areaAddressController.text,
        "beat": selectedBeat,
        "city": selectedCity,
        "district": selectedDistrict,
        "gstNo": gstNoController.text,
        "iaqDealerCode": selectedIaqDealer?.code ?? '',
        "landMark": landmarkController.text,
        "lat": position?.latitude ?? '',
        "lightingDealerCode": selectedLightingDealer?.code ?? '',
        "lng": position?.longitude ?? '',
        "mobileNo": mobileNoController.text,
        "panNo": panCardNoController.text,
        "pin": pinCodeController.text,
        "powerDealerCode": selectedPowerDealer?.code ?? '',
        "proprietorName": proprietorController.text,
        "role": globalController.role,
        "screenName": globalController.customerScreenName,
        "shopName": shopeNameController.text,
        "shopNo": apartmentAddressController.text,
        "state": selectedState
      };

      final requestJson = jsonEncode(requestMap);
      final response = await ApiService.postRequest(ApiConstants.addRetailer, requestJson);
      if (response != null) {
        if ((response["message"] ?? '') == "successfully") {
          // Get.back(result: true);
          return true;
        }
      }
    } catch (e) {
      redPrint("Exception Occured : $e");
      isLoading = false;
      update();
      return false;
    }
    isLoading = false;
    update();
    return false;
  }

  bool dropDownValidation() {
    if (selectedState == null) {
      Widgets().showToast("Please Select State.");
      return false;
    } else if (selectedDistrict == null) {
      Widgets().showToast("Please Select District.");
      return false;
    } else if (selectedCity == null) {
      Widgets().showToast("Please Select City.");
      return false;
    }
    //  else if (selectedBeat == null) {
    //   Widgets().showToast("Please Select Beat.");
    //   return false;
    // }
    else {
      return true;
    }
  }

  Future<void> openMapWithCoordinates() async {
    if (position == null) {
      await getCurrentPosition();
    }
    Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=${position!.latitude},${position!.longitude}');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
