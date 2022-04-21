import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/image_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/helper/dismiss_keyboard.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/notification.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CreateNotification extends StatefulWidget {
  static const String routeName = "/create_notification";
  const CreateNotification({Key? key}) : super(key: key);

  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController receiverTypeController = TextEditingController();
  TextEditingController receiverUserController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final quarantineWardController = TextEditingController();
  late List<String> users;
  List<KeyValue> quarantineWardList = [];

  List<KeyValue> types = const [
    KeyValue(name: "Tất cả", id: "0"),
    KeyValue(name: "Theo khu cách ly", id: "1"),
    KeyValue(name: "Cá nhân", id: "2")
  ];

  @override
  void initState() {
    super.initState();
    fetchQuarantineWardNoToken(null).then((value) {
      if (mounted) {
        setState(() {
          quarantineWardList = value;
        });
      }
    });
    receiverTypeController.text = "0";
    roleController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo thông báo'),
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
                      label: 'Kiểu người nhận',
                      hint: 'Chọn kiểu',
                      required: true,
                      itemValue: types,
                      onChanged: (value) {
                        if (value == null) {
                          receiverTypeController.text = "";
                        } else {
                          receiverTypeController.text = value.id;
                        }
                        setState(() {
                          quarantineWardController.text = "";
                          receiverUserController.text = "";
                        });
                      },
                      itemAsString: (KeyValue? u) => u!.name,
                      compareFn: (item, selectedItem) =>
                          item?.id == selectedItem?.id,
                      selectedItem: types.safeFirstWhere(
                          (e) => e.id == receiverTypeController.text),
                    ),
                    DropdownInput<KeyValue>(
                      label: 'Đối tượng',
                      hint: 'Chọn đối tượng',
                      required: true,
                      onChanged: (value) {
                        if (value == null) {
                          roleController.text = "";
                        } else {
                          roleController.text = value.id;
                        }
                      },
                      itemValue: roleListVi,
                      itemAsString: (KeyValue? u) => u!.name,
                      compareFn: (item, selectedItem) =>
                          item?.id == selectedItem?.id,
                      selectedItem: roleListVi
                          .safeFirstWhere((e) => e.id == roleController.text),
                    ),
                    if (receiverTypeController.text == "1")
                      DropdownInput<KeyValue>(
                        key: const Key("quarantine"),
                        label: 'Khu cách ly',
                        hint: 'Chọn khu cách ly',
                        itemAsString: (KeyValue? u) => u!.name,
                        onFind: quarantineWardList.isEmpty
                            ? (String? filter) =>
                                fetchQuarantineWardNoToken(null)
                            : null,
                        compareFn: (item, selectedItem) =>
                            item?.id == selectedItem?.id,
                        itemValue: quarantineWardList,
                        onChanged: (value) {
                          if (value == null) {
                            quarantineWardController.text = "";
                          } else {
                            quarantineWardController.text = value.id.toString();
                          }
                        },
                        mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                            ? Mode.DIALOG
                            : Mode.BOTTOM_SHEET,
                        maxHeight: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            100,
                        showSearchBox: true,
                        required: true,
                        popupTitle: 'Khu cách ly',
                      ),
                    if (receiverTypeController.text == "2")
                      MultiDropdownInput<KeyValue>(
                        key: const Key("user"),
                        label: 'Gửi đến',
                        hint: 'Chọn người nhận',
                        required: true,
                        dropdownBuilder: customDropDown,
                        onFind: (String? filter) => fetchCustomNotMemberList({
                          'role_name_list': roleController.text == "0"
                              ? 'MEMBER,SUPER_MANAGER,MANAGER,ADMINISTRATOR,STAFF'
                              : roleListEng
                                  .safeFirstWhere(
                                      (p0) => p0.id == roleController.text)
                                  ?.name,
                        }),
                        searchOnline: false,
                        onChanged: (value) {
                          if (value == null) {
                            receiverUserController.text = "";
                          } else {
                            receiverUserController.text =
                                value.map((e) => e.id).join(",");
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
                      type: "Notification",
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
          receiverType: int.parse(receiverTypeController.text),
          quarantineWard: int.tryParse(quarantineWardController.text),
          users: receiverUserController.text,
          role: int.tryParse(roleController.text),
          image: imageController.text != ""
              ? cloudinary.getImage(imageController.text).toString()
              : null,
        ),
      );
      cancel();
      showNotification(response);
    }
  }
}
