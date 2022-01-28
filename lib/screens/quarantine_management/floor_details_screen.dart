import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'component/general_info_floor.dart';
import 'component/room_list.dart';
import 'edit_floor_screen.dart';
import './add_room_screen.dart';

class FloorDetailsScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;

  const FloorDetailsScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
    this.currentFloor,
  }) : super(key: key);
  static const routeName = '/floor-details';
  @override
  _FloorDetailsScreen createState() => _FloorDetailsScreen();
}

class _FloorDetailsScreen extends State<FloorDetailsScreen> {
  late Future<dynamic> futureRoomList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    futureRoomList =
        fetchRoomList({'quarantine_floor': widget.currentFloor!.id});
    final appBar = AppBar(
      title: const Text("Thông tin chi tiết tầng"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditFloorScreen(
                  currentBuilding: widget.currentBuilding,
                  currentQuarantine: widget.currentQuarantine,
                  currentFloor: widget.currentFloor,
                ),
              ),
            ).then((value) => setState(() {}));
          },
          icon: Icon(Icons.edit),
          tooltip: "Cập nhật",
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureRoomList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                EasyLoading.dismiss();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.25,
                      child: GeneralInfoFloor(
                        currentBuilding: widget.currentBuilding!,
                        currentQuarantine: widget.currentQuarantine!,
                        currentFloor: widget.currentFloor!,
                        numOfRoom: snapshot.data.length,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.75,
                      child: RoomList(
                        data: snapshot.data,
                        currentBuilding: widget.currentBuilding!,
                        currentQuarantine: widget.currentQuarantine!,
                        currentFloor: widget.currentFloor!,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Snapshot has error');
              }
              EasyLoading.show();
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoomScreen(
                currentBuilding: widget.currentBuilding,
                currentQuarantine: widget.currentQuarantine,
                currentFloor: widget.currentFloor,
              ),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
        tooltip: 'Thêm phòng',
      ),
    );
  }
}
