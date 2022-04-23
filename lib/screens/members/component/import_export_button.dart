import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel
    hide Alignment, Column, Row, Border;
import 'package:url_launcher/url_launcher.dart';

// Platform specific import
import '../../../helper/save_mobile.dart'
    if (dart.library.html) '../../../helper/save_web.dart' as helper;

Widget buildExportingButtons(GlobalKey<SfDataGridState> key) {
  Future<void> exportDataGridToExcel() async {
    final excel.Workbook workbook = key.currentState!.exportToExcelWorkbook(
      cellExport: (DataGridCellExcelExportDetails details) {},
      excludeColumns: ['code'],
    );
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'ExportFile.xlsx');
  }

  return Container(
    margin: const EdgeInsets.all(8),
    height: 36,
    child: TextButton(
      onPressed: exportDataGridToExcel,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.output,
                size: 22,
                color: primaryText,
              ),
            ),
            const TextSpan(
              text: " Export",
            )
          ],
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(disable),
      ),
    ),
  );
}

Widget buildImportingButtons() {
  void importDataFromExcel() async {
    final files = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      onFileLoading: print,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    ))
        ?.files;

    if (files?.first != null) {
      importMember(files!.first);
    }
  }

  return Container(
    margin: const EdgeInsets.all(8),
    height: 36,
    decoration:
        BoxDecoration(color: disable, borderRadius: BorderRadius.circular(4)),
    child: TooltipVisibility(
      visible: false,
      child: PopupMenuButton(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.input,
                    size: 22,
                    color: primaryText,
                  ),
                ),
                const TextSpan(
                  text: " Import",
                )
              ],
            ),
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.file_download_outlined,
                  color: primaryText,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Tải xuống file mẫu',
                ),
              ],
            ),
            onTap: () async {
              launch(
                  "https://docs.google.com/spreadsheets/d/1ItVphe7GZRb-Bafiw_OFEAtSSDUgD71i/edit?usp=sharing&ouid=101792372176143715365&rtpof=true&sd=true");
            },
          ),
          PopupMenuItem(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.file_upload_outlined,
                  color: primaryText,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text('Tải lên'),
              ],
            ),
            onTap: importDataFromExcel,
          ),
        ],
      ),
    ),
  );
}

Widget searchBox(
    GlobalKey<SfDataGridState> key, TextEditingController keySearch) {
  return Container(
    margin: const EdgeInsets.all(8),
    alignment: Alignment.centerLeft,
    width: 400,
    height: 36,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(30)),
    child: TextField(
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
                  key.currentState!.refresh();
                },
              )
            : null,
        hintText: 'Tìm kiếm...',
        filled: false,
      ),
      onSubmitted: (v) {
        key.currentState!.refresh();
      },
    ),
  );
}
