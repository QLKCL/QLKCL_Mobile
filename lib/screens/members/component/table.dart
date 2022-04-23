import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum columns {
  fullName,
  birthday,
  gender,
  phoneNumber,
  quarantineWard,
  quarantineLocation,
  label,
  quarantinedAt,
  quarantinedFinishExpectedAt,
  healthStatus,
  positiveTestNow,
  code,
  accountStatus,
}

Map<columns, GridColumn> columnsValue = {
  columns.fullName: GridColumn(
      columnName: 'fullName',
      columnWidthMode: ColumnWidthMode.fill,
      minimumWidth: 150,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: const Text('Họ và tên',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.birthday: GridColumn(
      columnName: 'birthday',
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Ngày sinh',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.gender: GridColumn(
      columnName: 'gender',
      columnWidthMode: ColumnWidthMode.fitByCellValue,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text(
            'Giới tính',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
  columns.phoneNumber: GridColumn(
      columnName: 'phoneNumber',
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('SDT',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.quarantineWard: GridColumn(
      columnName: 'quarantineWard',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: const Text('Khu cách ly',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.quarantineLocation: GridColumn(
      columnName: 'quarantineLocation',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: const Text('Phòng',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.label: GridColumn(
      columnName: 'label',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Diện cách ly',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.quarantinedAt: GridColumn(
      columnName: 'quarantinedAt',
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Ngày cách ly',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.quarantinedFinishExpectedAt: GridColumn(
      columnName: 'quarantinedFinishExpectedAt',
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Ngày dự kiến hoàn thành',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.healthStatus: GridColumn(
      columnName: 'healthStatus',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Sức khỏe',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.positiveTestNow: GridColumn(
      columnName: 'positiveTestNow',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Xét nghiệm',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.code: GridColumn(
      columnName: 'code',
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Hành động',
              style: TextStyle(fontWeight: FontWeight.bold)))),
  columns.accountStatus: GridColumn(
      columnName: 'accountStatus',
      columnWidthMode: ColumnWidthMode.auto,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: const Text('Trạng thái tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold)))),
};

Widget buildDataGrid(
  GlobalKey<SfDataGridState> key,
  dataSource, {
  DataGridController? dataGridController,
  Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChange,
  List<columns> showColumnItems = const [],
}) {
  return SfDataGrid(
    key: key,
    allowPullToRefresh: true,
    source: dataSource,
    columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
    allowSorting: true,
    allowMultiColumnSorting: true,
    allowTriStateSorting: true,
    selectionMode: SelectionMode.multiple,
    showCheckboxColumn: true,
    controller: dataGridController,
    onSelectionChanged: onSelectionChange,
    columns: showColumnItems
        .map(
          (e) => columnsValue[e],
        )
        .cast<GridColumn>()
        .toList(),
  );
}

Widget buildStack(
  GlobalKey<SfDataGridState> key,
  dataSource,
  BoxConstraints constraints,
  bool showLoadingIndicator, {
  DataGridController? dataGridController,
  Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChange,
  List<columns> showColumnItems = const [],
}) {
  List<Widget> _getChildren() {
    final List<Widget> stackChildren = [];
    stackChildren.add(buildDataGrid(
      key,
      dataSource,
      dataGridController: dataGridController,
      onSelectionChange: onSelectionChange,
      showColumnItems: showColumnItems,
    ));

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
