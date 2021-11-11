import 'package:flutter/material.dart';
import 'component/general_info_floor.dart';
import 'package:qlkcl/screens/quarantine_management/room_details_screen.dart';
import 'edit_floor_screen.dart';
import './add_room_screen.dart';

import '../../components/cards.dart';

class FloorDetailsScreen extends StatefulWidget {
  const FloorDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/floor-details';
  @override
  _FloorDetailsScreen createState() => _FloorDetailsScreen();
}

class _FloorDetailsScreen extends State<FloorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Thông tin chi tiết tầng"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              EditFloorScreen.routeName,
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
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child: GeneralInfoFloor(
                  'Ký túc xá khu A', 'Tòa AH', 'Tầng 3', 8, 15, 300),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  //last item
                  if (index == 8) {
                    return Column(
                      children: [
                        QuarantineRelatedCard(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              RoomDetailsScreen.routeName,
                            );
                          },
                          id: '1',
                          name: 'Phòng ' + '30' + (index + 1).toString(),
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
                          RoomDetailsScreen.routeName,
                        );
                      },
                      id: '1',
                      name: 'Phòng ' + '30' + (index + 1).toString(),
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
            AddRoomScreen.routeName,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
