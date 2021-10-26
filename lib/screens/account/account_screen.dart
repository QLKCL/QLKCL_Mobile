import 'package:flutter/material.dart';
import 'package:qlkcl/components/qr_code.dart';
import 'package:qlkcl/theme/app_theme.dart';

class Account extends StatefulWidget {
  Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Quản lý tài khoản"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          GenerateQrCode(qrData: "Le Trung Son"),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              "Hồ sơ sức khỏe",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  title: Text('Lịch sử khai báo y tế'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                ListTile(
                  onTap: () {},
                  title: Text('Kết quả xét nghiệm'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              "Tài khoản và bảo mật",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  title: Text('Thông tin cá nhân'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                ListTile(
                  onTap: () {},
                  title: Text('Đổi mật khẩu'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: Text('Đăng xuất',
                  style: TextStyle(color: CustomColors.error)),
              trailing: Icon(
                Icons.logout_outlined,
                color: CustomColors.error,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
