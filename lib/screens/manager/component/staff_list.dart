import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/manager/update_manager_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

List<FilterStaff> paginatedDataSource = [];
double pageCount = 0;
final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
DataPagerController _dataPagerController = DataPagerController();

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
  final PagingController<int, FilterStaff> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  MemberDataSource memberDataSource = MemberDataSource();
  late Future<FilterResponse<FilterStaff>> fetch;

  bool showLoadingIndicator = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    StaffList.currentQuarrantine = widget.quarrantine;
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        showNotification("Có lỗi xảy ra!", status: Status.error);
      }
    });
    super.initState();
    fetch = fetchStaffList(data: {
      'page': 1,
      'quarantine_ward_id': widget.quarrantine?.id,
    });
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var newItems = await fetchStaffList(data: {
        'page': pageKey,
        'quarantine_ward_id': widget.quarrantine?.id,
      });

      var isLastPage = newItems.data.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data);
      } else {
        var nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Responsive.isDesktopLayout(context)
        ? FutureBuilder(
            future: fetch,
            builder: (BuildContext context,
                AsyncSnapshot<FilterResponse<FilterStaff>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.data.isEmpty) {
                    return Center(
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
                    );
                  } else {
                    showLoadingIndicator = false;
                    paginatedDataSource = snapshot.data!.data;
                    pageCount = snapshot.data!.totalPages.toDouble();
                    memberDataSource.buildDataGridRows();
                    memberDataSource.updateDataGridSource();
                    return listTable();
                  }
                }
              }
              return const Align(
                child: CircularProgressIndicator(),
              );
            },
          )
        : listCard(_pagingController);
  }

  Widget listCard(_pagingController) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, FilterStaff>(
        padding: const EdgeInsets.only(bottom: 70),
        pagingController: _pagingController,
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
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: const Text('Có lỗi xảy ra'),
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
            menus: menus(context, item),
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
              Expanded(
                child: SizedBox(
                  height: constraints.maxHeight - 60,
                  width: constraints.maxWidth,
                  child: buildStack(constraints),
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
                  delegate: memberDataSource,
                  onPageNavigationEnd: (int pageIndex) {
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

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      key: key,
      allowPullToRefresh: true,
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
            columnWidthMode: ColumnWidthMode.auto,
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
            columnName: 'status',
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: const Text('Trạng thái tài khoản',
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
  MemberDataSource();

  List<DataGridRow> _memberData = [];

  @override
  List<DataGridRow> get rows => _memberData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (oldPageIndex != newPageIndex) {
      var newItems = await fetchStaffList(data: {
        'page': newPageIndex + 1,
        'quarantine_ward_id': StaffList.currentQuarrantine?.id,
      });
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
    var newItems = await fetchStaffList(data: {
      'page': currentPageIndex + 1,
      'quarantine_ward_id': StaffList.currentQuarrantine?.id
    });
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
                  value: DateFormat('dd/MM/yyyy').parse(e.birthday)),
              DataGridCell<String>(columnName: 'gender', value: e.gender),
              DataGridCell<String>(
                  columnName: 'phoneNumber', value: e.phoneNumber),
              DataGridCell<String>(
                  columnName: 'quarantineWard', value: e.quarantineWard.name),
              DataGridCell<String>(columnName: 'status', value: e.status),
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
          alignment: Alignment.center,
          child: Text(
            row.getCells()[5].value.toString(),
          ),
        ),
        FutureBuilder(
          future: Future.delayed(Duration.zero, () => true),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const SizedBox()
                : menus(
                    context,
                    paginatedDataSource.safeFirstWhere(
                        (e) => e.code == row.getCells()[6].value.toString())!);
          },
        ),
      ],
    );
  }
}

Widget menus(BuildContext context, FilterStaff item) {
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
                builder: (context) => UpdateManager(
                      code: item.code,
                    )));
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        child: const Text('Cập nhật thông tin'),
        value: "update_info",
      ),
    ],
  );
}
