import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/resources/covid_data.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:intl/intl.dart';

class MemberHomePage extends StatefulWidget {
  @override
  _MemberHomePageState createState() {
    return _MemberHomePageState();
  }
}

class _MemberHomePageState extends State<MemberHomePage> {
  int _currentIndex = 0;

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
                  return Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InfoMemberHomePage(
                          color: CustomColors.warning,
                          title: "Nhiễm bệnh",
                          newCase: snapshot.data!.increaseConfirmed,
                          totalCase: snapshot.data!.confirmed,
                        ),
                        InfoMemberHomePage(
                          color: CustomColors.error,
                          title: "Tử vong",
                          newCase: snapshot.data!.increaseDeaths,
                          totalCase: snapshot.data!.deaths,
                        ),
                        InfoMemberHomePage(
                          color: CustomColors.success,
                          title: "Bình phục",
                          newCase: snapshot.data!.increaseRecovered,
                          totalCase: snapshot.data!.recovered,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        "Cập nhật: " +
                            DateFormat('HH:mm, dd/MM/yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data!.lastUpdate * 1000)),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ]);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
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
            label: 'Quét mã',
            icon: Icon(Icons.qr_code_scanner),
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
