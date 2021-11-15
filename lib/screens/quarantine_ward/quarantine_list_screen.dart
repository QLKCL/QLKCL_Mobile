import 'package:flutter/material.dart';
import 'package:qlkcl/models/quarantine.dart';
import './add_quarantine_screen.dart';
import './component/quarantine_list.dart';

class QuarantineListScreen extends StatefulWidget {
  static const String routeName = "/quarantine-list";

  @override
  State<QuarantineListScreen> createState() => _QuarantineListScreenState();
}

class _QuarantineListScreenState extends State<QuarantineListScreen> {
  late Future<dynamic> futureQuarantineList;

  @override
  void initState() {
    super.initState();
    futureQuarantineList = fetchQuarantineList();
  }

  @override
  void deactivate() {
    super.deactivate();
  }


  bool searched = false;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: searched
          ? Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
          : Text('Các khu cách ly'),
      centerTitle: true,
      actions: [
        searched
            ? IconButton(
                onPressed: () {
                  //quarantine filter bottomsheet
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
              ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<dynamic>(
        future: futureQuarantineList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return QuanrantineList(data: snapshot.data);
          } else if (snapshot.hasError) {
            return Text('Snap shot has error');
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "quarantine_fab",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            NewQuarantine.routeName,
          );
        },
      ),
    );
  }
}
