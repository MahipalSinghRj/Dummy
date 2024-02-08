import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerOutstandingAmountController.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/ui/outstanding_amount/OutStandingAmountSearch.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';

class OutStandingAmount extends StatefulWidget {
  const OutStandingAmount({Key? key}) : super(key: key);

  @override
  State<OutStandingAmount> createState() => _OutStandingAmountState();
}

class _OutStandingAmountState extends State<OutStandingAmount> {
  final TextEditingController searchController = TextEditingController();

  List<ChartData> chartData = <ChartData>[

  ];

  AdminCustomerOutstandingAmountController adminCustomerOutstandingAmountController = Get.put(AdminCustomerOutstandingAmountController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await adminCustomerOutstandingAmountController.getCustomerOutstandingAmountList(code: globalController.customerCode, role: globalController.role, screenName: globalController.customerScreenName);

    for (int i = 0; i < adminCustomerOutstandingAmountController.outstandingList.length; i++) {
      setState(() {
        chartData = [
          ChartData(
              adminCustomerOutstandingAmountController.outstandingList[i].bu!,
              double.parse(adminCustomerOutstandingAmountController.outstandingList[i].creditLimit!),
              double.parse(adminCustomerOutstandingAmountController.outstandingList[i].outstanding!),
              double.parse(adminCustomerOutstandingAmountController.outstandingList[i].overdue!)),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerOutstandingAmountController>(builder: (controller) {
      return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [pink, zumthor],
                    )),
                    child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Column(
                        children: [
                          Row(children: [
                            Widgets().textWidgetWithW500(titleText: 'Total Credit Limit', fontSize: 14, textColor: veryLightBoulder),
                            const Spacer(),
                            Widgets().textWidgetWithW500(titleText: '₹ ${controller.totalCreditLimit}', fontSize: 14, textColor: veryLightBoulder)
                          ]),
                          Widgets().verticalSpace(1.h),
                          Row(children: [
                            Widgets().textWidgetWithW500(titleText: 'Total Outstanding', fontSize: 14, textColor: veryLightBoulder),
                            const Spacer(),
                            Widgets().textWidgetWithW500(titleText: '₹ ${controller.totalOutstanding}', fontSize: 14, textColor: veryLightBoulder)
                          ]),
                          Widgets().verticalSpace(1.h),
                          Row(children: [
                            Widgets().textWidgetWithW500(titleText: 'Total Overdue', fontSize: 14, textColor: veryLightBoulder),
                            const Spacer(),
                            Widgets().textWidgetWithW500(titleText: '${controller.totalOverdue}', fontSize: 14, textColor: veryLightBoulder)
                          ])
                        ],
                      ),
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Text(
                      'Customer List',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: veryLightBoulder),
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child:
                        Widgets().textFieldWidgetWithSearchDelegate(controller: searchController, hintText: 'Search', iconName: search, keyBoardType: TextInputType.text, fillColor: white,
                        onTap: (){
                          showSearch(
                            context: context,
                            delegate: OutstandingAmountSearch(),
                          );
                        }),
                  ),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                    child: ListView.builder(
                      itemCount: controller.outstandingList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Widgets().outstandingAmountCard(
                            context: context,
                            credit: '₹ ${controller.outstandingList[index].creditLimit}',
                            outstanding: controller.outstandingList[index].outstanding!,
                            overdue: controller.outstandingList[index].overdue!);
                      },
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
                  Container(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 286,
                        child: SfCartesianChart(margin: const EdgeInsets.all(1), primaryXAxis: CategoryAxis(), series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                              width: 0.5,
                              spacing: 0.2,
                              borderWidth: 6,
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xff619DFF),
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),
                          ColumnSeries<ChartData, String>(
                              width: 0.5,
                              spacing: 0.2,
                              color: const Color(0xff46DDCC),
                              borderRadius: BorderRadius.circular(5),
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1),
                          ColumnSeries<ChartData, String>(
                              width: 0.5,
                              spacing: 0.2,
                              color: const Color(0xffFFB538),
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y2)
                        ]),
                      ),
                      Widgets().verticalSpace(1.h),
                      Container(
                        height: 1,
                        color: const Color(0xffD0D4EC),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    dotSvg,
                                    color: const Color(0xff619DFF),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .23,
                                    child: Text(
                                      'Credit Limit',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.sp, color: waterlooColor, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 57,
                              color: const Color(0xffD0D4EC),
                            ),
                            Widgets().horizontalSpace(2.w),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    dotSvg,
                                    color: const Color(0xff46DDCC),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .23,
                                    child: Text(
                                      'Outstanding',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.sp, color: waterlooColor, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 57,
                              color: const Color(0xffD0D4EC),
                            ),
                            Widgets().horizontalSpace(2.w),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    dotSvg,
                                    color: const Color(0xffFFB538),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .23,
                                    child: Text(
                                      'Overdue',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.sp, color: waterlooColor, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            )),
      );
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);

  final String x;
  final double? y;
  final double? y1;
  final double? y2;
}
