import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/networking/api_helper.dart';
// import 'package:qlkcl/screens/home/component/covid_info.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class MemberHomePage extends StatefulWidget {
  static const String routeName = "/member_home";
  MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late Future<CovidData> futureCovid;
  late Future<dynamic> futureData;
  bool _showFab = true;

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
      floatingActionButton: AnimatedSlide(
        duration: Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : Offset(0, 2),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.phone),
            tooltip: "Liên hệ khẩn cấp!",
            backgroundColor: Colors.red,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.0), // here the desired height
        child: AppBar(
          toolbarHeight: 64, // Set this height
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          cloudinary.getImage('Default/no_avatar').toString()),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: CustomColors.secondary,
                      width: 2.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào,",
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      FutureBuilder(
                        future: getName(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryText),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          titleTextStyle:
              TextStyle(fontSize: 16.0, color: CustomColors.primaryText),
          backgroundColor: CustomColors.background,
          centerTitle: false,
          actions: [
            Badge(
              position: BadgePosition.topEnd(top: 10, end: 4),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.scale,
              badgeContent: Text(
                "2",
                style: TextStyle(fontSize: 11.0, color: CustomColors.white),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: CustomColors.primaryText,
                ),
                onPressed: () {},
                tooltip: "Thông báo",
              ),
            ),
          ],
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              _showFab = false;
            } else if (direction == ScrollDirection.forward) {
              _showFab = true;
            }
          });
          return true;
        },
        child: RefreshIndicator(
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
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.primaryText),
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
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                //   child: Text(
                //     "Thông tin dịch bệnh (Việt Nam)",
                //     textAlign: TextAlign.left,
                //     style: Theme.of(context).textTheme.headline5,
                //   ),
                // ),
                // FutureBuilder<CovidData>(
                //   future: futureCovid,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return InfoCovidHomePage(
                //           increaseConfirmed: snapshot.data!.increaseConfirmed,
                //           confirmed: snapshot.data!.confirmed,
                //           increaseDeaths: snapshot.data!.increaseDeaths,
                //           deaths: snapshot.data!.deaths,
                //           increaseRecovered: snapshot.data!.increaseRecovered,
                //           recovered: snapshot.data!.recovered,
                //           lastUpdate: DateFormat('HH:mm, dd/MM/yyyy').format(
                //               DateTime.fromMillisecondsSinceEpoch(
                //                   snapshot.data!.lastUpdate * 1000)));
                //     } else if (snapshot.hasError) {
                //       return Text('${snapshot.error}');
                //     }

                //     // By default, show a loading spinner.
                //     // return const CircularProgressIndicator();
                //     return InfoCovidHomePage();
                //   },
                // ),
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
                            child: Container(
                              child: InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      CustomColors.primaryText,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                    child: Icon(
                                                      Icons.history,
                                                      size: 16,
                                                      color: CustomColors
                                                          .disableText,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " Sức khỏe: " +
                                                        (snapshot.data[
                                                                    'health_status'] ==
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
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      CustomColors.primaryText,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                    child: Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 16,
                                                      color: CustomColors
                                                          .disableText,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " Xét nghiệm: " +
                                                        (snapshot.data[
                                                                    'positive_test_now'] !=
                                                                null
                                                            ? ((snapshot.data[
                                                                            'positive_test_now'] ==
                                                                        false
                                                                    ? "Âm tính"
                                                                    : "Dương tính") +
                                                                " (" +
                                                                (snapshot.data[
                                                                            'positive_test_now'] !=
                                                                        null
                                                                    ? DateFormat(
                                                                            "dd/MM/yyyy HH:mm:ss")
                                                                        .format(
                                                                            DateTime.parse(snapshot.data['last_tested_had_result']).toLocal())
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
                                    ],
                                  ),
                                ),
                              ),
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
                                  ? snapshot.data['quarantine_ward']
                                      ['full_name']
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
                                      (snapshot.data['quarantine_ward']
                                                  ['ward'] !=
                                              null
                                          ? "${snapshot.data['quarantine_ward']['ward']['name']}, "
                                          : "") +
                                      (snapshot.data['quarantine_ward']
                                                  ['district'] !=
                                              null
                                          ? "${snapshot.data['quarantine_ward']['district']['name']}, "
                                          : "") +
                                      (snapshot.data['quarantine_ward']
                                                  ['city'] !=
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
                              quarantineTime:
                                  snapshot.data['quarantine_ward'] != null
                                      ? snapshot.data['quarantine_ward']
                                          ['quarantine_time']
                                      : 14,
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
                              builder: (context) =>
                                  MedicalDeclarationScreen()));
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
      ),
    );
  }
}
