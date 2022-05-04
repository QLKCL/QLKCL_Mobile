import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/table.dart';
import 'package:qlkcl/screens/members/timeline_member_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

List<FilterMember> paginatedDataSource = [];
double pageCount = 0;
DataPagerController _dataPagerController = DataPagerController();

TextEditingController keySearch = TextEditingController();
TextEditingController quarantineWardController = TextEditingController();
TextEditingController quarantineBuildingController = TextEditingController();
TextEditingController quarantineFloorController = TextEditingController();
TextEditingController quarantineRoomController = TextEditingController();
TextEditingController quarantineAtMinController = TextEditingController();
TextEditingController quarantineAtMaxController = TextEditingController();
TextEditingController quarantinedFinishExpectedAtMinController =
    TextEditingController();
TextEditingController quarantinedFinishExpectedAtMaxController =
    TextEditingController();
TextEditingController labelController = TextEditingController();
TextEditingController healthStatusController = TextEditingController();
TextEditingController testController = TextEditingController();
TextEditingController careStaffController = TextEditingController();

class SearchMember extends StatefulWidget {
  const SearchMember({Key? key}) : super(key: key);

  @override
  _SearchMemberState createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  List<KeyValue> _quarantineWardList = [];
  List<KeyValue> _quarantineBuildingList = [];
  List<KeyValue> _quarantineFloorList = [];
  List<KeyValue> _quarantineRoomList = [];
  List<KeyValue> _careStaffList = [];

  bool _searched = false;

  final PagingController<int, FilterMember> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late DataSource dataSource;
  late Future<FilterResponse<FilterMember>> fetch;

  bool showLoadingIndicator = true;

  @override
  void initState() {
    dataSource = DataSource(key);
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Có lỗi xảy ra!',
            ),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: _pagingController.retryLastFailedRequest,
            ),
          ),
        );
      }
    });

    super.initState();
    fetchQuarantineWard({
      'page_size': pageSizeMax,
    }).then((value) {
      if (mounted) {
        setState(() {
          _quarantineWardList = value;
        });
      }
    });
    if (quarantineWardController.text != "") {
      fetchQuarantineBuilding({
        'quarantine_ward': quarantineWardController.text,
        'page_size': pageSizeMax,
      }).then((value) {
        if (mounted) {
          setState(() {
            _quarantineBuildingList = value;
          });
        }
      });
    }
    if (quarantineBuildingController.text != "") {
      fetchQuarantineFloor({
        'quarantine_building_id_list': quarantineBuildingController.text,
        'page_size': pageSizeMax,
      }).then((value) {
        if (mounted) {
          setState(() {
            _quarantineFloorList = value;
          });
        }
      });
    }
    if (quarantineFloorController.text != "") {
      fetchQuarantineRoom({
        'quarantine_floor': quarantineFloorController.text,
        'page_size': pageSizeMax,
      }).then((value) {
        if (mounted) {
          setState(() {
            _quarantineRoomList = value;
          });
        }
      });
    }
    fetchNotMemberList({
      'role_name_list': 'STAFF,MANAGER',
      'quarantine_ward_id': quarantineWardController.text != ""
          ? quarantineWardController.text
          : null
    }).then((value) {
      if (mounted) {
        setState(() {
          _careStaffList = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<FilterResponse<FilterMember>> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchMemberList(
        data: filterMemberDataForm(
          keySearch: keySearch.text,
          page: pageKey,
          quarantineWard: quarantineWardController.text,
          quarantineBuilding: quarantineBuildingController.text,
          quarantineFloor: quarantineFloorController.text,
          quarantineRoom: quarantineRoomController.text,
          quarantineAtMin: parseDateTimeWithTimeZone(
              quarantineAtMinController.text,
              time: "00:00"),
          quarantineAtMax:
              parseDateTimeWithTimeZone(quarantineAtMaxController.text),
          quarantinedFinishExpectedAtMin: parseDateTimeWithTimeZone(
              quarantinedFinishExpectedAtMinController.text,
              time: "00:00"),
          quarantinedFinishExpectedAtMax: parseDateTimeWithTimeZone(
              quarantinedFinishExpectedAtMaxController.text),
          label: labelController.text,
          healthStatus: healthStatusController.text,
          test: testController.text,
          careStaff: careStaffController.text,
        ),
      );

      final isLastPage = newItems.data.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data, nextPageKey);
      }
      return newItems;
    } catch (error) {
      _pagingController.error = error;
      return FilterResponse<FilterMember>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 17),
                textAlignVertical: TextAlignVertical.center,
                controller: keySearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(
                    Icons.search,
                    color: secondaryText,
                  ),
                  suffixIcon: keySearch.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            /* Clear the search field */
                            keySearch.clear();
                            setState(() {
                              _searched = false;
                            });
                          },
                        )
                      : null,
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (v) {
                  setState(() {
                    _searched = true;
                  });
                  if (Responsive.isDesktopLayout(context)) {
                    setState(() {
                      fetch = fetchMemberList(
                        data: filterMemberDataForm(
                          keySearch: keySearch.text,
                          page: 1,
                          quarantineWard: quarantineWardController.text,
                          quarantineBuilding: quarantineBuildingController.text,
                          quarantineFloor: quarantineFloorController.text,
                          quarantineRoom: quarantineRoomController.text,
                          quarantineAtMin: parseDateTimeWithTimeZone(
                              quarantineAtMinController.text,
                              time: "00:00"),
                          quarantineAtMax: parseDateTimeWithTimeZone(
                              quarantineAtMaxController.text),
                          quarantinedFinishExpectedAtMin:
                              parseDateTimeWithTimeZone(
                                  quarantinedFinishExpectedAtMinController.text,
                                  time: "00:00"),
                          quarantinedFinishExpectedAtMax:
                              parseDateTimeWithTimeZone(
                                  quarantinedFinishExpectedAtMaxController
                                      .text),
                          label: labelController.text,
                          healthStatus: healthStatusController.text,
                          test: testController.text,
                          careStaff: careStaffController.text,
                        ),
                      );
                    });
                  } else {
                    _pagingController.refresh();
                  }
                },
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                memberFilter(
                  context,
                  quarantineWardController: quarantineWardController,
                  quarantineBuildingController: quarantineBuildingController,
                  quarantineFloorController: quarantineFloorController,
                  quarantineRoomController: quarantineRoomController,
                  quarantineAtMinController: quarantineAtMinController,
                  quarantineAtMaxController: quarantineAtMaxController,
                  quarantinedFinishExpectedAtMinController:
                      quarantinedFinishExpectedAtMinController,
                  quarantinedFinishExpectedAtMaxController:
                      quarantinedFinishExpectedAtMaxController,
                  quarantineWardList: _quarantineWardList,
                  quarantineBuildingList: _quarantineBuildingList,
                  quarantineFloorList: _quarantineFloorList,
                  quarantineRoomList: _quarantineRoomList,
                  careStaffList: _careStaffList,
                  labelController: labelController,
                  healthStatusController: healthStatusController,
                  testController: testController,
                  careStaffController: careStaffController,
                  onSubmit: (quarantineWardList,
                      quarantineBuildingList,
                      quarantineFloorList,
                      quarantineRoomList,
                      careStaffList,
                      search) {
                    setState(() {
                      _searched = search;
                      _quarantineWardList = quarantineWardList;
                      _quarantineBuildingList = quarantineBuildingList;
                      _quarantineFloorList = quarantineFloorList;
                      _quarantineRoomList = quarantineRoomList;
                      _careStaffList = careStaffList;
                    });
                    if (Responsive.isDesktopLayout(context)) {
                      setState(() {
                        fetch = fetchMemberList(
                          data: filterMemberDataForm(
                            keySearch: keySearch.text,
                            page: 1,
                            quarantineWard: quarantineWardController.text,
                            quarantineBuilding:
                                quarantineBuildingController.text,
                            quarantineFloor: quarantineFloorController.text,
                            quarantineRoom: quarantineRoomController.text,
                            quarantineAtMin: parseDateTimeWithTimeZone(
                                quarantineAtMinController.text,
                                time: "00:00"),
                            quarantineAtMax: parseDateTimeWithTimeZone(
                                quarantineAtMaxController.text),
                            quarantinedFinishExpectedAtMin:
                                parseDateTimeWithTimeZone(
                                    quarantinedFinishExpectedAtMinController
                                        .text,
                                    time: "00:00"),
                            quarantinedFinishExpectedAtMax:
                                parseDateTimeWithTimeZone(
                                    quarantinedFinishExpectedAtMaxController
                                        .text),
                            label: labelController.text,
                            healthStatus: healthStatusController.text,
                            test: testController.text,
                            careStaff: careStaffController.text,
                          ),
                        );
                      });
                    } else {
                      _pagingController.refresh();
                    }
                  },
                  useCustomBottomSheetMode:
                      ResponsiveWrapper.of(context).isLargerThan(MOBILE),
                );
              },
              icon: const Icon(Icons.filter_list_outlined),
              tooltip: "Lọc",
            )
          ],
        ),
        body: _searched
            ? Responsive.isDesktopLayout(context)
                ? FutureBuilder(
                    future: fetch,
                    builder: (BuildContext context,
                        AsyncSnapshot<FilterResponse<FilterMember>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Image.asset(
                                        "assets/images/no_data.png"),
                                  ),
                                  const Text('Không có dữ liệu'),
                                ],
                              ),
                            );
                          } else {
                            showLoadingIndicator = false;
                            paginatedDataSource = snapshot.data!.data;
                            pageCount = snapshot.data!.totalPages.toDouble();
                            dataSource.buildDataGridRows();
                            dataSource.updateDataGridSource();
                            return listMemberTable();
                          }
                        }
                      }
                      return const Align(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                : listMemberCard()
            : const Center(
                child: Text('Tìm kiếm người cách ly'),
              ),
      ),
    );
  }

  Widget listMemberCard() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(_pagingController.refresh),
      child: PagedListView<int, FilterMember>(
        padding: const EdgeInsets.only(bottom: 16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<FilterMember>(
          animateTransitions: true,
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Text('Không có kết quả tìm kiếm'),
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
            child: Text('Có lỗi xảy ra'),
          ),
          itemBuilder: (context, item, index) => MemberCard(
            member: item,
            onTap: () {
              Navigator.of(context,
                      rootNavigator: !Responsive.isDesktopLayout(context))
                  .push(
                MaterialPageRoute(
                  builder: (context) => TimelineMember(code: item.code),
                ),
              );
            },
            menus: menus(
              context,
              item,
              pagingController: _pagingController,
              showMenusItems: [
                menusOptions.updateInfo,
                menusOptions.createMedicalDeclaration,
                menusOptions.medicalDeclareHistory,
                menusOptions.createTest,
                menusOptions.testHistory,
                menusOptions.vaccineDoseHistory,
                menusOptions.resetPassword,
                menusOptions.destinationHistory,
                menusOptions.quarantineHistory,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listMemberTable() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: Responsive.isDesktopLayout(context)
            ? constraints.maxHeight - 20
            : constraints.maxHeight,
        child: Card(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: constraints.maxHeight - 60,
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
                  ),
                  SizedBox(
                    height: 60,
                    width: constraints.maxWidth,
                    child: SfDataPager(
                      controller: _dataPagerController,
                      pageCount: pageCount,
                      onPageNavigationStart: (int pageIndex) {
                        showLoading();
                      },
                      delegate: dataSource,
                      onPageNavigationEnd: (int pageIndex) {
                        BotToast.closeAllLoading();
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }
}

class DataSource extends DataGridSource {
  DataSource(this.key);
  GlobalKey<SfDataGridState> key;

  List<DataGridRow> _memberData = [];

  @override
  List<DataGridRow> get rows => _memberData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (oldPageIndex != newPageIndex) {
      final newItems = await fetchMemberList(
        data: filterMemberDataForm(
          keySearch: keySearch.text,
          page: newPageIndex + 1,
          quarantineWard: quarantineWardController.text,
          quarantineBuilding: quarantineBuildingController.text,
          quarantineFloor: quarantineFloorController.text,
          quarantineRoom: quarantineRoomController.text,
          quarantineAtMin: parseDateTimeWithTimeZone(
              quarantineAtMinController.text,
              time: "00:00"),
          quarantineAtMax:
              parseDateTimeWithTimeZone(quarantineAtMaxController.text),
          quarantinedFinishExpectedAtMin: parseDateTimeWithTimeZone(
              quarantinedFinishExpectedAtMinController.text,
              time: "00:00"),
          quarantinedFinishExpectedAtMax: parseDateTimeWithTimeZone(
              quarantinedFinishExpectedAtMaxController.text),
          label: labelController.text,
          healthStatus: healthStatusController.text,
          test: testController.text,
          careStaff: careStaffController.text,
        ),
      );
      paginatedDataSource = newItems.data;
      pageCount = newItems.totalPages.toDouble();
      buildDataGridRows();
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  Future<void> handleRefresh() async {
    final int currentPageIndex = _dataPagerController.selectedPageIndex;
    final newItems = await fetchMemberList(
      data: filterMemberDataForm(
        keySearch: keySearch.text,
        page: currentPageIndex + 1,
        quarantineWard: quarantineWardController.text,
        quarantineBuilding: quarantineBuildingController.text,
        quarantineFloor: quarantineFloorController.text,
        quarantineRoom: quarantineRoomController.text,
        quarantineAtMin: parseDateTimeWithTimeZone(
            quarantineAtMinController.text,
            time: "00:00"),
        quarantineAtMax:
            parseDateTimeWithTimeZone(quarantineAtMaxController.text),
        quarantinedFinishExpectedAtMin: parseDateTimeWithTimeZone(
            quarantinedFinishExpectedAtMinController.text,
            time: "00:00"),
        quarantinedFinishExpectedAtMax: parseDateTimeWithTimeZone(
            quarantinedFinishExpectedAtMaxController.text),
        label: labelController.text,
        healthStatus: healthStatusController.text,
        test: testController.text,
        careStaff: careStaffController.text,
      ),
    );
    paginatedDataSource = newItems.data;
    pageCount = newItems.totalPages.toDouble();
    buildDataGridRows();
    notifyListeners();
  }

  void buildDataGridRows() {
    _memberData = paginatedDataSource
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
                  row.getCells()[0].value.toString().isNotEmpty
                      ? row.getCells()[0].value.toString()
                      : row.getCells()[11].value.toString(),
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
                    paginatedDataSource.safeFirstWhere(
                        (e) => e.code == row.getCells()[11].value.toString())!,
                    tableKey: key,
                    showMenusItems: [
                      menusOptions.updateInfo,
                      menusOptions.createMedicalDeclaration,
                      menusOptions.medicalDeclareHistory,
                      menusOptions.createTest,
                      menusOptions.testHistory,
                      menusOptions.vaccineDoseHistory,
                      menusOptions.resetPassword,
                      menusOptions.destinationHistory,
                      menusOptions.quarantineHistory,
                    ],
                  );
          },
        ),
      ],
    );
  }
}
