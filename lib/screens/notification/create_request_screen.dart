import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/image_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/authentication.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/notification.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CreateRequest extends StatefulWidget {
  static const String routeName = "/create_request";
  const CreateRequest({Key? key}) : super(key: key);

  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController receiverUserController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  late int receiverType;
  int role = 1;
  int? quarantineWard;
  late List<String> users;
  List<KeyValue> managerList = [];

  @override
  void initState() {
    super.initState();
    titleController.text = "Phản ánh";
    getQuarantineWard().then((value) {
      if (mounted) {
        setState(() {
          quarantineWard = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gửi phản ánh/yêu cầu'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
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
                      showSearchBox: true,
                      mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                          ? Mode.DIALOG
                          : Mode.BOTTOM_SHEET,
                      maxHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          100,
                      popupTitle: 'Người nhận',
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
                    ImageField(
                      controller: imageController,
                      type: "Request",
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          'Gửi',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ],
                ),
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
      final CancelFunc cancel = showLoading();
      final response = await createNotification(
        data: createNotificationDataForm(
          title: titleController.text,
          description: descriptionController.text,
          receiverType: 2,
          quarantineWard: quarantineWard,
          users: receiverUserController.text,
          role: 0,
          image: cloudinary.getImage(imageController.text).toString(),
        ),
      );
      cancel();
      showNotification(response);
    }
  }
}
