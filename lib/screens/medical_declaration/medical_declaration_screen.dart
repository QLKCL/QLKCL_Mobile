import 'package:flutter/material.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/utils/constant.dart';

import 'component/md_form.dart';

class MedicalDeclarationScreen extends StatefulWidget {
  static const String routeName = "/medical_declaration";
  final String? phone;

  const MedicalDeclarationScreen({
    Key? key,
    this.phone,
  }) : super(key: key);

  @override
  _MedicalDeclarationScreenState createState() =>
      _MedicalDeclarationScreenState();
}

class _MedicalDeclarationScreenState extends State<MedicalDeclarationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khai báo y tế'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: MedDeclForm(
            mode: Permission.add,
            phone: widget.phone,
          ),
        ),
      ),
    );
  }
}
