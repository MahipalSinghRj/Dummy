import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import '../../../../common/AppBar.dart';
import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import 'TableView.dart';

class BeatOption02 extends StatefulWidget {
  const BeatOption02({Key? key}) : super(key: key);

  @override
  State<BeatOption02> createState() => _BeatOption02State();
}

class _BeatOption02State extends State<BeatOption02> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController filterController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  DateTime initialDateTime = DateTime.now();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Widgets().draggableBottomSheetTopContainer(titleText: "Beat (Option 02)"),
                Container(
                  decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
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
                            onTapOnTile: () {}),
                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'Beat Allocation - Individual Upload',
                            titleIcon: individualUpload,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [magicMint, oysterBay],
                            onTap: () {}),
                        Widgets().verticalSpace(2.h),
                        Widgets().textWidgetWithW500(titleText: 'Search Employee', fontSize: 11.sp, textColor: codGray),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWidget(
                            controller: filterController, hintText: 'Employee name / Code', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    dateFromController.text = dateTimeUtils.formatDateTime(value);
                                  });
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
                                    dateToController.text = dateTimeUtils.formatDateTime(value);
                                  });
                                }),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Widgets().dynamicButton(onTap: () {}, height: 45, width: 150, buttonBGColor: alizarinCrimson, titleText: 'Apply', titleColor: white),
                            Widgets().horizontalSpace(2.w),
                            Widgets().dynamicButton(onTap: () {}, height: 45, width: 150, buttonBGColor: codGray, titleText: 'Clear', titleColor: white),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ),
                ),
                Widgets().verticalSpace(3.h),
                Widgets().customLRPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Widgets().textWidgetWithW500(titleText: 'Present Month Beat Allocation', fontSize: 12.sp, textColor: codGray),
                      Widgets().verticalSpace(2.h),
                      const TableView()
                    ],
                  ),
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
