import 'package:flutter/material.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/screens/home/component/covid_info.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:intl/intl.dart';

class MemberHomePage extends StatefulWidget {
  static const String routeName = "/member_home";
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
      appBar: AppBar(
        title: Text("Trang chủ"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.help_outline),
        ),
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
