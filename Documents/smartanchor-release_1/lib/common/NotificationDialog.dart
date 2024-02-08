import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/new_order_controller/NewOrderController.dart';

import '../constants/assetsConst.dart';
import '../constants/colorConst.dart';
import '../views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import '../views/tsi_module/primary_order_module/ui/new_order/NewOrder.dart';

//ignore: must_be_immutable
class FilterByPopUp extends StatefulWidget {
  final String buName;
  final String customerCode;
  final String customerName;

  const FilterByPopUp({Key? key, required this.buName, required this.customerCode, required this.customerName}) : super(key: key);

  @override
  State<FilterByPopUp> createState() => _FilterByPopUpState();
}

class _FilterByPopUpState extends State<FilterByPopUp> {
  NewOrderController newOrderController = Get.put(NewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedBu;
  String? selectDivision;
  String? selectCategory;
  String? selectBrand;
  String? selectWarehouse;

  @override
  void initState() {
    getNewOrderFilterApi();
    super.initState();
  }

  getNewOrderFilterApi() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Widgets().loadingDataDialog(loadingText: "Loading data...");
    });
    await newOrderController.dropdownFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: Widgets().commonDecoration(bgColor: white, borderRadius: 1.5.h),
              child: Padding(
                padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w, top: 2.h, bottom: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(closeIcon))
                        ],
                      ),
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdown(
                              hintText: "Select BU",
                              width: 40.w,
                              onChanged: (value) {
                                setState(() {
                                  selectedBu = value;
                                });
                              },
                              itemValue: primaryOrderController.buList,
                              selectedValue: selectedBu),
                        ),
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdown(
                              hintText: "Select Division",
                              width: 40.w,
                              onChanged: (value) {
                                setState(() {
                                  selectDivision = value;
                                });
                              },
                              itemValue: newOrderController.selectDivision,
                              selectedValue: selectDivision),
                        ),
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdown(
                              hintText: "Select Category",
                              width: 40.w,
                              onChanged: (value) {
                                setState(() {
                                  selectCategory = value;
                                });
                              },
                              itemValue: newOrderController.selectCategory,
                              selectedValue: selectCategory),
                        ),
                        Widgets().filterByCard(
                          widget: Widgets().commonDropdown(
                              hintText: "Select Brand",
                              width: 40.w,
                              onChanged: (value) {
                                setState(() {
                                  selectBrand = value;
                                });
                              },
                              itemValue: newOrderController.selectBrand,
                              selectedValue: selectBrand),
                        ),
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Widgets().filterByCard(
                      widget: Widgets().commonDropdown(
                          hintText: "Select Warehouse",
                          width: 100.w,
                          onChanged: (value) {
                            setState(() {
                              selectWarehouse = value;
                            });
                          },
                          itemValue: itemValue,
                          selectedValue: selectWarehouse),
                    ),
                    Widgets().verticalSpace(1.5.h),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Widgets().dynamicButton(
                          //     onTap: () {
                          //       Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                          //       newOrderController
                          //           .productByBUFilter(
                          //               customerCode: widget.customerCode,
                          //               bu: widget.buName,
                          //               division: selectDivision ?? '',
                          //               category: selectCategory ?? '',
                          //               subBrand: selectBrand ?? '',
                          //               context: context)
                          //           .then((value) {
                          //         //Get.back();
                          //         Navigator.push(context, MaterialPageRoute(builder: (_) {
                          //           return NewOrder(
                          //             customerCode: widget.customerCode,
                          //             buName: widget.buName,
                          //             customerName: widget.customerName,
                          //             newOrderListData: newOrderController.productByBUItemsFilter,
                          //           );
                          //         }));
                          //         // Get.offAll(NewOrder(
                          //         //   customerCode: widget.customerCode,
                          //         //   buName: widget.buName,
                          //         //   customerName: widget.customerName,
                          //         //   newOrderListData: newOrderController.productByBUItemsFilter,
                          //         // ));
                          //
                          //         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                          //         //   return NewOrder(
                          //         //     customerCode: widget.customerCode,
                          //         //     buName: widget.buName,
                          //         //     customerName: widget.customerName,
                          //         //     newOrderListData: newOrderController.productByBUItemsFilter,
                          //         //   );
                          //         // }), (route) => false);
                          //       });
                          //     },
                          //     height: 5.5.h,
                          //     width: 32.w,
                          //     buttonBGColor: alizarinCrimson,
                          //     titleText: 'Apply',
                          //     titleColor: white),
                          Widgets().horizontalSpace(2.w),
                          Widgets().dynamicButton(onTap: () {}, height: 5.5.h, width: 32.w, buttonBGColor: alizarinCrimson, titleText: 'Clear', titleColor: white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
