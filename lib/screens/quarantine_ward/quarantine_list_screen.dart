import 'package:flutter/material.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'quarantine_list.dart';

class QuarantineListScreen extends StatefulWidget {
  static const String routeName = "/quarantine-list";

  @override
  State<QuarantineListScreen> createState() => _QuarantineListScreenState();
}

class _QuarantineListScreenState extends State<QuarantineListScreen> {
  final List<Quarantine> _quarantineList = [
    Quarantine(
      id: 'q1',
      full_name: 'Ký túc xá khu A ĐHQG TPHCM',
      phone_number: '0938555421',
      country_id: 'Việt Nam',
      city_id: 'Bình Dương',
      ward_id: 'Đông Hòa',
      district_id: 'Dĩ An',
      type: 'Tập trung',
      quarantine_time: 14,
      main_manager: 'Lê Trung Sơn',
    ),
    Quarantine(
      id: 'q1',
      full_name: 'Ký túc xá khu A ĐHQG TPHCM',
      phone_number: '0938555421',
      country_id: 'Việt Nam',
      city_id: 'Bình Dương',
      ward_id: 'Đông Hòa',
      district_id: 'Dĩ An',
      type: 'Tập trung',
      quarantine_time: 14,
      main_manager: 'Lê Trung Sơn',
    ),
    Quarantine(
      id: 'q1',
      full_name: 'Ký túc xá khu A ĐHQG TPHCM',
      phone_number: '0938555421',
      country_id: 'Việt Nam',
      city_id: 'Bình Dương',
      ward_id: 'Đông Hòa',
      district_id: 'Dĩ An',
      type: 'Tập trung',
      quarantine_time: 14,
      main_manager: 'Lê Trung Sơn',
    ),
    Quarantine(
      id: 'q1',
      full_name: 'Ký túc xá khu A ĐHQG TPHCM',
      phone_number: '0938555421',
      country_id: 'Việt Nam',
      city_id: 'Bình Dương',
      ward_id: 'Đông Hòa',
      district_id: 'Dĩ An',
      type: 'Tập trung',
      quarantine_time: 14,
      main_manager: 'Lê Trung Sơn',
    ),
  ];

  //add new quarantine ward
  void _addNewQuarantine(String id, String full_name, int phone_number, String country_id, String city_id, String ward_id, String district_id, String type, int quarantine_time, String main_manager) {
    final newTx = Quarantine(
      id: id,
      full_name: full_name,
      phone_number: phone_number.toString(),
      country_id: country_id,
      city_id: city_id,
      ward_id: ward_id,
      district_id: district_id,
      type:  type,
      quarantine_time: quarantine_time,
      main_manager: main_manager,
    );
    setState(() {
      _quarantineList.add(newTx);
    });
  }

  void _startAddNewQuanrantine(BuildContext ctx) {
    
  }


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
      body: QuanrantineList(_quarantineList),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
