import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/building_details_screen.dart';

class BuildingList extends StatelessWidget {
  final Quarantine currentQuarantine;
  final data;
  const BuildingList({Key? key, this.data, required this.currentQuarantine})
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuildingDetailsScreen(
                            currentQuarantine: currentQuarantine,
                            currentBuilding: Building.fromJson(data[index]),
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
