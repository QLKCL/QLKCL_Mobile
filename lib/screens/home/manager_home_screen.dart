import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/home/component/manager_info.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';

// cre: https://pub.dev/packages/flutter_speed_dial/example

class ManagerHomePage extends StatefulWidget {
  static const String routeName = "/manager_home";
  ManagerHomePage({Key? key}) : super(key: key);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  late Future<dynamic> futureData;

  var renderOverlay = true;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    futureData = fetch();
  }

  Future<dynamic> fetch() async {
    ApiHelper api = ApiHelper();
    final response = await api.postHTTP(Constant.homeManager, null);
    return response != null && response['data'] != null
        ? response['data']
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Trang chủ"),
            centerTitle: true,
            actions: [
              Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.scale,
                badgeContent: Text(
                  "",
                  style: TextStyle(color: CustomColors.white),
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications_none_outlined),
                  onPressed: () {},
                  tooltip: "Thông báo",
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => Future.sync(() {
              setState(() {
                futureData = fetch();
              });
            }),
            child: FutureBuilder<dynamic>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InfoManagerHomePage(
                    waitingUsers: snapshot.data['number_of_waiting_users'],
                    suspectedUsers: snapshot.data['number_of_suspected_users'],
                    needTestUsers: snapshot.data['number_of_need_test_users'],
                    canFinishUsers: snapshot.data['number_of_can_finish_users'],
                    waitingTests: snapshot.data['number_of_waiting_tests'],
                    numberIn: snapshot.data['in'].entries
                        .map((entry) => KeyValue(
                            id: DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(entry.key)),
                            name: entry.value))
                        .toList()
                        .cast<KeyValue>()
                        .reversed
                        .toList(),
                    numberOut: snapshot.data['out'].entries
                        .map((entry) => KeyValue(
                            id: DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(entry.key)),
                            name: entry.value))
                        .toList()
                        .cast<KeyValue>()
                        .reversed
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                // return const CircularProgressIndicator();
                return InfoManagerHomePage();
              },
            ),
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 3,
            openCloseDial: isDialOpen,
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,

            /// If false, backgroundOverlay will not be rendered.
            renderOverlay: renderOverlay,
            overlayColor: Colors.black,
            overlayOpacity: 0.3,
            useRotationAnimation: useRAnimation,
            tooltip: 'Tạo mới',

            animationSpeed: 200,
            shape: const StadiumBorder(),
            childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.description_outlined),
                label: 'Phiếu xét nghiệm',
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(AddTest.routeName),
              ),
              SpeedDialChild(
                child: const Icon(Icons.person_add_alt),
                label: 'Người cách ly',
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(AddMember.routeName),
              ),
              SpeedDialChild(
                child: const Icon(Icons.manage_accounts_outlined),
                label: 'Quản lý',
                onTap: () => {},
              ),
              SpeedDialChild(
                child: const Icon(Icons.business_outlined),
                label: 'Khu cách ly',
                visible: true,
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(NewQuarantine.routeName),
              ),
            ],
          ),
        ));
  }
}
