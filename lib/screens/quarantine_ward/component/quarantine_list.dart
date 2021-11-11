import 'package:flutter/material.dart';
import '../../../models/quarantine.dart';
import './quarantine_item.dart';

class QuanrantineList extends StatelessWidget {
  final List<Quarantine> quarantines;

  QuanrantineList(this.quarantines);

  @override
  Widget build(BuildContext context) {
    return quarantines.isEmpty
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return QuarantineItem(
                  id: quarantines[index].id,
                  name: quarantines[index].fullName,
                  numberOfMem: 0,
                  manager: quarantines[index].mainManager);
            },
            itemCount: quarantines.length,
          );
  }
}
