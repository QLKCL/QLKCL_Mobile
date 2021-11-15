import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:qlkcl/models/quarantine.dart';
import './edit_quarantine_screen.dart';
import './component/quarantine_info.dart';

class QuarantineDetailScreen extends StatefulWidget {
  static const routeName = '/quarantine-details';
  final String? id;
  QuarantineDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  _QuarantineDetailScreenState createState() => _QuarantineDetailScreenState();
}

class _QuarantineDetailScreenState extends State<QuarantineDetailScreen> {
  late Future<dynamic> futureQuarantine;
  late Quarantine quarantineInfo;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      futureQuarantine = fetchQuarantine(id: widget.id);
      // print(futureQuarantine);
    } else {
      futureQuarantine = fetchQuarantine();
    }
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //define appBar
    final appBar = AppBar(
      title: Text('Thông tin khu cách ly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, EditQuarantine.routeName);
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );

    //Config Screen
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<dynamic>(
        future: futureQuarantine,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            EasyLoading.dismiss();
            if (snapshot.hasData) {
              quarantineInfo = Quarantine.fromJson(snapshot.data);
              return QuarantineInfo(quarantineInfo: quarantineInfo);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }
          EasyLoading.show();
          return Container();
        },
      ),
    );
  }
}
