import 'package:flutter/material.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/screens/home/component/covid_info.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';

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
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Giới thiệu'),
              content: Container(
                height: 100,
                child: Wrap(
                  direction: Axis.vertical, // make sure to set this
                  spacing: 4, // set your spacing
                  children: <Widget>[
                    const Text('Ứng dụng quản lý khu cách ly'),
                    const Text('Nhóm sinh viên thực hiện: Nhóm TT'),
                    const Text('Version: 1.0'),
                    const Text('Email: son.le.lhld@gmail.com'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          icon: Icon(Icons.help_outline),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getQuarantineStatus(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "WAITING") {
                    return Card(
                      child: ListTile(
                        title: Text(
                          "Tài khoản của bạn chưa được xét duyệt. Vui lòng liên hệ người quản lý!",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: CircleAvatar(
                            backgroundColor: CustomColors.error,
                            child: Icon(
                              Icons.notification_important_outlined,
                              color: CustomColors.white,
                            )),
                      ),
                    );
                  } else if (snapshot.data == "REFUSED") {
                    return Card(
                      child: ListTile(
                        title: Text(
                          "Tài khoản của bạn đã bị từ chối. Vui lòng liên hệ người quản lý!",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: CircleAvatar(
                            backgroundColor: CustomColors.error,
                            child: Icon(
                              Icons.notification_important_outlined,
                              color: CustomColors.white,
                            )),
                      ),
                    );
                  } else if (snapshot.data == "LOCKED") {
                    return Card(
                      child: ListTile(
                        title: Text(
                          "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ người quản lý!",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: CircleAvatar(
                            backgroundColor: CustomColors.error,
                            child: Icon(
                              Icons.notification_important_outlined,
                              color: CustomColors.white,
                            )),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
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
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => MedicalDeclarationScreen()));
                },
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
