import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info.dart';
import 'package:qlkcl/utils/data_form.dart';

class AddBuildingScreen extends StatefulWidget {
  final Quarantine? currentQuarrantine;
  const AddBuildingScreen({
    Key? key,
    this.currentQuarrantine,
  }) : super(key: key);

  static const routeName = '/add-building';

  @override
  _AddBuildingScreenState createState() => _AddBuildingScreenState();
}

class _AddBuildingScreenState extends State<AddBuildingScreen> {
  late Future<dynamic> futureBuildingList;

  @override
  void initState() {
    super.initState();
    futureBuildingList =
        fetchBuildingList({'quarantine_ward': widget.currentQuarrantine!.id});
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
      final response = await createBuilding(createBuildingDataForm(
        name: nameController.text,
        quarantineWard: widget.currentQuarrantine!.id,
      ));
      cancel();
      showNotification(response);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Thêm tòa'),
      centerTitle: true,
    );
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: futureBuildingList,
              builder: (context, snapshot) {
                showLoading();
                if (snapshot.hasData) {
                  BotToast.closeAllLoading();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.25,
                        child: GeneralInfo(
                          currentQuarantine: widget.currentQuarrantine!,
                          numOfBuilding: snapshot.data.length,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.6,
                          child: Input(
                            label: 'Tên tòa',
                            required: true,
                            controller: nameController,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Spacer(),
                            ElevatedButton(
                              onPressed: _submit,
                              child: Text("Xác nhận"),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Snapshot has error');
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
