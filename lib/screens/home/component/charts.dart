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
      title: ChartTitle(text: "Thống kê người cách ly"),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          minimum: 0,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      tooltipBehavior: TooltipBehavior(enable: true),
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
          name: 'Mới cách ly'),
      ColumnSeries<KeyValue, String>(
          dataSource: outData,
          color: Colors.blue,
          xValueMapper: (KeyValue sales, _) => sales.id as String,
          yValueMapper: (KeyValue sales, _) => sales.name,
          name: 'Đã hoàn thành cách ly'),
      ColumnSeries<KeyValue, String>(
          dataSource: hospitalizeData,
          color: Colors.yellow,
          xValueMapper: (KeyValue sales, _) => sales.id as String,
          yValueMapper: (KeyValue sales, _) => sales.name,
          name: 'Chuyển viện')
    ];
  }
}
