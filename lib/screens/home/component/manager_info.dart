import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/test/list_test_no_result_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

import 'charts.dart';

class InfoManagerHomePage extends StatelessWidget {
  final int waitingUsers;
  final int suspectedUsers;
  final int needTestUsers;
  final int canFinishUsers;
  final int waitingTests;
  final List<KeyValue> numberIn;
  final List<KeyValue> numberOut;
  const InfoManagerHomePage({
    this.waitingUsers = 0,
    this.suspectedUsers = 0,
    this.needTestUsers = 0,
    this.canFinishUsers = 0,
    this.waitingTests = 0,
    this.numberIn = const [],
    this.numberOut = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          InfoManagerHomeCard(
            title: "Xét nghiệm cần cập nhật",
            subtitle: waitingTests.toString(),
            icon: WebsafeSvg.asset("assets/svg/xet_nghiem_cap_nhat.svg"),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(ListTestNoResult.routeName);
            },
          ),
          InfoManagerHomeCard(
            title: "Chờ xét duyệt",
            subtitle: waitingUsers.toString(),
            icon: WebsafeSvg.asset("assets/svg/cho_xet_duyet.svg"),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 1)));
            },
          ),
          InfoManagerHomeCard(
            title: "Nghi nhiễm",
            subtitle: suspectedUsers.toString(),
            icon: WebsafeSvg.asset("assets/svg/nghi_nhiem.svg"),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 2)));
            },
          ),
          InfoManagerHomeCard(
            title: "Tới hạn xét nghiệm",
            subtitle: needTestUsers.toString(),
            icon: WebsafeSvg.asset("assets/svg/toi_han_xet_nghiem.svg"),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 3)));
            },
          ),
          InfoManagerHomeCard(
            title: "Sắp hoàn thành cách ly",
            subtitle: canFinishUsers.toString(),
            icon: WebsafeSvg.asset("assets/svg/sap_hoan_thanh_cach_ly.svg"),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 4)));
            },
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
                      child: GroupedFillColorBarChart.withData(
                          numberIn, numberOut),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoManagerHomeCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String title;
  final String subtitle;
  const InfoManagerHomeCard(
      {required this.onTap,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                width: 8,
              ),

              //text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.primaryText),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.disableText,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.groups_rounded,
                              size: 22,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                            text: " " + subtitle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: CustomColors.disableText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
