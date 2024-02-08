import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_on_map/CustomerOnMap.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/controller/CustomerProfileController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/models/CustomerProfileResponse.dart';

import 'package:smartanchor/views/tsi_module/other_details_of_customer/ui/LedgerReport.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/ChartsSupportClasses.dart';
import '../../../../../utils/functionsUtils.dart';

import '../all_invoices/AllInvoices.dart';
import '../customer_profile/models/CustomerProfileDetailsResonse.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key, required this.masterId}) : super(key: key);
  final String masterId;
  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final TextEditingController commentController = TextEditingController();
  CustomerProfileDetailsResponse customerProfileDetails =
      CustomerProfileDetailsResponse(
          address: '',
          beat: '',
          buName: '',
          city: '',
          creditLimit: '',
          customerCode: '',
          customerName: '',
          latitude: '',
          longitude: '',
          masterId: '',
          noOrderCount: '',
          orderCount: '',
          outstanding: '',
          overdue: '',
          phoneNo: '',
          returnOrderCount: '',
          state: '',
          totalOrderValue: '');
  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedValue;
  String? selectedBu;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(
        enable: true,
        color: Colors.white,
        textStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CustomerProfileController controller =
          Get.put(CustomerProfileController());
      customerProfileDetails =
          await controller.getCustomerDetailsByMasterId(widget.masterId);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<CustomerProfileController>(
            init: CustomerProfileController(),
            builder: (controller) {
              return CustomeLoading(
                isLoading: controller.isLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Widgets().newOrderUserNameDetailsTile(
                          context: context,
                          titleName: customerProfileDetails.customerName,
                          titleValue:
                              "(Customer Code : ${customerProfileDetails.customerCode})"),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                        child: Column(
                          children: [
                            Widgets().customerDetailsExpantionCard(
                                context: context,
                                address: customerProfileDetails.address,
                                beat: customerProfileDetails.beat,
                                city: customerProfileDetails.city,
                                state: customerProfileDetails.state,
                                creditLimit: controller
                                    .customerProfileDetails.creditLimit,
                                outstanding: controller
                                    .customerProfileDetails.outstanding,
                                overdue: customerProfileDetails.overdue,
                                callingOnTap: () {
                                  //TODO add permission in info. plist for calling
                                  Utils().makePhoneCall(controller
                                      .customerProfileDetails.phoneNo);
                                },
                                locationOnTap: () {
                                  Get.to(() => CustomerOnMap(
                                        isSingleCustomer: true,
                                        singleCustomerDetails:
                                            controller.customerProfileDetails,
                                      ));
                                },
                                phoneNumber: customerProfileDetails.phoneNo,
                                verify: 'Verify'),
                            // Widgets().retailerDealerDetailsCard(
                            //     context: context,
                            //     dealerDetails: '',
                            //     powerDealer: 'Dealer Details',
                            //     iaqDealer: 'Dealer Details',
                            //     lightingDealer: 'Dealer Details'),
                            // Widgets().verticalSpace(2.h),
                            Widgets().tileWithTwoIconAndSingleText(
                                context: context,
                                title: 'All Invoices',
                                titleIcon: noteDetailsIcon,
                                subtitleIcon: rightArrowWithCircleIcon,
                                tileGradientColor: [magicMint, oysterBay],
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return AllInvoices(
                                      customerCode:
                                          customerProfileDetails.customerCode,
                                    );
                                  }));
                                }),
                            Widgets().verticalSpace(2.h),
                            // Widgets().tileWithTwoIconAndSingleText(
                            //     context: context,
                            //     title: 'Ledger Report',
                            //     titleIcon: outstanging,
                            //     subtitleIcon: rightArrowWithCircleIcon,
                            //     tileGradientColor: [magicMint, oysterBay],
                            //     onTap: () {
                            //       Navigator.push(context,
                            //           MaterialPageRoute(builder: (_) {
                            //         return const LedgerReport();
                            //       }));
                            //     }),
                            // Widgets().verticalSpace(2.h),
                            //Four status color container Customer Details
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Widgets().colorContainer(
                                        bgColor: lightSkyColor,
                                        borderColor: malibu,
                                        iconName: orderedIcon,
                                        titleText: controller
                                            .customerProfileDetails.orderCount,
                                        subTitleText: 'Total Ordered Items'),
                                    Widgets().horizontalSpace(2.w),
                                    Widgets().colorContainer(
                                        bgColor: lightParrotColor,
                                        borderColor: turquoise,
                                        iconName: amountCollectIcon,
                                        titleText:
                                            '₹ ${customerProfileDetails.totalOrderValue}',
                                        subTitleText: 'Order Value',
                                        iconColor: turquoise),
                                  ],
                                ),
                                Widgets().verticalSpace(1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Widgets().colorContainer(
                                        bgColor: lightredColor,
                                        borderColor: hotPink,
                                        iconName: transactionIcon,
                                        titleText: controller
                                            .customerProfileDetails
                                            .noOrderCount,
                                        subTitleText: 'No Order Count',
                                        iconColor: hotPink),
                                    Widgets().horizontalSpace(2.w),
                                    Widgets().colorContainer(
                                        bgColor: lightyellowColor,
                                        borderColor: yellowOrange,
                                        iconName: returnIcon,
                                        titleText: controller
                                            .customerProfileDetails
                                            .returnOrderCount,
                                        subTitleText: 'Return Order'),
                                  ],
                                ),
                              ],
                            ),
                            Widgets().verticalSpace(1.h),
                            //Three status color container Retailer / SubStockist Profile
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Widgets().colorThreeContainerInRow(
                            //         bgColor: lightSkyColor,
                            //         borderColor: malibu,
                            //         iconName: orderedIcon,
                            //         titleText: '52',
                            //         subTitleText: 'Total Ordered Items'),
                            //     Widgets().horizontalSpace(2.w),
                            //     Widgets().colorThreeContainerInRow(
                            //         bgColor: lightParrotColor,
                            //         borderColor: turquoise,
                            //         iconName: amountCollectIcon,
                            //         titleText: '₹ 376,240',
                            //         subTitleText: 'Order Value',
                            //         iconColor: turquoise),
                            //     Widgets().horizontalSpace(2.w),
                            //     Widgets().colorThreeContainerInRow(
                            //         bgColor: lightredColor,
                            //         borderColor: hotPink,
                            //         iconName: transactionIcon,
                            //         titleText: '05',
                            //         subTitleText: 'No Order Count',
                            //         iconColor: hotPink),
                            //   ],
                            // ),

                            Widgets().verticalSpace(2.h),
                            Container(
                              decoration: BoxDecoration(
                                color: pieChartBG,
                                border: Border.all(color: pieChartBorder),
                                borderRadius: BorderRadius.circular(1.5.h),
                              ),
                              child: _buildDefaultPieChart(
                                  overdue: customerProfileDetails.overdue,
                                  outstanding: controller
                                      .customerProfileDetails.outstanding,
                                  creditLimit: controller
                                      .customerProfileDetails.creditLimit),
                            )
                          ],
                        ),
                      ),
                      Widgets().verticalSpace(2.h),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  SfCircularChart _buildDefaultPieChart(
      {required String creditLimit,
      required String overdue,
      required String outstanding}) {
    return SfCircularChart(
      palette: [malibu, lightSky, yellowOrange],
      title: ChartTitle(
          text: 'Outstanding Amount',
          alignment: ChartAlignment.near,
          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: _getDefaultPieSeries(
          overdue: overdue, outstanding: outstanding, creditLimit: creditLimit),
      tooltipBehavior: _tooltip,
    );
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries(
      {required String creditLimit,
      required String overdue,
      required String outstanding}) {
    double cl = double.tryParse(creditLimit) ?? 0;
    double od = double.tryParse(overdue) ?? 0;
    double os = double.tryParse(outstanding) ?? 0;
    double total = cl + od + os;

    double clPerc = ((cl / total) * 100);
    double odPerc = (od / total) * 100;
    double osPerc = (os / total) * 100;
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '5%',
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Credit Limit',
                y: double.tryParse(clPerc.toStringAsPrecision(2)),
                text: 'Credit Limit \n ${clPerc.toStringAsPrecision(2)}%'),
            ChartSampleData(
                x: 'Outstanding',
                y: double.tryParse(osPerc.toStringAsPrecision(2)),
                text: 'Outstanding \n ${osPerc.toStringAsPrecision(2)}%'),
            ChartSampleData(
                x: 'Overdue',
                y: double.tryParse(odPerc.toStringAsPrecision(2)),
                text: 'Overdue \n ${odPerc.toStringAsPrecision(2)}%'),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }
}
