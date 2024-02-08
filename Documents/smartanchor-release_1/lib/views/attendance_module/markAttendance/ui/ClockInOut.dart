import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../utils/PermissionController.dart';
import '../../../home_module/BottomNavigation/LandingPage.dart';
import '../controllers/MarkAttendanceController.dart';
import '../controllers/ViewLocationOnMapController.dart';
import 'ViewLocationOnMap.dart';

class ClockInOut extends StatefulWidget {
  const ClockInOut({Key? key}) : super(key: key);

  @override
  State<ClockInOut> createState() => _ClockInOutState();
}

class _ClockInOutState extends State<ClockInOut> {
  final TextEditingController searchController = TextEditingController();
  MarkAttendanceController markAttendanceController = Get.put(MarkAttendanceController());
  GlobalController globalController = Get.put(GlobalController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  var isLocationPermissionAllowed = [Permission.location];

  @override
  void initState() {
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
        return Container(
          height: 100.h,
          decoration: Widgets().commonDecorationForTopLRRadiusWithBGColor(bgColor: white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: 100.w,
                  decoration: Widgets().commonDecorationForTopLRRadiusWithBGColor(bgColor: white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Widgets().profilePictureAvatar(
                          imageUrl:
                              "https://media.istockphoto.com/id/1394781347/photo/hand-holdig-plant-growing-on-green-background-with-sunshine.jpg?s=1024x1024&w=is&k=20&c=KJIpH7RN4AousDF7cdcNkMFV4JBLKe7Ild_9tWCXFys="),
                      Widgets().verticalSpace(2.h),
                      Widgets().textWidgetWithW500(titleText: "Hello ${globalController.userName}", fontSize: 12.sp, textColor: codGray),
                      Widgets().verticalSpace(0.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Widgets().textWidgetWithW400(titleText: "Employee Code : ", fontSize: 10.sp, textColor: Colors.grey),
                          Widgets().textWidgetWithW400(titleText: globalController.customerScreenName, fontSize: 10.sp, textColor: alizarinCrimson),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 55.h,
                decoration: Widgets().commonDecorationForTopLR9WithBGColor(bgColor: alizarinCrimson),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets().customTop15Padding(child: Widgets().textWidgetWithW500(titleText: "Attendance", fontSize: 11.sp, textColor: white)),
                    Widgets().attendanceWithProfileContainer(
                      inContainerColor: !globalController.isClockIn ? white : silverApprox,
                      outContainerColor: globalController.isClockIn ? white : silverApprox,
                      onTapIn: globalController.isClockIn
                          ? () {
                              Widgets().showToast("Not punched out yet!");
                            }
                          : () async {
                              // if (dateTimeUtils.isMorning)
                              if (true) {
                                ViewLocationOnMapController viewLocationOnMapController = Get.put(ViewLocationOnMapController());
                                PermissionController permissionController = Get.put(PermissionController());

                                await viewLocationOnMapController.checkLocationPermissionAndService();
                                bool status = await permissionController.locationServiceAndPermissionEnabled();

                                print(status);

                                if (status) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                    return ViewLocationOnMap(attendanceType: "IN");
                                  }), (route) => false);
                                  // Get.to(ViewLocationOnMap(
                                  //   attendanceType: "IN",
                                  // ));
                                } else {
                                  Widgets().showToast("Please make sure Location permission is granted and  Location Service enabled");
                                }
                              } else {
                                Widgets().showToast("You can not clock-in after 12 PM");
                              }
                            },
                      onTapOut: !globalController.isClockIn
                          ? () {
                              Widgets().showToast("Not punched in yet!");
                            }
                          : () async {
                              ViewLocationOnMapController viewLocationOnMapController = Get.put(ViewLocationOnMapController());
                              PermissionController permissionController = Get.put(PermissionController());
                              await viewLocationOnMapController.checkLocationPermissionAndService();
                              bool status = await permissionController.locationServiceAndPermissionEnabled();
                              if (status) {
                                Get.to(ViewLocationOnMap(
                                  attendanceType: "OUT",
                                ));
                              } else {
                                Widgets().showToast("Please make sure Location permission is granted and  Location Service enabled");
                              }
                            },
                      onTapSkip: () {
                        Get.offAll(
                            () => const LandingPage(
                                  selectedItemIndex: 0,
                                ),
                            predicate: (route) => false);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) {
                        //     return const LandingPage(
                        //       selectedItemIndex: 0,
                        //     );
                        //   }),
                        //   (route) => false,
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
