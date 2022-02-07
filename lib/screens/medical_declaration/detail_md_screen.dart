import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/constant.dart';

import 'component/md_form.dart';

class ViewMD extends StatefulWidget {
  static const String routeName = "/update_md";
  final String id;

  const ViewMD({Key? key, required this.id}) : super(key: key);

  @override
  _ViewMDState createState() => _ViewMDState();
}

class _ViewMDState extends State<ViewMD> {
  late Future<dynamic> futureMD;

  void initState() {
    super.initState();
    futureMD = fetchMedDecl(data: {'id': widget.id});
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin tờ khai'),
          centerTitle: true,
        ),
        body: FutureBuilder<dynamic>(
          future: futureMD,
          builder: (context, snapshot) {
            showLoading();
            if (snapshot.connectionState == ConnectionState.done) {
              BotToast.closeAllLoading();
              if (snapshot.hasData) {
                return MedDeclForm(
                  medicalDeclData: MedicalDecl.fromJson(snapshot.data),
                  mode: Permission.view,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return Container();
          },
        ),
      ),
    );
  }
}
