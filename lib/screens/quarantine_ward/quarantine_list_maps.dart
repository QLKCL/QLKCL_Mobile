import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_ward/component/quarantine_maps.dart';

class QuanrantineListMaps extends StatefulWidget {
  const QuanrantineListMaps({Key? key}) : super(key: key);
  @override
  _QuanrantineListMapsState createState() => _QuanrantineListMapsState();
}

class _QuanrantineListMapsState extends State<QuanrantineListMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bản đồ các khu cách ly'),
          centerTitle: true,
        ),
        body: const QuanrantineMaps());
  }
}
