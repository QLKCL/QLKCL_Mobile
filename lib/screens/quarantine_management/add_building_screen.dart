import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info.dart';
import 'package:qlkcl/utils/constant.dart';
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
    futureBuildingList = fetchBuildingList({
      'quarantine_ward': widget.currentQuarrantine!.id,
      'page_size': pageSizeMax,
    });
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final CancelFunc cancel = showLoading();
      final response = await createBuilding(createBuildingDataForm(
        name: nameController.text,
        quarantineWard: widget.currentQuarrantine!.id,
      ));
      cancel();
      showNotification(response);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Thêm tòa'),
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
              if (snapshot.connectionState == ConnectionState.done) {
                BotToast.closeAllLoading();
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.25,
                        child: GeneralInfo(
                          currentQuarantine: widget.currentQuarrantine!,
                          numOfBuilding: snapshot.data.length,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxWidth: 800),
                            child: Form(
                              key: _formKey,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Input(
                                  label: 'Tên tòa',
                                  required: true,
                                  controller: nameController,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text("Xác nhận"),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('Snapshot has error');
                } else {
                  return const Text(
                    'Không có dữ liệu',
                    textAlign: TextAlign.center,
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
