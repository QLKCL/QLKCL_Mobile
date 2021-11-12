import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';

class ListTestNoResult extends StatefulWidget {
  static const String routeName = "/list_test_no_result";
  ListTestNoResult({Key? key}) : super(key: key);

  @override
  _ListTestNoResultState createState() => _ListTestNoResultState();
}

class _ListTestNoResultState extends State<ListTestNoResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xét nghiệm cần cập nhật"),
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
          TestNoResultCard(
            name: "Le Trung Son",
            gender: "male",
            birthday: "20/05/2000",
            id: "PCR-123456789",
            time: "22/09/2021",
            onTap: () {
              Navigator.pushNamed(context, UpdateTest.routeName);
            },
          ),
        ],
      )),
    );
  }
}
