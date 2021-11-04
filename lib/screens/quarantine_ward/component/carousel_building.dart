import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import './building_item.dart';

class CarouselBuilding extends StatefulWidget {
  @override
  _CarouselBuildingState createState() => _CarouselBuildingState();
}

class _CarouselBuildingState extends State<CarouselBuilding> {
  int _counter = 0;

  final listBuilding = [
    BuildingItem(building_name: 'Tòa AH'),
    BuildingItem(building_name: 'Tòa A7'),
    BuildingItem(building_name: 'Tòa A5'),
    BuildingItem(building_name: 'Tòa A6'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(
      //   left: 23,
      // ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 140,
          enableInfiniteScroll: false,
          initialPage: 2,
          viewportFraction: 0.33,
          onPageChanged: (index, reason) => setState(() => _counter = index),
        ),
        items: listBuilding.map((building) {
          return Builder(
            builder: (BuildContext context) {
              return BuildingItem(building_name: building.building_name);
            },
          );
        }).toList(),
      ),
    );
  }
}
