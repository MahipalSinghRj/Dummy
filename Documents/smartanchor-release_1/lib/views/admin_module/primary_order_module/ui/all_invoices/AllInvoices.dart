import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerAllInvoiceListController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/AllInvoicesController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../global/common_controllers/GlobalController.dart';

class AllAdminInvoices extends StatefulWidget {
  const AllAdminInvoices({Key? key}) : super(key: key);

  @override
  State<AllAdminInvoices> createState() => _AllAdminInvoicesState();
}

class _AllAdminInvoicesState extends State<AllAdminInvoices> {
  final TextEditingController orderController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  AllInvoicesController allInvoicesController = Get.put(AllInvoicesController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;
  DateTime initialDateTime = DateTime.now();


  AdminCustomerInvoiceListController adminCustomerInvoiceListController = Get.put(AdminCustomerInvoiceListController());
  GlobalController globalController = Get.put(GlobalController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async{
    await adminCustomerInvoiceListController.getCustomerAllInvoiceListList(code: globalController.customerCode, role: globalController.role, screenName: globalController.customerScreenName, fromDate: dateFromController.text, toDate: dateToController.text, bu: selectedBu??'');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerInvoiceListController>(builder: (controller)
    {
      return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                        child: Widgets().customLRPadding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Widgets().verticalSpace(2.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Widgets().textWidgetWithW700(titleText: 'Invoice Period', fontSize: 11.sp),
                                  Widgets().dynamicButton(onTap: () {},
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
                                dropDownWidget: Widgets().commonDropdown(
                                  selectedValue: selectedBu,
                                  hintText: "Selected BU",
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBu = value;
                                    });
                                  },
                                  itemValue: itemValue,
                                ),
                                datePickerWidget: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Widgets().datePicker(
                                        context: context,
                                        onTap: () {
                                          Get.back();
                                        },
                                        controller: dateFromController,
                                        width: 40.w,
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
                                        width: 40.w,
                                        hintText: 'Date Tto',
                                        initialDateTime: initialDateTime,
                                        onDateTimeChanged: (value) {
                                          setState(() {
                                            dateToController.text = dateTimeUtils.formatDateTime(value);
                                          });
                                        }),
                                  ],
                                ), onApply: () {
                                fetchData();
                                Get.back();
                              },
                              ),
                              Widgets().verticalSpace(2.h),
                            ],
                          ),
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Text(
                          'All Invoice',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: veryLightBoulder),
                        ),
                      ),

                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                        child: ListView.builder(
                          itemCount: controller.invoiceLists.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            //var items = allInvoicesController.dataList[index];
                            return Widgets().allInvoicesCardList(
                                context: context,
                                initialValue: true,
                                onChanged: (value) {
                                  /*setState(() {
                                    items.isSelected = value!;
                                    if (value) {
                                      allInvoicesController.selectedItems.add(items);
                                    } else {
                                      allInvoicesController.selectedItems.remove(items);
                                    }
                                  });*/
                                },
                                businessUnit: controller.invoiceLists[index].bu!,
                                date: controller.invoiceLists[index].date!,
                                referenceOrder: controller.invoiceLists[index].salesOrder!,
                                salesOrder: controller.invoiceLists[index].salesOrder!,
                                transactionType: controller.invoiceLists[index].transactionType!);
                          },
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                    ],
                  )
                ],
              ),
            )),
      );
    });
  }
}
