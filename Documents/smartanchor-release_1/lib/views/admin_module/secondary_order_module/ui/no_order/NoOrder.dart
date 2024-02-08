import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/views/admin_module/secondary_order_module/controllers/RetailerNoOrderController.dart';
import 'package:smartanchor/views/admin_module/secondary_order_module/ui/no_order/NoOrderDetail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/DateTimeUtils.dart';

class AdminSecondaryNoOrder extends StatefulWidget {
  const AdminSecondaryNoOrder({Key? key}) : super(key: key);

  @override
  State<AdminSecondaryNoOrder> createState() => _AdminSecondaryNoOrderState();
}

class _AdminSecondaryNoOrderState extends State<AdminSecondaryNoOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<ChartData> chartData = <ChartData>[];

  final TextEditingController searchController = TextEditingController();

  String? selectedBu;
  String? selectState;
  String? selectZone;
  String? selectDivision;
  String? selectCategory;
  String? selectCity;

  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());

  bool isFilter = false;
  DateTime initialDateTime = DateTime.now();
  RetailerNoOrderController retailerNoOrderController =
      Get.put(RetailerNoOrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchDropDownData();
  }

  fetchDropDownData() async {
    retailerNoOrderController.getAdminData(
        bu: selectedBu ?? '',
        division: selectDivision ?? '',
        category: selectCategory ?? '',
        brand: "",
        city: selectCity ?? '',
        state: selectState ?? '',
        zone: selectZone ?? '');
  }

  fetchData() async {
    await retailerNoOrderController.getRetailerNoOrderList(
        fromDate: "",
        toDate: dateToController.text,
        bu: selectedBu ?? '',
        zone: selectZone ?? '',
        state: selectState ?? '',
        city: selectCity ?? '',
        pageNumber: 0,
        pageSize: 0,
        role: globalController.role,
        screenName: globalController.customerScreenName,
        searchString: '');

    for (int i = 0;
        i < retailerNoOrderController.noOrderGraphLists.length;
        i++) {
      setState(() {
        chartData.add(
          ChartData(
              retailerNoOrderController.noOrderGraphLists[i].monthhNo
                  .toString(),
              retailerNoOrderController
                  .noOrderGraphLists[i].customerVisitedCount!
                  .toDouble(),
              retailerNoOrderController.noOrderGraphLists[i].noOrdersCount!
                  .toDouble()),
        );
      });
    }
    /*setState(() {
      chartData = [
        ChartData('Total Retailer', int.parse(retailerProfileController.totalRetailer).toDouble(), malachite),
        ChartData('New Retailer', int.parse(retailerProfileController.newRetailer).toDouble(), brinkPinkColor),
      ];
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNoOrderController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(context, scaffoldKey),
              drawer: MainDrawer(context),
              body: Container(
                  width: 100.w,
                  height: 100.h,
                  color: alizarinCrimson,
                  child: DraggableScrollableSheet(
                      initialChildSize: 01,
                      minChildSize: 01,
                      maxChildSize: 1,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                            child: Container(
                                decoration: Widgets().boxDecorationTopLRRadius(
                                    color: white, topLeft: 2.h, topRight: 2.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Widgets()
                                          .draggableBottomSheetTopContainer(
                                              titleText: "No Orders"),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: Widgets()
                                            .tileWithTwoIconAndSingleText(
                                                context: context,
                                                title: 'Search by Filter',
                                                titleIcon: filter,
                                                subtitleIcon:
                                                    rightArrowWithCircleIcon,
                                                tileGradientColor: [
                                                  pink,
                                                  zumthor
                                                ],
                                                onTap: () {
                                                  showNewDialog();
                                                }),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Widgets().myBeatColorContainer(
                                                    bgColor: hintOfGreen,
                                                    borderColor: malachite,
                                                    iconName: groupSvg,
                                                    titleText: controller
                                                        .totalRetailerVisited!,
                                                    iconColor:
                                                        const Color(0xff5BCB81),
                                                    context: context,
                                                    subTitleText:
                                                        'Total Retailers Visited', fixWidth: false),
                                              ),
                                              Widgets().horizontalSpace(2.w),
                                              Expanded(
                                                child: Widgets()
                                                    .myBeatColorContainer(
                                                  bgColor:
                                                      const Color(0xffFFF6F4),
                                                  borderColor: brinkPinkColor,
                                                  iconName: customerSvg,
                                                  titleText:
                                                      controller.noOrderCount!,
                                                  context: context,
                                                  iconColor: brinkPinkColor,
                                                  subTitleText:
                                                      'No Order Count', fixWidth: false
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Widgets().customLRPadding(
                                        child: Container(
                                          color: const Color(0xffF4F9FF),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 286,
                                                child: SfCartesianChart(
                                                    margin: const EdgeInsets.all(1),
                                                    primaryXAxis:
                                                        CategoryAxis(),
                                                    series: <CartesianSeries>[
                                                      ColumnSeries<ChartData,
                                                              String>(
                                                          width: 0.4,
                                                          spacing: 0.2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color:
                                                              const Color(0xff34D196),
                                                          dataSource: chartData,
                                                          xValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.y),
                                                      ColumnSeries<ChartData,
                                                              String>(
                                                          width: 0.4,
                                                          spacing: 0.2,
                                                          color:
                                                              const Color(0xffEE466B),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          dataSource: chartData,
                                                          xValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (ChartData data,
                                                                      _) =>
                                                                  data.y1),
                                                    ]),
                                              ),
                                              Container(
                                                height: 1,
                                                color: const Color(0xffD0D4EC),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        //height: 70,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              dotSvg,
                                                              color: const Color(
                                                                  0xff34D196),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .23,
                                                              child: Text(
                                                                'Total Retailers Visited',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color:
                                                                        waterlooColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              controller
                                                                  .totalRetailerVisited!,
                                                              style: TextStyle(
                                                                  color:
                                                                      veryLightBoulder,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      12.sp,
                                                                  letterSpacing:
                                                                      .3),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 86,
                                                      color: const Color(
                                                          0xffD0D4EC),
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        // height: 70,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              dotSvg,
                                                              color: const Color(
                                                                  0xffEE466B),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .23,
                                                              child: Text(
                                                                'No Order Count',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color:
                                                                        waterlooColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              controller
                                                                  .noOrderCount!,
                                                              style: TextStyle(
                                                                  color:
                                                                      veryLightBoulder,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      12.sp,
                                                                  letterSpacing:
                                                                      .3),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: Text(
                                          'No Ordered Customers',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: veryLightBoulder),
                                        ),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.h),
                                        child: Widgets().textFieldWidget(
                                            controller: searchController,
                                            hintText:
                                                'Retailers / code',
                                            iconName: search,
                                            onTap: () async {
                                              await controller
                                                  .getRetailerNoOrderListwithSearch(
                                                      fromDate:
                                                          dateFromController
                                                              .text,
                                                      toDate:
                                                          dateToController.text,
                                                      bu: selectedBu ?? '',
                                                      zone: selectZone ?? '',
                                                      state: selectState ?? '',
                                                      city: selectCity ?? '',
                                                      pageNumber: 0,
                                                      pageSize: 0,
                                                      role:
                                                          globalController.role,
                                                      screenName: globalController
                                                          .customerScreenName,
                                                      searchString:
                                                          searchController
                                                              .text);
                                            },
                                            keyBoardType: TextInputType.text,
                                            fillColor: white),
                                      ),
                                      Widgets().verticalSpace(2.h),
                                      Widgets().customLRPadding(
                                        child: ListView.builder(
                                          itemCount:
                                              controller.noOrderLists.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                  return AdminSecondaryNoOrderDetail(
                                                    code: controller
                                                        .noOrderLists[index]
                                                        .code!,
                                                    orderId: controller
                                                        .noOrderLists[index]
                                                        .noOrderId!,
                                                    orderDate: controller
                                                        .noOrderLists[index]
                                                        .date!,
                                                  );
                                                }));
                                              },
                                              child: Widgets()
                                                  .AdmincustomerNoOrderCard(
                                                      context: context,
                                                      shopTitleText: controller
                                                          .noOrderLists[index]
                                                          .retailerName!,
                                                      customerCode:
                                                          '(Code : ${controller.noOrderLists[index].code})',
                                                      beat: controller
                                                          .noOrderLists[index]
                                                          .beat!,
                                                      city: controller
                                                          .noOrderLists[index]
                                                          .city!,
                                                      state: controller
                                                          .noOrderLists[index]
                                                          .state!,
                                                      reason: controller
                                                          .noOrderLists[index]
                                                          .reason!,
                                                      date:
                                                          controller
                                                              .noOrderLists[
                                                                  index]
                                                              .date!,
                                                      orderId: controller
                                                          .noOrderLists[index]
                                                          .noOrderId!),
                                            );
                                          },
                                        ),
                                      ),

                                      /*  Widgets().verticalSpace(2.h),
                                Widgets().customLRPadding(
                                  child: ListView.builder(
                                    itemCount: 4,
                                      shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {

                                      return Widgets().EmployeeCard(

                                      );

                                    },
                                  ),
                                ),
*/
                                      Widgets().verticalSpace(2.h),
                                    ])));
                      }))));
    });
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              GetBuilder<RetailerNoOrderController>(builder: (controller) {
            return StatefulBuilder(builder: (context1, myState) {
              return Wrap(
                spacing: 1,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().textWidgetWithW700(
                          titleText: "Filter by", fontSize: 14.sp),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(closeIcon))
                    ],
                  ),
                  Widgets().verticalSpace(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Widgets().filterByCard(
                          widget: Widgets().commonDropdownWith8sp(
                              hintText: "Select BU",
                              onChanged: (value) {
                                myState(() {
                                  selectedBu = value;
                                });

                                // fetchDropDownData();
                              },
                              itemValue: controller.buList,
                              selectedValue: selectedBu),
                        ),
                      ),
                      (globalController.role == "ZSM" ||
                              globalController.role == 'NSM')
                          ? Expanded(
                              flex: 1,
                              child: Widgets().filterByCard(
                                widget: Widgets().commonDropdownWith8sp(
                                    hintText: "Select Zone",
                                    onChanged: (value) {
                                      myState(() {
                                        selectZone = value;
                                      });

                                      //  fetchDropDownData();
                                    },
                                    itemValue: controller.zoneList,
                                    selectedValue: selectZone),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().verticalSpace(1.h),
                  globalController.role == "NSM"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Widgets().filterByCard(
                                  widget: Widgets().commonDropdownWith8sp(
                                      hintText: "Select State",
                                      onChanged: (value) {
                                        myState(() {
                                          selectState = value;
                                        });

                                        // fetchDropDownData();
                                      },
                                      itemValue: controller.stateList,
                                      selectedValue: selectState),
                                )),
                          ],
                        )
                      : const SizedBox(),
                  Widgets().verticalSpace(2.h),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Widgets().datePicker(
                            context: context,
                            onTap: () {
                              Get.back();
                            },
                            controller: dateFromController,
                            //width: 30.w,
                            hintText: 'Date from',
                            initialDateTime: initialDateTime,
                            onDateTimeChanged: (value) {
                              setState(() {
                                dateFromController.text = dateTimeUtils
                                    .formatDateTimePreviousOrder(value);
                              });
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: Widgets().datePicker(
                            context: context,
                            onTap: () {
                              Get.back();
                            },
                            controller: dateToController,
                            //width: 30.w,
                            hintText: 'Date to',
                            initialDateTime: initialDateTime,
                            onDateTimeChanged: (value) {
                              setState(() {
                                dateToController.text = dateTimeUtils
                                    .formatDateTimePreviousOrder(value);
                              });
                            }),
                      ),
                    ],
                  ),
                  Widgets().verticalSpace(1.h),
                  Container(
                    height: 20,
                  ),
                  Widgets().verticalSpace(1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Widgets().dynamicButton(
                          onTap: () async {
                            fetchData();
                            Get.back();
                          },
                          height: 5.5.h,
                          width: 32.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Apply',
                          titleColor: white),
                      Widgets().horizontalSpace(2.w),
                      Widgets().dynamicButton(
                          onTap: () {
                            setState(() {
                              isFilter = false;
                              selectedBu = null;
                              selectZone = null;
                              selectState = null;
                              dateFromController.text = '';
                              dateToController.text = '';
                            });
                            Get.back();
                          },
                          height: 5.5.h,
                          width: 32.w,
                          buttonBGColor: alizarinCrimson,
                          titleText: 'Clear',
                          titleColor: white),
                      Widgets().verticalSpace(1.5.h),
                    ],
                  ),
                ],
              );
            });
          }));
        });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);

  final String x;
  final double? y;
  final double? y1;
}
