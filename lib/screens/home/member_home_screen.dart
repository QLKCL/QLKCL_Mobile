import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/covid_data.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/home/component/app_bar.dart';
import 'package:qlkcl/screens/home/component/card.dart';
import 'package:qlkcl/screens/home/component/covid_info.dart';
import 'package:qlkcl/screens/home/component/requarantined.dart';
import 'package:qlkcl/screens/notification/create_request_screen.dart';
import 'package:qlkcl/utils/api.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberHomePage extends StatefulWidget {
  static const String routeName = "/member_home";
  const MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late Future<CovidData> futureCovid;
  late Future<dynamic> futureData;
  List<KeyValue> quarantineWardList = [];

  @override
  void initState() {
    super.initState();
    futureCovid = fetchCovidList();
    futureData = fetch();
    fetchQuarantineWardNoToken({
      'is_full': "false",
    }).then((value) {
      if (mounted) {
        setState(() {
          quarantineWardList = value;
        });
      }
    });
  }

  Future<dynamic> fetch() async {
    final ApiHelper api = ApiHelper();
    final response = await api.postHTTP(Api.homeMember, null);
    return response != null && response['data'] != null
        ? response['data']
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Thông tin dịch bệnh (Việt Nam)",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      FutureBuilder<CovidData>(
                        future: futureCovid,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return InfoCovidHomePage(
                                increaseConfirmed:
                                    snapshot.data!.increaseConfirmed,
                                confirmed: snapshot.data!.confirmed,
                                increaseDeaths: snapshot.data!.increaseDeaths,
                                deaths: snapshot.data!.deaths,
                                increaseRecovered:
                                    snapshot.data!.increaseRecovered,
                                recovered: snapshot.data!.recovered,
                                increaseActived: snapshot.data!.increaseActived,
                                actived: snapshot.data!.actived,
                                lastUpdate: snapshot.data!.lastUpdate);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          // return const CircularProgressIndicator();
                          return const InfoCovidHomePage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<dynamic>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var msg = "";
                    if (snapshot.data['custom_user']['status'] == "WAITING") {
                      msg =
                          "Tài khoản của bạn chưa được xét duyệt. Vui lòng liên hệ với quản lý khu cách ly!";
                    } else if (snapshot.data['custom_user']['status'] ==
                        "REFUSED") {
                      msg =
                          "Tài khoản của bạn đã bị từ chối. Vui lòng liên hệ với quản lý khu cách ly!";
                    } else if (snapshot.data['custom_user']['status'] ==
                        "LOCKED") {
                      msg =
                          "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ với quản lý khu cách ly!";
                    } else if (snapshot.data['custom_user']['status'] ==
                        "LEAVE") {
                      msg =
                          "Tài khoản của bạn không còn hoạt động trong hệ thống. Vui lòng liên hệ với quản lý hoặc đăng ký tái cách ly!";
                    }
                    return Column(
                      children: [
                        if (msg != "")
                          Card(
                            child: ListTile(
                              isThreeLine: true,
                              contentPadding: const EdgeInsets.all(8),
                              title: Text(
                                msg,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: primaryText),
                              ),
                              minVerticalPadding: 10,
                              subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Khu cách ly: ${(snapshot.data['quarantine_ward'] != null && snapshot.data['quarantine_ward']['full_name'] != "") ? snapshot.data['quarantine_ward']['full_name'] : "Không rõ"}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: primaryText),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Số điện thoại: ${(snapshot.data['quarantine_ward'] != null && snapshot.data['quarantine_ward']['phone_number'] != "") ? snapshot.data['quarantine_ward']['phone_number'] : "Chưa có"}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: primaryText),
                                      ),
                                    ],
                                  )),
                              leading: CircleAvatar(
                                backgroundColor: error,
                                child: Icon(
                                  Icons.notification_important_outlined,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        HealthStatus(
                            healthStatus: snapshot.data['health_status'],
                            positiveTestNow: snapshot.data['positive_test_now'],
                            lastTestedHadResult:
                                snapshot.data['last_tested_had_result'],
                            numberOfVaccineDoses:
                                snapshot.data['number_of_vaccine_doses']),
                        if (snapshot.data['quarantine_ward'] != null &&
                            msg == "")
                          QuarantineHome(
                            name: snapshot.data['quarantine_ward'] != null
                                ? snapshot.data['quarantine_ward']['full_name']
                                : "",
                            manager: snapshot.data['quarantine_ward'] != null
                                ? snapshot.data['quarantine_ward']
                                    ['main_manager']['full_name']
                                : "",
                            address:
                                getAddress(snapshot.data['quarantine_ward']),
                            room: getRoom(snapshot.data),
                            phone: snapshot.data['quarantine_ward'] != null &&
                                    snapshot.data['quarantine_ward']
                                            ['phone_number'] !=
                                        null
                                ? snapshot.data['quarantine_ward']
                                    ['phone_number']
                                : "Chưa có",
                            quarantineAt: snapshot.data['quarantined_at'] ?? "",
                            quarantineFinishExpect: snapshot
                                    .data['quarantined_finish_expected_at'] ??
                                "",
                          ),
                        if (snapshot.data['custom_user']['status'] == "LEAVE")
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              onPressed: () {
                                memberRequarantined(
                                  context,
                                  quarantineWardList: quarantineWardList,
                                  useCustomBottomSheetMode:
                                      ResponsiveWrapper.of(context)
                                          .isLargerThan(MOBILE),
                                ).then((value) {
                                  if (value != null &&
                                      value.status == Status.success) {
                                    setState(() {
                                      futureData = fetch();
                                    });
                                  }
                                });
                              },
                              child: Text(
                                'Đăng ký tái cách ly',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        if (snapshot.data['quarantine_ward'] != null &&
                            snapshot.data['quarantine_ward']['phone_number'] !=
                                "")
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                primary: success,
                              ),
                              onPressed:
                                  (snapshot.data['quarantine_ward'] != null &&
                                          snapshot.data['quarantine_ward']
                                                  ['phone_number'] !=
                                              "")
                                      ? () async {
                                          launch(
                                              "tel://${snapshot.data['quarantine_ward']['phone_number']}");
                                        }
                                      : () {
                                          showNotification(
                                              'Số điện thoại không tồn tại.',
                                              status: Status.error);
                                        },
                              child: Text(
                                'Gọi cấp cứu',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              primary: warning,
                            ),
                            onPressed: () => Navigator.of(context,
                                    rootNavigator:
                                        !Responsive.isDesktopLayout(context))
                                .pushNamed(CreateRequest.routeName),
                            child: Text(
                              'Phản ánh/yêu cầu',
                              style: TextStyle(
                                color: white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  // return const CircularProgressIndicator();
                  return const SizedBox();
                },
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    primary: secondary,
                  ),
                  onPressed: () {
                    Navigator.of(context,
                            rootNavigator: !Responsive.isDesktopLayout(context))
                        .pushNamed(MedicalDeclarationScreen.routeName);
                  },
                  child: Text(
                    'Khai báo y tế',
                    style: TextStyle(
                      color: white,
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
