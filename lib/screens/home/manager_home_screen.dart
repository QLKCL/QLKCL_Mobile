import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/screens/home/component/manager_info.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';

class ManagerHomePage extends StatefulWidget {
  static const String routeName = "/manager_home";
  ManagerHomePage({Key? key}) : super(key: key);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  late Future<dynamic> futureData;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.help_outline),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBarModalBottomSheet(
                barrierColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Wrap(
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            'Tạo mới',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description_outlined),
                        title: Text('Phiếu xét nghiệm'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AddTest.routeName);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.person_add_alt),
                        title: Text('Người cách ly'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AddMember.routeName);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.manage_accounts_outlined),
                        title: Text('Quản lý'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.business_outlined),
                        title: Text('Khu cách ly'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, NewQuarantine.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
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
                  .map((entry) => KeyValue(id: entry.key, name: entry.value))
                  .toList()
                  .cast<KeyValue>()
                  .reversed
                  .toList(),
              numberOut: snapshot.data['out'].entries
                  .map((entry) => KeyValue(id: entry.key, name: entry.value))
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
    );
  }
}
