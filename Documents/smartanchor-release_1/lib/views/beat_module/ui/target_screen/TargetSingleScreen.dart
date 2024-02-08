import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';
import '../../../../utils/ChartsSupportClasses.dart';
import '../../controllers/IndividualUploadController.dart';

class TargetSingleScreen extends StatefulWidget {
  const TargetSingleScreen({Key? key}) : super(key: key);

  @override
  State<TargetSingleScreen> createState() => _TargetSingleScreenState();
}

class _TargetSingleScreenState extends State<TargetSingleScreen> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, color: Colors.white, textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
        context: context,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Widgets().singleTargetPeriodDateTile(context: context, periodDate: "01-03-2022"),
              Widgets().verticalSpace(2.h),
              Widgets().customLRPadding(
                child: Widgets().targetSingleScreenCard(
                    context: context,
                    achievedAmount: "₹ 530.00",
                    businessUnit: "POWER",
                    category: "WIRES CABLES AND TAPES",
                    division: "WIRING DEVICE",
                    subBrand: "Building Wire",
                    targetAmount: "₹ 1432.78",
                    type: "Trade"),
              ),
              Widgets().verticalSpace(2.h),
              Container(
                  decoration: BoxDecoration(
                    color: pieChartBG,
                  ),
                  child: _buildDefaultPieChart(targetAmount: "1432.78", achievedAmount: "530")),
              Widgets().verticalSpace(2.h),
              Widgets().customLRPadding(
                child: Row(
                  children: [Widgets().textWidgetWithW500(titleText: "Date Wise Targets", fontSize: 16.sp, textColor: Colors.black)],
                ),
              ),
              Widgets().verticalSpace(2.h),
              Widgets().customLRPadding(child: _buildTrackerColumnChart(IndividualUploadController())),
              Widgets().verticalSpace(2.h),
            ],
          ),
        ),
      ),
    );
  }

  SfCircularChart _buildDefaultPieChart({
    required String targetAmount,
    required String achievedAmount,
  }) {
    return SfCircularChart(
      palette: [malibu, lightSky, yellowOrange],
      title: ChartTitle(text: 'Amount', alignment: ChartAlignment.near, textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp)),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: _getDefaultPieSeries(
        targetAmount: targetAmount,
        achievedAmount: achievedAmount,
      ),
      tooltipBehavior: _tooltip,
    );
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries({
    required String targetAmount,
    required String achievedAmount,
  }) {
    double ta = double.tryParse(targetAmount) ?? 0;
    double aa = double.tryParse(achievedAmount) ?? 0;

    double total = ta + aa;

    double taPerc = ((ta / total) * 100);
    double aaPerc = (aa / total) * 100;

    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '0%',
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Target Amount', y: double.tryParse(taPerc.toStringAsPrecision(2)), text: 'Target Amount \n ${taPerc.toStringAsPrecision(2)}%'),
            ChartSampleData(x: 'Achieved Amount', y: double.tryParse(aaPerc.toStringAsPrecision(2)), text: 'Achieved Amount \n ${aaPerc.toStringAsPrecision(2)}%'),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }

  Widget _buildTrackerColumnChart(IndividualUploadController controller) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      enableAxisAnimation: true,
      title: ChartTitle(text: ''),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          autoScrollingDelta: 10,

          // maximum: 28,
          // minimum: 0,
          interval: 1,
          labelPlacement: LabelPlacement.onTicks,
          autoScrollingMode: AutoScrollingMode.start,
          arrangeByIndex: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
      ),
      primaryYAxis: NumericAxis(
          minimum: 0, maximum: 100, axisLine: const AxisLine(width: 1), majorGridLines: const MajorGridLines(width: 0), majorTickLines: const MajorTickLines(size: 0)),
      series: _getTracker(controller),
      tooltipBehavior: _tooltip,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getTracker(IndividualUploadController controller) {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: controller.cartesianChartModelList,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: graphBarTrackColor,
          color: graphBarColor,
          borderRadius: BorderRadius.circular(5),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Marks',
          emptyPointSettings: EmptyPointSettings(
              // Mode of empty point
              mode: EmptyPointMode.average),
          dataLabelSettings:
              const DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}
