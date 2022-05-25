import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/manager/update_manager_screen.dart';
import 'package:qlkcl/screens/members/component/buttons.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/table.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

DataPagerController _dataPagerController = DataPagerController();
TextEditingController keySearch = TextEditingController();

class StaffList extends StatefulWidget {
  const StaffList({
    Key? key,
    required this.quarrantine,
  }) : super(key: key);
  final KeyValue? quarrantine;
  static KeyValue? currentQuarrantine;

  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList>
    with AutomaticKeepAliveClientMixin<StaffList> {
  final PagingController<int, FilterStaff> pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late DataSource dataSource;
  double pageCount = 0;
  List<FilterStaff> paginatedDataSource = [];
  late Future<FilterResponse<FilterStaff>> fetch;

  bool showLoadingIndicator = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    StaffList.currentQuarrantine = widget.quarrantine;
    pagingController.addPageRequestListener(_fetchPage);
    pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        showNotification("Có lỗi xảy ra!", status: Status.error);
      }
    });
    super.initState();
    fetchStaffList(data: {
      "search": keySearch.text,
      'page': 1,
      'quarantine_ward_id': widget.quarrantine?.id,
    }).then((data) {
      showLoadingIndicator = false;
      paginatedDataSource = data.data;
      pageCount = data.totalPages.toDouble();
      dataSource = DataSource(
        key,
        (value) {
          setState(() {
            pageCount = value;
          });
        },
        memberData: paginatedDataSource,
      );
      dataSource.buildDataGridRows();
      dataSource.updateDataGridSource();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchStaffList(data: {
        "search": keySearch.text,
        'page': pageKey,
        'quarantine_ward_id': widget.quarrantine?.id,
      });

      final isLastPage = newItems.data.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems.data, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Responsive.isDesktopLayout(context)
        ? showLoadingIndicator
            ? const Align(
                child: CircularProgressIndicator(),
              )
            : paginatedDataSource.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Image.asset("assets/images/no_data.png"),
                        ),
                        const Text('Không có dữ liệu'),
                      ],
                    ),
                  )
                : listTable()
        : listCard(pagingController);
  }

  Widget listCard(pagingController) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => pagingController.refresh(),
      ),
      child: PagedListView<int, FilterStaff>(
        padding: const EdgeInsets.only(bottom: 70),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<FilterStaff>(
          animateTransitions: true,
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Image.asset("assets/images/no_data.png"),
                ),
                const Text('Không có dữ liệu'),
              ],
            ),
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
            child: Text('Có lỗi xảy ra'),
          ),
          itemBuilder: (context, item, index) => ManagerCard(
            manager: item,
            onTap: () {
              Navigator.of(context,
                      rootNavigator: !Responsive.isDesktopLayout(context))
                  .push(MaterialPageRoute(
                      builder: (context) => UpdateManager(
                            code: item.code,
                          )));
            },
            menus: menus(
              context,
              item,
              showMenusItems: [
                menusOptions.updateInfo,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTable() {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchBox(key, keySearch),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildExportingButton(key),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: constraints.maxHeight - 120,
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
                      columns.accountStatus,
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
                  delegate: dataSource,
                  onPageNavigationStart: (pageIndex) {
                    showLoading();
                  },
                  onPageNavigationEnd: (pageIndex) {
                    BotToast.closeAllLoading();
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class DataSource extends DataGridSource {
  DataSource(
    this.key,
    this.updatePageCount, {
    required List<FilterStaff> memberData,
  }) {
    _paginatedRows = memberData;
    buildDataGridRows();
  }

  Function updatePageCount;
  GlobalKey<SfDataGridState> key;

  List<DataGridRow> _memberData = [];
  List<FilterStaff> _paginatedRows = [];

  @override
  List<DataGridRow> get rows => _memberData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (oldPageIndex != newPageIndex) {
      final newItems = await fetchStaffList(data: {
        "search": keySearch.text,
        'page': newPageIndex + 1,
        'quarantine_ward_id': StaffList.currentQuarrantine?.id,
      });
      _paginatedRows = newItems.data;
      updatePageCount(newItems.totalPages.toDouble());
      buildDataGridRows();
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  Future<void> handleRefresh() async {
    final int currentPageIndex = _dataPagerController.selectedPageIndex;
    final newItems = await fetchStaffList(data: {
      "search": keySearch.text,
      'page': currentPageIndex + 1,
      'quarantine_ward_id': StaffList.currentQuarrantine?.id
    });
    _paginatedRows = newItems.data;
    updatePageCount(newItems.totalPages.toDouble());
    buildDataGridRows();
    notifyListeners();
  }

  void buildDataGridRows() {
    _memberData = _paginatedRows
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'fullName', value: e.fullName),
              DataGridCell<DateTime?>(
                  columnName: 'birthday',
                  value: DateFormat('dd/MM/yyyy').parse(e.birthday)),
              DataGridCell<String>(columnName: 'gender', value: e.gender),
              DataGridCell<String>(
                  columnName: 'phoneNumber', value: e.phoneNumber),
              DataGridCell<String>(
                  columnName: 'quarantineWard', value: e.quarantineWard.name),
              DataGridCell<String>(
                  columnName: 'accountStatus', value: e.status),
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
                          builder: (context) => UpdateManager(
                                code: row.getCells()[6].value.toString(),
                              )));
                },
                child: Text(
                  row.getCells()[0].value.toString().isNotEmpty
                      ? row.getCells()[0].value.toString()
                      : row.getCells()[6].value.toString(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: row.getCells()[5].value.toString() == "LOCKED"
                    ? error.withOpacity(0.25)
                    : row.getCells()[5].value.toString() == "LEAVE"
                        ? warning.withOpacity(0.25)
                        : success.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: row.getCells()[5].value.toString() == "LOCKED"
                  ? Text(
                      "Đã khóa",
                      style: TextStyle(color: error),
                    )
                  : row.getCells()[5].value.toString() == "LEAVE"
                      ? Text(
                          "Không hoạt động",
                          style: TextStyle(color: warning),
                        )
                      : Text(
                          "Hoạt động",
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
                    _paginatedRows.safeFirstWhere(
                        (e) => e.code == row.getCells()[6].value.toString())!,
                    showMenusItems: [
                      menusOptions.updateManagerInfo,
                    ],
                  );
          },
        ),
      ],
    );
  }
}
