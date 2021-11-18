import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/quarantine_management/component/member_in_room.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'component/general_info_room.dart';
import './edit_room_screen.dart';

class RoomDetailsScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final Floor? currentFloor;
  final Room? currentRoom;

  const RoomDetailsScreen(
      {Key? key,
      this.currentBuilding,
      this.currentFloor,
      this.currentQuarantine,
      this.currentRoom})
      : super(key: key);
  static const routeName = '/room-details';
  @override
  _RoomDetailsScreen createState() => _RoomDetailsScreen();
}

class _RoomDetailsScreen extends State<RoomDetailsScreen> {
  late Future<dynamic> futureMemberList;

  @override
  void initState() {
    super.initState();
    futureMemberList = fetchMemberList(
      data: filterMemberByRoomDataForm(
        quarantineWard: widget.currentQuarantine!.id,
        quarantineBuilding: widget.currentBuilding!.id,
        quarantineFloor: widget.currentFloor!.id,
        quarantineRoom: widget.currentRoom!.id,
      ),
    );
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Thông tin chi tiết phòng"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditRoomScreen(
                  currentBuilding: widget.currentBuilding,
                  currentQuarantine: widget.currentQuarantine,
                  currentFloor: widget.currentFloor,
                  currentRoom: widget.currentRoom,
                ),
              ),
            );
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureMemberList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('snapshot data in room detail');
                print(snapshot.data);
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
                        child: GeneralInfoRoom(
                          currentBuilding: widget.currentBuilding!,
                          currentFloor: widget.currentFloor!,
                          currentQuarantine: widget.currentQuarantine!,
                          currentRoom: widget.currentRoom!,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.75,
                      //margin: const EdgeInsets.symmetric(vertical: 8),
                      child: MemberRoom(data: snapshot.data),
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
              builder: (context) => AddMember(
                quarantineWard: KeyValue(id: widget.currentQuarantine!.id, name: widget.currentQuarantine!.fullName) ,
                quarantineBuilding: KeyValue(id: widget.currentBuilding!.id, name: widget.currentBuilding!.name) ,
                quarantineFloor: KeyValue(id: widget.currentFloor!.id, name: widget.currentFloor!.name) ,
                quarantineRoom: KeyValue(id: widget.currentRoom!.id, name: widget.currentRoom!.name) ,
              ),
            ),
          );
        },
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
