import 'package:flutter/material.dart';
import '../../models/quarantine.dart';
import '../../components/cards.dart';

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
                  name: quarantines[index].full_name,
                  numberOfMem: 0,
                  manager: quarantines[index].main_manager);
            },
            itemCount: quarantines.length,
          );
  }
}
