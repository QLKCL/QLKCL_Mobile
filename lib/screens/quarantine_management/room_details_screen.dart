import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/room.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/add_member_screen.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/table.dart';
import 'package:qlkcl/screens/members/timeline_member_screen.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'component/general_info_room.dart';
import './edit_room_screen.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/app_theme.dart';

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
  late Future<FilterResponse<FilterMember>> futureMemberList;

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late DataSource dataSource;

  bool showLoadingIndicator = true;

  late Room currentRoom;

  @override
  void initState() {
    dataSource = DataSource();
    super.initState();
    currentRoom = widget.currentRoom!;
    futureMemberList = fetchMemberList(
      data: filterMemberByRoomDataForm(
        quarantineWard: widget.currentQuarantine!.id,
        quarantineBuilding: widget.currentBuilding!.id,
        quarantineFloor: widget.currentFloor!.id,
        quarantineRoom: currentRoom.id,
      ),
    );
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
                  currentRoom: currentRoom,
                ),
              ),
            ).then(
              (value) => setState(
                () {
                  if (value != null) {
                    currentRoom = value;
                  }
                  futureMemberList = fetchMemberList(
                    data: filterMemberByRoomDataForm(
                      quarantineWard: widget.currentQuarantine!.id,
                      quarantineBuilding: widget.currentBuilding!.id,
                      quarantineFloor: widget.currentFloor!.id,
                      quarantineRoom: currentRoom.id,
                    ),
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.edit),
          tooltip: "Cập nhật",
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<FilterResponse<FilterMember>>(
            future: futureMemberList,
            builder: (context, snapshot) {
              showLoading();
              if (snapshot.connectionState == ConnectionState.done) {
                BotToast.closeAllLoading();
                if (snapshot.hasData) {
                  showLoadingIndicator = false;
                  dataSource = DataSource(data: snapshot.data!.data);
                  return Responsive.isDesktopLayout(context)
                      ? listMemberTable(appBar)
                      : listMemberCard(appBar, snapshot.data!);
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
              builder: (context) => AddMember(
                quarantineWard: KeyValue(
                    id: widget.currentQuarantine!.id,
                    name: widget.currentQuarantine!.fullName),
                quarantineBuilding: KeyValue(
                    id: widget.currentBuilding!.id,
                    name: widget.currentBuilding!.name),
                quarantineFloor: KeyValue(
                    id: widget.currentFloor!.id,
                    name: widget.currentFloor!.name),
                quarantineRoom:
                    KeyValue(id: currentRoom.id, name: currentRoom.name),
              ),
            ),
          ).then((value) => setState(() {
                futureMemberList = fetchMemberList(
                  data: filterMemberByRoomDataForm(
                    quarantineWard: widget.currentQuarantine!.id,
                    quarantineBuilding: widget.currentBuilding!.id,
                    quarantineFloor: widget.currentFloor!.id,
                    quarantineRoom: currentRoom.id,
                  ),
                );
              }));
        },
        tooltip: 'Thêm người cách ly',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget listMemberCard(
      PreferredSizeWidget appBar, FilterResponse<FilterMember> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.25,
            child: GeneralInfoRoom(
              currentBuilding: widget.currentBuilding!,
              currentFloor: widget.currentFloor!,
              currentQuarantine: widget.currentQuarantine!,
              currentRoom: currentRoom,
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.75,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  MemberCard(
                    member: data.data[index],
                    isThreeLine: false,
                    onTap: () {
                      Navigator.of(context,
                              rootNavigator:
                                  !Responsive.isDesktopLayout(context))
                          .push(MaterialPageRoute(
                              builder: (context) => TimelineMember(
                                    code: data.data[index].code,
                                  )));
                    },
                    menus: menus(
                      context,
                      data.data[index],
                      showMenusItems: [
                        menusOptions.updateInfo,
                        menusOptions.createMedicalDeclaration,
                        menusOptions.medicalDeclareHistory,
                        menusOptions.createTest,
                        menusOptions.testHistory,
                        menusOptions.vaccineDoseHistory,
                        menusOptions.changeRoom,
                      ],
                    ),
                  ),
                  if (index == data.data.length - 1) const SizedBox(height: 70),
                ],
              );
            },
            itemCount: data.data.length,
          ),
        ),
      ],
    );
  }

  Widget listMemberTable(PreferredSizeWidget appBar) {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.25,
            child: GeneralInfoRoom(
              currentBuilding: widget.currentBuilding!,
              currentFloor: widget.currentFloor!,
              currentQuarantine: widget.currentQuarantine!,
              currentRoom: currentRoom,
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75 -
              200,
          child: Card(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: buildStack(
                        key,
                        dataSource,
                        constraints,
                        showLoadingIndicator,
                        showColumnItems: [
                          columns.fullName,
                          columns.birthday,
                          columns.gender,
                          columns.phoneNumber,
                          columns.quarantineWard,
                          columns.quarantineLocation,
                          columns.label,
                          columns.quarantinedAt,
                          columns.quarantinedFinishExpectedAt,
                          columns.healthStatus,
                          columns.positiveTestNow,
                          columns.code,
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class DataSource extends DataGridSource {
  DataSource({List<FilterMember>? data}) {
    members = data ?? [];
    buildDataGridRows();
  }

  List<FilterMember> members = [];
  List<DataGridRow> _memberData = [];

  @override
  List<DataGridRow> get rows => _memberData;

  void buildDataGridRows() {
    _memberData = members
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'fullName', value: e.fullName),
              DataGridCell<DateTime?>(
                  columnName: 'birthday',
                  value: e.birthday != null
                      ? DateFormat('dd/MM/yyyy').parse(e.birthday!)
                      : null),
              DataGridCell<String>(columnName: 'gender', value: e.gender),
              DataGridCell<String>(
                  columnName: 'phoneNumber', value: e.phoneNumber),
              DataGridCell<String>(
                  columnName: 'quarantineWard',
                  value: e.quarantineWard?.name ?? ""),
              DataGridCell<String>(
                  columnName: 'quarantineLocation',
                  value: e.quarantineLocation),
              DataGridCell<String>(columnName: 'label', value: e.label),
              DataGridCell<DateTime?>(
                  columnName: 'quarantinedAt',
                  value: e.quarantinedAt != null
                      ? DateTime.parse(e.quarantinedAt!).toLocal()
                      : null),
              DataGridCell<DateTime?>(
                  columnName: 'quarantinedFinishExpectedAt',
                  value: e.quarantinedFinishExpectedAt != null
                      ? DateTime.parse(e.quarantinedFinishExpectedAt!).toLocal()
                      : null),
              DataGridCell<String>(
                  columnName: 'healthStatus', value: e.healthStatus),
              DataGridCell<bool?>(
                  columnName: 'positiveTestNow', value: e.positiveTestNow),
              DataGridCell<String>(columnName: 'code', value: e.code),
            ],
          ),
        )
        .toList();
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: <Widget>[
        FutureBuilder(
          future: Future.delayed(Duration.zero, () => true),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context,
                          rootNavigator: !Responsive.isDesktopLayout(context))
                      .push(MaterialPageRoute(
                          builder: (context) => TimelineMember(
                                code: row.getCells()[11].value.toString(),
                              )));
                },
                child: Text(
                  row.getCells()[0].value.toString(),
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[1].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[1].value)
                : "",
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child:
              Text(row.getCells()[2].value.toString() == "MALE" ? "Nam" : "Nữ"),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              row.getCells()[3].value.toString(),
            )),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[5].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(row.getCells()[6].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[7].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[7].value)
                : "",
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[8].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[8].value)
                : "",
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: row.getCells()[9].value.toString() == "SERIOUS"
                    ? error.withOpacity(0.25)
                    : row.getCells()[9].value.toString() == "UNWELL"
                        ? warning.withOpacity(0.25)
                        : success.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: row.getCells()[9].value.toString() == "SERIOUS"
                  ? Text(
                      "Nguy hiểm",
                      style: TextStyle(color: error),
                    )
                  : row.getCells()[9].value.toString() == "UNWELL"
                      ? Text(
                          "Không tốt",
                          style: TextStyle(color: warning),
                        )
                      : Text(
                          "Bình thường",
                          style: TextStyle(color: success),
                        ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: row.getCells()[10].value == null
                    ? secondaryText.withOpacity(0.25)
                    : row.getCells()[10].value == true
                        ? error.withOpacity(0.25)
                        : success.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: row.getCells()[10].value == null
                  ? Text(
                      "Chưa có",
                      style: TextStyle(color: secondaryText),
                    )
                  : row.getCells()[10].value == true
                      ? Text(
                          "Dương tính",
                          style: TextStyle(color: error),
                        )
                      : Text(
                          "Âm tính",
                          style: TextStyle(color: success),
                        ),
            )
          ],
        ),
        FutureBuilder(
          future: Future.delayed(Duration.zero, () => true),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const SizedBox()
                : menus(
                    context,
                    members.safeFirstWhere(
                        (e) => e.code == row.getCells()[11].value.toString())!,
                    showMenusItems: [
                      menusOptions.updateInfo,
                      menusOptions.createMedicalDeclaration,
                      menusOptions.medicalDeclareHistory,
                      menusOptions.createTest,
                      menusOptions.testHistory,
                      menusOptions.vaccineDoseHistory,
                      menusOptions.changeRoom,
                    ],
                  );
          },
        ),
      ],
    );
  }
}
