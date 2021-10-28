import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/theme/app_theme.dart';

class ListAllMember extends StatefulWidget {
  static const String routeName = "/list_all_member";
  ListAllMember({Key? key}) : super(key: key);

  @override
  _ListAllMemberState createState() => _ListAllMemberState();
}

class _ListAllMemberState extends State<ListAllMember> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
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
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TestNoResult(
                    name: "Le Trung Son",
                    gender: "male",
                    birthday: "20/05/2000",
                    id: "PCR-123456789",
                    time: "22/09/2021",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
