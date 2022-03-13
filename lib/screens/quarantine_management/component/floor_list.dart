import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';

import '../floor_details_screen.dart';

class FloorList extends StatelessWidget {
  final Quarantine currentQuarantine;
  final Building currentBuilding;
  final data;

  const FloorList(
      {Key? key,
      this.data,
      required this.currentQuarantine,
      required this.currentBuilding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (data == null || data.isEmpty)
        ? Center(
            child: Text('Không có dữ liệu'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  QuarantineRelatedCard(
                    onTap: () {
                      Navigator.of(context,
                              rootNavigator:
                                  !Responsive.isDesktopLayout(context))
                          .push(
                        MaterialPageRoute(
                          builder: (context) => FloorDetailsScreen(
                            currentBuilding: currentBuilding,
                            currentQuarantine: currentQuarantine,
                            currentFloor: Floor.fromJson(data[index]),
                          ),
                        ),
                      );
                    },
                    name: data[index]['name'],
                    numOfMem: data[index]['num_current_member'],
                    maxMem: data[index]['total_capacity'] == null
                        ? 0
                        : data[index]['total_capacity'],
                  ),
                  index == data.length - 1 ? SizedBox(height: 70) : Container(),
                ],
              );
            },
            itemCount: data.length,
          );
  }
}
