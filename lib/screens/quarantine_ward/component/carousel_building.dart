import 'package:flutter/material.dart';
import './building_item.dart';

class CarouselBuilding extends StatefulWidget {
  @override
  _CarouselBuildingState createState() => _CarouselBuildingState();
}

class _CarouselBuildingState extends State<CarouselBuilding> {
  final listBuildingName = [
    'Toà AH',
    'Tòa A7',
    'Tòa A5',
    'Tòa A6',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 150,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listBuildingName.length,
        itemBuilder: (BuildContext context, int index) => Card(
          child: Container(
            child: BuildingItem(
              buildingName: listBuildingName[index],
            ),
          ),
        ),
      ),
    );
  }
}
