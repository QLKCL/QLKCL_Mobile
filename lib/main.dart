import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý khu cách ly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ManagerHomePage(),
    );
  }
}

class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() {
    return _ManagerHomePageState();
  }
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Trang chủ"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.help_outline),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          ListItem(
            title: "Xét nghiệm cần cập nhật",
            subtitle: "50",
            icon: Image.asset("assets/images/xet_nghiem_cap_nhat.png"),
            onTap: () {},
          ),
          ListItem(
            title: "Chờ xét duyệt",
            subtitle: "50",
            icon: Image.asset("assets/images/cho_xet_duyet.png"),
            onTap: () {},
          ),
          ListItem(
            title: "Nghi nhiễm",
            subtitle: "50",
            icon: Image.asset("assets/images/nghi_nhiem.png"),
            onTap: () {},
          ),
          ListItem(
            title: "Tới hạn xét nghiệm",
            subtitle: "50",
            icon: Image.asset("assets/images/toi_han_xet_nghiem.png"),
            onTap: () {},
          ),
          ListItem(
            title: "Sắp hoàn thành cách ly",
            subtitle: "50",
            icon: Image.asset("assets/images/sap_hoan_thanh_cach_ly.png"),
            onTap: () {},
          ),
          Container(
            height: 400,
            // padding: EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Thống kê người cách ly"),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GroupedFillColorBarChart.withSampleData(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: CustomColors.secondary,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Trang chủ',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Người cách ly',
            icon: Icon(Icons.groups_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Quét mã',
            icon: Icon(Icons.qr_code_scanner),
          ),
          BottomNavigationBarItem(
            label: 'Khu cách ly',
            icon: Icon(Icons.apartment_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Tài khoản',
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final VoidCallback onTap;
  final Image icon;
  final String title;
  final String subtitle;
  const ListItem(
      {required this.onTap,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: icon,
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                  title: Text(title),
                  subtitle: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.groups_rounded),
                        ),
                        TextSpan(
                          text: " " + subtitle,
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      ),
    );
  }
}

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
      behaviors: [new charts.SeriesLegend(position: charts.BehaviorPosition.bottom,)],
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
        fillColorFn: (_, __) =>
            charts.MaterialPalette.red.shadeDefault.lighter,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Hoàn thành cách ly',
        domainFn: (OrdinalSales num, _) => num.day,
        measureFn: (OrdinalSales num, _) => num.num,
        data: outData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
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
