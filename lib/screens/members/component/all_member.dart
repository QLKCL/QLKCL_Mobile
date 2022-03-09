import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/screens/medical_declaration/list_medical_declaration_screen.dart';
import 'package:qlkcl/screens/medical_declaration/medical_declaration_screen.dart';
import 'package:qlkcl/screens/members/change_quarantine_info.dart';
import 'package:qlkcl/screens/members/update_member_screen.dart';
import 'package:qlkcl/screens/test/add_test_screen.dart';
import 'package:qlkcl/screens/test/list_test_screen.dart';
import 'package:qlkcl/screens/vaccine/list_vaccine_dose_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

// cre: https://pub.dev/packages/infinite_scroll_pagination/example
// cre: https://help.syncfusion.com/flutter/datagrid/paging

class AllMember extends StatefulWidget {
  AllMember({Key? key}) : super(key: key);

  @override
  _AllMemberState createState() => _AllMemberState();
}

List<FilterMember> paginatedDataSource = [];
List<FilterMember> _members = [];

class _AllMemberState extends State<AllMember>
    with AutomaticKeepAliveClientMixin<AllMember> {
  final PagingController<int, FilterMember> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 10);

  late MemberDataSource _memberDataSource = MemberDataSource();

  bool showLoadingIndicator = true;
  double pageCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        showNotification("Có lỗi xảy ra!", status: "error");
      }
    });
    super.initState();
    _fetchPage(1).then((value) => setState((() {
          _members = value;
          paginatedDataSource = _members;
          pageCount = (_members.length / ROWS_PER_PAGE).ceilToDouble();
        })));
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }

  Future<List<FilterMember>> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchMemberList(
          data: {'page': pageKey, 'page_size': PAGE_SIZE_MAX});

      final isLastPage = newItems.length < PAGE_SIZE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      return newItems;
    } catch (error) {
      _pagingController.error = error;
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Responsive.isDesktopLayout(context)
            ? (_members.length > 0
                ? listMemberTable()
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Loading",
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            : listMemberCard(_pagingController),
      ),
    );
  }

  Widget listMemberCard(_pagingController) {
    return PagedListView<int, FilterMember>(
      padding: EdgeInsets.only(bottom: 70),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<FilterMember>(
        animateTransitions: true,
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: Text('Không có dữ liệu'),
        ),
        firstPageErrorIndicatorBuilder: (context) => Center(
          child: Text('Có lỗi xảy ra'),
        ),
        itemBuilder: (context, item, index) => MemberCard(
          member: item,
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => UpdateMember(
                      code: item.code,
                    )));
          },
          menus: menus(context, item),
        ),
      ),
    );
  }

  Widget listMemberTable() {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 128),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(children: [
            Column(
              children: [
                SizedBox(
                    height: constraints.maxHeight - 60,
                    width: constraints.maxWidth,
                    child: buildStack(constraints)),
                Container(
                  height: 60,
                  width: constraints.maxWidth,
                  child: SfDataPager(
                    pageCount: pageCount,
                    direction: Axis.horizontal,
                    onPageNavigationStart: (int pageIndex) {
                      setState(() {
                        showLoadingIndicator = true;
                      });
                    },
                    delegate: _memberDataSource,
                    onPageNavigationEnd: (int pageIndex) {
                      setState(() {
                        showLoadingIndicator = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ]);
        },
      ),
    );
  }

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      source: _memberDataSource,
      columnWidthMode: ColumnWidthMode.lastColumnFill,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      allowSorting: true,
      rowsPerPage: ROWS_PER_PAGE,
      selectionMode: SelectionMode.single,
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
  MemberDataSource() {
    paginatedDataSource =
        _members.length > 0 ? _members.getRange(0, 10).toList() : [];
    buildDataGridRows();
  }

  List<DataGridRow> _memberData = [];

  @override
  List<DataGridRow> get rows => _memberData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * ROWS_PER_PAGE;
    int endIndex = startIndex + ROWS_PER_PAGE;
    if (startIndex < _members.length) {
      if (endIndex > _members.length) {
        endIndex = _members.length;
      }
      paginatedDataSource =
          _members.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _memberData = paginatedDataSource
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'fullName', value: e.fullName),
              DataGridCell<String>(columnName: 'birthday', value: e.birthday),
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
              DataGridCell<String>(
                  columnName: 'positiveTestNow',
                  value: e.positiveTestNow.toString()),
              DataGridCell<String>(columnName: 'code', value: e.code),
            ],
          ),
        )
        .toList();
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
          child: 
          // Text(
            // DateFormat("dd/MM/yyyy")
            //     .format(DateTime.parse(row.getCells()[1].value.toString())),
          // ),
          Text(row.getCells()[1].value.toString()),
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
                    _members.safeFirstWhere(
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
    onSelected: (result) {
      if (result == 'update_info') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => UpdateMember(
                  code: item.code,
                )));
      } else if (result == 'create_medical_declaration') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => MedicalDeclarationScreen(
                  phone: item.phoneNumber,
                )));
      } else if (result == 'medical_declare_history') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ListMedicalDeclaration(
                  code: item.code,
                  phone: item.phoneNumber,
                )));
      } else if (result == 'create_test') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => AddTest(
                  code: item.code,
                  name: item.fullName,
                )));
      } else if (result == 'test_history') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ListTest(
                  code: item.code,
                  name: item.fullName,
                )));
      } else if (result == 'vaccine_dose_history') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ListVaccineDose(
                  code: item.code,
                )));
      } else if (result == 'change_room') {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ChangeQuanrantineInfo(
                  code: item.code,
                  quarantineWard: item.quarantineWard,
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
      PopupMenuItem(
        child: Text('Thông tin tiêm chủng'),
        value: "vaccine_dose_history",
      ),
      PopupMenuItem(
        child: Text('Chuyển phòng'),
        value: "change_room",
      ),
    ],
  );
}
