import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/charts.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:intl/intl.dart';

class ManagerHomePage extends StatefulWidget {
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
            onPressed: () {},
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
            onTap: () {},
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      // margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        "Thống kê người cách ly",
                        // textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    // SizedBox(
                    //   height: 200,
                    // ),
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

class MemberHomePage extends StatefulWidget {
  MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late Future<CovidData> futureCovid;

  @override
  void initState() {
    super.initState();
    futureCovid = fetchCovidList();
  }

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
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Thông tin dịch bệnh (Việt Nam)",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            FutureBuilder<CovidData>(
              future: futureCovid,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InfoCovidHomePage(
                      increaseConfirmed: snapshot.data!.increaseConfirmed,
                      confirmed: snapshot.data!.confirmed,
                      increaseDeaths: snapshot.data!.increaseDeaths,
                      deaths: snapshot.data!.deaths,
                      increaseRecovered: snapshot.data!.increaseRecovered,
                      recovered: snapshot.data!.recovered,
                      lastUpdate: DateFormat('HH:mm, dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data!.lastUpdate * 1000)));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                // return const CircularProgressIndicator();
                return InfoCovidHomePage();
              },
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  primary: CustomColors.secondary,
                ),
                onPressed: () {},
                child: Text(
                  'Khai báo y tế',
                  style: TextStyle(color: CustomColors.white),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(16),
                child: Image.asset(
                  "assets/images/member_home_image.png",
                )),
          ],
        ),
      ),
    );
  }
}
