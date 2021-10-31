import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/charts.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_no_result_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ManagerHomePage extends StatefulWidget {
  static const String routeName = "/manager_home";
  ManagerHomePage({Key? key}) : super(key: key);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
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
            onPressed: () {
              showBarModalBottomSheet(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Wrap(
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            'Tạo mới',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description_outlined),
                        title: Text('Phiếu xét nghiệm'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AddTest.routeName);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add_alt),
                        title: Text('Người cách ly'),
                      ),
                      ListTile(
                        leading: Icon(Icons.manage_accounts_outlined),
                        title: Text('Quản lý'),
                      ),
                      ListTile(
                        leading: Icon(Icons.business_outlined),
                        title: Text('Khu cách ly'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          InfoManagerHomePage(
            title: "Xét nghiệm cần cập nhật",
            subtitle: "0",
            icon: WebsafeSvg.asset("assets/svg/xet_nghiem_cap_nhat.svg"),
            onTap: () {
              Navigator.pushNamed(context, ListTestNoResult.routeName);
            },
          ),
          InfoManagerHomePage(
            title: "Chờ xét duyệt",
            subtitle: "0",
            icon: WebsafeSvg.asset("assets/svg/cho_xet_duyet.svg"),
            onTap: () {},
          ),
          InfoManagerHomePage(
            title: "Nghi nhiễm",
            subtitle: "0",
            icon: WebsafeSvg.asset("assets/svg/nghi_nhiem.svg"),
            onTap: () {},
          ),
          InfoManagerHomePage(
            title: "Tới hạn xét nghiệm",
            subtitle: "0",
            icon: WebsafeSvg.asset("assets/svg/toi_han_xet_nghiem.svg"),
            onTap: () {},
          ),
          InfoManagerHomePage(
            title: "Sắp hoàn thành cách ly",
            subtitle: "0",
            icon: WebsafeSvg.asset("assets/svg/sap_hoan_thanh_cach_ly.svg"),
            onTap: () {},
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Thống kê người cách ly",
                        style: Theme.of(context).textTheme.headline6,
                      ),
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
    );
  }
}
