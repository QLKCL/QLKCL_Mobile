import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/home/component/manager_info.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/notification/list_notification_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';

// cre: https://pub.dev/packages/flutter_speed_dial/example
// cre: https://pub.dev/packages/badges
// cre: https://stackoverflow.com/questions/45631350/flutter-hiding-floatingactionbutton

class ManagerHomePage extends StatefulWidget {
  static const String routeName = "/manager_home";
  ManagerHomePage({Key? key}) : super(key: key);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  bool _showFab = true;

  var renderOverlay = true;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> fetch() async {
    await Future.delayed(const Duration(seconds: 1));
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
                        image: NetworkImage(cloudinary
                            .getImage('Default/no_avatar')
                            .toString()),
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
                position: BadgePosition.topEnd(top: 10, end: 16),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.scale,
                badgeContent: Text(
                  "2",
                  style: TextStyle(fontSize: 11.0, color: CustomColors.white),
                ),
                child: IconButton(
                  padding: EdgeInsets.only(right: 24),
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: CustomColors.primaryText,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(ListNotification.routeName);
                  },
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
            onRefresh: fetch,
            child: FutureBuilder<dynamic>(
              future: fetch(),
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
        ),
        floatingActionButton: AnimatedSlide(
          duration: Duration(milliseconds: 300),
          offset: _showFab ? Offset.zero : Offset(0, 2),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _showFab ? 1 : 0,
            child: SpeedDial(
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
          ),
        ),
      ),
    );
  }
}
