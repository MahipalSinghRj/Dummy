import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../controllers/ViewLocationOnMapController.dart';
import 'TakeYourPhoto.dart';

//ignore: must_be_immutable
class ViewLocationOnMap extends StatefulWidget {
  String? attendanceType;

  ViewLocationOnMap({Key? key, required this.attendanceType}) : super(key: key);

  @override
  State<ViewLocationOnMap> createState() => _ViewLocationOnMapState();
}

class _ViewLocationOnMapState extends State<ViewLocationOnMap> {
  final TextEditingController searchController = TextEditingController();
  ViewLocationOnMapController viewLocationOnMapController =
      Get.put(ViewLocationOnMapController());

// Output: Albert Embankment, London SE1 7SP, UK

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Widgets()
          .loadingDataDialog(loadingText: "Location Fetching, Please wait...");
      await viewLocationOnMapController.dataFetch();
    });
    super.initState();
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
                Expanded(
                  flex: 6,
                  child: Widgets().draggableBottomSheetTopContainer(
                      titleText: "View Location On Map"),
                ),
                Expanded(
                  flex: 94,
                  child: Container(
                    width: 100.w,
                    decoration: Widgets()
                        .commonDecorationForTopLRRadiusWithBGColor(
                            bgColor: coralRed),
                    child: SizedBox.expand(
                      child: Stack(
                        children: [
                          mapsScreenAttendance(viewLocationOnMapController),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 14.h,
                            child: Widgets().customLeftRightPadding(
                                child: Widgets().getAddressBlock(
                              context: context,
                              iconPath: globalController.isClockIn
                                  ? out
                                  : clockInIcon,
                              titleText:
                                  globalController.isClockIn ? 'OUT' : 'IN',
                              dateTime: viewLocationOnMapController.currentTime,
                              address: viewLocationOnMapController.showMarker
                                  ? viewLocationOnMapController.address
                                  : "\n",
                              lat:
                                  "Lat ${viewLocationOnMapController.position?.latitude ?? "fetching.."}°",
                              long:
                                  "Long ${viewLocationOnMapController.position?.longitude ?? "fetching.."}°",
                            )),
                          ),
                          Positioned(
                            bottom: 4.5.h,
                            left: 0,
                            right: 0,
                            child: Widgets().customLeftRightPadding(
                                child: Widgets().iconElevationButton(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      //   return const TakeYourPhoto();
                                      // }));
                                      Get.to(()=>const TakeYourPhoto());
                                    },
                                    icon: camera,
                                    width: 100.h,
                                    titleText: 'Take Your Photo',
                                    isBackgroundOk: true,
                                    bgColor: alizarinCrimson,
                                    iconColor: white)),
                          ),
                        ],
                      ),
                    ),
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
    print("Initial Marker Location : ${(controller.markers)}");
    return GoogleMap(
      initialCameraPosition: controller.cameraPosition,
      markers: controller.markers,
      liteModeEnabled: false,
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: true,
      // mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController gMapController) async {
        controller.mapController = gMapController;

        // controller.update();
      },
    );
    // });
  }
}
