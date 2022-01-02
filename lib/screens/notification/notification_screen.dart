import 'package:flutter/material.dart';

class ListNotification extends StatefulWidget {
  static const String routeName = "/notification";
  ListNotification({Key? key}) : super(key: key);

  @override
  _ListNotificationState createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông báo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text("Danh sách các thông báo"),
        ],
      )),
    );
  }
}
