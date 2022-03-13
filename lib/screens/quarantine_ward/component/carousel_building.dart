import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/add_building_screen.dart';
import 'package:qlkcl/screens/quarantine_management/building_list_screen.dart';
import './building_item.dart';

class CarouselBuilding extends StatefulWidget {
  final Quarantine? currentQuarantine;
  final data;
  const CarouselBuilding({
    Key? key,
    this.data,
    this.currentQuarantine,
  }) : super(key: key);

  @override
  State<CarouselBuilding> createState() => _CarouselBuildingState();
}

class _CarouselBuildingState extends State<CarouselBuilding> {
  @override
  Widget build(BuildContext context) {
    return (widget.data == null || widget.data.isEmpty)
        ? Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 23, right: 23, top: 21, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách tòa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //Add building here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBuildingScreen(
                              currentQuarrantine: widget.currentQuarantine,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      child: Text('Tạo tòa'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            CustomColors.primary),
                      ),
                    )
                  ],
                ),
              ),
              Text('Chưa có tòa nào được tạo'),
            ],
          )
        : Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 23, right: 23, top: 21, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách tòa (' + widget.data.length.toString() + ')',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuildingListScreen(
                              currentQuarrantine: widget.currentQuarantine,
                            ),
                          ),
                        );
                      },
                      child: Text('Xem tất cả'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            CustomColors.primary),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.data.length,
                  padding: EdgeInsets.only(bottom: 16),
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Container(
                      child: BuildingItem(
                        currentQuarantine: widget.currentQuarantine!,
                        currentBuilding: Building.fromJson(widget.data[index]),
                        buildingName: widget.data[index]['name'],
                        maxMem: widget.data[index]['total_capacity'] != null
                            ? widget.data[index]['total_capacity']
                            : 0,
                        currentMem: widget.data[index]['num_current_member'],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
