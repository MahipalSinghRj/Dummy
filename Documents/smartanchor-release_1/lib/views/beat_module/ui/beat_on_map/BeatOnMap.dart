import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';
import 'package:smartanchor/views/beat_module/controllers/MyBeatController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../utils/functionsUtils.dart';
import '../../../tsi_module/primary_order_module/ui/all_invoices/AllInvoices.dart';
import '../../models/responseModels/GetCustomerAddressResponse.dart';
import '../../models/responseModels/GetCustomerDetailsResponse.dart';
import '../../models/responseModels/GetEventsAllocationResponse.dart';

class BeatOnMap extends StatefulWidget {
  final List<BeatsEventData> beatsList;
  const BeatOnMap({Key? key, required this.beatsList}) : super(key: key);

  @override
  State<BeatOnMap> createState() => _BeatOnMapState();
}

class _BeatOnMapState extends State<BeatOnMap> {
  final TextEditingController searchController = TextEditingController();
  ViewLocationOnMapController viewLocationOnMapController =
      Get.put(ViewLocationOnMapController());
  MyBeatController myBeatController = Get.put(MyBeatController());

  String? selectedValue;
  String? selectedBu;

  bool isMapDataLoad = false;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(19.1774423, 72.8671835),
    zoom: 9,
  );

  // Completer<GoogleMapController>? _controller;
  // CameraPosition? _kGooglePlex;

  GetCustomerDetailsResponse beatDetailsList =
      GetCustomerDetailsResponse(customerData: []);

  CustomerData currentCustomerData = CustomerData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await getData();
      },
    );
  }

  getData() async {
    Widgets().loadingDataDialog(loadingText: "Loading data...");
    try {
      await Future.forEach(widget.beatsList, (BeatsEventData element) async {
        if (element.beatCode != null && (element.beatCode ?? '').isNotEmpty) {
          GetCustomerDetailsResponse? value = await myBeatController
              .getCustomerDetails(beatCode: element.beatCode ?? '');
          if (value != null) {
            beatDetailsList.customerData!.addAll(value.customerData ?? []);
          }
        }
      });

      if (beatDetailsList.customerData!.isNotEmpty) {
        currentCustomerData = beatDetailsList.customerData!.first;
      }

      await Future.forEach((beatDetailsList.customerData ?? []),
          (element) async {
        var item = element as CustomerData;
        final latLng = await viewLocationOnMapController
            .getAddressLocation(item.address ?? '');
        if (latLng != null) {
          element.latitude = latLng.latitude.toString();
          element.longitude = latLng.longitude.toString();
        }
      });

      viewLocationOnMapController.markers = beatDetailsList.customerData!
          .map((e) => Marker(
              onTap: () {
                currentCustomerData = e;
                setState(() {});
              },
              markerId: MarkerId(e.customerCode ?? ''),
              position: LatLng(double.parse(e.latitude ?? "0"),
                  double.parse(e.longitude ?? '0'))))
          .toSet();

      if (viewLocationOnMapController.markers.isNotEmpty) {
        cameraPosition = CameraPosition(
            target: viewLocationOnMapController.markers.first.position,
            zoom: 4);

        await viewLocationOnMapController.mapController!.moveCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: viewLocationOnMapController.markers.first.position,
                zoom: 4)));
      }
      viewLocationOnMapController.update();
    } catch (e) {
      print("Exception Occured : $e");
    } finally {
      Get.back();
    }
  }

  // getLatLangFromAddress() async {
  //   await viewLocationOnMapController.checkLocationPermissionAndService();

  //   for (int i = 0; i < widget.customerMapList.length; i++) {
  //     List<Location> locations =
  //         await locationFromAddress('${widget.customerMapList[i].address}');
  //     if (locations.isNotEmpty) {
  //       double latitude = locations.first.latitude;
  //       double longitude = locations.first.longitude;
  //       printMe("Latitude : $latitude");
  //       printMe("longitude : $longitude");

  //       CustomerMapWithLatLng customerLL = CustomerMapWithLatLng(
  //           address: widget.customerMapList[i].address,
  //           beat: widget.customerMapList[i].beat,
  //           city: widget.customerMapList[i].city,
  //           customerCode: widget.customerMapList[i].customerCode,
  //           lag: latitude,
  //           lat: longitude,
  //           masterId: widget.customerMapList[i].masterId,
  //           name: widget.customerMapList[i].name,
  //           state: widget.customerMapList[i].state);

  //       _customerMapWithLatLngList.add(customerLL);
  //     }
  //   }
  //   setState(() {
  //     isMapDataLoad = true;
  //   });
  //   printMe(
  //       "_customerMapWithLatLngList Length : ${_customerMapWithLatLngList.length}");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ViewLocationOnMapController>(
        init: ViewLocationOnMapController(),
        builder: (controller) => Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: SizedBox.expand(
              child: Stack(
                children: [
                  mapsScreenAttendance(controller),
                  Positioned(
                      top: 3.h,
                      left: 0,
                      right: 0,
                      child: Widgets().customLRPadding(
                        child: Widgets().textFieldWidget(
                            controller: searchController,
                            hintText: 'Search',
                            iconName: search,
                            keyBoardType: TextInputType.text,
                            fillColor: white),
                      )),
                  if (viewLocationOnMapController.markers.isNotEmpty)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Widgets().customLRPadding(
                          child: Widgets().customerOnMapAddressCard(
                              context: context,
                              shopTitleText:
                                  currentCustomerData.customerName ?? "",
                              customerCode:
                                  '(Customer Code : ${currentCustomerData.customerCode ?? ""})',
                              address: currentCustomerData.address ?? "",
                              beat: "",
                              city: "",
                              state: "",
                              viewDetailsOnTap: () {},
                              noteDetailsOnTap: () {
                                Get.to(() => AllInvoices(
                                    customerCode:
                                        currentCustomerData.customerCode ??
                                            ''));
                              },
                              callingOnTap: () {
                                print(
                                    "PHONE NUMBER : ${currentCustomerData.phoneNumber}");
                                Utils().makePhoneCall(currentCustomerData
                                            .phoneNumber ==
                                        null
                                    ? ""
                                    : "+91  ${currentCustomerData.phoneNumber}");
                              },
                              locationOnTap: () async {
                                viewLocationOnMapController.openMapWithAddress(
                                    currentCustomerData.address ?? '');
                              })),
                    ),
                ],
              ),
            )),
      ),
    );
  }

  mapsScreenAttendance(ViewLocationOnMapController controller) {
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      liteModeEnabled: false,
      markers: controller.markers,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: (GoogleMapController gcontroller) {
        controller.mapController = gcontroller;
      },
    );
  }

  //Show model bottom sheet
  void editOrderListCard(
      {required BuildContext context,
      required String address,
      required String beat,
      required String city,
      required String customerCode,
      required String masterId,
      required String name,
      required String state}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: 40.h),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 5,
                  )
                ],
                color: white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.h),
                    topLeft: Radius.circular(4.h))),
            child: Wrap(
              children: [
                Widgets().customLRPadding(
                    child: Widgets().customerOnMapAddressCard(
                        context: context,
                        shopTitleText: name,
                        customerCode: '(Customer Code : $customerCode)',
                        address: address,
                        beat: beat,
                        city: city,
                        state: state,
                        viewDetailsOnTap: () {},
                        noteDetailsOnTap: () {},
                        callingOnTap: () {},
                        locationOnTap: () {
                          launchMap(address);
                        })),
              ],
            ),
          );
        });
      },
    );
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  createGoogleMap() {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, 122.085749655962),
      zoom: 14.4746,
    );

    return GoogleMap(
      mapType: MapType.none,
      myLocationButtonEnabled: true,
      liteModeEnabled: true,
      zoomGesturesEnabled: true,
      onTap: (latLng) {
        printMe("Clicked Location : $latLng");
      },
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
