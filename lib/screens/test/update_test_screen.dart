import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/theme/app_theme.dart';

class UpdateTest extends StatefulWidget {
  static const String routeName = "/update_test";
  UpdateTest({Key? key}) : super(key: key);

  @override
  _UpdateTestState createState() => _UpdateTestState();
}

class _UpdateTestState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cập nhật phiếu xét nghiệm'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Input(
                label: 'Mã phiếu',
                required: true,
                enabled: false,
                initValue: "PCR-123456",
              ),
              Input(label: 'Mã người xét nghiệm'),
              Input(
                label: 'Họ và tên',
                hint: 'Nhập họ và tên',
              ),
              DropdownInput(
                label: 'Trạng thái',
                hint: 'Chọn trạng thái',
                required: true,
                itemValue: ['Đang chờ kết quả', 'Đã có kết quả'],
                selectedItem: 'Đang chờ kết quả',
                maxHeight: 112,
              ),
              DropdownInput(
                label: 'Kỹ thuật xét nghiệm',
                hint: 'Chọn kỹ thuật xét nghiệm',
                required: true,
                itemValue: ['Test nhanh', 'Real time PCR'],
                selectedItem: 'Test nhanh',
                maxHeight: 112,
              ),
              DropdownInput(
                label: 'Kết quả',
                hint: 'Chọn kết quả',
                required: true,
                itemValue: ['Chưa có kết quả', 'Âm tính', 'Dương tính'],
                selectedItem: 'Chưa có kết quả',
                maxHeight: 168,
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Xác nhận',
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
