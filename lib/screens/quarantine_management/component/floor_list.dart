import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';

import '../floor_details_screen.dart';

class FloorList extends StatelessWidget {
  final data;

  const FloorList({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              //last item
              if (index == data.length - 1) {
                return Column(
                  children: [
                    QuarantineRelatedCard(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          FloorDetailsScreen.routeName,
                        );
                      },
                      id: data[index]['id'],
                      name: data[index]['name'],
                      numOfMem: data[index]['num_current_member'],
                      maxMem: data[index]['total_capacity'] == null
                          ? 0
                          : data[index]['total_capacity'],
                    ),
                    SizedBox(height: 70),
                  ],
                );
              } else
                return QuarantineRelatedCard(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      FloorDetailsScreen.routeName,
                    );
                  },
                  id: data[index]['id'],
                  name: data[index]['name'],
                  numOfMem: data[index]['num_current_member'],
                  maxMem: data[index]['total_capacity'] == null
                      ? 0
                      : data[index]['total_capacity'],
                );
            },
            itemCount: data.length,
          );
  }
}
