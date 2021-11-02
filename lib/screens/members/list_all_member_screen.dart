import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/theme/app_theme.dart';

// cre: https://stackoverflow.com/questions/50462281/flutter-i-want-to-select-the-card-by-onlongpress

class ListAllMember extends StatefulWidget {
  static const String routeName = "/list_all_member";
  ListAllMember({Key? key}) : super(key: key);

  @override
  _ListAllMemberState createState() => _ListAllMemberState();
}

class _ListAllMemberState extends State<ListAllMember>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 0);
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
      resizeToAvoidBottomInset: false,
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
          labelStyle: TextStyle(fontSize: 16.0),
          unselectedLabelStyle: TextStyle(fontSize: 16.0),
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
                // Respond to button press
              },
              child: Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(1)) {
                      indexList.remove(1);
                    } else {
                      indexList.add(1);
                    }
                    longPress();
                  },
                ),
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(2)) {
                      indexList.remove(2);
                    } else {
                      indexList.add(2);
                    }
                    longPress();
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(1)) {
                      indexList.remove(1);
                    } else {
                      indexList.add(1);
                    }
                    longPress();
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(1)) {
                      indexList.remove(1);
                    } else {
                      indexList.add(1);
                    }
                    longPress();
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(1)) {
                      indexList.remove(1);
                    } else {
                      indexList.add(1);
                    }
                    longPress();
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  id: "1",
                  longPressEnabled: longPressFlag,
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                  onLongPress: () {
                    if (indexList.contains(1)) {
                      indexList.remove(1);
                    } else {
                      indexList.add(1);
                    }
                    longPress();
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "Không có dữ liệu",
              style: TextStyle(color: CustomColors.secondaryText, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}
