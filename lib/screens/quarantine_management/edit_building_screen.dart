import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_building.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';

class EditBuildingScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  const EditBuildingScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
  }) : super(key: key);
  static const routeName = '/editing-building';

  @override
  _EditBuildingScreenState createState() => _EditBuildingScreenState();
}

class _EditBuildingScreenState extends State<EditBuildingScreen> {
  late Future<int> numOfFloor;
  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    numOfFloor =
        fetchNumOfFloor({'quarantine_building': widget.currentBuilding!.id});
    nameController.text = widget.currentBuilding!.name;
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
      final response = await updateBuilding(updateBuildingDataForm(
        name: nameController.text,
        id: widget.currentBuilding!.id,
      ));

      cancel();
      showNotification(response);
      if (response.success) {
        Navigator.of(context).pop(response.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin tòa'),
      centerTitle: true,
    );
    return DismissKeyboard(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: numOfFloor,
              builder: (context, snapshot) {
                showLoading();
                if (snapshot.connectionState == ConnectionState.done) {
                  BotToast.closeAllLoading();
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.25,
                          child: GeneralInfoBuilding(
                            currentQuarantine: widget.currentQuarantine!,
                            currentBuilding: widget.currentBuilding!,
                            numberOfFloor: snapshot.data,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Input(
                              label: 'Tên tòa mới',
                              hint: 'Tên tòa mới',
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
                  } else {
                    return Text(
                      'Không có dữ liệu',
                      textAlign: TextAlign.center,
                    );
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
