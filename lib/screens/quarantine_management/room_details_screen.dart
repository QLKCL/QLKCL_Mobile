import 'package:badges/badges.dart';
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
import 'package:qlkcl/screens/members/change_quarantine_info.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'component/general_info_room.dart';
import './edit_room_screen.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';

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

  late MemberDataSource memberDataSource = MemberDataSource();

  bool showLoadingIndicator = true;
  double pageCount = 0;

  late Room currentRoom;

  @override
  void initState() {
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
    var appBar = AppBar(
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
                  memberDataSource =
                      MemberDataSource(data: snapshot.data!.data);
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
              return Container();
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
                                builder: (context) => UpdateMember(
                                      code: data.data[index].code,
                                    )));
                      },
                      menus: menus(context, data.data[index])),
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
                      child: buildStack(constraints),
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

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      source: memberDataSource,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      allowSorting: true,
      allowMultiColumnSorting: true,
      allowTriStateSorting: true,
      selectionMode: SelectionMode.multiple,
      showCheckboxColumn: true,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'fullName',
            columnWidthMode: ColumnWidthMode.fill,
            minimumWidth: 50,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: const Text('Họ và tên',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'birthday',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Ngày sinh',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'gender',
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text(
                  'Giới tính',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
        GridColumn(
            columnName: 'phoneNumber',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('SDT',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantineWard',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: const Text('Khu cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantineLocation',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: const Text('Phòng',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'label',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Diện cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantinedAt',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Ngày cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantinedFinishExpectedAt',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Ngày dự kiến hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'healthStatus',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Sức khỏe',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'positiveTestNow',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Xét nghiệm',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'action',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Hành động',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
      ],
    );
  }

  Widget buildStack(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      List<Widget> stackChildren = [];
      stackChildren.add(buildDataGrid(constraints));

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: const Align(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ));
      }

      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }
}

class MemberDataSource extends DataGridSource {
  MemberDataSource({List<FilterMember>? data}) {
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
                      ? DateTime.parse(e.quarantinedAt!)
                      : null),
              DataGridCell<DateTime?>(
                  columnName: 'quarantinedFinishExpectedAt',
                  value: e.quarantinedFinishExpectedAt != null
                      ? DateTime.parse(e.quarantinedFinishExpectedAt!)
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
                          builder: (context) => UpdateMember(
                                code: row.getCells()[11].value.toString(),
                              )));
                },
                child: Text(
                  row.getCells()[0].value.toString(),
                  style: TextStyle(
                    color: CustomColors.primaryText,
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
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Badge(
            elevation: 0,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            badgeColor: row.getCells()[9].value.toString() == "SERIOUS"
                ? CustomColors.error.withOpacity(0.25)
                : row.getCells()[9].value.toString() == "UNWELL"
                    ? CustomColors.warning.withOpacity(0.25)
                    : CustomColors.success.withOpacity(0.25),
            badgeContent: row.getCells()[9].value.toString() == "SERIOUS"
                ? Text(
                    "Nguy hiểm",
                    style: TextStyle(color: CustomColors.error),
                  )
                : row.getCells()[9].value.toString() == "UNWELL"
                    ? Text(
                        "Không tốt",
                        style: TextStyle(color: CustomColors.warning),
                      )
                    : Text(
                        "Bình thường",
                        style: TextStyle(color: CustomColors.success),
                      ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Badge(
            elevation: 0,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            badgeColor: row.getCells()[10].value == null
                ? CustomColors.secondaryText.withOpacity(0.25)
                : row.getCells()[10].value == true
                    ? CustomColors.error.withOpacity(0.25)
                    : CustomColors.success.withOpacity(0.25),
            badgeContent: row.getCells()[10].value == null
                ? Text(
                    "Chưa có",
                    style: TextStyle(color: CustomColors.secondaryText),
                  )
                : row.getCells()[10].value == true
                    ? Text(
                        "Dương tính",
                        style: TextStyle(color: CustomColors.error),
                      )
                    : Text(
                        "Âm tính",
                        style: TextStyle(color: CustomColors.success),
                      ),
          ),
        ),
        FutureBuilder(
          future: Future.delayed(Duration.zero, () => true),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const SizedBox()
                : menus(
                    context,
                    members.safeFirstWhere(
                        (e) => e.code == row.getCells()[11].value.toString())!);
          },
        ),
      ],
    );
  }
}

Widget menus(BuildContext context, FilterMember item) {
  return PopupMenuButton(
    icon: Icon(
      Icons.more_vert,
      color: CustomColors.disableText,
    ),
    onSelected: (result) {
      if (result == 'update_info') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => UpdateMember(
                      code: item.code,
                    )));
      } else if (result == 'create_medical_declaration') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => MedicalDeclarationScreen(
                      phone: item.phoneNumber,
                    )));
      } else if (result == 'medical_declare_history') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => ListMedicalDeclaration(
                      code: item.code,
                      phone: item.phoneNumber,
                    )));
      } else if (result == 'create_test') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => AddTest(
                      code: item.code,
                      name: item.fullName,
                    )));
      } else if (result == 'test_history') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => ListTest(
                      code: item.code,
                      name: item.fullName,
                    )));
      } else if (result == 'vaccine_dose_history') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => ListVaccineDose(
                      code: item.code,
                    )));
      } else if (result == 'change_room') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => ChangeQuanrantineInfo(
                      code: item.code,
                      quarantineWard: item.quarantineWard,
                    )));
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        child: const Text('Cập nhật thông tin'),
        value: "update_info",
      ),
      PopupMenuItem(
        child: const Text('Khai báo y tế'),
        value: "create_medical_declaration",
      ),
      PopupMenuItem(
        child: const Text('Lịch sử khai báo y tế'),
        value: "medical_declare_history",
      ),
      PopupMenuItem(
        child: const Text('Tạo phiếu xét nghiệm'),
        value: "create_test",
      ),
      PopupMenuItem(
        child: const Text('Lịch sử xét nghiệm'),
        value: "test_history",
      ),
      PopupMenuItem(
        child: const Text('Thông tin tiêm chủng'),
        value: "vaccine_dose_history",
      ),
      PopupMenuItem(
        child: const Text('Chuyển phòng'),
        value: "change_room",
      ),
    ],
  );
}
