import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/no_order_controller/NoOrderController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/FileUtils.dart';
import '../../../../../utils/GetLatLong.dart';
import '../../controllers/primary_order_contoller/PrimaryOrderController.dart';

class NoOrder extends StatefulWidget {
  final String customerName;
  final String customerCode;

  const NoOrder({Key? key, required this.customerName, required this.customerCode}) : super(key: key);

  @override
  State<NoOrder> createState() => _NoOrderState();
}

class _NoOrderState extends State<NoOrder> {
  NoOrderController noOrderController = Get.put(NoOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  GlobalController globalController = Get.put(GlobalController());
  GetLatLong getLatLong = Get.put(GetLatLong());
  final TextEditingController commentController = TextEditingController();
  String? selectedBu;
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
      noOrderController.fileName == '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoOrderController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          globalController.splashNavigation();
          return Future.value(false);
        },
        child: SafeArea(
          child: Widgets().scaffoldWithAppBarDrawer(
              context: context,
              body: Container(
                decoration: BoxDecoration(gradient: Widgets().gradientColor(gradientColorList: [pink, zumthor])),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                        Widgets().customLRPadding(
                            child: Column(
                          children: [
                            Widgets().verticalSpace(2.h),
                            Widgets().commonDropdown(
                                hintText: "Selected Reason",
                                onChanged: (value) {
                                  setState(() {
                                    selectedBu = value;
                                  });
                                },
                                itemValue: controller.reasonsList,
                                selectedValue: selectedBu),
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
                            Widgets().commentContainer(hintText: 'Enter Remark', commentController: commentController),
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
                                  //Navigator.pop(context);
                                  globalController.splashNavigation();
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: codGray,
                                titleText: 'Cancel',
                                titleColor: white),
                            Widgets().dynamicButton(
                                onTap: () async {
                                  var baseFile = controller.base64;
                                  var mimeTypeFile = '';
                                  if (baseFile == null) {
                                    baseFile = '';
                                  } else {
                                    mimeTypeFile = "image/png";
                                  }

                                  printMe("selectedBu : $selectedBu");

                                  if (selectedBu == null) {
                                    Widgets().showToast("Please select reason");
                                    return;
                                  }

                                  /*if (commentController.text.toString().isEmpty) {
                                    Widgets().showToast("Please add remarks");
                                    return;
                                  }*/

                                  var lat = await getLatLong.getLatitude();
                                  var long = await getLatLong.getLongitude();

                                  await controller
                                      .submitNoOrder(
                                          reason: selectedBu!,
                                          buName: primaryOrderController.businessUnit,
                                          customerCode: widget.customerCode,
                                          file: controller.base64 ?? '',
                                          lattitude: '$lat',
                                          longtitude: '$long',
                                          mimeType: mimeTypeFile,
                                          remarks: commentController.text)
                                      .then((value) {
                                    if (value != null && value.successCode == 200) {
                                      Widgets().orderIsGeneratedForNoOrderBottomSheet(
                                        context: context,
                                        message: "No Order",
                                        userEmailId: globalController.customerEmailAddress,
                                        onTap: () async {
                                          Get.back();
                                          globalController.splashNavigation();
                                        },
                                      );
                                    } else {
                                      Widgets().showToast("Something went wrong.");
                                    }
                                  });
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
