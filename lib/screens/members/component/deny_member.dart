import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';

class DenyMember extends StatelessWidget {
  const DenyMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Không có dữ liệu",
        style: TextStyle(color: CustomColors.secondaryText, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
