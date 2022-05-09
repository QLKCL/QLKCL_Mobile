import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/screens/test/component/test_form.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class AddTest extends StatefulWidget {
  static const String routeName = "/add_test";
  const AddTest({Key? key, this.phoneNumber, this.name}) : super(key: key);
  final String? phoneNumber;
  final String? name;

  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo phiếu xét nghiệm'),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.input,
              ),
              tooltip: "Import",
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
                        "https://docs.google.com/spreadsheets/d/1rCrnCv1aFXa8hfrGsAPWfa1brh2C6bDt/edit?usp=sharing&ouid=101792372176143715365&rtpof=true&sd=true");
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
          ],
        ),
        body: TestForm(
          user: (widget.phoneNumber != null && widget.name != null)
              ? KeyValue(id: widget.phoneNumber, name: widget.name)
              : null,
          mode: Permission.add,
        ),
      ),
    );
  }
}

void importDataFromExcel() async {
  final files = (await FilePicker.platform.pickFiles(
    type: FileType.custom,
    onFileLoading: print,
    allowedExtensions: ['csv', 'xls', 'xlsx'],
  ))
      ?.files;

  if (files?.first != null) {
    importTest(files!.first);
  }
}
