import 'package:flutter/material.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/screens/manager/add_manager_screen.dart';
import 'package:qlkcl/screens/manager/component/staff_list.dart';
import 'package:qlkcl/screens/members/search_member.dart';
import 'package:qlkcl/utils/app_theme.dart';

// cre: https://stackoverflow.com/questions/50462281/flutter-i-want-to-select-the-card-by-onlongpress

class ListAllManager extends StatefulWidget {
  static const String routeName = "/list_all_manager";
  final int tab;
  final int currentQuarrantine;
  ListAllManager({
    Key? key,
    this.tab = 0,
    required this.currentQuarrantine,
  }) : super(key: key);

  @override
  _ListAllManagerState createState() => _ListAllManagerState();
}

class _ListAllManagerState extends State<ListAllManager>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "manager_fab",
        onPressed: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .pushNamed(
            AddManager.routeName,
          );
        },
        child: Icon(Icons.add),
        tooltip: "Thêm quản lý, cán bộ",
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text("Danh sách quản lý, cán bộ"),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context,
                              rootNavigator:
                                  !Responsive.isDesktopLayout(context))
                          .push(MaterialPageRoute(
                              builder: (context) => SearchMember()));
                    },
                    icon: Icon(Icons.search),
                    tooltip: "Tìm kiếm",
                  ),
                ],
                pinned: true,
                floating: !Responsive.isDesktopLayout(context),
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: CustomColors.white,
                  tabs: [
                    Tab(text: "Quản lý"),
                    Tab(text: "Cán bộ"),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(),
            StaffList(
              quarrantine: widget.currentQuarrantine,
            ),
          ].map((e) {
            return LayoutBuilder(
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
                            ? constraints.maxHeight - 140
                            : constraints.maxHeight - 20,
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
