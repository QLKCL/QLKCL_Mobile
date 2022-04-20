import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InOutChart extends StatelessWidget {
  final List<KeyValue> inData;
  final List<KeyValue> outData;
  final List<KeyValue> hospitalizeData;
  const InOutChart({
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
  const DestiantionChart({
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
        // interval: 1,
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

class DestinationChartCard extends StatelessWidget {
  const DestinationChartCard({
    Key? key,
    required this.data,
    required this.startTimeMinController,
    required this.startTimeMaxController,
    this.height = 400,
    required this.refresh,
  }) : super(key: key);
  final List<KeyValue> data;
  final TextEditingController startTimeMinController;
  final TextEditingController startTimeMaxController;
  final double height;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 16;
    final crossAxisCount = screenWidth <= maxMobileSize
        ? 1
        : screenWidth >= minDesktopSize
            ? (screenWidth - 230) ~/ (maxMobileSize - 64)
            : screenWidth ~/ (maxMobileSize - 32);
    final width = screenWidth / crossAxisCount;

    return Column(
      children: [
        ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
          rowCrossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Thống kê dữ liệu toàn quốc",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 6,
              rowFit: FlexFit.loose,
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: width < maxMobileSize ? width + 100 : maxMobileSize,
                child: NewDateRangeInput(
                  label: 'Thời gian',
                  controllerStart: startTimeMinController,
                  controllerEnd: startTimeMaxController,
                  maxDate: DateTime.now(),
                  onChangedFunction: refresh,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: height,
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: DestiantionChart(data: data),
            ),
          ),
        )
      ],
    );
  }
}
