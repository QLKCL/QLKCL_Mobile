import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class AddTest extends StatefulWidget {
  static const String routeName = "/add_test";
  AddTest({Key? key}) : super(key: key);

  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Tạo phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Input(
                  label: 'Mã phiếu',
                  required: true,
                  enabled: false,
                  initValue: "PCR-123456",
                ),
              ),
              Container(
                child: Input(
                  label: 'Họ và tên',
                  required: true,
                  enabled: true,
                ),
              ),
              DropdownInput(
                label: 'Trạng thái',
                hint: 'Đang chờ kết quả',
                required: true,
                itemValue: ['Đang chờ kết quả', 'Đã có kết quả'],
              ),
              DropdownInput(
                label: 'Kỹ thuật xét nghiệm',
                hint: 'Test nhanh',
                required: true,
                itemValue: ['Test nhanh', 'Real time PCR'],
              ),
              DropdownInput(
                label: 'Kết quả',
                hint: 'Chưa có kết quả',
                required: true,
                itemValue: ['Chưa có kết quả', 'Âm tính', 'Dương tính'],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Tạo',
                    style: TextStyle(color: CustomColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
