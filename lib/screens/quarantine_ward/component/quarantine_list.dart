import 'package:flutter/material.dart';

import './quarantine_item.dart';

class QuanrantineList extends StatelessWidget {
  final data;
  const QuanrantineList({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(data);
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return QuarantineItem(
                  id: data[index]['id'].toString(),
                  name: data[index]['full_name'] ?? "",
                  //HOW TO GET NUMBER OF MEMBER.
                  numberOfMem: 0,
                  manager: data[index]["main_manager"]["full_name"] ?? "");
            },
            itemCount: data.length,
          );
  }
}
