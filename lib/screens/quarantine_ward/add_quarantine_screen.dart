import 'package:flutter/material.dart';
import '../../components/input.dart';
import '../../components/dropdown_field.dart';

class NewQuarantine extends StatefulWidget {
  static const String routeName = "/quarantine-list/add";
  //final VoidCallback addNewQuarantine;
  //NewQuarantine(this.addNewQuarantine);

  @override
  _NewQuarantineState createState() => _NewQuarantineState();
}

class _NewQuarantineState extends State<StatefulWidget> {
  final appBar = AppBar(
    title: Text('Thêm khu cách ly'),
    centerTitle: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        
        // margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Thông tin chung',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              child: Input(
                label: 'Tên đầy đủ',
                hint: 'Tên đầy đủ',
                required: true,
              ),
            ),
            DropdownInput(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
            ),
          
            DropdownInput(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: true,
              itemValue: ['TP. Hồ Chí Minh', 'Đà Nẵng', 'Hà Nội', 'Bình Dương'],
            ),
            DropdownInput(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: true,
              itemValue: ['Gò Vấp', 'Quận 1', 'Quận 2', 'Quận 3'],
            ),
            DropdownInput(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: true,
              itemValue: ['1', '2', '3', '4'],
            ),
            
            DropdownInput(
              label: 'Cơ sở cách ly',
              hint: 'Cơ sở cách ly',
              required: true,
              itemValue: ['Tập trung', 'Tư nhân'],
            ),
            Input(
              label: 'Thời gian cách ly (ngày)',
              hint: 'Thời gian cách ly',
              required: true,
              type: TextInputType.number,
            ),
            Input(
              label: 'Người quản lý',
              hint: 'Người quản lý',
            ),
            Input(
              label: 'Điện thoại liên hệ',
              hint: 'Điện thoại liên hệ',
              //required: true,
              type: TextInputType.number,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 15),
              child: Text(
                'Thêm ảnh',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
