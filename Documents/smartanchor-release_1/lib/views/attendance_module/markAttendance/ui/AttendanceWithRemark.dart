import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/attendance_module/markAttendance/controllers/MarkAttendanceController.dart';

import '../../../../common/AppBar.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../utils/FileUtils.dart';
import '../controllers/ViewLocationOnMapController.dart';

class AttendanceWithRemark extends StatefulWidget {
  const AttendanceWithRemark({Key? key}) : super(key: key);

  @override
  State<AttendanceWithRemark> createState() => _AttendanceWithRemarkState();
}

class _AttendanceWithRemarkState extends State<AttendanceWithRemark> {
  final TextEditingController commentController = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());

  ViewLocationOnMapController viewLocationOnMapController = Get.find();

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
          return SingleChildScrollView(
            child: Container(
              height: 100.h,
              decoration: Widgets().commonDecorationForTopLeftRightRadius(),
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: coralRed,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.w),
                            topRight: Radius.circular(3.w),
                          ),
                        ),
                        child: Center(
                            child: Widgets().textWidgetWithW500(
                                titleText: "Attendance",
                                fontSize: 11.sp,
                                textColor: white)),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Expanded(
                      flex: 35,
                      child: Widgets().customLRPadding(
                        child: Container(
                            width: 100.w,
                            decoration: Widgets().commonDecoration(
                                borderRadius: 5.h, bgColor: white),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1.h),
                              child: mapsScreenAttendance(),
                            )),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Stack(
                      children: [
                        Widgets().customLRPadding(
                          child: SizedBox(
                            width: 100.w,
                            height: 35.h,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(1.h),
                                child: viewLocationOnMapController
                                            .attendanceImage !=
                                        null
                                    ? Image.file(
                                        viewLocationOnMapController
                                            .attendanceImage!,
                                        fit: BoxFit.fill,
                                      )
                                    : const Center(
                                        child: Text('No image selected'))),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 2.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w, right: 3.w),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: globalController.isClockIn,
                      child: Expanded(
                        flex: 15,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 0),
                          child: Container(
                              width: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3.w),
                                  topRight: Radius.circular(3.w),
                                ),
                              ),
                              child: Widgets().commentContainer(
                                  hintText: 'Enter Remark',
                                  commentController: commentController)),
                        ),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Expanded(
                      flex: 6,
                      child: Widgets().customLRPadding(
                        child: Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.w),
                              topRight: Radius.circular(3.w),
                            ),
                          ),
                          child: Widgets().dynamicButton(
                              onTap: () {
                                MarkAttendanceController
                                    markAttendanceController =
                                    Get.put(MarkAttendanceController());
                                FileUtils fileUtils = Get.put(FileUtils());
                                DateTimeUtils dateTimeUtil =
                                    Get.put(DateTimeUtils());

                                Widgets().loadingDataDialog(
                                    loadingText:
                                        "Data Uploading, Please wait...");
                                // Todo: Add loader
                                markAttendanceController.clockInOut(
                                  viewLocationOnMapController.address,
                                  fileUtils.fileToBase64(
                                      viewLocationOnMapController
                                          .attendanceImage!),
                                  viewLocationOnMapController.position!.latitude
                                      .toString(),
                                  globalController.isClockIn,
                                  viewLocationOnMapController
                                      .position!.longitude
                                      .toString(),
                                  commentController.text,
                                  dateTimeUtil
                                      .dateTimeToTimestamp(
                                          viewLocationOnMapController
                                              .currentTime)
                                      .toString(),
                                );
                              },
                              height: 6.h,
                              width: 100.w,
                              buttonBGColor: alizarinCrimson,
                              titleText: 'Mark My Attendance',
                              titleColor: white),
                        ),
                      ),
                    ),
                    Widgets().verticalSpace(3.h)
                  ],
                ),
              ),
            ),
          );
        });
  }

  mapsScreenAttendance() {
    return GetBuilder<ViewLocationOnMapController>(builder: (controller) {
      return GoogleMap(
        initialCameraPosition: controller.cameraPosition,
        markers: controller.markers,
        liteModeEnabled: true,
        onMapCreated: (GoogleMapController mapController) {
          viewLocationOnMapController.mapController = mapController;
          controller.markers = controller.updatemarker();
          controller.cameraPosition =
              controller.getCameraPosition(controller.position!);
        },
      );
    });
  }
}
