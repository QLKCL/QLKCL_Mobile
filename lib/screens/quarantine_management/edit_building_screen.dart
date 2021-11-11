import 'package:flutter/material.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_building.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

class EditBuildingScreen extends StatefulWidget {
  const EditBuildingScreen({Key? key}) : super(key: key);
  static const routeName = '/editing-building';

  @override
  _EditBuildingScreenState createState() => _EditBuildingScreenState();
}

class _EditBuildingScreenState extends State<EditBuildingScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin tòa'),
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
              
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.25,
              child: GeneralInfoBuilding('Ký túc xá khu A', 'Tòa AH', 8, 15, 300),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.65,
              child: Input(label: 'Tên', hint: 'Tên tòa mới'),),
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
