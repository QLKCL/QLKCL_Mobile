import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/component/floor_list.dart';
import 'package:qlkcl/utils/constant.dart';
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
  late Building currentBuilding;

  @override
  void initState() {
    super.initState();
    currentBuilding = widget.currentBuilding!;
    futureFloorList = fetchFloorList({
      'quarantine_building_id_list': currentBuilding.id,
      'page_size': pageSizeMax,
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ).then((value) => setState(() {
                  if (value != null) {
                    currentBuilding = value;
                  }
                  futureFloorList = fetchFloorList({
                    'quarantine_building_id_list': currentBuilding.id,
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
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            setState(() {
              futureFloorList = fetchFloorList({
                'quarantine_building_id_list': currentBuilding.id,
                'page_size': pageSizeMax,
              });
            });
          }),
          child: FutureBuilder<dynamic>(
              future: futureFloorList,
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
                          child: GeneralInfoBuilding(
                            currentQuarantine: widget.currentQuarantine!,
                            currentBuilding: currentBuilding,
                            numberOfFloor: snapshot.data.length,
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.75,
                          child: FloorList(
                            data: snapshot.data,
                            currentBuilding: currentBuilding,
                            currentQuarantine: widget.currentQuarantine!,
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
          ).then((value) => setState(() {
                futureFloorList = fetchFloorList({
                  'quarantine_building_id_list': currentBuilding.id,
                  'page_size': pageSizeMax,
                });
              }));
        },
        tooltip: 'Thêm tầng',
        child: const Icon(Icons.add),
      ),
    );
  }
}
