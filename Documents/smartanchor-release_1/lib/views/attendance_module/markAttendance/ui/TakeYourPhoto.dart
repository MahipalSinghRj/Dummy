import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';

import '../../../../common/AppBar.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/FileUtils.dart';
import '../controllers/ViewLocationOnMapController.dart';
import 'AttendanceWithRemark.dart';

class TakeYourPhoto extends StatefulWidget {
  const TakeYourPhoto({Key? key}) : super(key: key);

  @override
  State<TakeYourPhoto> createState() => _TakeYourPhotoState();
}

class _TakeYourPhotoState extends State<TakeYourPhoto> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  ViewLocationOnMapController viewLocationOnMapController = Get.find();
  FileUtils fileUtils = Get.put(FileUtils());

  @override
  void initState() {
    fnGetImage();
    super.initState();
  }

  fnGetImage() {
    fileUtils.takeSelfieWithCamera().then((value) {
      if (value != null) {
        viewLocationOnMapController.attendanceImage = value;
      }
      setState(() {});
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
        return Container(
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2.h),
              topRight: Radius.circular(2.h),
            ),
          ),
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
                      topLeft: Radius.circular(2.h),
                      topRight: Radius.circular(2.h),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Take Your Photo",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp, color: white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 95,
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: coralRed,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.h),
                      topRight: Radius.circular(2.h),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: viewLocationOnMapController.attendanceImage != null
                                  ? Image.file(
                                      viewLocationOnMapController.attendanceImage!,
                                      fit: BoxFit.fill,
                                    )
                                  : Center(
                                      child: Text(
                                      'No image selected',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                                    ))),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 14.h,
                          child: Widgets().customLeftRightPadding(
                              child: Widgets().getAddressBlock(
                            context: context,
                            iconPath: globalController.isClockIn ? out : clockInIcon,
                            titleText: globalController.isClockIn ? 'OUT' : 'IN',
                            dateTime: viewLocationOnMapController.currentTime,
                            address: viewLocationOnMapController.showMarker ? viewLocationOnMapController.address : "\n",
                            lat: "Lat ${viewLocationOnMapController.position?.latitude ?? "fetching.."}°",
                            long: "Long ${viewLocationOnMapController.position?.longitude ?? "fetching.."}°",
                          )),
                        ),
                        Positioned(
                          bottom: 3.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(),
                              Container(),
                              InkWell(
                                onTap: () {
                                  if (viewLocationOnMapController.attendanceImage == null) {
                                    Widgets().showToast("Please capture photo.");
                                  } else {
                                    // Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    //   return const AttendanceWithRemark();
                                    // }));
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                      return const AttendanceWithRemark();
                                    }), (route) => false);
                                    //Get.to(const AttendanceWithRemark());
                                  }
                                },
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 5.h,
                                    backgroundColor: coralRedBlur1,
                                    child: CircleAvatar(radius: 4.h, backgroundColor: alizarinCrimson, child: Icon(Icons.check, color: white, size: 4.h)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  fnGetImage();
                                },
                                child: CircleAvatar(radius: 4.5.h, backgroundColor: white, child: Icon(Icons.refresh, color: codGray, size: 4.h)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
