import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/quarantine_management/building_details_screen.dart';

class QuarantineRelatedList extends StatelessWidget {
  final data;
  const QuarantineRelatedList({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuildingDetailsScreen(
                                    id: data[index]['id'])));
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
                      BuildingDetailsScreen.routeName,
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
