import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/utils/constant.dart';

import 'component/des_form.dart';

class DestinationHistoryScreen extends StatefulWidget {
  static const String routeName = "/destination_history";
  final String? code;

  const DestinationHistoryScreen({
    Key? key,
    this.code,
  }) : super(key: key);

  @override
  _DestinationHistoryScreenState createState() =>
      _DestinationHistoryScreenState();
}

class _DestinationHistoryScreenState extends State<DestinationHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khai báo di chuyển'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: DestinationHistoryForm(
            mode: Permission.add,
            code: widget.code,
          ),
        ),
      ),
    );
  }
}
