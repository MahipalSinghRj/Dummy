import 'dart:ui';

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class SalesActivityData1 {
  SalesActivityData1(this.filter, this.sales);

  final String filter;
  final double sales;
}

class SalesActivityData {
  SalesActivityData(this.x, this.y, this.secondValue);

  final String x;
  final double y;
  final double secondValue;
}

class SalesWorthData {
  SalesWorthData(this.x, this.y);

  final String x;
  final double y;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}

class CustomerDemoData {
  CustomerDemoData(this.x, this.y, this.color);

  final String x;
  final String y;
  final Color? color;
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}

class ChartDataTSITarget {
  ChartDataTSITarget(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}

class ChartDataBU {
  ChartDataBU(
      {this.cat,
      this.firstLine,
      this.secondLine,
      this.thirdLine,
      this.fourthLine,
      this.fivethLine,
      this.sixthLine,
      this.seventhLine,
      this.eighthLine,
      this.ninethLine,
      this.tenthLine,
      this.color});

  final String? cat;
  final int? firstLine;
  final int? secondLine;
  final int? thirdLine;
  final int? fourthLine;
  final int? fivethLine;
  final int? sixthLine;
  final int? seventhLine;
  final int? eighthLine;
  final int? ninethLine;
  final int? tenthLine;

  final Color? color;
}

class ChartDataDummy {
  ChartDataDummy(this.x, this.y, this.y2);
  final String x;
  final double y;
  final double y2;
}

class ChartDataValue {
  ChartDataValue(this.name, this.months, this.data);

  final String name;
  final String months;
  final int data;
}

class TopBuChart {
  TopBuChart(this.x, this.y);

  final String x;
  final num y;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class TopAdminProductPrfmcChart {
  TopAdminProductPrfmcChart(this.x, this.y);

  final String x;
  final num y;
}
