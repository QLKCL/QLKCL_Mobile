import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_ward/component/quarantine_list.dart';
import './add_quarantine_screen.dart';

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
  //add new quarantine ward
  // void _addNewQuarantine(
  //     String id,
  //     String full_name,
  //     int phone_number,
  //     String country_id,
  //     String city_id,
  //     String ward_id,
  //     String district_id,
  //     String type,
  //     int quarantine_time,
  //     String main_manager) {
  //   final newTx = Quarantine(
  //     id: id,
  //     full_name: full_name,
  //     phone_number: phone_number.toString(),
  //     country_id: country_id,
  //     city_id: city_id,
  //     ward_id: ward_id,
  //     district_id: district_id,
  //     type: type,
  //     quarantine_time: quarantine_time,
  //     main_manager: main_manager,
  //   );
  //   setState(() {
  //     DUMMY_QUARANTINE.add(newTx);
  //   });
  // }

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
      // ListView.builder(
      //     itemBuilder: (ctx, index) {
      //       return QuarantineItem(
      //           id: DUMMY_QUARANTINE[index].id,
      //           name: DUMMY_QUARANTINE[index].full_name,
      //           numberOfMem: DUMMY_QUARANTINE[index].numOfMem,
      //           manager: DUMMY_QUARANTINE[index].main_manager);
      //     },
      //     itemCount: DUMMY_QUARANTINE.length,
      //   ),
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
