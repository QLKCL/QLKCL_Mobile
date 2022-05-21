import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/utils/constant.dart';
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
  late Floor currentFloor;

  @override
  void initState() {
    super.initState();
    currentFloor = widget.currentFloor!;
    futureRoomList = fetchRoomList({
      'quarantine_floor': currentFloor.id,
      'page_size': pageSizeMax,
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ).then((value) => setState(() {
                  if (value != null) {
                    currentFloor = value;
                  }
                  futureRoomList = fetchRoomList({
                    'quarantine_floor': currentFloor.id,
                    'page_size': pageSizeMax,
                  });
                }));
          },
          icon: const Icon(Icons.edit),
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
              showLoading();
              if (snapshot.connectionState == ConnectionState.done) {
                BotToast.closeAllLoading();
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.25,
                        child: GeneralInfoFloor(
                          currentBuilding: widget.currentBuilding!,
                          currentQuarantine: widget.currentQuarantine!,
                          currentFloor: currentFloor,
                          numOfRoom: snapshot.data.length,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        child: RoomList(
                          data: snapshot.data,
                          currentBuilding: widget.currentBuilding!,
                          currentQuarantine: widget.currentQuarantine!,
                          currentFloor: currentFloor,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('Snapshot has error');
                } else {
                  return const Text(
                    'Không có dữ liệu',
                    textAlign: TextAlign.center,
                  );
                }
              }
              return const SizedBox();
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
          ).then((value) => setState(() {
                futureRoomList = fetchRoomList({
                  'quarantine_floor': currentFloor.id,
                  'page_size': pageSizeMax,
                });
              }));
        },
        child: const Icon(Icons.add),
        tooltip: 'Thêm phòng',
      ),
    );
  }
}
