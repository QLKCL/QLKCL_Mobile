import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';

class ListTest extends StatefulWidget {
  static const String routeName = "/list_test";
  ListTest({Key? key}) : super(key: key);

  @override
  _ListTestState createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Lịch sử xét nghiệm"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Test(
            id: "KB-123456789",
            time: "22/09/2021 18:00",
            status: "Âm tính",
            onTap: () {},
          ),
        ],
      )),
    );
  }
}
