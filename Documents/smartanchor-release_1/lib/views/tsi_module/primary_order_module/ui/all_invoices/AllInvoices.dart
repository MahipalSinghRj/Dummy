import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/AllInvoicesController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';

class AllInvoices extends StatefulWidget {
  const AllInvoices({Key? key, required this.customerCode}) : super(key: key);
  final String customerCode;
  @override
  State<AllInvoices> createState() => _AllInvoicesState();
}

class _AllInvoicesState extends State<AllInvoices> {
  final TextEditingController orderController = TextEditingController();

  AllInvoicesController allInvoicesController =
  Get.put(AllInvoicesController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  ScrollController _scrollController = ScrollController();
  DateTime initialDateTime = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getData();
    });
  }

  getData() async {
    await allInvoicesController.getBUForCustomers();

    await allInvoicesController.fetchAllInvoices(
        customerNo: widget.customerCode);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    double pixels = _scrollController.position.pixels;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the
      //end of the list

      isLoading = true;
      setState(() {});
      await allInvoicesController.fetchAllInvoices(
          customerNo: widget.customerCode,
          page: (allInvoicesController.pageCount + 1),
          disableLoading: true);
      isLoading = false;
      _scrollController.position.setPixels(pixels);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<AllInvoicesController>(
            init: AllInvoicesController(),
            builder: (controller) => CustomeLoading(
              isLoading: controller.isLoading,
              child: SingleChildScrollView(
                controller: _scrollController,
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
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Widgets().textWidgetWithW700(
                                        titleText: 'Invoice Period',
                                        fontSize: 11.sp),
                                    Widgets().dynamicButton(
                                        onTap: () {},
                                        height: 4.h,
                                        width: 30.w,
                                        buttonBGColor: alizarinCrimson,
                                        titleText: "Download",
                                        titleColor: white),
                                  ],
                                ),
                                Widgets().verticalSpace(2.h),
                                Widgets().invoicesPeriodExpantionTile(
                                  context: context,
                                  onApply: () {
                                    controller.fetchAllInvoices(
                                        customerNo: widget.customerCode,
                                        page: 1);
                                  },
                                  dropDownWidget: Widgets().commonDropdown(
                                    selectedValue: controller.selectedBu,
                                    hintText: "Selected BU",
                                    onChanged: (value) {
                                      controller.selectedBu = value;
                                      controller.update();
                                    },
                                    itemValue: controller.availableBu,
                                  ),
                                  datePickerWidget: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Widgets().datePicker(
                                          context: context,
                                          onTap: () {
                                            controller.update();
                                            Get.back();
                                          },
                                          controller:
                                          controller.dateFromController,
                                          width: 40.w,
                                          hintText: 'Date from',
                                          initialDateTime: initialDateTime,
                                          onDateTimeChanged: (value) {
                                            controller.dateFromController.text =
                                                dateTimeUtils
                                                    .formatDateTime(value);
                                            controller.update();
                                          }),
                                      Widgets().datePicker(
                                          context: context,
                                          onTap: () {
                                            Get.back();
                                          },
                                          controller:
                                          controller.dateToController,
                                          width: 40.w,
                                          hintText: 'Date to',
                                          initialDateTime: initialDateTime,
                                          onDateTimeChanged: (value) {
                                            controller.dateToController.text =
                                                dateTimeUtils
                                                    .formatDateTime(value);
                                            controller.update();
                                          }),
                                    ],
                                  ),
                                ),
                                Widgets().verticalSpace(2.h),
                              ],
                            ),
                          ),
                        ),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: ListView.builder(
                            itemCount: allInvoicesController
                                .allInvoicesModal?.items.length ??
                                0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final items = allInvoicesController
                                  .allInvoicesModal!.items[index];
                              return Widgets().allInvoicesCardList(
                                  context: context,
                                  initialValue: items.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      items.isSelected = value!;
                                      if (value) {
                                        allInvoicesController.selectedItems
                                            .add(items);
                                      } else {
                                        allInvoicesController.selectedItems
                                            .remove(items);
                                      }
                                    });
                                  },
                                  businessUnit: items.bu,
                                  date: dateTimeUtils.formatDateTime(
                                      DateTime.parse(items.date)),
                                  referenceOrder: items.referenceCode,
                                  salesOrder: items.salesOrder,
                                  transactionType: items.transactionType);
                            },
                          ),
                        ),
                        if (isLoading)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                          ),
                        Widgets().verticalSpace(2.h),
                        Widgets().verticalSpace(2.h),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}