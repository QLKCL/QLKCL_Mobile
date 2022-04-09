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
  final dynamic data;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Image.asset("assets/images/no_data.png"),
                ),
                const Text('Không có dữ liệu'),
              ],
            ),
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
                    maxMem: data[index]['total_capacity'] ?? 0,
                  ),
                  index == data.length - 1
                      ? const SizedBox(height: 70)
                      : Container(),
                ],
              );
            },
            itemCount: data.length,
          );
  }
}
