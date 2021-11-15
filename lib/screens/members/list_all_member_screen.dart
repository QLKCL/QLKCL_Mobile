import 'package:flutter/material.dart';
import 'package:qlkcl/screens/members/search_member.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/component/all_member.dart';
import 'package:qlkcl/screens/members/component/complete_member.dart';
import 'package:qlkcl/screens/members/component/confirm_member.dart';
import 'package:qlkcl/screens/members/component/deny_member.dart';
import 'package:qlkcl/screens/members/component/suspect_member.dart';
import 'package:qlkcl/screens/members/component/test_member.dart';
import 'package:qlkcl/config/app_theme.dart';

// cre: https://stackoverflow.com/questions/50462281/flutter-i-want-to-select-the-card-by-onlongpress

class ListAllMember extends StatefulWidget {
  static const String routeName = "/list_all_member";
  final int tab;
  ListAllMember({Key? key, this.tab = 0}) : super(key: key);

  @override
  _ListAllMemberState createState() => _ListAllMemberState();
}

class _ListAllMemberState extends State<ListAllMember>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: widget.tab);
    _tabController.addListener(_handleTabChange);
  }

  _handleTabChange() {
    setState(() {});
  }

  bool longPressFlag = false;
  List<String> indexList = [];

  void longPress() {
    setState(() {
      if (indexList.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              heroTag: "member_fab",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  AddMember.routeName,
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: longPressFlag
                  ? Text('${indexList.length} đã chọn')
                  : Text("Danh sách người cách ly"),
              centerTitle: true,
              actions: [
                longPressFlag
                    ? IconButton(
                        onPressed: () {},
                        icon: GestureDetector(
                          child: Icon(
                            Icons.more_vert,
                          ),
                          onTap: () {},
                        ))
                    : (IconButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => SearchBox()));
                        },
                        icon: Icon(Icons.search),
                      )),
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: CustomColors.white,
                tabs: [
                  Tab(text: "Toàn bộ"),
                  Tab(text: "Chờ xét duyệt"),
                  Tab(text: "Nghi nhiễm"),
                  Tab(text: "Tới hạn xét nghiệm"),
                  Tab(text: "Sắp hoàn thành cách ly"),
                  Tab(text: "Từ chối"),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            AllMember(),
            ConfirmMember(
              longPressFlag: longPressFlag,
              indexList: indexList,
              longPress: longPress,
            ),
            SuspectMember(),
            TestMember(),
            CompleteMember(),
            DenyMember(),
          ],
        ),
      ),
    );
  }
}
