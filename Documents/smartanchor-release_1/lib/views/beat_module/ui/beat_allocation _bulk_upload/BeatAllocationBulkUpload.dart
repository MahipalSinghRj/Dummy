import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../../../utils/PermissionController.dart';
import '../../controllers/BulkUploadController.dart';

class BeatAllocationBulkUpload extends StatefulWidget {
  const BeatAllocationBulkUpload({
    Key? key,
  }) : super(key: key);

  @override
  State<BeatAllocationBulkUpload> createState() =>
      _BeatAllocationBulkUploadState();
}

class _BeatAllocationBulkUploadState extends State<BeatAllocationBulkUpload> {
  final TextEditingController orderController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  PermissionController permissionController = Get.put(PermissionController());

  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  DateTime initialDateTime = DateTime.now();
  List<Color> statusColor = [alizarinCrimson, malachite];
  BulkUploadController bulkUploadController = Get.put(BulkUploadController());

  @override
  void initState() {
    super.initState();
    dateFromController.text = dateTimeUtils.formatDateTime(initialDateTime);
    dateToController.text = dateTimeUtils.formatDateTime(initialDateTime);

    loadInitialData();
  }

  loadInitialData() {
    Future.delayed(const Duration(seconds: 1), () {
      bulkUploadController.getUserListData(
          customerCode: globalController.customerScreenName);
      bulkUploadController.getBulkExcelAudit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<BulkUploadController>(builder: (controller) {
          return Widgets().scaffoldWithAppBarDrawer(
              context: context,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: Widgets().commonDecorationWithGradient(
                              borderRadius: 0,
                              gradientColorList: [pink, zumthor]),
                          child: Widgets().customLRPadding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().verticalSpace(2.h),
                                Widgets().textWidgetWithW700(
                                    titleText: 'Select Date Range',
                                    fontSize: 11.sp),
                                Widgets().verticalSpace(2.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Widgets().datePicker(
                                        context: context,
                                        onTap: () {
                                          Get.back();
                                        },
                                        controller: dateFromController,
                                        width: 45.w,
                                        hintText: 'Date from',
                                        initialDateTime: initialDateTime,
                                        onDateTimeChanged: (value) {
                                          setState(() {
                                            dateFromController.text =
                                                dateTimeUtils
                                                    .formatDateTime(value);
                                          });

                                          print("dateFromController.text");
                                          print(dateFromController.text);
                                        }),
                                    Widgets().datePicker(
                                        context: context,
                                        onTap: () {
                                          Get.back();
                                        },
                                        controller: dateToController,
                                        width: 45.w,
                                        hintText: 'Date to',
                                        initialDateTime: initialDateTime,
                                        onDateTimeChanged: (value) {
                                          setState(() {
                                            dateToController.text =
                                                dateTimeUtils
                                                    .formatDateTime(value);
                                          });
                                        }),
                                  ],
                                ),
                                Widgets().verticalSpace(2.h),
                                Widgets().selectLasExpansionTile(
                                    onExpansionChanged: (isExpanded) {
                                      //  if (isExpanded) {
                                      //   controller.resetSearchListItems();
                                      // }
                                    },
                                    context: context,
                                    searchController: searchTextController,
                                    // checkWidget: ListView.builder(
                                    //   itemCount: controller.selectedItemList.length,
                                    //   shrinkWrap: true,
                                    //   physics: const NeverScrollableScrollPhysics(),
                                    //   itemBuilder: (BuildContext context, int index) {
                                    //     return Row(
                                    //       children: [
                                    //         Widgets().customCheckBoxWidget(
                                    //             onChanged: (value) {
                                    //               if (value!) {
                                    //                 controller.updateSearchSelection(index, true);
                                    //               } else {
                                    //                 controller.updateSearchSelection(index, false);
                                    //               }
                                    //             },
                                    //             initialValue: controller.selectedItemList[index].isSelected,
                                    //             borderWidth: 1),
                                    //         Widgets().horizontalSpace(2.w),
                                    //         Widgets().textWidgetWithW400(titleText: controller.userList[index], fontSize: 9.sp, textColor: codGray)
                                    //       ],
                                    //     );
                                    //   },
                                    // ),
                                    checkWidget: searchView()),
                                Widgets().verticalSpace(2.h),
                                Widgets().iconElevationButton(
                                    onTap: () async {
                                      if (dateTimeUtils
                                          .isStartDateBeforeEndDate(
                                              dateFromController.text,
                                              dateToController.text)) {
                                        if (bulkUploadController
                                            .getSelectedValues()
                                            .isEmpty) {
                                          Widgets().showToast(
                                              "Please select an employee !!");
                                        } else {
                                          bool permissionGranted =
                                              await permissionController
                                                  .isStoragePermissionGranted();

                                          if (permissionGranted) {
                                            bulkUploadController.downloadExcel(
                                                startDate:
                                                    dateFromController.text,
                                                endDate: dateToController.text,
                                                userList: bulkUploadController
                                                    .getSelectedValues());
                                          } else {
                                            Widgets().showToast(
                                                "Please Grant permission to save File !!");

                                            permissionController
                                                .askReadWritePermission();
                                          }
                                        }
                                      }
                                    },
                                    icon: excel,
                                    width: 40.w,
                                    height: 6.h,
                                    titleText: 'Excel Download',
                                    isBackgroundOk: true,
                                    bgColor: magicMint,
                                    iconColor: codGray,
                                    textColor: codGray),
                                Widgets().verticalSpace(2.h),
                              ],
                            ),
                          ),
                        ),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: Column(
                            children: [
                              Widgets().iconElevationButton(
                                onTap: () {
                                  uploadExcelFileBottomSheet(
                                    context: context,
                                    onTapUploadBrowse: () async {
                                      bool permissionGranted =
                                          await permissionController
                                              .isStoragePermissionGranted();
                                      if (!permissionGranted) {
                                        Widgets().showToast(
                                            "Permission to access storage is denied.");
                                        await permissionController
                                            .askReadWritePermission();
                                      } else {
                                        bulkUploadController.pickExcel();
                                      }

                                      setState(() {});
                                    },
                                    onTapUploadButton: () async {
                                      await bulkUploadController.uploadExcel();
                                    },
                                  );
                                },
                                icon: addIcon,
                                iconColor: alizarinCrimson,
                                titleText: 'Upload Excel File',
                                textColor: alizarinCrimson,
                                isBackgroundOk: false,
                                width: 100.w,
                                bgColor: codGray,
                              ),
                              Widgets().verticalSpace(2.h),
                              ListView.builder(
                                itemCount:
                                    controller.bulkUploadList?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Widgets()
                                      .beatAllocationBulkUploadCardList(
                                          context: context,
                                          onTapExcel: () async {
                                            bool permissionGranted =
                                                await permissionController
                                                    .isStoragePermissionGranted();

                                            if (permissionGranted) {
                                              await bulkUploadController
                                                  .downloadIndividualExcel(
                                                fileName: controller
                                                        .bulkUploadList?[index]
                                                        .fileName ??
                                                    '',
                                                base64: controller
                                                        .bulkUploadList?[index]
                                                        .downloadUrl ??
                                                    '',
                                              );
                                            } else {
                                              Widgets().showToast(
                                                  "Please Grant permission to save File !!");

                                              permissionController
                                                  .askReadWritePermission();
                                            }

                                            //downloadUrl
                                          },
                                          uploadDate: controller
                                                  .bulkUploadList?[index]
                                                  .uploadDate ??
                                              'N/A',
                                          uploadType: controller
                                                  .bulkUploadList?[index]
                                                  .uploadType ??
                                              'N/A',
                                          status: controller.bulkUploadList?[index].status ??
                                              'N/A',
                                          noOfRecords: controller
                                                  .bulkUploadList?[index]
                                                  .noOfRecords ??
                                              'N/A',
                                          dateFrom: controller
                                                  .bulkUploadList?[index]
                                                  .dateFrom ??
                                              'N/A',
                                          statusColor: controller.bulkUploadList?[index].status != null &&
                                                  controller.bulkUploadList?[index].status ==
                                                      'Uploaded Successfully'
                                              ? statusColor[1]
                                              : statusColor[0],
                                          beatExtensionFormat:
                                              controller.bulkUploadList?[index].fileName ?? 'N/A');
                                },
                              ),
                            ],
                          ),
                        ),
                        Widgets().verticalSpace(1.5.h),
                      ],
                    )
                  ],
                ),
              ));
        }),
      ),
    );
  }

  //Upload Excel file bottom sheet
  Future uploadExcelFileBottomSheet({
    required BuildContext context,
    required Function() onTapUploadBrowse,
    required Function() onTapUploadButton,
  }) {
    return Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: GetBuilder<BulkUploadController>(builder: (controller) {
              return Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, -4),
                        spreadRadius: 5,
                      )
                    ],
                    color: pippin,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Widgets().textWidgetWithW700(
                              titleText: "Upload Excel File", fontSize: 13.sp),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(closeIcon))
                        ],
                      ),
                      Widgets().verticalSpace(3.h),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(2.h),
                        strokeWidth: 1,
                        color: dottedBorderColor,
                        dashPattern: const [4, 4],
                        child: (controller.uploadedExcelFile?.name != null)
                            ? ListTile(
                                leading: const Icon(Icons.file_present_rounded),
                                title: Text(controller.uploadedExcelFile?.name
                                        ?.toString() ??
                                    ''),
                                trailing: InkWell(
                                    onTap: () {
                                      controller.deleteExcelFile();
                                    },
                                    child: Icon(Icons.cancel_outlined)),
                              )
                            : SizedBox(
                                width: 100.w,
                                height: 25.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      individualUpload,
                                      height: 3.h,
                                    ),
                                    Widgets().verticalSpace(1.h),
                                    Widgets().textWidgetWithW500(
                                        titleText: "Drop a file to upload, or",
                                        fontSize: 10.sp,
                                        textColor: codGray),
                                    Widgets().verticalSpace(1.h),
                                    InkWell(
                                        onTap: onTapUploadBrowse,
                                        child: Widgets()
                                            .underLineTextWidgetWithW500(
                                                titleText:
                                                    "click here to browse",
                                                fontSize: 10.sp,
                                                textColor: curiousBlue)),
                                  ],
                                ),
                              ),
                      ),
                      Widgets().verticalSpace(3.h),
                      Widgets().dynamicButton(
                          onTap: onTapUploadButton,
                          height: 5.5.h,
                          width: 40.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: "Upload",
                          titleColor: white),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),

      barrierColor: Colors.transparent,
      persistent: false,
      isDismissible: false,
      // isDismissible: false,
    );
  }

  FocusNode? autoTextFieldFocusNode;
  int i = 0;

  void handleTextChange(String text) {
    printMe("Search Text is : $text");
  }

  final TextEditingController filterController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();

  Widget searchView() {
    return Container(
      height: 6.5.h,
      decoration: ShapeDecoration(
        color: white,
        shape: RoundedRectangleBorder(
            borderRadius: i != 0
                ? BorderRadius.only(
                    topRight: Radius.circular(1.5.h),
                    topLeft: Radius.circular(1.5.h))
                : BorderRadius.circular(1.5.h)),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
            spreadRadius: 5,
          )
        ],
      ),
      child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            print("bulkUploadController.userNameList");
            print(bulkUploadController.userNameList);
            return bulkUploadController.userNameList
                .where((user) => user
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .toList();
          },
          displayStringForOption: (String input) => input.toString(),
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            autoTextFieldFocusNode = fieldFocusNode;
            searchTextController = fieldTextEditingController;
            return TextField(
              controller: searchTextController,
              focusNode: autoTextFieldFocusNode,
              //readOnly: i == 0 ? true : false,
              style: const TextStyle(fontWeight: FontWeight.w400),
              onTapOutside: (x) {},
              decoration: InputDecoration(
                hintText: 'Type here',
                hintStyle:
                    TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
                filled: true,
                fillColor: white,
                suffixIcon: Image.asset(search),
              ),
              onTap: () {
                if (bulkUploadController.userNameList.isEmpty) {
                  Widgets().showToast("data not found !!");
                }
                // setState(() {
                //   i = 1;
                // });
              },
              onChanged: handleTextChange,
            );
          },
          // onSelected
          onSelected: (String selectedItem) async {
//todo: update calender on date/view change, reset on selection for new employee
            printMe('selected item : $selectedItem');
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Material(
              elevation: 4.0,
              child: InkWell(
                onTap: () {
                  print("*888888888888888888888888888888");
                  autoTextFieldFocusNode?.unfocus();

                  // FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      String titleText = options.elementAt(index);

                      for (var item in bulkUploadController.userNameList) {
                        if (item.contains(titleText)) {
                          titleText = item;
                        }
                      }

                      return Row(
                        children: [
                          Widgets().customCheckBoxWidget(
                              onChanged: (value) {
                                if (value!) {
                                  bulkUploadController.updateSearchSelection(
                                      option, true);
                                } else {
                                  bulkUploadController.updateSearchSelection(
                                      option, false);
                                }
                              },
                              initialValue:
                                  bulkUploadController.isSelectedValue(option),
                              borderWidth: 1),
                          Widgets().horizontalSpace(2.w),
                          Widgets().textWidgetWithW400(
                              titleText: option,
                              fontSize: 9.sp,
                              textColor: codGray)
                        ],
                      );
                    }),
              ),
            );
          }),
    );
  }
}
