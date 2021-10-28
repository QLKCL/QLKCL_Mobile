import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Danh sách người cách ly"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
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
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Member(
                  name: "Le Trung Son",
                  gender: "male",
                  birthday: "20/05/2000",
                  room: "Phòng 3 - Tầng 2 - Tòa 1 - Khu A",
                  lastTestResult: "Âm tính",
                  lastTestTime: "22/09/2021",
                  onTap: () {},
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
    );
  }
}
