import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_management/building_details_screen.dart';
import 'package:qlkcl/screens/quarantine_management/component/add_building_screen.dart';
import 'component/general_info.dart';
import '../../components/cards.dart';
import 'add_building_screen.dart';

class BuildingListScreen extends StatefulWidget {
  const BuildingListScreen({Key? key}) : super(key: key);
  static const routeName = '/quarantine-details/building-list';
  @override
  _BuildingListScreenState createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Danh sách tòa'),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child: GeneralInfo('Ký túc xá khu A', 8, 15, 300),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  //last item
                  if (index == 9) {
                    return Column(
                      children: [
                        QuarantineRelatedCard(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              BuildingDetailsScreen.routeName,
                            );
                          },
                          id: '1',
                          name: 'Tòa AH',
                          numOfMem: 15,
                          maxMem: 300,
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
                      id: '1',
                      name: 'Tòa AH',
                      numOfMem: 15,
                      maxMem: 300,
                    );
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            AddBuildingScreen.routeName,
          );
        },
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      // body: ,
    );
  }
}
