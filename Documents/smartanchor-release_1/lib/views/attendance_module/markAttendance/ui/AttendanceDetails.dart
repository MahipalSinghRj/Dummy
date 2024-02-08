import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../beat_module/ui/beat_opotion01/BeatOption01.dart';
import '../../../beat_module/ui/my_beat/MyBeat.dart';
import '../../models/DailyAttendanceApiResponse.dart';
import '../../viewAttendance/controllers/ViewAttendanceController.dart';

class AttendanceDetails extends StatefulWidget {
  final DailyAttendanceApiResponse? attendanceApiResponse;
  final String todayDate;

  const AttendanceDetails(
      {Key? key, required this.attendanceApiResponse, required this.todayDate})
      : super(key: key);

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Completer<GoogleMapController> _controllerIn =
      Completer<GoogleMapController>();
  ViewAttendanceController viewAttendanceController =
      Get.put(ViewAttendanceController());

  GlobalController globalController = Get.put(GlobalController());
  @override
  Widget build(BuildContext context) {
    double logInLat = double.tryParse(widget
                .attendanceApiResponse?.logIn?.details?[0].latitude
                ?.toString() ??
            "0.0") ??
        0.0;
    double logInLong = double.tryParse(widget
                .attendanceApiResponse?.logIn?.details?[0].longitude
                ?.toString() ??
            "0.0") ??
        0.0;
    double logOutLat = double.tryParse(widget
                .attendanceApiResponse?.logOut?.details?[0].latitude
                ?.toString() ??
            "0.0") ??
        0.0;
    double logOutLong = double.tryParse(widget
                .attendanceApiResponse?.logOut?.details?[0].longitude
                ?.toString() ??
            "0.0") ??
        0.0;
    LatLng loginLatLng = LatLng(logInLat, logInLong);
    LatLng logOutLatLong = LatLng(logOutLat, logOutLong);
    printMe("Login Latlong : $loginLatLng");
    printMe("Logout Latlong : $logOutLatLong");
    bool isPresent = widget.attendanceApiResponse?.present ?? false;
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: (!isPresent)
                ? Widgets().customLRPadding(
                    child: Center(
                      child: SizedBox(
                        height: 33.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(noDataFound),
                            Widgets().textWidgetWithW400(
                                titleText: 'No Data Found',
                                fontSize: 10.sp,
                                textColor: boulder),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Widgets().iconWithTextInRowWithColor(
                                  iconName: calender,
                                  titleText: widget.todayDate),
                              Widgets().attendanceStatusRow(
                                  color: viewAttendanceController
                                      .getPresentColor(widget
                                          .attendanceApiResponse?.present),
                                  titleText: viewAttendanceController
                                      .getPresentStatus(widget
                                          .attendanceApiResponse?.present)),
                            ],
                          ),
                        ),
                        Widgets().verticalSpace(1.h),
                        Widgets().horizontalDivider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6.h,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Widgets().getInOutContainerInRow(
                                          onTap: () {},
                                          iconPath: clockInIcon,
                                          titleText: 'IN')),
                                  Widgets().verticalDivider1(),
                                  Expanded(
                                      flex: 2,
                                      child: Widgets().getInOutContainerInRow(
                                          onTap: () {},
                                          iconPath: out,
                                          titleText: 'OUT')),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 55.h,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(1.h),
                                      child: Column(
                                        children: [
                                          Widgets().verticalSpace(2.h),
                                          SizedBox(
                                              width: 50.w,
                                              height: 24.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: mapWidgetIn(
                                                  loginLatLng,
                                                ),
                                              )),
                                          Widgets().verticalSpace(1.h),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                width: 50.w,
                                                height: 24.h,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      imageUrl: viewAttendanceController
                                                          .generateImageUrl(widget
                                                                  .attendanceApiResponse
                                                                  ?.logIn
                                                                  ?.details?[0]
                                                                  .image
                                                                  ?.toString() ??
                                                              ""),
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                              child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            color: Colors.grey,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            child: Text(
                                                                "No Image Available"),
                                                          ),
                                                        ],
                                                      )),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 1.5.h,
                                                child: Widgets()
                                                    .getAddressBlockCompressed(
                                                        context: context,
                                                        iconPath: clockInIcon,
                                                        titleText: 'IN',
                                                        // dateTime: 'May 21, 2023 11:49:08',
                                                        dateTime: widget
                                                                .attendanceApiResponse
                                                                ?.logIn
                                                                ?.details?[0]
                                                                .date
                                                                ?.toString() ??
                                                            '',
                                                        address: widget
                                                                .attendanceApiResponse
                                                                ?.logIn
                                                                ?.details?[0]
                                                                .address
                                                                ?.toString() ??
                                                            '',
                                                        lat: widget
                                                                .attendanceApiResponse
                                                                ?.logIn
                                                                ?.details?[0]
                                                                .latitude
                                                                ?.toString() ??
                                                            '',
                                                        long: widget
                                                                .attendanceApiResponse
                                                                ?.logIn
                                                                ?.details?[0]
                                                                .longitude
                                                                ?.toString() ??
                                                            ''),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Widgets().verticalDivider1(),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(1.h),
                                      child: Column(
                                        children: [
                                          //Widgets().getInOutContainerInRow(onTap: () {}, iconPath: clockInIcon, titleText: 'OUT'),
                                          Widgets().verticalSpace(2.h),
                                          SizedBox(
                                              width: 50.w,
                                              height: 24.h,
                                              //decoration: Widgets().commonDecoration(borderRadius: 10, bgColor: white),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: mapWidget(logOutLatLong),
                                              )),
                                          Widgets().verticalSpace(1.h),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                width: 50.w,
                                                height: 24.h,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      imageUrl: viewAttendanceController
                                                          .generateImageUrl(widget
                                                                  .attendanceApiResponse
                                                                  ?.logOut
                                                                  ?.details?[0]
                                                                  .image
                                                                  ?.toString() ??
                                                              ""),
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                              child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.image,
                                                            color: Colors.grey,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            child: Text(
                                                                "No Image Available"),
                                                          ),
                                                        ],
                                                      )),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 1.5.h,
                                                child: Widgets().getAddressBlockCompressed(
                                                    context: context,
                                                    iconPath: out,
                                                    titleText: 'OUT',
                                                    dateTime: widget
                                                            .attendanceApiResponse
                                                            ?.logOut
                                                            ?.details?[0]
                                                            .date
                                                            ?.toString() ??
                                                        '',
                                                    address: widget
                                                            .attendanceApiResponse
                                                            ?.logOut
                                                            ?.details?[0]
                                                            .address
                                                            ?.toString() ??
                                                        '',
                                                    lat: widget
                                                            .attendanceApiResponse
                                                            ?.logOut
                                                            ?.details?[0]
                                                            .latitude
                                                            ?.toString() ??
                                                        '',
                                                    long: widget
                                                            .attendanceApiResponse
                                                            ?.logOut
                                                            ?.details?[0]
                                                            .longitude
                                                            ?.toString() ??
                                                        ''),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Widgets().horizontalDivider(),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: Column(
                            children: [
                              Widgets().tileWithWhiteBGAndThreeItemRow(
                                context: context,
                                icon: workingIcon,
                                titleText: 'Total Working Hrs',
                                subTitleText: viewAttendanceController
                                        .haveValue(widget.attendanceApiResponse
                                            ?.totalWorkedHours
                                            ?.toString())
                                    ? '${widget.attendanceApiResponse?.totalWorkedHours?.toString() ?? "N/A"} Hrs'
                                    : "N/A",
                              ),
                              Widgets().verticalSpace(1.h),
                              Widgets().tileWithWhiteBGAndThreeItemRow(
                                  context: context,
                                  icon: people,
                                  titleText: 'Total  Visited Customer',
                                  subTitleText:
                                      viewAttendanceController.haveValue(widget
                                              .attendanceApiResponse
                                              ?.totalVisitedCustomer
                                              ?.toString())
                                          ? widget.attendanceApiResponse
                                                  ?.totalVisitedCustomer
                                                  ?.toString() ??
                                              "N/A"
                                          : 'N/A'),
                              Widgets().verticalSpace(1.h),
                              Widgets().tileWithWhiteBGAndThreeItemRow(
                                  context: context,
                                  icon: cartIcon,
                                  titleText: 'Primary Order Punch',
                                  subTitleText:
                                      viewAttendanceController.haveValue(widget
                                              .attendanceApiResponse
                                              ?.primeryOrderPunched
                                              ?.toString())
                                          ? widget.attendanceApiResponse
                                                  ?.primeryOrderPunched
                                                  ?.toString() ??
                                              "N/A"
                                          : "N/A"),
                              Widgets().verticalSpace(1.h),
                              Widgets().tileWithWhiteBGAndThreeItemRow(
                                  context: context,
                                  icon: cartIcon,
                                  titleText: 'Secondary Order Punch',
                                  subTitleText:
                                      viewAttendanceController.haveValue(widget
                                              .attendanceApiResponse
                                              ?.secondaryOrderPunched
                                              ?.toString())
                                          ? widget.attendanceApiResponse
                                                  ?.secondaryOrderPunched
                                                  ?.toString() ??
                                              "N/A"
                                          : "N/A"),
                              Widgets().verticalSpace(1.h),
                              Widgets().dynamicButton(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return globalController.role == 'TSI' ||
                                              globalController.role == 'LAS'
                                          ? MyBeat()
                                          : BeatOption01();
                                    }));
                                  },
                                  height: 6.h,
                                  width: 100.w,
                                  buttonBGColor: alizarinCrimson,
                                  titleText: 'Go To My Beat',
                                  titleColor: white),
                              Widgets().verticalSpace(3.h),
                              InkWell(
                                  onTap: () {
                                    //Get.back();
                                    Navigator.pop(context);
                                  },
                                  child: Widgets().textWithArrowIcon(
                                      icon: Icons.arrow_back,
                                      textTitle: 'Back to Month')),
                              Widgets().verticalSpace(3.h),
                            ],
                          ),
                        )
                      ],
                    ),
                  )));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget mapWidget(LatLng latLng) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 16,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("marker1"),
          position: latLng,
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (value) {},
        ),
      },
      liteModeEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Widget mapWidgetIn(LatLng latLng) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 16,
      ),
      liteModeEnabled: true,
      markers: {
        Marker(
          markerId: const MarkerId("marker1"),
          position: latLng,
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (value) {},
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _controllerIn.complete(controller);
      },
    );
  }
}
