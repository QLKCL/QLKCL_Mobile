import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/screens/quarantine_management/building_list_screen.dart';
import './building_item.dart';

class CarouselBuilding extends StatelessWidget {
  final data;
  const CarouselBuilding({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return (data == null || data.isEmpty)
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
                      'Danh sách tòa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, BuildingListScreen.routeName);
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
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Container(
                      child: BuildingItem(
                        buildingName: 'Tòa ' + data[index]['name'],
                        maxMem: data[index]['total_capacity'] != null
                            ? data[index]['total_capacity']
                            : null,
                        currentMem: data[index]['num_current_member'],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
