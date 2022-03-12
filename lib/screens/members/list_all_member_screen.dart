import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/component/completed_member.dart';
import 'package:qlkcl/screens/members/search_member.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/component/all_member.dart';
import 'package:qlkcl/screens/members/component/complete_expect_member.dart';
import 'package:qlkcl/screens/members/component/confirm_member.dart';
import 'package:qlkcl/screens/members/component/denied_member.dart';
import 'package:qlkcl/screens/members/component/suspect_member.dart';
import 'package:qlkcl/screens/members/component/need_test_member.dart';
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
        TabController(length: 7, vsync: this, initialIndex: widget.tab);
    _tabController.addListener(_handleTabChange);
  }

  _handleTabChange() {
    setState(() {
      indexList.clear();
      longPress();
    });
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

  bool onDone = false;
  void onDoneCallback() {
    onDone = false;
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
              tooltip: "Thêm người cách ly",
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: longPressFlag
                    ? Text('${indexList.length} đã chọn')
                    : Text("Danh sách người cách ly"),
                centerTitle: true,
                actions: [
                  longPressFlag
                      ? PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: CustomColors.disableText,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Text('Chấp nhận'),
                              onTap: () async {
                                CancelFunc cancel = showLoading();
                                final response = await acceptManyMember(
                                    {'member_codes': indexList.join(",")});
                                cancel();
                                if (response.success) {
                                  setState(() {
                                    onDone = true;
                                  });
                                  indexList.clear();
                                  longPress();
                                }
                              },
                            ),
                            PopupMenuItem(
                              child: Text('Từ chối'),
                              onTap: () async {
                                CancelFunc cancel = showLoading();
                                final response = await denyMember(
                                    {'member_codes': indexList.join(",")});
                                cancel();
                                showNotification(response);
                                if (response.success) {
                                  setState(() {
                                    onDone = true;
                                  });
                                  indexList.clear();
                                  longPress();
                                }
                              },
                            ),
                          ],
                        )
                      : (IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => SearchMember()));
                          },
                          icon: Icon(Icons.search),
                          tooltip: "Tìm kiếm",
                        )),
                ],
                pinned: true,
                floating: !Responsive.isDesktopLayout(context),
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
                    Tab(text: "Đã hoàn thành cách ly"),
                  ],
                ),
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
              onDone: onDone,
              onDoneCallback: onDoneCallback,
            ),
            SuspectMember(),
            NeedTestMember(),
            ExpectCompleteMember(),
            DeniedMember(),
            CompletedMember(),
          ].map((e) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          child: e,
                          width: constraints.maxWidth,
                          height: Responsive.isDesktopLayout(context)
                              ? constraints.maxHeight - 275
                              : constraints.maxHeight,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
