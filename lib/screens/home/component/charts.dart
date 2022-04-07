import 'package:flutter/material.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InOutChart extends StatelessWidget {
  final List<KeyValue> inData;
  final List<KeyValue> outData;
  final List<KeyValue> hospitalizeData;
  InOutChart({
    required this.inData,
    required this.outData,
    required this.hospitalizeData,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableAxisAnimation: true,
      title: ChartTitle(text: "Thống kê người cách ly"),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.rotate45),
      primaryYAxis: NumericAxis(
        minimum: 0,
        interval: 1,
        // desiredIntervals: 1,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      tooltipBehavior: TooltipBehavior(
        enable: true,

        /// To specify the tooltip position, whethter its auto or pointer.
        tooltipPosition: TooltipPosition.pointer,
        canShowMarker: true,
      ),
    );
  }

  ///Get the column series
  List<ColumnSeries<KeyValue, String>> _getDefaultColumn() {
    return <ColumnSeries<KeyValue, String>>[
      ColumnSeries<KeyValue, String>(
        dataSource: inData,
        color: Colors.red,
        xValueMapper: (KeyValue sales, _) => sales.id as String,
        yValueMapper: (KeyValue sales, _) => sales.name,
        name: 'Mới cách ly',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          showZeroValue: false,
        ),
      ),
      ColumnSeries<KeyValue, String>(
        dataSource: outData,
        color: Colors.blue,
        xValueMapper: (KeyValue sales, _) => sales.id as String,
        yValueMapper: (KeyValue sales, _) => sales.name,
        name: 'Đã hoàn thành cách ly',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          showZeroValue: false,
        ),
      ),
      ColumnSeries<KeyValue, String>(
        dataSource: hospitalizeData,
        color: Colors.yellow,
        xValueMapper: (KeyValue sales, _) => sales.id as String,
        yValueMapper: (KeyValue sales, _) => sales.name,
        name: 'Chuyển viện',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          showZeroValue: false,
        ),
      ),
    ];
  }
}

class DestiantionChart extends StatelessWidget {
  final List<KeyValue> data;
  DestiantionChart({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // enableAxisAnimation: true,
      title: ChartTitle(text: "Thống kê người di chuyển"),
      primaryXAxis: CategoryAxis(
        isInversed: true,
        majorGridLines: const MajorGridLines(width: 0),
        interval: 1,
        visibleMaximum: 10,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,

        // /// To enable the pinch zooming as true.
        // enablePinching: true,
        // zoomMode: ZoomMode.y
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        interval: 1,
        // labelFormat: '{value}%',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      tooltipBehavior: TooltipBehavior(
        enable: true,

        /// To specify the tooltip position, whethter its auto or pointer.
        tooltipPosition: TooltipPosition.pointer,
        canShowMarker: true,
      ),
      // onAxisLabelTapped: (AxisLabelTapArgs args) {
      //   Navigator.of(context,
      //           rootNavigator: !Responsive.isDesktopLayout(context))
      //       .push(
      //     MaterialPageRoute(builder: (context) => Container()),
      //   );
      // },
    );
  }

  ///Get the column series
  List<BarSeries<KeyValue, String>> _getDefaultColumn() {
    return <BarSeries<KeyValue, String>>[
      BarSeries<KeyValue, String>(
        dataSource: data,
        color: Colors.red,
        xValueMapper: (KeyValue sales, _) => sales.id.name as String,
        yValueMapper: (KeyValue sales, _) => sales.name,
        name: 'Số người',
        // dataLabelSettings: const DataLabelSettings(
        //   isVisible: true,
        //   labelAlignment: ChartDataLabelAlignment.top,
        //   showZeroValue: false,
        // ),
      ),
    ];
  }
}
