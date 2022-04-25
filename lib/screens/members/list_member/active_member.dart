import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/members/component/buttons.dart';
import 'package:qlkcl/screens/members/component/menus.dart';
import 'package:qlkcl/screens/members/component/table.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

// cre: https://pub.dev/packages/infinite_scroll_pagination/example
// cre: https://help.syncfusion.com/flutter/datagrid/paging

DataPagerController _dataPagerController = DataPagerController();
TextEditingController keySearch = TextEditingController();

class ActiveMember extends StatefulWidget {
  const ActiveMember({Key? key}) : super(key: key);

  @override
  _ActiveMemberState createState() => _ActiveMemberState();
}

class _ActiveMemberState extends State<ActiveMember>
    with AutomaticKeepAliveClientMixin<ActiveMember> {
  final PagingController<int, FilterMember> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late DataSource dataSource;
  double pageCount = 0;
  List<FilterMember> paginatedDataSource = [];
  late Future<FilterResponse<FilterMember>> fetch;

  bool showLoadingIndicator = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        showNotification("Có lỗi xảy ra!", status: Status.error);
      }
    });
    super.initState();
    fetchMemberList(data: {
      "search": keySearch.text,
      'page': 1,
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
    // _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchMemberList(data: {
        "search": keySearch.text,
        'page': pageKey,
      });

      final isLastPage = newItems.data.length < pageSize;
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
                : listMemberTable()
        : listMemberCard();
  }

  Widget listMemberCard() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(_pagingController.refresh),
      child: PagedListView<int, FilterMember>(
        padding: const EdgeInsets.only(bottom: 70),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<FilterMember>(
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
          itemBuilder: (context, item, index) => MemberCard(
            member: item,
            onTap: () {
              Navigator.of(context,
                      rootNavigator: !Responsive.isDesktopLayout(context))
                  .push(MaterialPageRoute(
                      builder: (context) => UpdateMember(
                            code: item.code,
                          )));
            },
            menus: menus(
              context,
              item,
              showMenusItems: [
                menusOptions.updateInfo,
                menusOptions.createMedicalDeclaration,
                menusOptions.medicalDeclareHistory,
                menusOptions.createTest,
                menusOptions.testHistory,
                menusOptions.vaccineDoseHistory,
                menusOptions.changeRoom,
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
                        buildImportingButton(),
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
                  delegate: dataSource,
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
    required List<FilterMember> memberData,
  }) {
    _paginatedRows = memberData;
    buildDataGridRows();
  }

  Function updatePageCount;
  GlobalKey<SfDataGridState> key;

  List<DataGridRow> _memberData = [];
  List<FilterMember> _paginatedRows = [];

  @override
  List<DataGridRow> get rows => _memberData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (oldPageIndex != newPageIndex) {
      final newItems = await fetchMemberList(data: {
        "search": keySearch.text,
        'page': newPageIndex + 1,
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
    final newItems = await fetchMemberList(data: {
      "search": keySearch.text,
      'page': currentPageIndex + 1,
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
                          builder: (context) => UpdateMember(
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
                    _paginatedRows.safeFirstWhere(
                        (e) => e.code == row.getCells()[11].value.toString())!,
                    showMenusItems: [
                      menusOptions.updateInfo,
                      menusOptions.createMedicalDeclaration,
                      menusOptions.medicalDeclareHistory,
                      menusOptions.createTest,
                      menusOptions.testHistory,
                      menusOptions.vaccineDoseHistory,
                      menusOptions.changeRoom,
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
