/// UI file for admin attendance module to show employee location on map

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../attendance_module/markAttendance/controllers/ViewLocationOnMapController.dart';
import '../controllers/AdminAttendanceController.dart';

class AdminTrackEmployee extends StatefulWidget {
  final String customerCode;
  final String customerName;
  final String customerDate;

  const AdminTrackEmployee(
      {Key? key,
      required this.customerCode,
      required this.customerName,
      required this.customerDate})
      : super(key: key);

  @override
  State<AdminTrackEmployee> createState() => _AdminTrackEmployeeState();
}

class _AdminTrackEmployeeState extends State<AdminTrackEmployee> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  GlobalController globalController = Get.put(GlobalController());
  AdminAttendanceController adminAttendanceController =
      Get.put(AdminAttendanceController());

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  List<LatLng> latLen = [];

  ViewLocationOnMapController viewLocationOnMapController =
      Get.put(ViewLocationOnMapController());

  late CameraPosition cameraPosition;

  bool isDataLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
  }

  fetchData() async {
    await adminAttendanceController.getAdminTrackEmployee(
        code: widget.customerCode, date: widget.customerDate);
    for (int i = 0; i < adminAttendanceController.coordinates.length; i++) {
      if(adminAttendanceController.coordinates[i].latitude.toString().isNotEmpty
      && adminAttendanceController.coordinates[i].longitude.toString().isNotEmpty ){
        latLen.add(LatLng(double.tryParse(adminAttendanceController.coordinates[i].latitude!) ?? 0.0,
            double.tryParse(adminAttendanceController.coordinates[i].longitude!) ?? 0.0));
      }

    }

    var mapIcon = await getBitmapDescriptorFromAssetBytes(marker, 120);

    // declared for loop for various locations
    setState(() {
      for (int i = 0; i < latLen.length; i++) {
        var id = i + 1;
        _markers.add(Marker(
            markerId: MarkerId(id.toString()),
            position: latLen[i],
            icon: mapIcon));
      }

      _polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: latLen,
        color: Colors.red,
      ));
      isDataLoad = true;
      if (latLen.isNotEmpty) {
        cameraPosition = CameraPosition(
          target: LatLng(latLen[0].latitude, latLen[0].longitude),
          zoom: 16,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: Container(
              width: 100.w,
              height: 100.h,
              color: alizarinCrimson,
              child: bottomDetailsSheet(),
            )));
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return GetBuilder<ViewLocationOnMapController>(
          init: ViewLocationOnMapController(),
          builder: (viewLocationOnMapController) => Container(
            height: 100.h,
            decoration: Widgets().commonDecorationForTopLRRadiusWithBGColor(
                bgColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Widgets().newOrderUserNameDetailsTile(
                    context: context,
                    titleName: widget.customerName,
                    titleValue: "(Employee Code : ${widget.customerCode})"),
                (isDataLoad)
                    ? Expanded(
                        flex: 94,
                        child: Container(
                          width: 100.w,
                          decoration: Widgets()
                              .commonDecorationForTopLRRadiusWithBGColor(
                                  bgColor: coralRed),
                          child: SizedBox.expand(
                            child: Stack(
                              children: [
                                mapsScreenAttendance(
                                    viewLocationOnMapController),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 94,
                        child: Container(
                          color: Colors.white,
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  mapsScreenAttendance(ViewLocationOnMapController controller) {
    // return GetBuilder<ViewLocationOnMapController>(builder: (controller) {
    printMe("Marker value : $_markers");
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      markers: Set.from(_markers),
      // liteModeEnabled: true,
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      polylines: _polyline,
      onMapCreated: (GoogleMapController gMapController) async {
        controller.mapController = gMapController;
        // controller.update();
      },
    );
    // });
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  String generateRandomId() {
    Random random = Random();
    int randomNumber = random
        .nextInt(999999); // Generates a random number between 0 and 999999
    String randomId = randomNumber
        .toString()
        .padLeft(6, '0'); // Ensures the ID is always 6 digits
    return randomId;
  }
}
