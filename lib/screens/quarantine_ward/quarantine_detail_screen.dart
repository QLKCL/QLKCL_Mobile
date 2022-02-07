import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';

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
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      futureQuarantine = fetchQuarantine(id: widget.id);
    } else {
      futureQuarantine = fetchQuarantine();
    }

    //define appBar
    final appBar = AppBar(
      title: Text('Thông tin khu cách ly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditQuarantineScreen(
                  id: widget.id,
                  quarantineInfo: quarantineInfo,
                ),
              ),
            ).then((value) => setState(() {}));
          },
          icon: Icon(Icons.edit),
          tooltip: "Cập nhật",
        ),
      ],
    );

    //Config Screen
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<dynamic>(
        future: futureQuarantine,
        builder: (context, snapshot) {
          showLoading();
          if (snapshot.connectionState == ConnectionState.done) {
            BotToast.closeAllLoading();
            if (snapshot.hasData) {
              quarantineInfo = Quarantine.fromJson(snapshot.data);
              return QuarantineInfo(
                quarantineInfo: quarantineInfo,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }
          return Container();
        },
      ),
    );
  }
}
