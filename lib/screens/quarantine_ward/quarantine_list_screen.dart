import 'package:flutter/material.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/screens/quarantine_ward/component/quarantine_list_maps.dart';
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

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Các khu cách ly'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => QuanrantineListMaps()));
        },
        icon: const Icon(Icons.map_outlined),
        tooltip: "Bản đồ",
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context,
                    rootNavigator: !Responsive.isDesktopLayout(context))
                .push(MaterialPageRoute(
                    builder: (context) => SearchQuarantine()));
          },
          icon: const Icon(Icons.search),
          tooltip: "Tìm kiếm",
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: QuanrantineList(),
      floatingActionButton: FloatingActionButton(
        heroTag: "quarantine_fab",
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .pushNamed(
            NewQuarantine.routeName,
          );
        },
        tooltip: "Thêm khu cách ly mới",
      ),
    );
  }
}
