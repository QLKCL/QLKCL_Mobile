import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/models/floor.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info_building.dart';
import 'package:qlkcl/utils/data_form.dart';
import '../../components/input.dart';
import 'package:qlkcl/config/app_theme.dart';

class EditBuildingScreen extends StatefulWidget {
  final Building? currentBuilding;
  final Quarantine? currentQuarantine;
  final VoidCallback onGoBackFloorList;
  const EditBuildingScreen({
    Key? key,
    this.currentBuilding,
    this.currentQuarantine,
    required this.onGoBackFloorList,
  }) : super(key: key);
  static const routeName = '/editing-building';

  @override
  _EditBuildingScreenState createState() => _EditBuildingScreenState();
}

class _EditBuildingScreenState extends State<EditBuildingScreen> {
  late Future<int> numOfFloor;

  @override
  void initState() {
    super.initState();
    numOfFloor =
        fetchNumOfFloor({'quarantine_building': widget.currentBuilding!.id});
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      final registerResponse = await updateBuilding(updateBuildingDataForm(
        name: nameController.text,
        id: widget.currentBuilding!.id,
      ));
      
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerResponse.message)),
      );
      widget.onGoBackFloorList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Sửa thông tin tòa'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: numOfFloor,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                EasyLoading.dismiss();
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
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.6,
                        child: Input(
                          label: 'Tên tòa mới',
                          hint: 'Tên tòa mới',
                          controller: nameController,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          "Xác nhận",
                          style: TextStyle(color: CustomColors.white),
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Snapshot has error');
              }
              EasyLoading.show();
              return Container();
            }),
      ),
    );
  }
}
