import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_floor.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

class EditFloorScreen extends StatefulWidget {
  const EditFloorScreen({Key? key}) : super(key: key);
  static const routeName = '/editing-floor';

  @override
  _EditFloorScreenState createState() => _EditFloorScreenState();
}

class _EditFloorScreenState extends State<EditFloorScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin tầng'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
     
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child: GeneralInfoFloor('Ký túc xá khu A', 'Tòa AH','Tầng 3', 8, 15, 300),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.55,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Input(label: 'Tên', hint: 'Tên tầng mới'),),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Xác nhận",
                  style: TextStyle(color: CustomColors.white),
                ),
              ),
            )

          ],

        ),
      ),
    );
  }
}
