import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/component/floor_list.dart';
import 'component/general_info_building.dart';
import './edit_building_screen.dart';
import './add_floor_screen.dart';

class BuildingDetailsScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  // final int? id;

  const BuildingDetailsScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
  }) : super(key: key);
  static const routeName = '/building-details';
  @override
  _BuildingDetailsScreen createState() => _BuildingDetailsScreen();
}

class _BuildingDetailsScreen extends State<BuildingDetailsScreen> {
  late Future<dynamic> futureFloorList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    futureFloorList =
        fetchFloorList({'quarantine_building': widget.currentBuilding!.id});

    final appBar = AppBar(
      title: const Text("Thông tin chi tiết tòa"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBuildingScreen(
                  currentBuilding: widget.currentBuilding,
                  currentQuarantine: widget.currentQuarantine,
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
            future: futureFloorList,
            builder: (context, snapshot) {
              showLoading();
              if (snapshot.hasData) {
                BotToast.closeAllLoading();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.25,
                      child: GeneralInfoBuilding(
                        currentQuarantine: widget.currentQuarantine!,
                        currentBuilding: widget.currentBuilding!,
                        numberOfFloor: snapshot.data.length,
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.75,
                      child: FloorList(
                        data: snapshot.data,
                        currentBuilding: widget.currentBuilding!,
                        currentQuarantine: widget.currentQuarantine!,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Snapshot has error');
              }
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFloorScreen(
                currentBuilding: widget.currentBuilding,
                currentQuarantine: widget.currentQuarantine,
              ),
            ),
          ).then((value) => setState(() {}));
        },
        tooltip: 'Thêm tầng',
        child: const Icon(Icons.add),
      ),
    );
  }
}
