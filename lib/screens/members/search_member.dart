import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

List<FilterMember> paginatedDataSource = [];
double pageCount = 0;
final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
DataPagerController _dataPagerController = DataPagerController();

TextEditingController keySearch = TextEditingController();
TextEditingController quarantineWardController = TextEditingController();
TextEditingController quarantineBuildingController = TextEditingController();
TextEditingController quarantineFloorController = TextEditingController();
TextEditingController quarantineRoomController = TextEditingController();
TextEditingController quarantineAtMinController = TextEditingController();
TextEditingController quarantineAtMaxController = TextEditingController();
TextEditingController quarantinedFinishExpectedAtController =
    TextEditingController();
TextEditingController labelController = TextEditingController();
TextEditingController healthStatusController = TextEditingController();
TextEditingController testController = TextEditingController();

class SearchMember extends StatefulWidget {
  SearchMember({Key? key}) : super(key: key);

  @override
  _SearchMemberState createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  List<KeyValue> _quarantineWardList = [];
  List<KeyValue> _quarantineBuildingList = [];
  List<KeyValue> _quarantineFloorList = [];
  List<KeyValue> _quarantineRoomList = [];

  bool _searched = false;

  final PagingController<int, FilterMember> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  MemberDataSource _memberDataSource = MemberDataSource();
  late Future<FilterResponse<FilterMember>> fetch;

  bool showLoadingIndicator = true;

  @override
  void initState() {
    fetchQuarantineWard({
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineWardList = value;
        }));
    fetchQuarantineBuilding({
      'quarantine_ward': quarantineWardController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineBuildingList = value;
        }));
    fetchQuarantineFloor({
      'quarantine_building': quarantineBuildingController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineFloorList = value;
        }));
    fetchQuarantineRoom({
      'quarantine_floor': quarantineFloorController.text,
      'page_size': PAGE_SIZE_MAX,
    }).then((value) => setState(() {
          _quarantineRoomList = value;
        }));

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Có lỗi xảy ra!',
            ),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
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
          quarantineAtMin:
              parseDateToDateTimeWithTimeZone(quarantineAtMinController.text),
          quarantineAtMax:
              parseDateToDateTimeWithTimeZone(quarantineAtMaxController.text),
          quarantinedFinishExpectedAt: parseDateToDateTimeWithTimeZone(
              quarantinedFinishExpectedAtController.text),
          label: labelController.text,
          healthStatus: healthStatusController.text,
          test: testController.text,
        ),
      );

      final isLastPage = newItems.data.length < PAGE_SIZE;
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
          titleSpacing: 0.0,
          title: Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: TextField(
                // maxLines: 1,
                autofocus: true,
                style: TextStyle(fontSize: 17),
                textAlignVertical: TextAlignVertical.center,
                controller: keySearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: CustomColors.secondaryText,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                      keySearch.clear();
                      setState(() {
                        _searched = false;
                      });
                    },
                  ),
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (v) {
                  setState(() {
                    _searched = true;
                  });
                  if (Responsive.isDesktopLayout(context)) {
                    setState(() {});
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
                  quarantinedFinishExpectedAtController:
                      quarantinedFinishExpectedAtController,
                  quarantineWardList: _quarantineWardList,
                  quarantineBuildingList: _quarantineBuildingList,
                  quarantineFloorList: _quarantineFloorList,
                  quarantineRoomList: _quarantineRoomList,
                  labelController: labelController,
                  healthStatusController: healthStatusController,
                  testController: testController,
                  onSubmit: (quarantineWardList, quarantineBuildingList,
                      quarantineFloorList, quarantineRoomList, search) {
                    setState(() {
                      _searched = search;
                      _quarantineWardList = quarantineWardList;
                      _quarantineBuildingList = quarantineBuildingList;
                      _quarantineFloorList = quarantineFloorList;
                      _quarantineRoomList = quarantineRoomList;
                    });
                    if (Responsive.isDesktopLayout(context)) {
                      setState(() {});
                    } else {
                      _pagingController.refresh();
                    }
                  },
                );
              },
              icon: Icon(Icons.filter_list_outlined),
              tooltip: "Lọc",
            )
          ],
        ),
        body: _searched
            ? Responsive.isDesktopLayout(context)
                ? FutureBuilder(
                    future: fetchMemberList(
                      data: filterMemberDataForm(
                        keySearch: keySearch.text,
                        page: 1,
                        quarantineWard: quarantineWardController.text,
                        quarantineBuilding: quarantineBuildingController.text,
                        quarantineFloor: quarantineFloorController.text,
                        quarantineRoom: quarantineRoomController.text,
                        quarantineAtMin: parseDateToDateTimeWithTimeZone(
                            quarantineAtMinController.text),
                        quarantineAtMax: parseDateToDateTimeWithTimeZone(
                            quarantineAtMaxController.text),
                        quarantinedFinishExpectedAt:
                            parseDateToDateTimeWithTimeZone(
                                quarantinedFinishExpectedAtController.text),
                        label: labelController.text,
                        healthStatus: healthStatusController.text,
                        test: testController.text,
                      ),
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<FilterResponse<FilterMember>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data.isEmpty) {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Image.asset(
                                        "assets/images/no_data.png"),
                                  ),
                                  Text('Không có dữ liệu'),
                                ],
                              ),
                            );
                          } else {
                            showLoadingIndicator = false;
                            paginatedDataSource = snapshot.data!.data;
                            pageCount = snapshot.data!.totalPages.toDouble();
                            _memberDataSource.buildDataGridRows();
                            _memberDataSource.updateDataGridSource();
                            return listMemberTable();
                          }
                        }
                      }
                      return Align(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  )
                : listMemberCard(_pagingController)
            : Center(
                child: Text('Tìm kiếm người cách ly'),
              ),
      ),
    );
  }

  Widget listMemberCard(_pagingController) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, FilterMember>(
        padding: EdgeInsets.only(bottom: 16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<FilterMember>(
          animateTransitions: true,
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text('Không có kết quả tìm kiếm'),
          ),
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Text('Có lỗi xảy ra'),
          ),
          itemBuilder: (context, item, index) => MemberCard(
            member: item,
            onTap: () {
              Navigator.of(context,
                      rootNavigator: !Responsive.isDesktopLayout(context))
                  .push(
                MaterialPageRoute(
                  builder: (context) => UpdateMember(
                    code: item.code,
                  ),
                ),
              );
            },
            menus: menus(context, item, pagingController: _pagingController),
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
                      child: buildStack(constraints),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: constraints.maxWidth,
                    child: SfDataPager(
                      controller: _dataPagerController,
                      pageCount: pageCount,
                      direction: Axis.horizontal,
                      onPageNavigationStart: (int pageIndex) {
                        showLoading();
                      },
                      delegate: _memberDataSource,
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

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      key: key,
      allowPullToRefresh: true,
      source: _memberDataSource,
      columnWidthMode: ColumnWidthMode.none,
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
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text('Họ và tên',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'birthday',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Ngày sinh',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'gender',
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text(
                  'Giới tính',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
        GridColumn(
            columnName: 'phoneNumber',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('SDT',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantineWard',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text('Khu cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantineLocation',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text('Phòng',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'label',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Diện cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantinedAt',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Ngày cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantinedFinishExpectedAt',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Ngày dự kiến hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'healthStatus',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Sức khỏe',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'positiveTestNow',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Xét nghiệm',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'action',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Hành động',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
      ],
    );
  }

  Widget buildStack(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];
      stackChildren.add(buildDataGrid(constraints));

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Align(
            alignment: Alignment.center,
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
  MemberDataSource();

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
          quarantineAtMin:
              parseDateToDateTimeWithTimeZone(quarantineAtMinController.text),
          quarantineAtMax:
              parseDateToDateTimeWithTimeZone(quarantineAtMaxController.text),
          quarantinedFinishExpectedAt: parseDateToDateTimeWithTimeZone(
              quarantinedFinishExpectedAtController.text),
          label: labelController.text,
          healthStatus: healthStatusController.text,
        ),
      );
      if (newItems.currentPage <= newItems.totalPages) {
        paginatedDataSource = newItems.data;
        buildDataGridRows();
        notifyListeners();
      } else {
        paginatedDataSource = [];
      }
      return true;
    }
    return false;
  }

  @override
  Future<void> handleRefresh() async {
    int currentPageIndex = _dataPagerController.selectedPageIndex;
    final newItems = await fetchMemberList(
      data: filterMemberDataForm(
        keySearch: keySearch.text,
        page: currentPageIndex + 1,
        quarantineWard: quarantineWardController.text,
        quarantineBuilding: quarantineBuildingController.text,
        quarantineFloor: quarantineFloorController.text,
        quarantineRoom: quarantineRoomController.text,
        quarantineAtMin:
            parseDateToDateTimeWithTimeZone(quarantineAtMinController.text),
        quarantineAtMax:
            parseDateToDateTimeWithTimeZone(quarantineAtMaxController.text),
        quarantinedFinishExpectedAt: parseDateToDateTimeWithTimeZone(
            quarantinedFinishExpectedAtController.text),
        label: labelController.text,
        healthStatus: healthStatusController.text,
      ),
    );
    if (newItems.currentPage <= newItems.totalPages) {
      paginatedDataSource = newItems.data;
      pageCount = newItems.totalPages.toDouble();
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
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
          future: Future.delayed(Duration(milliseconds: 0), () => true),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[1].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[1].value)
                : "",
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child:
              Text(row.getCells()[2].value.toString() == "MALE" ? "Nam" : "Nữ"),
        ),
        Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              row.getCells()[3].value.toString(),
            )),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[5].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(row.getCells()[6].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[7].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[7].value)
                : "",
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[8].value != null
                ? DateFormat('dd/MM/yyyy').format(row.getCells()[8].value)
                : "",
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
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
          future: Future.delayed(Duration(milliseconds: 0), () => true),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? SizedBox()
                : menus(
                    context,
                    paginatedDataSource.safeFirstWhere(
                        (e) => e.code == row.getCells()[11].value.toString())!);
          },
        ),
      ],
    );
  }
}

Widget menus(BuildContext context, FilterMember item,
    {PagingController<int, FilterMember>? pagingController}) {
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
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        child: Text('Cập nhật thông tin'),
        value: "update_info",
      ),
      PopupMenuItem(
        child: Text('Khai báo y tế'),
        value: "create_medical_declaration",
      ),
      PopupMenuItem(
        child: Text('Lịch sử khai báo y tế'),
        value: "medical_declare_history",
      ),
      PopupMenuItem(
        child: Text('Tạo phiếu xét nghiệm'),
        value: "create_test",
      ),
      PopupMenuItem(
        child: Text('Lịch sử xét nghiệm'),
        value: "test_history",
      ),
    ],
  );
}
