import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/utils/constant.dart';
import 'component/quarantine_form.dart';

class EditQuarantineScreen extends StatefulWidget {
  static const String routeName = "/edit-quarantine";
  final String? id;
  final Quarantine? quarantineInfo;

  const EditQuarantineScreen({Key? key, this.id, this.quarantineInfo})
      : super(key: key);

  @override
  _EditQuarantineScreenState createState() => _EditQuarantineScreenState();
}

class _EditQuarantineScreenState extends State<EditQuarantineScreen> {
  late Quarantine quarantineInfo;
  late Future<dynamic> futureQuarantine;

  final appBar = AppBar(
    title: const Text('Cập nhật khu cách ly'),
    centerTitle: true,
  );

  @override
  void initState() {
    super.initState();
    if ((widget.quarantineInfo != null))
      futureQuarantine = fetchQuarantine(widget.id);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: (widget.quarantineInfo != null)
            ? QuarantineForm(
                quarantineInfo: widget.quarantineInfo,
                mode: Permission.edit,
              )
            : (FutureBuilder<dynamic>(
                future: futureQuarantine,
                builder: (context, snapshot) {
                  showLoading();
                  if (snapshot.connectionState == ConnectionState.done) {
                    BotToast.closeAllLoading();
                    if (snapshot.hasData) {
                      quarantineInfo = Quarantine.fromJson(snapshot.data);

                      return QuarantineForm(
                        quarantineInfo: quarantineInfo,
                        mode: Permission.edit,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }

                  return Container();
                },
              )),
      ),
    );
  }
}
