import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/attendance_module/viewAttendance/ui/AttendanceMonth.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/DateTimeUtils.dart';
import '../../viewAttendance/controllers/ViewAttendanceController.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final TextEditingController daterFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
      context: context,
      isShowBackButton: false,
      body: Container(
        width: 100.w,
        height: 100.h,
        color: alizarinCrimson,
        child: bottomDetailsSheet(),
      ),
    ));
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return GetBuilder<ViewAttendanceController>(
          builder: (controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration:
                  Widgets().boxDecorationTopLRRadius(color: white, topLeft: 2.h, topRight: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().verticalSpace(2.h),
                  Widgets().textWidgetWithW500(
                      titleText: "Select Leave Date", fontSize: 12.sp, textColor: codGray),
                  Widgets().verticalSpace(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().datePicker(
                          context: context,
                          onTap: () {
                            Get.back();
                          },
                          controller: daterFromController,
                          hintText: "Date from",
                          width: 43.w,
                          initialDateTime: selectedDate,
                          onDateTimeChanged: (value) {
                            selectedDate = value;
                            daterFromController.text =
                                dateTimeUtils.formatDateTimePreviousOrder(selectedDate);
                          }),
                      Widgets().datePicker(
                          context: context,
                          onTap: () {
                            Get.back();
                          },
                          controller: dateToController,
                          hintText: "Date to",
                          width: 43.w,
                          initialDateTime: selectedDate,
                          onDateTimeChanged: (value) {
                            selectedDate = value;
                            dateToController.text =
                                dateTimeUtils.formatDateTimePreviousOrder(selectedDate);
                          }),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().commentContainer(
                    hintText: 'Enter Remark',
                    commentController: commentController,
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().dynamicButton(
                      onTap: () async {
                        printMe("From Date: ${daterFromController.text}");
                        printMe("To Date: ${dateToController.text}");
                        printMe("Remark: ${commentController.text}");

                        if (daterFromController.text.toString().isEmpty) {
                          Widgets().showToast("Enter from date");
                          return;
                        }

                        if (dateToController.text.toString().isEmpty) {
                          Widgets().showToast("Enter to date");
                          return;
                        }

                        Widgets().loadingDataDialog(loadingText: "Loading Data, Please wait...");

                        await controller
                            .applyLeave(daterFromController.text, dateToController.text,
                                commentController.text)
                            .then((value) {
                          printMe("Response : $value");

                          if(value!){
                            Widgets().showToast("Your leave Successfully submitted");

                          }else{
                            Widgets().showToast("Something went wrong, please try after some time");
                          }

                          Get.back();

                        });
                      },
                      height: 6.h,
                      width: MediaQuery.of(context).size.width,
                      buttonBGColor: alizarinCrimson,
                      titleText: 'Apply Leave',
                      titleColor: white),
                  Widgets().verticalSpace(2.h),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const AttendanceMonth();
                          }),
                        );
                      },
                      child: Widgets()
                          .textWithArrowIcon(icon: Icons.arrow_back, textTitle: 'Back to Month')),
                  Widgets().verticalSpace(2.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
