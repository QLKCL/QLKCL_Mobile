import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// cre: https://google.github.io/charts/flutter/example/bar_charts/grouped_fill_color.html

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class GroupedFillColorBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  GroupedFillColorBarChart(this.seriesList, {required this.animate});

  factory GroupedFillColorBarChart.withSampleData() {
    return new GroupedFillColorBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
      behaviors: [
        new charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
        )
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final inData = [
      new OrdinalSales('17/10', 5),
      new OrdinalSales('18/10', 25),
      new OrdinalSales('19/10', 80),
      new OrdinalSales('20/10', 75),
    ];

    final outData = [
      new OrdinalSales('17/10', 10),
      new OrdinalSales('18/10', 40),
      new OrdinalSales('19/10', 50),
      new OrdinalSales('20/10', 45),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Mới cách ly',
        domainFn: (OrdinalSales num, _) => num.day,
        measureFn: (OrdinalSales num, _) => num.num,
        data: inData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Hoàn thành cách ly',
        domainFn: (OrdinalSales num, _) => num.day,
        measureFn: (OrdinalSales num, _) => num.num,
        data: outData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String day;
  final int num;

  OrdinalSales(this.day, this.num);
}
