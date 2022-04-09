import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/add_building_screen.dart';
import 'package:qlkcl/screens/quarantine_management/component/bulding_list.dart';
import 'component/general_info.dart';

class BuildingListScreen extends StatefulWidget {
  final Quarantine? currentQuarrantine;
  const BuildingListScreen({Key? key, this.currentQuarrantine})
      : super(key: key);
  static const routeName = '/building-list';
  @override
  _BuildingListScreenState createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  late Future<dynamic> futureBuildingList;

  @override
  void initState() {
    super.initState();
    futureBuildingList =
        fetchBuildingList({'quarantine_ward': widget.currentQuarrantine!.id});
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Danh sách tòa'),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureBuildingList,
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
                        child: GeneralInfo(
                          currentQuarantine: widget.currentQuarrantine!,
                          numOfBuilding: snapshot.data.length,
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        child: BuildingList(
                            data: snapshot.data,
                            currentQuarantine: widget.currentQuarrantine!),
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
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBuildingScreen(
                        currentQuarrantine: widget.currentQuarrantine,
                      ))).then((value) => setState(() {
                futureBuildingList = fetchBuildingList(
                    {'quarantine_ward': widget.currentQuarrantine!.id});
              }));
        },
        tooltip: 'Thêm tòa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
