import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/screens/test/update_test_screen.dart';

class DetailTest extends StatefulWidget {
  static const String routeName = "/detail_test";
  DetailTest({Key? key}) : super(key: key);

  @override
  _DetailTestState createState() => _DetailTestState();
}

class _DetailTestState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin phiếu xét nghiệm'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, UpdateTest.routeName);
              },
              icon: Icon(Icons.edit),
            ),
          ],
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
              Input(
                label: 'Thời gian tạo',
                initValue: "08/09/2021 21:00",
              ),
              Input(
                label: 'Cập nhật lần cuối',
                initValue: "08/09/2021 21:00",
              ),
              Input(
                label: 'Người cập nhật',
                initValue: "Nguyễn Văn A",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
