// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/no_order_controller/NoOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/FileUtils.dart';
import '../../../../../utils/GetLatLong.dart';
import '../../controllers/retailer_no_controller/RetailerNoControllerSec.dart';

class RetailerNoOrder extends StatefulWidget {
  final String retailerName;
  final String retailerCode;
  final String buName;
  final String emailAddress;

  const RetailerNoOrder({Key? key, required this.retailerName,
    required this.retailerCode,
    required this.buName,
    required this.emailAddress,
  }) : super(key: key);

  @override
  State<RetailerNoOrder> createState() => _RetailerNoOrderState();
}

class _RetailerNoOrderState extends State<RetailerNoOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  NoOrderController noOrderController = Get.put(NoOrderController());
  RetailerNoOrderControllerSec retailerNoOrderControllerSec = Get.put(RetailerNoOrderControllerSec());
  GlobalController globalController = Get.put(GlobalController());
  GetLatLong getLatLong = Get.put(GetLatLong());
  FileUtils fileUtils = Get.put(FileUtils());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });

    await noOrderController.getReasons();
    setState(() {
      retailerNoOrderControllerSec.fileName == '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNoOrderControllerSec>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          //globalController.splashNavigation();
          globalController.secondaryNavigation(context: context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
              body: Container(
                decoration: BoxDecoration(gradient: Widgets().gradientColor(gradientColorList: [pink, zumthor])),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
                        Widgets().customLRPadding(
                            child: Column(
                          children: [
                            Widgets().verticalSpace(2.h),
                            Widgets().commonDropdown(
                                hintText: "Selected Reason",
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedReason = value;
                                  });
                                },
                                itemValue: noOrderController.reasonsList,
                                selectedValue: controller.selectedReason),
                            Widgets().verticalSpace(2.h),
                            Widgets().iconElevationButton(
                                onTap: () {
                                  fileUtils.takeFileWithGallery().then((value) {
                                    if (value != null) {
                                      setState(() {
                                        Widgets().showToast("Photo successfully attached.");
                                        controller.base64 = fileUtils.fileToBase64(value);
                                        controller.fileName = fileUtils.getFilename(value);
                                        controller.extension = controller.fileName.split('.').last;
                                      });
                                    } else {
                                      Widgets().showToast("Please try again.");
                                    }
                                  });
                                },
                                icon: camera,
                                titleText: 'Attachment',
                                isBackgroundOk: false,
                                width: 100.w,
                                bgColor: codGray,
                                textColor: alizarinCrimson,
                                iconColor: alizarinCrimson),
                            Widgets().verticalSpace(2.h),
                            Widgets().commentContainer(hintText: 'Enter Remark', commentController: controller.commentController),
                            Widgets().verticalSpace(2.h),
                          ],
                        )),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 4.h,
                      child: Widgets().customLRPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().dynamicButton(
                                onTap: () async {
                                  setState(() {
                                    controller.fileName == '';
                                  });
                                  globalController.splashNavigation();
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: codGray,
                                titleText: 'Cancel',
                                titleColor: white),
                            Widgets().dynamicButton(
                                onTap: () async {
                                  printMe("selected reason : ${controller.selectedReason}");
                                  controller.baseFile = await controller.base64;

                                  if (controller.validationSubmitNoOrder()) {
                                    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                    var lat = await getLatLong.getLatitude();
                                    var long = await getLatLong.getLongitude();
                                    await controller
                                        .noOrderFn(
                                      attachmentBase64: controller.baseFile,
                                      bu: widget.buName,
                                      reason: controller.selectedReason ?? '',
                                      latitude: lat ?? "",
                                      longitude: long ?? '',
                                      mimeType: controller.mimeTypeFile,
                                      remark: controller.commentController.text,
                                      retailerCode: widget.retailerCode,
                                    )
                                        .then((value) {
                                      Get.back();
                                      if (value == true) {
                                        Widgets().orderIsGeneratedForNoOrderBottomSheet(
                                          context: context,
                                          message: "NoOrder",
                                          userEmailId: widget.emailAddress,
                                          onTap: () async {
                                            Get.back();
                                            globalController.splashNavigation();
                                          },
                                        );
                                      } else {
                                        Widgets().showToast("Something went wrong.");
                                      }
                                    });
                                  }
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: alizarinCrimson,
                                titleText: 'Submit',
                                titleColor: white)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }
}
