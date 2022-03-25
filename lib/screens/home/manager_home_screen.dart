import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qlkcl/utils/api.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/notification.dart' as notifications;
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/home/component/manager_info.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/notification/list_notification_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'package:responsive_framework/responsive_framework.dart';

// cre: https://pub.dev/packages/flutter_speed_dial/example
// cre: https://pub.dev/packages/badges
// cre: https://stackoverflow.com/questions/45631350/flutter-hiding-floatingactionbutton

class ManagerHomePage extends StatefulWidget {
  static const String routeName = "/manager_home";
  final int role;
  ManagerHomePage({
    Key? key,
    this.role = 4, // Staff
  }) : super(key: key);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  late int unreadNotifications = 0;
  late dynamic listNotification = [];
  bool _showFab = true;

  late Future<dynamic> futureData;

  var renderOverlay = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);

  final quarantineWardController = TextEditingController();
  List<KeyValue> quarantineWardList = [];

  @override
  void initState() {
    super.initState();
    futureData = fetch();
    notifications.fetchUserNotificationList(data: {
      'page_size': PAGE_SIZE_MAX
    }).then((value) => setState(() {
          listNotification = value;
          unreadNotifications = listNotification
              .where((element) =>
                  notifications.Notification.fromJson(element).isRead == false)
              .toList()
              .length;
        }));
    fetchQuarantineWard({
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          quarantineWardList = value;
        }));
  }

  Future<dynamic> fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    ApiHelper api = ApiHelper();
    final response = await api.postHTTP(
        Api.homeManager,
        prepareDataForm({
          "number_of_days_in_out": 12,
          "quarantine_ward_id": quarantineWardController.text
        }));
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
                showBadge: unreadNotifications != 0,
                position: BadgePosition.topEnd(top: 10, end: 16),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(8),
                padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                badgeContent: Text(
                  unreadNotifications.toString(),
                  style: TextStyle(fontSize: 11.0, color: CustomColors.white),
                ),
                child: IconButton(
                  padding: EdgeInsets.only(right: 24),
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: CustomColors.primaryText,
                  ),
                  onPressed: () {
                    Navigator.of(context,
                            rootNavigator: !Responsive.isDesktopLayout(context))
                        .pushNamed(ListNotification.routeName)
                        .then((value) => {
                              notifications.fetchUserNotificationList(data: {
                                'page_size': PAGE_SIZE_MAX
                              }).then((value) => setState(() {
                                    listNotification = value;
                                    unreadNotifications = listNotification
                                        .where((element) =>
                                            notifications.Notification.fromJson(
                                                    element)
                                                .isRead ==
                                            false)
                                        .toList()
                                        .length;
                                  }))
                            });
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
            onRefresh: () => Future.sync(() {
              setState(() {
                futureData = fetch();
              });
            }),
            child: FutureBuilder<dynamic>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int numberDays =
                      ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
                          ? 4
                          : ResponsiveWrapper.of(context).isLargerThan(TABLET)
                              ? 12
                              : 6;
                  return InfoManagerHomePage(
                    totalUsers:
                        snapshot.data['number_of_all_members_past_and_now'],
                    availableSlots: snapshot.data['number_of_available_slots'],
                    activeUsers:
                        snapshot.data['number_of_quarantining_members'],
                    waitingUsers: snapshot.data['number_of_waiting_members'],
                    suspectedUsers:
                        snapshot.data['number_of_suspected_members'],
                    needTestUsers: snapshot.data['number_of_need_test_members'],
                    canFinishUsers:
                        snapshot.data['number_of_can_finish_members'],
                    waitingTests: snapshot.data['number_of_waiting_tests'],
                    positiveUsers: snapshot.data['number_of_positive_members'],
                    hospitalizedUsers:
                        snapshot.data['number_of_hospitalized_members'],
                    numberIn: snapshot.data['in'].entries
                        .map((entry) => KeyValue(
                            id: DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(entry.key)),
                            name: entry.value))
                        .toList()
                        .cast<KeyValue>()
                        .reversed
                        .take(numberDays)
                        .toList()
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
                        .take(numberDays)
                        .toList()
                        .reversed
                        .toList(),
                    hospitalize: snapshot.data['hospitalize'].entries
                        .map((entry) => KeyValue(
                            id: DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(entry.key)),
                            name: entry.value))
                        .toList()
                        .cast<KeyValue>()
                        .reversed
                        .take(numberDays)
                        .toList()
                        .reversed
                        .toList(),
                    quarantineWardList: quarantineWardList,
                    quarantineWardController: quarantineWardController,
                    refresh: () {
                      setState(() {});
                    },
                    role: widget.role,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                // return const CircularProgressIndicator();
                return InfoManagerHomePage(
                  quarantineWardList: quarantineWardList,
                  quarantineWardController: quarantineWardController,
                  refresh: () {
                    setState(() {});
                  },
                  role: widget.role,
                );
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
                  child: const Icon(Icons.edit_outlined),
                  label: 'Khai báo y tế',
                  onTap: () => Navigator.of(context,
                          rootNavigator: !Responsive.isDesktopLayout(context))
                      .pushNamed(MedicalDeclarationScreen.routeName),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.description_outlined),
                  label: 'Phiếu xét nghiệm',
                  onTap: () => Navigator.of(context,
                          rootNavigator: !Responsive.isDesktopLayout(context))
                      .pushNamed(AddTest.routeName),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.person_add_alt),
                  label: 'Người cách ly',
                  onTap: () => Navigator.of(context,
                          rootNavigator: !Responsive.isDesktopLayout(context))
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
                  onTap: () => Navigator.of(context,
                          rootNavigator: !Responsive.isDesktopLayout(context))
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
