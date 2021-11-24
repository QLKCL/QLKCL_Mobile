import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/infomation.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/home/component/covid_info.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:websafe_svg/websafe_svg.dart';

class MemberHomePage extends StatefulWidget {
  static const String routeName = "/member_home";
  MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late Future<CovidData> futureCovid;
  late Future<dynamic> futureData;

  @override
  void initState() {
    super.initState();
    futureCovid = fetchCovidList();
    futureData = fetch();
  }

  Future<dynamic> fetch() async {
    ApiHelper api = ApiHelper();
    final response = await api.postHTTP(Constant.homeMember, null);
    return response != null && response['data'] != null
        ? response['data']
        : null;
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                futureCovid = fetchCovidList();
                futureData = fetch();
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() {
          setState(() {
            futureCovid = fetchCovidList();
            futureData = fetch();
          });
        }),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: getQuarantineStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var msg = "";
                    if (snapshot.data == "WAITING") {
                      msg =
                          "Tài khoản của bạn chưa được xét duyệt. Vui lòng liên hệ người quản lý!";
                    } else if (snapshot.data == "REFUSED") {
                      msg =
                          "Tài khoản của bạn bị từ chối. Vui lòng liên hệ người quản lý!";
                    } else if (snapshot.data == "LOCKED") {
                      msg =
                          "Tài khoản của bạn bị khóa. Vui lòng liên hệ người quản lý!";
                    }
                    if (msg != "") {
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            msg,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.error,
                            child: Icon(
                              Icons.notification_important_outlined,
                              color: CustomColors.white,
                            ),
                          ),
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
              FutureBuilder<dynamic>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            "Thông tin sức khỏe của bạn",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Card(
                          child: ListTile(
                            // contentPadding: EdgeInsets.all(16),
                            title: Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 2),
                              child: snapshot.data['custom_user']
                                          ['full_name'] !=
                                      ""
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: snapshot.data['custom_user']
                                                    ['full_name'] +
                                                " ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.top,
                                            child: snapshot.data['custom_user']
                                                        ['gender'] ==
                                                    "MALE"
                                                ? WebsafeSvg.asset(
                                                    "assets/svg/male.svg")
                                                : WebsafeSvg.asset(
                                                    "assets/svg/female.svg"),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      "Vui lòng cập nhật thông tin cá nhân!",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                            ),
                            subtitle: Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: Wrap(
                                direction:
                                    Axis.vertical, // make sure to set this
                                spacing: 8, // s
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.primaryText,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.history,
                                            size: 16,
                                            color: CustomColors.disableText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " Sức khỏe: " +
                                              (snapshot.data['health_status'] ==
                                                      "SERIOUS"
                                                  ? "Nguy hiểm"
                                                  : (snapshot.data[
                                                              'health_status'] ==
                                                          "UNWELL"
                                                      ? "Nghi nhiễm"
                                                      : "Bình thường")),
                                        )
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.primaryText,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.description_outlined,
                                            size: 16,
                                            color: CustomColors.disableText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " Xét nghiệm: " +
                                              (snapshot.data['positive_test'] !=
                                                      null
                                                  ? ((snapshot.data[
                                                                  'positive_test'] ==
                                                              false
                                                          ? "Âm tính"
                                                          : "Dương tính") +
                                                      " (" +
                                                      (snapshot.data[
                                                                  'positive_test'] !=
                                                              null
                                                          ? DateFormat(
                                                                  "dd/MM/yyyy HH:mm:ss")
                                                              .format(DateTime.parse(
                                                                      snapshot.data[
                                                                          'last_tested'])
                                                                  .toLocal())
                                                          : "") +
                                                      ")")
                                                  : "Chưa có kết quả xét nghiệm"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                        if (snapshot.data['quarantine_ward'] != null)
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                            child: Text(
                              "Thông tin cách ly",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        if (snapshot.data['quarantine_ward'] != null)
                          QuarantineHome(
                            name: snapshot.data['quarantine_ward'] != null
                                ? snapshot.data['quarantine_ward']['full_name']
                                : "",
                            manager: snapshot.data['quarantine_ward'] != null
                                ? snapshot.data['quarantine_ward']
                                    ['main_manager']['full_name']
                                : "",
                            address: snapshot.data['quarantine_ward'] != null
                                ? (snapshot.data['quarantine_ward']
                                                ['address'] !=
                                            null
                                        ? "${snapshot.data['quarantine_ward']['address']}, "
                                        : "") +
                                    (snapshot.data['quarantine_ward']['ward'] !=
                                            null
                                        ? "${snapshot.data['quarantine_ward']['ward']['name']}, "
                                        : "") +
                                    (snapshot.data['quarantine_ward']
                                                ['district'] !=
                                            null
                                        ? "${snapshot.data['quarantine_ward']['district']['name']}, "
                                        : "") +
                                    (snapshot.data['quarantine_ward']['city'] !=
                                            null
                                        ? "${snapshot.data['quarantine_ward']['city']['name']}"
                                        : "")
                                : "",
                            room: (snapshot.data['quarantine_room'] != null
                                    ? "${snapshot.data['quarantine_room']['name']} - "
                                    : "") +
                                (snapshot.data['quarantine_floor'] != null
                                    ? "${snapshot.data['quarantine_floor']['name']} - "
                                    : "") +
                                (snapshot.data['quarantine_building'] != null
                                    ? "${snapshot.data['quarantine_building']['name']} - "
                                    : "") +
                                (snapshot.data['quarantine_ward'] != null
                                    ? "${snapshot.data['quarantine_ward']['full_name']}"
                                    : ""),
                            phone: snapshot.data['quarantine_ward'] != null &&
                                    snapshot.data['quarantine_ward']
                                            ['phone_number'] !=
                                        null
                                ? snapshot.data['quarantine_ward']
                                    ['phone_number']
                                : "Chưa có",
                            quarantineAt:
                                snapshot.data['quarantined_at'] != null
                                    ? snapshot.data['quarantined_at']
                                    : "",
                          ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  // return const CircularProgressIndicator();
                  return Container();
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
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
