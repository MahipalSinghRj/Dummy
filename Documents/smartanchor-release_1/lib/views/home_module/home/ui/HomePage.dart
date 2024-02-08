import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timelines/timelines.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/assetsConst.dart';
import '../../../../constants/colorConst.dart';
import '../../../../constants/labelConst.dart';
import '../../../../debug/printme.dart';
import '../../../../global/common_controllers/GlobalController.dart';
import '../../../../utils/ChartsSupportClasses.dart';
import '../../../tsi_module/primary_order_module/ui/primary_order/PrimaryOrder.dart';
import '../../../tsi_module/secondary_order_module/ui/secondary_order/SecondaryOrder.dart';
import '../../contollers/HomeContoller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());

  GlobalController globalController = Get.put(GlobalController());

  CarouselController carouselController = CarouselController();

  int bannerIndex = 0;

  List<SalesActivityData> salesActivityList = [];

  List<SalesWorthData> salesWorthData = [];

  late TooltipBehavior _tooltipPie;
  late TooltipBehavior _tooltipSTA;

  TrackballBehavior? _trackballBehavior;

  String? selectedSalesBUFilter;

  String tappedValue = "0";
  String tappedText = "Sales Value";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMonthAndYear();
    _tooltipPie = TooltipBehavior(enable: true, format: 'point.x');
    _tooltipSTA = TooltipBehavior(enable: true, format: 'point.x\npoint.y');

    _trackballBehavior = TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);

    callAPIsOnStarts();

    printMe("User app version : ${globalController.appVersion}");
  }

  callAPIsOnStarts() async {
    await homeController.getDashBoardBanner();

    await homeController.getSalesActivity();

    await homeController.getSalesActivityMonthly();

    await homeController.getTopCustomers();

    await homeController.getTopProducts();

    getSalesActivityGraphData();

    getCustomerDemographyData();

    getSalesWorthData();

    homeController.getSalesTargetAttainment().then((value) {});

    getBUSalesData(selectedSalesBUFilter);
  }

  getSalesActivityGraphData() async {
    salesActivityList.clear();
    await homeController.getSalesActivityGraph(homeController.selectedSalesActivityFilter);

    for (int i = 0; i < homeController.primaryCategoriesList.length; i++) {
      setState(() {
        salesActivityList.add(SalesActivityData(homeController.primaryCategoriesList[i], homeController.primaryOrdersList[i],
            (homeController.secondaryOrdersList.isEmpty) ? 0.0 : homeController.secondaryOrdersList[i]));
      });
    }
  }

  getCustomerDemographyData() async {
    homeController.customData.clear();
    await homeController.getCustomerDemoGraphy();

    printMe("Total value : ${homeController.totalValue}");
    if (homeController.totalValue > 0) {
      for (int i = 0; i < homeController.customerCount.length; i++) {
        setState(() {
          homeController.customData.add(ChartData(homeController.customerNames[i], returnPercentage(homeController.customerCount[i]), colors[i]));
        });
      }
    }
  }

  getSalesWorthData() async {
    salesWorthData.clear();
    await homeController.getSalesWorthGraph(homeController.selectedSalesWorthFilter);
    for (int i = 0; i < homeController.salesCategoriesList.length; i++) {
      setState(() {
        salesWorthData.add(SalesWorthData(homeController.salesCategoriesList[i], homeController.salesOrdersList[i]));
      });
    }
  }

  double returnPercentage(part) {
    double percentage = (part / homeController.totalValue) * 100.0;
    printMe("Per value : $percentage");
    String val = percentage.toStringAsFixed(2);
    return double.parse(val); //.truncateToDouble();
  }

  //List<ChartSampleData> topBuList = [];

  List<List<TopBuChart>> dataSourceOfFinancialYearList = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return SafeArea(
          child: Widgets().scaffoldWithAppBarDrawer(
              context: context,
              isShowBackButton: false,
              body: Container(
                height: 100.h,
                width: 100.w,
                color: alizarinCrimson,
                child: bottomDetailsSheet(),
              )));
    });
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 01,
        maxChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Text(
                            "Hello, ${globalController.userName}",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  bannerBlock(),
                  Widgets().verticalSpace(2.h),
                  salesActivityTodayBlock(),
                  Widgets().verticalSpace(2.h),
                  transactionSectionBlock(),
                  Widgets().verticalSpace(2.h),
                  salesActivityGraphBlock(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Indicator.dot(
                            color: const Color(0xFF8183FF),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Primary Order",
                            style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Indicator.dot(
                            color: const Color(0xFFFF76BA),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Secondary Order",
                            style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Widgets().verticalSpace(2.h),
                  buttonPrimarySecondarySection(),
                  Widgets().verticalSpace(2.h),
                  customDemographyGraphBlock(),
                  Widgets().verticalSpace(2.h),
                  (homeController.topCustomerList.isEmpty) ? Container() : topFiveCustomerBlock(),
                  Widgets().verticalSpace(2.h),
                  (homeController.salesTSIChartData.isEmpty) ? Container() : buildTSISalesTargetBlock(),
                  Widgets().verticalSpace(2.h),
                  salesWorthGraphBlock(),
                  Widgets().verticalSpace(2.h),
                  (homeController.topProductList.isEmpty) ? Container() : topFiveSaleProductBlock(),
                  Widgets().verticalSpace(2.h),
                  (dataSourceOfFinancialYearList.isEmpty) ? Container() : salesBUGraphBlock(),
                  Widgets().verticalSpace(2.h),
                ],
              ),
            ),
          );
        });
  }

  Widget bannerBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return controller.bannerItems!.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                children: [
                  CarouselSlider(
                    items: List.generate(controller.bannerItems!.length, (ind) {
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              // height: 150,
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                imageUrl: controller.bannerItems![ind].imageURL!,
                                fit: BoxFit.contain,
                                progressIndicatorBuilder: (context, url, downloadProgress) => const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    carouselController: carouselController,
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      onPageChanged: (ind1, reason) {
                        setState(() {
                          bannerIndex = ind1;
                        });
                      },
                      initialPage: bannerIndex,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: AnimatedSmoothIndicator(
                      activeIndex: bannerIndex,
                      count: controller.bannerItems!.length,
                      effect: const ExpandingDotsEffect(activeDotColor: Color.fromRGBO(0, 0, 0, 0.9), dotWidth: 8, dotHeight: 8),
                    ),
                  )
                ],
              ),
            );
    });
  }

  Widget salesActivityTodayBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        color: chablis,
        width: 100.h,
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sales Activity Today",
              style: TextStyle(color: veryLightBoulder, fontSize: 15.sp),
            ),
            Widgets().verticalSpace(2.h),
            SizedBox(
                height: 16.h,
                //  width: 100.w,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        //width: 55.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: lightPinkColor),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Row(
                                children: [
                                  Container(
                                      width: 40.00,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: brinkPinkColor,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        rupeeSignSvg,
                                        height: 20.0,
                                        width: 20.0,
                                      )),
                                  Widgets().horizontalSpace(2.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.todayOrderValue.toString(),
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Widgets().verticalSpace(0.5.h),
                                      Row(
                                        children: [
                                          FittedBox(
                                              child: RichText(
                                            text: TextSpan(text: controller.percentageDifference, style: TextStyle(color: alizarinCrimson), children: [
                                              TextSpan(
                                                text: " From Yesterday",
                                                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: boulder),
                                              )
                                            ]),
                                          )),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 60.w,
                                child: SvgPicture.asset(
                                  graphIndicator,
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Widgets().horizontalSpace(2.w),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        //width: 55.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: tangerine.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                              child: Row(
                                children: [
                                  Container(
                                      width: 40.00,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: yellowOrange,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        persomfullSvg,
                                        height: 20.0,
                                        width: 20.0,
                                      )),
                                  Widgets().horizontalSpace(2.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.orderCount,
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Widgets().verticalSpace(0.5.h),
                                      Text(
                                        "New Orders",
                                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                //color: tangerine,
                                width: 60.w,
                                child: SvgPicture.asset(
                                  newleadgraphSvg,
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Widgets().horizontalSpace(2.w),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        // width: 55.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xFFDCFCE7)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                              child: Row(
                                children: [
                                  Container(
                                      width: 40.00,
                                      height: 40.0,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF5BCB81),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        cartIconSvg,
                                        height: 20.0,
                                        width: 20.0,
                                      )),
                                  Widgets().horizontalSpace(2.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.newCustomers,
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Widgets().verticalSpace(0.5.h),
                                      Text(
                                        "New Customers",
                                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 60.w,
                                child: SvgPicture.asset(
                                  newcustomergraphSvg,
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget transactionSectionBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 45.w,
              height: 20.h,
              decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [cornflowerBlue, lochmara]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets().verticalSpace(0.5.h),
                  Container(
                      height: 7.h,
                      width: 7.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(child: SvgPicture.asset(transactionIcon)),
                      )),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    controller.totalMonthlyOrdersCount,
                    style: TextStyle(fontSize: 15.sp, color: white, fontWeight: FontWeight.w600),
                  ),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 12.sp, color: white),
                  ),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    "Monthly Orders",
                    style: TextStyle(fontSize: 12.sp, color: white),
                  ),
                ],
              ),
            ),
            Container(
              width: 45.w,
              height: 20.h,
              decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [peachOrange, tickleMePink]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets().verticalSpace(0.5.h),
                  Container(
                      height: 7.h,
                      width: 7.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(child: SvgPicture.asset(amountCollectIcon)),
                      )),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    controller.totalMonthlyOrdersValue,
                    style: TextStyle(fontSize: 15.sp, color: white, fontWeight: FontWeight.w600),
                  ),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 12.sp, color: white),
                  ),
                  Widgets().verticalSpace(0.5.h),
                  Text(
                    "Monthly Orders Value",
                    style: TextStyle(fontSize: 12.sp, color: white),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget salesActivityGraphBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sales Activity",
                  style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: Colors.black,
                    ),
                    value: controller.selectedSalesActivityFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year ",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: codGray,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedSalesActivityFilter(filter: data!);
                      getSalesActivityGraphData();
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // height: 35.h,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(labelRotation: 45),
                //tooltipBehavior: _tooltip,
                series: <ChartSeries<SalesActivityData, String>>[
                  ColumnSeries<SalesActivityData, String>(
                    dataSource: salesActivityList,
                    xValueMapper: (SalesActivityData data, _) => data.x,
                    yValueMapper: (SalesActivityData data, _) => data.y,
                    color: const Color(0xFF8183FF),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  ),
                  ColumnSeries<SalesActivityData, String>(
                    dataSource: salesActivityList,
                    xValueMapper: (SalesActivityData data, _) => data.x,
                    yValueMapper: (SalesActivityData data, _) => data.secondValue,
                    color: const Color(0xFFFF76BA),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  )
                ]),
          ),
        ]),
      );
    });
  }

  Widget buttonPrimarySecondarySection() {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          Widgets().verticalSpace(2.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const PrimaryOrder(navigationTag: "PrimaryOrder");
                }),
              );
            },
            child: Container(
                width: 93.w,
                height: 12.h,
                padding: const EdgeInsets.only(left: 15),
                decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [selago, selago]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(child: SvgPicture.asset(primaryOrderIcon)),
                        )),
                    Widgets().horizontalSpace(5.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Primary Order",
                          style: TextStyle(fontWeight: FontWeight.w500, color: veryLightBoulder, fontSize: 15.sp),
                        ),
                        Widgets().verticalSpace(1.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Read More",
                              style: TextStyle(color: veryLightBoulder, fontSize: 10.sp),
                            ),
                            Widgets().horizontalSpace(1.w),
                            SvgPicture.asset(
                              forwardArrowIcon,
                              color: Colors.black,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ),
          Widgets().verticalSpace(1.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SecondaryOrder();
                }),
              );
              // Widgets().showToast("Coming soon.");
            },
            child: Container(
                width: 93.w,
                height: 12.h,
                decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [bridesmaid, bridesmaid]),
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(child: SvgPicture.asset(shopIcon)),
                        )),
                    Widgets().horizontalSpace(5.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Secondary Order",
                          style: TextStyle(fontWeight: FontWeight.w500, color: veryLightBoulder, fontSize: 15.sp),
                        ),
                        Widgets().verticalSpace(1.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Read More",
                              style: TextStyle(color: veryLightBoulder, fontSize: 10.sp),
                            ),
                            Widgets().horizontalSpace(1.w),
                            SvgPicture.asset(forwardArrowIcon, color: Colors.black)
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget customDemographyGraphBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        color: Colors.white,
        // height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Customer Demography',
                style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            (homeController.totalValue == 0)
                ? SizedBox(height: 200, child: Center(child: Widgets().textWidgetWithW500(titleText: "No Data Available", fontSize: 14.sp, textColor: boulder)))
                : SfCircularChart(
                    /*legend: const Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.bottom),*/
                    tooltipBehavior: _tooltipPie,
                    series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: controller.customData,
                          explodeOffset: '5%',
                          explode: true,
                          //explodeAll: true,
                          explodeGesture: ActivationMode.singleTap,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelMapper: (ChartData data, _) => "${data.y}%",
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ]),
            SizedBox(
                child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: List.generate(controller.customerNames.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    //width: Get.width / 2.4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Indicator.dot(
                              color: colors[index],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                controller.customerNames[index].toString(),
                                style: TextStyle(color: waterlooColor, fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ))
          ],
        ),
      );
    });
  }

  Widget topFiveCustomerBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top 5 Customers",
                        style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                      /* Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(color: alizarinCrimson, fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.arrow_forward_ios, color: alizarinCrimson, size: 1.5.h)
                        ],
                      ),*/
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "#",
                            style: TextStyle(color: silverApprox, fontWeight: FontWeight.w500),
                          ),
                          Text("CUSTOMERS", style: TextStyle(color: silverApprox, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text("AMOUNT($rupeesSign)", style: TextStyle(color: silverApprox, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: controller.topCustomerList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        padding: const EdgeInsets.all(12),
                        decoration: Widgets().commonDecoration(bgColor: colorsList[index], borderRadius: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    "0${index + 1}.",
                                    style: TextStyle(color: codGray),
                                  ),
                                  Widgets().horizontalSpace(2.w),
                                  Expanded(
                                    child: Text(
                                      controller.topCustomerList[index].customerNo!,
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              "$rupeesSign ${controller.topCustomerList[index].amount!}",
                              style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 10.sp),
                            )
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget salesWorthGraphBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        height: 45.h,
        width: 92.w,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        decoration: Widgets().commonDecorationWithGradient(borderRadius: 10, gradientColorList: [cornflowerBlue, lochmara]),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sales Worth",
                  style: TextStyle(color: white, fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                  child: DropdownButton<String>(
                    underline: DropdownButtonHideUnderline(child: Container()),
                    isExpanded: false,
                    isDense: true,
                    iconSize: 30,
                    icon: SvgPicture.asset(
                      downArrowIcon,
                      color: codGray,
                    ),
                    value: controller.selectedSalesWorthFilter,
                    //elevation: 5,
                    style: const TextStyle(),
                    iconEnabledColor: codGray,
                    items: [
                      "WEEKLY",
                      "MONTHLY",
                      "YEARLY",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10.sp, color: codGray),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Year ",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: white,
                      ),
                    ),
                    onChanged: ((data) {
                      controller.isSelectedSalesWorthFilter(filter: data!);
                      getSalesWorthData();
                    }),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 35.h,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                    textStyle: TextStyle(color: white),
                  ),
                  labelRotation: 45,
                  labelStyle: TextStyle(color: white),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    textStyle: TextStyle(color: white),
                  ),
                  labelStyle: TextStyle(color: white),
                ),
                plotAreaBorderColor: white,
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<SalesWorthData, String>>[
                  SplineSeries(
                    dataSource: salesWorthData,
                    xValueMapper: (SalesWorthData sales, _) => sales.x,
                    yValueMapper: (SalesWorthData sales, _) => sales.y,
                    color: white,
                  )
                ]),
          ),
        ]),
      );
    });
  }

  Widget topFiveSaleProductBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Text(
                    "Sales of Top 5 Products",
                    style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                ListView.builder(
                    itemCount: controller.topProductList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 6.h,
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  color: topFiveProductColor[index],
                                ),
                                /* Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: topFiveProductColor[index].withOpacity(0.1),
                                  ),
                                  child: Center(child: SvgPicture.asset(topFiveProductIcon[index])),
                                ),*/
                                Widgets().horizontalSpace(2.w),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    controller.topProductList[index].itemDescription!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: veryLightBoulder,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Order Value",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp, color: veryLightBoulder),
                                ),
                                Text(
                                  "$rupeesSign ${controller.topProductList[index].amount!}",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: veryLightBoulder),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTSISalesTargetBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        color: Colors.white,
        // height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Sales Target Attainment (STA)',
                style: TextStyle(color: codGray, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Stack(
              children: [
                SfCircularChart(
                    annotations: [
                      CircularChartAnnotation(
                          widget: Text(
                        "$tappedText\n$tappedValue",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ))
                    ],
                    tooltipBehavior: _tooltipSTA,
                    series: <CircularSeries>[
                      DoughnutSeries<ChartDataTSITarget, String>(
                        onPointTap: (pointInteractionDetails) {
                          tappedValue = pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].y.toString();
                          tappedText = pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].x.toString();
                          setState(() {});
                        },
                        dataSource: controller.salesTSIChartData,
                        xValueMapper: (ChartDataTSITarget data, _) => data.x,
                        yValueMapper: (ChartDataTSITarget data, _) => data.y,
                        innerRadius: '80%',
                        pointColorMapper: (ChartDataTSITarget data, _) => data.color,
                      )
                    ]),
                /*Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${_tooltipSTA.format}",
                          style: const TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ))),*/
              ],
            )
          ],
        ),
      );
    });
  }

  Widget salesBUGraphBlock() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        height: 45.h,
        width: 92.w,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Top BU & Division Wise Sales",
                    style: TextStyle(color: codGray, fontSize: 15.sp, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                (controller.filtersListBuSales.isEmpty)
                    ? Container()
                    : SizedBox(
                        height: 15,
                        child: DropdownButton<String>(
                          underline: DropdownButtonHideUnderline(child: Container()),
                          isExpanded: false,
                          isDense: true,
                          iconSize: 30,
                          icon: SvgPicture.asset(
                            downArrowIcon,
                            color: Colors.black,
                          ),
                          value: controller.selectedSalesBUFilter,
                          //elevation: 5,
                          style: const TextStyle(),
                          iconEnabledColor: codGray,
                          items: controller.filtersListBuSales.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 10.sp, color: codGray),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select Year ",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: codGray,
                            ),
                          ),
                          onChanged: ((data) {
                            setState(() {
                              controller.selectedSalesBUFilter = data;
                            });
                            //controller.isSelectedSalesBuFilter(filter: data!);
                            getBUSalesData(data);
                          }),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 35.h,
            child: _buildSalesStackedLines(),
          ),
        ]),
      );
    });
  }

  getBUSalesData(selectedSalesBUFilter) async {
    await Future.delayed(const Duration(seconds: 1));
    Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
    await homeController.getTsiDashboardProductSales(selectedSalesBUFilter).then((value) {
      Get.back();

      for (int salesIndex = 0; salesIndex <= homeController.salesDataBuSales.length - 1; salesIndex++) {
        dataSourceOfFinancialYearList.add(rawCalculation(homeController.salesDataBuSales[salesIndex].data as List<int>));
      }

      setState(() {});

      printMe("Filter List :${homeController.filtersListBuSales}");

      /*List<SalesDataBu>? salesDataList = [];
      salesDataList = homeController.salesDataBuSales;

      List<List<int>> result = [];

      for (int i = 0; i < salesDataList[0].data!.length; i++) {
        List<int> currentList = [];
        for (var salesData in salesDataList) {
          currentList.add(salesData.data![i]);
        }
        result.add(currentList);
      }
      printMe("ChartDataBU firstLine   : ${result}");

      topBuList.clear();
      for (int i = 0; i < homeController.categoriesListBuSales.length; i++) {
        topBuList.add(
          ChartSampleData(
            x: homeController.categoriesListBuSales[i].toString(),
            y: setValuesInStackLines(i, 'y', result),
            yValue: setValuesInStackLines(i, "yValue", result),
            secondSeriesYValue:
                setValuesInStackLines(i, "secondSeriesYValue", result),
            thirdSeriesYValue:
                setValuesInStackLines(i, "thirdSeriesYValue", result),
          ),
        );
      }*/
    });
  }

  List<TopBuChart> rawCalculation(List<int> salesData) {
    List<TopBuChart> dataSourceList = <TopBuChart>[];

    for (int i = 0; i < homeController.salesDataBuSales.length; i++) {
      dataSourceList.add(TopBuChart(
        '$i',
        salesData[i],
      ));
    }

    return dataSourceList;
  }

  int setValuesInStackLines(int index, String key, List<List<int>> resultList) {
    List<List<int>> result = resultList;
    List<int> resultItem = [];

    for (int i = 0; i < result.length; i++) {
      if (i == index) {
        resultItem = result[i];
      }
    }

    int returnValue = 0;

    switch (key) {
      case 'y':
        {
          returnValue = resultItem[0];
        }
        break;
      case 'yValue':
        {
          returnValue = resultItem[1];
        }
        break;

      case 'secondSeriesYValue':
        {
          returnValue = resultItem[2];
        }
        break;

      case 'thirdSeriesYValue':
        {
          returnValue = resultItem[3];
        }
        break;
      default:
        {
          returnValue = 0;
        }
    }

    return returnValue;
  }

  getCurrentMonthAndYear() {
    DateTime now = DateTime.now();
    selectedSalesBUFilter = DateFormat('MMM yyyy').format(now);
    setState(() {
      homeController.selectedSalesBUFilter = selectedSalesBUFilter;
    });
    //homeController.isSelectedSalesBuFilter(filter: selectedSalesBUFilter!);
  }

  SfCartesianChart _buildSalesStackedLines() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ' '),
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), rangePadding: ChartRangePadding.auto, minimum: 0),
      /*primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.normal,
          axisLine: const AxisLine(width: 1),
          */ /*title: AxisTitle(
            text: "Amount (in Lacs)",
            alignment: ChartAlignment.center
          ),*/ /*
          //numberFormat:  NumberFormat.compact(),
          labelPosition: ChartDataLabelPosition.outside,
          majorTickLines: const MajorTickLines(size: 1)),*/
      series: _getSalesStackedLine100Series(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineSeries<TopBuChart, String>> _getSalesStackedLine100Series() {
    List<SplineSeries<TopBuChart, String>> generateStackedSeriesList = [];

    for (int dataSourceIndex = 0; dataSourceIndex <= dataSourceOfFinancialYearList.length - 1; dataSourceIndex++) {
      generateStackedSeriesList.add(SplineSeries<TopBuChart, String>(
          dataSource: dataSourceOfFinancialYearList[dataSourceIndex],
          xValueMapper: (TopBuChart sales, _) => sales.x,
          yValueMapper: (TopBuChart sales, _) {
            return sales.y;
          },
          /*dataLabelMapper:  (TopBuChart sales, _) {
            return "${numDifferentiation(sales.y.toString())} lac";
          },
          name: homeController.salesDataBuSales[dataSourceIndex].name,*/
          legendIconType: LegendIconType.circle,
          enableTooltip: true,
          /* color: homeController.salesDataBuSales[dataSourceIndex].colorCode != null
              ? HexColor(homeController.salesDataBuSales[dataSourceIndex].colorCode.toString())
              : codGray,*/
          markerSettings: const MarkerSettings(isVisible: false)));
    }
    return generateStackedSeriesList;
  }

  num numDifferentiation(String value) {
    int v = int.parse(value);
    double a = (v / 100000);
    value = '$a';
    return num.parse(value);
  }
}
