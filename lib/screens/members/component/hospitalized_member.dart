import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

List<FilterMember> paginatedDataSource = [];
double pageCount = 1;
final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
DataPagerController _dataPagerController = DataPagerController();

class HospitalizedMember extends StatefulWidget {
  HospitalizedMember({Key? key}) : super(key: key);

  @override
  _HospitalizedMemberState createState() => _HospitalizedMemberState();
}

class _HospitalizedMemberState extends State<HospitalizedMember>
    with AutomaticKeepAliveClientMixin<HospitalizedMember> {
  final PagingController<int, FilterMember> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  MemberDataSource _memberDataSource = MemberDataSource();
  late Future<FilterResponse<FilterMember>> fetch;

  bool showLoadingIndicator = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
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
    fetch = fetchMemberList(data: {
      'page': 1,
      'status_list': "LEAVE",
      'quarantined_status_list': "HOSPITALIZE"
    });
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchMemberList(data: {
        'page': pageKey,
        'status_list': "LEAVE",
        'quarantined_status_list': "HOSPITALIZE"
      });

      final isLastPage = newItems.data.length < PAGE_SIZE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + 1;
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
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Image.asset("assets/images/no_data.png"),
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
        : listMemberCard(_pagingController);
  }

  Widget listMemberCard(_pagingController) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, FilterMember>(
          padding: EdgeInsets.only(bottom: 70),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<FilterMember>(
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset("assets/images/no_data.png"),
                  ),
                  Text('Không có dữ liệu'),
                ],
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text('Có lỗi xảy ra'),
            ),
            itemBuilder: (context, item, index) => MemberCard(
              member: item,
              isThreeLine: false,
              onTap: () {
                Navigator.of(context,
                        rootNavigator: !Responsive.isDesktopLayout(context))
                    .push(MaterialPageRoute(
                        builder: (context) => UpdateMember(
                              code: item.code,
                            )));
              },
              menus: menus(context, item),
            ),
          ),
        ),
      ),
    );
  }

  Widget listMemberTable() {
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
    );
  }

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      key: key,
      allowPullToRefresh: true,
      source: _memberDataSource,
      columnWidthMode: ColumnWidthMode.auto,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      allowSorting: true,
      allowMultiColumnSorting: true,
      allowTriStateSorting: true,
      selectionMode: SelectionMode.multiple,
      showCheckboxColumn: true,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'fullName',
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
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text('Khu cách ly',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'quarantineLocation',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text('Phòng',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'healthStatus',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: Text('Sức khỏe',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'positiveTestNow',
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
      final newItems = await fetchMemberList(data: {
        'page': newPageIndex + 1,
        'status_list': "LEAVE",
        'quarantined_status_list': "HOSPITALIZE"
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
    final newItems = await fetchMemberList(data: {
      'page': currentPageIndex + 1,
      'status_list': "LEAVE",
      'quarantined_status_list': "HOSPITALIZE"
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
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[0].value.toString()),
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
            overflow: TextOverflow.ellipsis,
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
          child: Text(
            row.getCells()[6].value.toString() == "SERIOUS"
                ? "Nguy hiểm"
                : (row.getCells()[6].toString() == "UNWELL"
                    ? "Không tốt"
                    : "Bình thường"),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(row.getCells()[7].value != null
                ? (row.getCells()[7].value == true ? "Dương tính" : "Âm tính")
                : "Chưa có")),
        FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500), () => true),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? SizedBox()
                : menus(
                    context,
                    paginatedDataSource.safeFirstWhere(
                        (e) => e.code == row.getCells()[8].value.toString())!);
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
    onSelected: (result) async {
      if (result == 'update_info') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => UpdateMember(
                      code: item.code,
                    )));
      } else if (result == 'medical_declare_history') {
        Navigator.of(context,
                rootNavigator: !Responsive.isDesktopLayout(context))
            .push(MaterialPageRoute(
                builder: (context) => ListMedicalDeclaration(
                      code: item.code,
                      phone: item.phoneNumber,
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
      } else if (result == 'move_hospital') {}
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        child: Text('Cập nhật thông tin'),
        value: "update_info",
      ),
      PopupMenuItem(
        child: Text('Lịch sử khai báo y tế'),
        value: "medical_declare_history",
      ),
      PopupMenuItem(
        child: Text('Lịch sử xét nghiệm'),
        value: "test_history",
      ),
      PopupMenuItem(
        child: Text('Thông tin tiêm chủng'),
        value: "vaccine_dose_history",
      ),
      PopupMenuItem(
        child: Text('Chuyển viện'),
        value: "move_hospital",
      ),
    ],
  );
}