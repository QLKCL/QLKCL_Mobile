import 'package:flutter/material.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_ward/component/dummy_data.dart';
import 'component/quarantine_item.dart';
import './add_quarantine_screen.dart';

class QuarantineListScreen extends StatefulWidget {
  static const String routeName = "/quarantine-list";

  @override
  State<QuarantineListScreen> createState() => _QuarantineListScreenState();
}

class _QuarantineListScreenState extends State<QuarantineListScreen> {
  //add new quarantine ward
  void addNewQuarantine(
      String id,
      String fullName,
      int phoneNumber,
      String countryId,
      String cityId,
      String wardId,
      String districtId,
      String type,
      int quarantineTime,
      String mainManager) {
    final newTx = Quarantine(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber.toString(),
      countryId: countryId,
      cityId: cityId,
      wardId: wardId,
      districtId: districtId,
      type: type,
      quarantineTime: quarantineTime,
      mainManager: mainManager,
    );
    setState(() {
      DUMMY_QUARANTINE.add(newTx);
    });
  }

  bool searched = false;

  // void _startAddNewQuanrantine(BuildContext ctx) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return NewQuarantine(addNewQuarantine(String id, String fullName, int phoneNumber, String countryId, String cityId, String wardId, String districtId, String type, int quarantineTime, String mainManager));
  //     }),)
  // }

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
      body: DUMMY_QUARANTINE.isEmpty
          ? Center(
              child: Text('Không có dữ liệu'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return QuarantineItem(
                    id: DUMMY_QUARANTINE[index].id,
                    name: DUMMY_QUARANTINE[index].fullName,
                    numberOfMem: DUMMY_QUARANTINE[index].numOfMem,
                    manager: DUMMY_QUARANTINE[index].mainManager);
              },
              itemCount: DUMMY_QUARANTINE.length,
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
