import 'package:flutter/material.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/component/all_member.dart';
import 'package:qlkcl/screens/members/component/complete_member.dart';
import 'package:qlkcl/screens/members/component/confirm_member.dart';
import 'package:qlkcl/screens/members/component/deny_member.dart';
import 'package:qlkcl/screens/members/component/suspect_member.dart';
import 'package:qlkcl/screens/members/component/test_member.dart';
import 'package:qlkcl/theme/app_theme.dart';

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
  bool searched = false;
  List<int> indexList = [];

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
    return DismissKeyboard(
        child: Scaffold(
      appBar: AppBar(
        title: longPressFlag
            ? Text('${indexList.length} đã chọn')
            : (searched
                ? Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                /* Clear the search field */
                              },
                            ),
                            hintText: 'Search...',
                            border: InputBorder.none),
                      ),
                    ),
                  )
                : Text("Danh sách người cách ly")),
        centerTitle: true,
        // leading: searched
        //     ? IconButton(
        //         onPressed: () {},
        //         icon: Icon(Icons.arrow_back),
        //       )
        //     : null,
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
              : (searched
                  ? IconButton(
                      onPressed: () {
                        memberFilter(context);
                      },
                      icon: Icon(Icons.filter_list_outlined),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          searched = true;
                        });
                      },
                      icon: Icon(Icons.search),
                    )),
        ],
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
    ));
  }
}
