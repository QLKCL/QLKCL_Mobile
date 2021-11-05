import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
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
    return DismissKeyboard(
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Tạo phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
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
                child: Input(label: 'Mã người xét nghiệm'),
              ),
              Container(
                child: Input(
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên',
                ),
              ),
              DropdownInput(
                label: 'Trạng thái',
                hint: 'Chọn trạng thái',
                required: true,
                itemValue: ['Đang chờ kết quả', 'Đã có kết quả'],
                selectedItem: 'Đang chờ kết quả',
              ),
              DropdownInput(
                label: 'Kỹ thuật xét nghiệm',
                hint: 'Chọn kỹ thuật xét nghiệm',
                required: true,
                itemValue: ['Test nhanh', 'Real time PCR'],
                selectedItem: 'Test nhanh',
              ),
              DropdownInput(
                label: 'Kết quả',
                hint: 'Chọn kết quả',
                required: true,
                itemValue: ['Chưa có kết quả', 'Âm tính', 'Dương tính'],
                selectedItem: 'Chưa có kết quả',
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
