import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/models/building.dart';
import 'package:qlkcl/screens/quarantine_management/component/general_info.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class AddBuildingScreen extends StatefulWidget {
  final Quarantine? currentQuarrantine;
  final Permission mode;

  const AddBuildingScreen({
    Key? key,
    this.currentQuarrantine,
    this.mode = Permission.add,
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
      if (widget.mode == Permission.add) {
        final registerResponse = await createBuilding(createBuildingDataForm(
          name: nameController.text,
          quarantineWard: widget.currentQuarrantine!.id,
        ));
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(registerResponse.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Thêm tòa'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
            future: futureBuildingList,
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
