import 'package:flutter/material.dart';

class MedicalDeclaration extends StatefulWidget {
  static const String routeName = "/medical_declaration";

  const MedicalDeclaration({Key? key}) : super(key: key);

  @override
  _MedicalDeclarationState createState() => _MedicalDeclarationState();
}

class _MedicalDeclarationState extends State<MedicalDeclaration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khai báo y tế'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              Text("Khai hộ"),
          ],

        ),
      ),
    );
  }
}
