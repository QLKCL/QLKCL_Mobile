import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_room.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({Key? key}) : super(key: key);
  static const routeName = '/editing-room';

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin phòng'),
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
              child: GeneralInfoRoom('Ký túc xá khu A', 'Tòa AH','Tầng 3', '307', 3, 4),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.55,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Input(label: 'Tên', hint: 'Tên phòng mới'),
                  Input(label: 'Số người tối đa', hint: 'Số người tối đa', type: TextInputType.number,),
                ],
              ),),
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
