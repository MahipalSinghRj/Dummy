import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/customer_on_map_controller/CustomerOnMapController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../all_invoices/AllInvoices.dart';
import '../customer_profile/models/CustomerProfileDetailsResonse.dart';

class CustomerOnMap extends StatefulWidget {
  CustomerOnMap({Key? key, this.isSingleCustomer = false, this.singleCustomerDetails}) : super(key: key);
  final bool isSingleCustomer;
  CustomerProfileDetailsResponse? singleCustomerDetails;
  @override
  State<CustomerOnMap> createState() => _CustomerOnMapState();
}

class _CustomerOnMapState extends State<CustomerOnMap> {
  // List<String> itemValue = ["Mumbai", "Delhi"];
  // String? selectedValue;
  // String? selectedBu;
  CustomerOnMapController controller = Get.put(CustomerOnMapController());

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isSingleCustomer && widget.singleCustomerDetails != null) {
        controller.singleCustomerDetails = widget.singleCustomerDetails;

        await getAddressLatLng(widget.singleCustomerDetails!.address);
        print("Latitude: $latitude, Longitude: ${longitude}");
        print("Address: ${widget.singleCustomerDetails!.address}");
        final postions = LatLng(latitude, longitude);
        controller.markers = {Marker(markerId: MarkerId(widget.singleCustomerDetails?.customerCode ?? "0"), position: postions)};
        controller.viewLocationOnMapController.cameraPosition = CameraPosition(target: postions);
      } else if (widget.isSingleCustomer == false) {
        await controller.fetchAllMapMarkers();
      }
    });
    setState(() {});
  }

  Future<void> getAddressLatLng(String address) async {
    LatLng? result = await getLatLngFromAddress(address);

    if (result != null) {
      setState(() {
        latitude = result.latitude;
        longitude = result.longitude;
      });
    } else {
      print("Error getting location for address: $address");
    }
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LatLng(location.latitude, location.longitude);
      } else {
        // Handle the case where no location is found for the given address
        return null;
      }
    } catch (e) {
      // Handle any errors that might occur during the geocoding process
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<CustomerOnMapController>(
            init: CustomerOnMapController(),
            builder: (controller) => CustomeLoading(
              isLoading: controller.isLoading,
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    mapsScreenAttendance(controller),
                    Positioned(
                        top: 3.h,
                        left: 0,
                        right: 0,
                        child: Widgets().customLRPadding(
                          child: Widgets().textFieldWidget(
                              controller: controller.searchController, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Widgets().customLRPadding(
                          child: Widgets().customerOnMapAddressCard(
                              context: context,
                              shopTitleText: widget.singleCustomerDetails?.customerName ?? "",
                              customerCode: '(Customer Code : ${widget.singleCustomerDetails?.customerCode ?? ""})',
                              address: widget.singleCustomerDetails?.address ?? "",
                              beat: widget.singleCustomerDetails?.beat ?? "",
                              city: widget.singleCustomerDetails?.city ?? "",
                              state: widget.singleCustomerDetails?.state ?? "",
                              viewDetailsOnTap: () {},
                              noteDetailsOnTap: () {
                                Get.to(() => AllInvoices(customerCode: widget.singleCustomerDetails?.customerCode ?? ''));
                              },
                              callingOnTap: () {
                                Utils().makePhoneCall(widget.singleCustomerDetails?.phoneNo ?? '');
                              },
                              locationOnTap: () async {
                                controller.openMapWithAddress(controller.singleCustomerDetails?.address ?? '');
                              })),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  mapsScreenAttendance(CustomerOnMapController controller) {
    return GoogleMap(
      liteModeEnabled: false,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition: controller.viewLocationOnMapController.cameraPosition,
      markers: controller.markers,
      onMapCreated: (GoogleMapController gMapController) {
        controller.viewLocationOnMapController.mapController = gMapController;
      },
    );
  }
}
