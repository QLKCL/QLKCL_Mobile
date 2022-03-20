import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/notification.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';

class CreateRequest extends StatefulWidget {
  static const String routeName = "/create_request";
  CreateRequest({Key? key}) : super(key: key);

  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController receiverUserController = TextEditingController();
  late int receiverType;
  int role = 1;
  int? quarantineWard;
  late List<String> users;
  List<KeyValue> managerList = [];

  @override
  void initState() {
    super.initState();
    titleController.text = "Phản ánh";
    getQuarantineWard().then((value) => setState(() {
          quarantineWard = value;
        }));
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
          title: Text('Gửi phản ánh/yêu cầu'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownInput<KeyValue>(
                    label: 'Gửi đến',
                    hint: 'Chọn người nhận',
                    required: true,
                    onFind: quarantineWard != null
                        ? (String? filter) => fetchNotMemberList({
                              'role_name_list': 'SUPER_MANAGER,MANAGER,STAFF',
                              'quarantine_ward_id': quarantineWard,
                            })
                        : null,
                    onChanged: (value) {
                      if (value == null) {
                        receiverUserController.text = "";
                      } else {
                        receiverUserController.text = value.id.toString();
                      }
                    },
                    itemAsString: (KeyValue? u) => u!.name,
                    compareFn: (item, selectedItem) =>
                        item?.id == selectedItem?.id,
                  ),
                  Input(
                    label: 'Tiêu đề',
                    controller: titleController,
                    showClearButton: false,
                    required: true,
                  ),
                  Input(
                    label: 'Nội dung',
                    maxLines: 15,
                    controller: descriptionController,
                    showClearButton: false,
                    required: true,
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text(
                        'Gửi',
                        style: TextStyle(color: CustomColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      CancelFunc cancel = showLoading();
      final response = await createNotification(
        data: createNotificationDataForm(
          title: titleController.text,
          description: descriptionController.text,
          receiverType: 2,
          quarantineWard: quarantineWard,
          users: receiverUserController.text,
          role: 0,
        ),
      );
      cancel();
      showNotification(response);
    }
  }
}
