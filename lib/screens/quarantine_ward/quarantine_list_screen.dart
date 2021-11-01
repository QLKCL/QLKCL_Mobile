import 'package:flutter/material.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_ward/component/dummy_data.dart';
import 'component/quarantine_item.dart';
import 'component/quarantine_list.dart';
import './add_quarantine_screen.dart';

class QuarantineListScreen extends StatefulWidget {
  static const String routeName = "/quarantine-list";

  @override
  State<QuarantineListScreen> createState() => _QuarantineListScreenState();
}

class _QuarantineListScreenState extends State<QuarantineListScreen> {
 

  //add new quarantine ward
  void _addNewQuarantine(
      String id,
      String full_name,
      int phone_number,
      String country_id,
      String city_id,
      String ward_id,
      String district_id,
      String type,
      int quarantine_time,
      String main_manager) {
    final newTx = Quarantine(
      id: id,
      full_name: full_name,
      phone_number: phone_number.toString(),
      country_id: country_id,
      city_id: city_id,
      ward_id: ward_id,
      district_id: district_id,
      type: type,
      quarantine_time: quarantine_time,
      main_manager: main_manager,
    );
    setState(() {
      DUMMY_QUARANTINE.add(newTx);
    });
  }

  // void _startAddNewQuanrantine(BuildContext ctx) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return NewQuarantine(_addNewQuarantine(String id, String full_name, int phone_number, String country_id, String city_id, String ward_id, String district_id, String type, int quarantine_time, String main_manager));
  //     }),)
  // }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Các khu cách ly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: DUMMY_QUARANTINE.isEmpty
          ? Center(
              child: Text('Không có dữ liệu'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return QuarantineItem(
                    id: DUMMY_QUARANTINE[index].id,
                    name: DUMMY_QUARANTINE[index].full_name,
                    numberOfMem: DUMMY_QUARANTINE[index].numOfMem,
                    manager: DUMMY_QUARANTINE[index].main_manager);
              },
              itemCount: DUMMY_QUARANTINE.length,
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "quarantine_fab",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NewQuarantine.routeName);
        },
      ),
    );
  }
}
