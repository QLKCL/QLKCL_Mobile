import 'package:flutter/material.dart';
import './building_item.dart';

class CarouselBuilding extends StatelessWidget {
  final data;
  const CarouselBuilding({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return (data == null || data.isEmpty)
        ? Text('Chưa có tòa nào được tạo')
        : Container(
            alignment: Alignment.center,
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: Container(
                  child: BuildingItem(
                    buildingName: 'Tòa '+ data[index]['name'],
                  ),
                ),
              ),
            ),
          );
  }
}
