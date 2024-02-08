import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/beat_module/ui/add_beat/AddBeat.dart';
import 'package:smartanchor/views/beat_module/ui/beat_allocation%20_bulk_upload/BeatAllocationBulkUpload.dart';
import 'package:smartanchor/views/beat_module/ui/beat_allocation_individual_upload/BeatAllocationIndividualUpload.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../debug/printme.dart';
import '../../controllers/Option01Controller.dart';

class BeatOption01 extends StatefulWidget {
  const BeatOption01({Key? key}) : super(key: key);

  @override
  State<BeatOption01> createState() => _BeatOption01State();
}

class _BeatOption01State extends State<BeatOption01> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController filterController = TextEditingController();

  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  Option01Controller option01controller = Get.put(Option01Controller());
  DateTime initialDateTime = DateTime.now();
  FocusNode? autoTextFieldFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoTextFieldFocusNode = FocusNode();
    fn();
  }

  fn() {
    Future.delayed(const Duration(seconds: 1), () {
      option01controller.getUserListData();
      option01controller.getActionEventApprovalData(
          dateFrom: '', dateTo: '', employeeCode: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   option01controller.getActionEventApprovalData(dateFrom: '', dateTo: '', employeeCode: '');
          // }),
          body: Container(
            width: 100.w,
            height: 100.h,
            color: alizarinCrimson,
            child: bottomDetailsSheet(),
          )),
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: 100.h,
          decoration: Widgets().commonDecorationForTopLeftRightRadius(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().draggableBottomSheetTopContainer(
                    titleText: "Beat (Option 01)"),
                Container(
                  decoration: Widgets().commonDecorationWithGradient(
                      borderRadius: 0, gradientColorList: [pink, zumthor]),
                  child: Widgets().customLRPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().verticalSpace(2.h),
                        Widgets().beatAllocationBulkUploadTile(
                            context: context,
                            title: 'Beat Allocation - Bulk Upload',
                            titleIcon: bulkUpload,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [magicMint, oysterBay],
                            onTapOnTile: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return BeatAllocationBulkUpload();
                              }));
                            }),
                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'Beat Allocation - Individual Upload',
                            titleIcon: individualUpload,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [magicMint, oysterBay],
                            onTap: () {
                              Get.to(
                                  () => const BeatAllocationIndividualUpload());
                            }),
                        // Container(
                        //   decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                        //   child: Widgets().customLRPadding(
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Widgets().verticalSpace(2.h),
                        //         Widgets().textWidgetWithW700(titleText: 'Select Employee', fontSize: 11.sp),
                        //         Widgets().verticalSpace(2.h),
                        //         //searchView(),
                        //         Widgets().verticalSpace(2.h),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Widgets().verticalSpace(2.h),
                        // Widgets().textWidgetWithW500(titleText: 'Search Employee', fontSize: 11.sp, textColor: codGray),
                        // Widgets().verticalSpace(1.h),
                        // Widgets().textFieldWidget(
                        //     controller: filterController, hintText: 'Employee name / Code', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                        Widgets().verticalSpace(2.h),

                        Widgets().textWidgetWithW700(
                            titleText: 'Select Employee', fontSize: 11.sp),
                        Widgets().verticalSpace(1.h),

                        searchView(),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Widgets().datePicker(
                                context: context,
                                onTap: () {
                                  Get.back();
                                },
                                controller:
                                    option01controller.dateFromController,
                                width: 45.w,
                                hintText: 'Date from',
                                initialDateTime: initialDateTime,
                                onDateTimeChanged: (value) {
                                  option01controller.dateFromController.text =
                                      dateTimeUtils.formatDateTime(value);
                                  option01controller.fromDateSetter(
                                      option01controller
                                          .dateFromController.text);
                                }),
                            Widgets().datePicker(
                                context: context,
                                onTap: () {
                                  Get.back();
                                },
                                controller: option01controller.dateToController,
                                width: 45.w,
                                hintText: 'Date to',
                                initialDateTime: initialDateTime,
                                onDateTimeChanged: (value) {
                                  option01controller.dateToController.text =
                                      dateTimeUtils.formatDateTime(value);
                                  option01controller.toDateSetter(
                                      option01controller.dateToController.text);
                                }),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Widgets().dynamicButton(
                                onTap: () {
                                  String selectedUser = '';

                                  if (option01controller
                                      .selectedEmployee.isNotEmpty) {
                                    for (var item in option01controller
                                        .userListForSearchOnlyCode) {
                                      if (option01controller.selectedEmployee
                                          .contains(item)) {
                                        selectedUser = item;
                                      }
                                    }
                                  }
                                  option01controller.getActionEventApprovalData(
                                      dateFrom: option01controller.fromDate,
                                      dateTo: option01controller.toDate,
                                      employeeCode: selectedUser);
                                },
                                height: 5.h,
                                width: 30.w,
                                buttonBGColor: alizarinCrimson,
                                titleText: 'Apply',
                                titleColor: white),
                            Widgets().horizontalSpace(2.w),
                            Widgets().dynamicButton(
                                onTap: () {
                                  option01controller.fnClear();
                                  fn();
                                },
                                height: 5.h,
                                width: 30.w,
                                buttonBGColor: codGray,
                                titleText: 'Clear',
                                titleColor: white),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ),
                ),
                Widgets().verticalSpace(3.h),
                GetBuilder<Option01Controller>(builder: (controller) {
                  return controller.approvalData.isEmpty
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
                      : Widgets().customLRPadding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Widgets().textWidgetWithW500(
                                  titleText: 'Present Month Beat Allocation',
                                  fontSize: 12.sp,
                                  textColor: codGray),
                              Widgets().verticalSpace(2.h),
                              ListView.builder(
                                itemCount: controller.approvalData.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 1.h),
                                    child: Widgets().beatOption1ExpantionCard(
                                        context: context,
                                        userName: controller.approvalData[index]
                                                .employeeName ??
                                            'N/A',
                                        //todo : user code implementation requires changes
                                        userCode:
                                            '(${controller.approvalData[index].userName ?? 'N/A'})',
                                        presentMonthBeatAllocationWidget:
                                            ListView.builder(
                                          itemCount:
                                              controller.headerList.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int subItemIndex) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 1.h),
                                              child: Widgets()
                                                  .primaryOrderRowDetails(
                                                      context: context,
                                                      title:
                                                          controller.headerList[
                                                              subItemIndex],
                                                      subTitle: controller
                                                                  .approvalData[
                                                                      index]
                                                                  .beatList?[
                                                              subItemIndex] ??
                                                          'N/A'),
                                            );
                                          },
                                        ),
                                        onTapView: () {
                                          if (controller.approvalData[index]
                                                  .approve ==
                                              'true') {
                                            Get.to(() =>
                                                BeatAllocationIndividualUpload(
                                                    customerCodeWithName:
                                                        controller
                                                                .approvalData[
                                                                    index]
                                                                .userName ??
                                                            ''));
                                          } else {
                                            Get.to(() => AddBeat(
                                                controller.approvalData[index]
                                                        .userName ??
                                                    '',
                                                'beat'));
                                          }
                                        },
                                        approve: controller.approvalData[index]
                                                    .approve ==
                                                'true'
                                            ? true
                                            : false),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                }),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        );
      },
    );
  }

  int i = 0;

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
            return option01controller.userListForSearch
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
            option01controller.searchTextController =
                fieldTextEditingController;

            return TextField(
              controller: option01controller.searchTextController,
              focusNode: autoTextFieldFocusNode,
              //readOnly: i == 0 ? true : false,
              style: const TextStyle(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Search Employee',
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
            option01controller.employeeSetter(selectedItem);
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Material(
              elevation: 4.0,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.elementAt(index);

                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  void handleTextChange(String text) {
    printMe("Search Text is : $text");
  }
}
