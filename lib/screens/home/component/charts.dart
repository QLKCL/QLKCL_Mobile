import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';

// cre: https://google.github.io/charts/flutter/example/bar_charts/grouped_fill_color.html

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class GroupedFillColorBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  GroupedFillColorBarChart(this.seriesList, {required this.animate});

  factory GroupedFillColorBarChart.withData(List<KeyValue> inData,
      List<KeyValue> outData, List<KeyValue> hospitalizeData) {
    return new GroupedFillColorBarChart(
      _createChart(inData, outData, hospitalizeData),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      // defaultRenderer: new charts.BarRendererConfig(
      //     groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
      behaviors: [
        new charts.SeriesLegend(
          desiredMaxColumns: Responsive.isMobileLayout(context) ? 2 : 3,
          position: charts.BehaviorPosition.bottom,
        )
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<KeyValue, String>> _createChart(
      List<KeyValue> inData,
      List<KeyValue> outData,
      List<KeyValue> hospitalizeData) {
    return [
      // Blue bars with a lighter center color.
      new charts.Series<KeyValue, String>(
        id: 'Mới cách ly',
        domainFn: (KeyValue num, _) => num.id,
        measureFn: (KeyValue num, _) => num.name,
        data: inData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
      // Hollow green bars.
      new charts.Series<KeyValue, String>(
        id: 'Đã hoàn thành cách ly',
        domainFn: (KeyValue num, _) => num.id,
        measureFn: (KeyValue num, _) => num.name,
        data: outData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      // Hollow green bars.
      new charts.Series<KeyValue, String>(
        id: 'Chuyển viện',
        domainFn: (KeyValue num, _) => num.id,
        measureFn: (KeyValue num, _) => num.name,
        data: hospitalizeData,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      ),
    ];
  }
}
