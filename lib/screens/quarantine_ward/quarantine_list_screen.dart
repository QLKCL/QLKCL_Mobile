import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_ward/search_quarantine_screen.dart';
import './add_quarantine_screen.dart';
import './component/quarantine_list.dart';

class QuarantineListScreen extends StatefulWidget {
  static const String routeName = "/quarantine-list";

  @override
  State<QuarantineListScreen> createState() => _QuarantineListScreenState();
}

class _QuarantineListScreenState extends State<QuarantineListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  //bool searched = false;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Các khu cách ly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => SearchQuarantine()));
          },
          icon: Icon(Icons.search),
          tooltip: "Tìm kiếm",
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: QuanrantineList(),
      floatingActionButton: FloatingActionButton(
        heroTag: "quarantine_fab",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            NewQuarantine.routeName,
          );
        },
        tooltip: "Thêm khu cách ly mới",
      ),
    );
  }
}
