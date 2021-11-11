import 'package:flutter/material.dart';
import 'component/general_info_building.dart';
import 'package:qlkcl/screens/quarantine_management/floor_details_screen.dart';
import './edit_building_screen.dart';
import '../../components/cards.dart';
import './add_floor_screen.dart';

class BuildingDetailsScreen extends StatefulWidget {
  const BuildingDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/building-details';
  @override
  _BuildingDetailsScreen createState() => _BuildingDetailsScreen();
}

class _BuildingDetailsScreen extends State<BuildingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Thông tin chi tiết tòa"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              EditBuildingScreen.routeName,
            );
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              child:
                  GeneralInfoBuilding('Ký túc xá khu A', 'Tòa AH', 8, 15, 300),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  //last item
                  if (index == 8) {
                    return Column(
                      children: [
                        QuarantineRelatedCard(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              FloorDetailsScreen.routeName,
                            );
                          },
                          id: '1',
                          name: 'Tầng ' + (index + 1).toString(),
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
                          FloorDetailsScreen.routeName,
                        );
                      },
                      id: '1',
                      name: 'Tầng ' + (index + 1).toString(),
                      numOfMem: 15,
                      maxMem: 300,
                    );
                },
                itemCount: 9,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            AddFloorScreen.routeName,
          );
        },
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
