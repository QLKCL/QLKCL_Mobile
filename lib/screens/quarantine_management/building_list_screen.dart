import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  onRefresh() {
    //print('On refresh');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //print('init building screen');
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    futureBuildingList =
        fetchBuildingList({'quarantine_ward': widget.currentQuarrantine!.id});

    print('Build building list screen');
    final appBar = AppBar(
      title: Text('Danh sách tòa'),
    );
    //print(widget.currentQuarrantine!.fullName);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureBuildingList,
            builder: (context, snapshot) {
              print('building list');
              print(snapshot.data);
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
                      child: GeneralInfo(
                        currentQuarantine: widget.currentQuarrantine!,
                        numOfBuilding: snapshot.data.length,
                      ),
                    ),
                    Container(
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
                  builder: (context) => AddBuildingScreen(
                        currentQuarrantine: widget.currentQuarrantine,
                        onGoBackBuildingList: onRefresh,
                      )));
        },
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      // body: ,
    );
  }
}
