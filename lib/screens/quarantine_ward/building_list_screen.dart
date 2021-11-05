import 'package:flutter/material.dart';

class BuildingListScreen extends StatefulWidget {
  const BuildingListScreen({Key? key}) : super(key: key);
  static const routeName = '/quarantine-details/building-list';
  @override
  _BuildingListScreenState createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Danh sách tòa'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.edit),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      // body: ,
    );
  }
}
