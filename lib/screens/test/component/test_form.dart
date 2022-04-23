import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/test.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/data_form.dart';

class TestForm extends StatefulWidget {
  final CreatedBy? userCode;
  final Test? testData;
  final Permission mode;
  const TestForm(
      {Key? key, this.testData, this.mode = Permission.view, this.userCode})
      : super(key: key);

  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final _formKey = GlobalKey<FormState>();
  final testCodeController = TextEditingController();
  final userCodeController = TextEditingController();
  final userNameController = TextEditingController();
  final stateController = TextEditingController();
  final typeController = TextEditingController();
  final resultController = TextEditingController();
  final createAtController = TextEditingController();
  final updateAtController = TextEditingController();
  final createByController = TextEditingController();
  final updateByController = TextEditingController();

  String? userCodeError;

  @override
  void initState() {
    if (widget.testData != null) {
      testCodeController.text =
          widget.testData?.code != null ? widget.testData!.code : "";
      userCodeController.text =
          widget.testData?.user.code != null ? widget.testData!.user.code : "";
      userNameController.text = widget.testData?.user.fullName != null
          ? widget.testData!.user.fullName
          : "";
      stateController.text =
          widget.testData?.status != null ? widget.testData!.status : "";
      typeController.text =
          widget.testData?.type != null ? widget.testData!.type : "";
      resultController.text =
          widget.testData?.result != null ? widget.testData!.result : "";
      createAtController.text = widget.testData?.createdAt != null
          ? DateFormat("dd/MM/yyyy HH:mm:ss")
              .format(widget.testData!.createdAt.toLocal())
          : "";
      createByController.text = widget.testData?.createdBy != null
          ? widget.testData!.createdBy.fullName
          : "";
      updateAtController.text = widget.testData?.updatedAt != null
          ? DateFormat("dd/MM/yyyy HH:mm:ss")
              .format(widget.testData!.updatedAt.toLocal())
          : "";
      updateByController.text = widget.testData?.updatedBy != null
          ? widget.testData!.updatedBy.fullName
          : "";
    } else {
      userCodeController.text =
          widget.userCode != null ? widget.userCode!.code : "";
      userNameController.text =
          widget.userCode != null ? widget.userCode!.fullName : "";
      stateController.text = "WAITING";
      typeController.text = "QUICK";
      resultController.text = "NONE";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Input(
                  label: 'Mã phiếu',
                  enabled: false,
                  controller: testCodeController,
                ),
                Input(
                  label: 'Mã người xét nghiệm',
                  controller: userCodeController,
                  required: widget.mode != Permission.view,
                  enabled:
                      widget.userCode == null && widget.mode == Permission.add,
                  type: TextInputType.number,
                  validatorFunction: userCodeValidator,
                  onChangedFunction: (_) async {
                    if (userCodeController.text.isEmpty) {
                      userNameController.text = "";
                      setState(() {});
                    } else {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    }
                  },
                  onSavedFunction: (value) async {
                    final data = await fetchUser(data: {"code": value});
                    if (data.status == Status.success) {
                      userCodeError = null;
                      userNameController.text =
                          data.data['custom_user']['full_name'];
                    } else {
                      userCodeError = data.message;
                      userNameController.text = "";
                    }
                    setState(() {});
                  },
                  autoValidate: false,
                  error: userCodeError,
                ),
                Input(
                  label: 'Họ và tên',
                  controller: userNameController,
                  enabled: false,
                ),
                // DropdownInput<KeyValue>(
                //   label: 'Trạng thái',
                //   hint: 'Chọn trạng thái',
                //   required: widget.mode != Permission.view,
                //   itemValue: testStateList,
                //   itemAsString: (KeyValue? u) => u!.name,
                //   maxHeight: 112,
                //   compareFn: (item, selectedItem) =>
                //       item?.id == selectedItem?.id,
                //   selectedItem: testStateList.safeFirstWhere(
                //       (state) => state.id == stateController.text),
                //   onChanged: (value) {
                //     if (value == null) {
                //       stateController.text = "";
                //     } else {
                //       stateController.text = value.id;
                //     }
                //   },
                //   enabled: widget.mode == Permission.edit ||
                //       widget.mode == Permission.add,
                // ),
                DropdownInput<KeyValue>(
                  label: 'Kỹ thuật xét nghiệm',
                  hint: 'Chọn kỹ thuật xét nghiệm',
                  required: widget.mode != Permission.view,
                  itemValue: testTypeList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 112,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: testTypeList
                      .safeFirstWhere((type) => type.id == typeController.text),
                  onChanged: (value) {
                    if (value == null) {
                      typeController.text = "";
                    } else {
                      typeController.text = value.id;
                    }
                  },
                  enabled: widget.mode == Permission.add,
                ),
                DropdownInput<KeyValue>(
                  label: 'Kết quả',
                  hint: 'Chọn kết quả',
                  required: widget.mode != Permission.view,
                  itemValue: testValueList,
                  itemAsString: (KeyValue? u) => u!.name,
                  maxHeight: 168,
                  compareFn: (item, selectedItem) =>
                      item?.id == selectedItem?.id,
                  selectedItem: testValueList.safeFirstWhere(
                      (result) => result.id == resultController.text),
                  onChanged: (value) {
                    if (value == null) {
                      resultController.text = "";
                    } else {
                      if (value.id == "NEGATIVE" || value.id == "POSITIVE") {
                        stateController.text = "DONE";
                      } else {
                        stateController.text = "WAITING";
                      }
                      resultController.text = value.id;
                    }
                  },
                  enabled: widget.mode == Permission.edit ||
                      widget.mode == Permission.add,
                ),
                if (widget.mode == Permission.view)
                  Input(
                    label: 'Thời gian tạo',
                    controller: createAtController,
                    enabled: false,
                  ),
                if (widget.mode == Permission.view)
                  Input(
                    label: 'Người tạo',
                    controller: createByController,
                    enabled: false,
                  ),
                if (widget.mode == Permission.view)
                  Input(
                    label: 'Cập nhật lần cuối',
                    controller: updateAtController,
                    enabled: false,
                  ),
                if (widget.mode == Permission.view)
                  Input(
                    label: 'Người cập nhật',
                    controller: updateByController,
                    enabled: false,
                  ),
                if (widget.mode == Permission.edit ||
                    widget.mode == Permission.add)
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate() &&
        (userCodeError == null || userCodeError == "")) {
      final CancelFunc cancel = showLoading();
      if (widget.mode == Permission.add) {
        final response = await createTest(createTestDataForm(
            userCode: userCodeController.text,
            status: stateController.text,
            type: typeController.text,
            result: resultController.text));
        cancel();
        showNotification(response);
        if (response.status == Status.success) {
          Navigator.pop(context);
        }
      } else if (widget.mode == Permission.edit) {
        final response = await updateTest(updateTestDataForm(
            code: widget.testData!.code,
            status: stateController.text,
            type: typeController.text,
            result: resultController.text));
        cancel();
        showNotification(response);
        if (response.status == Status.success) {
          Navigator.pop(context);
        }
      }
    }
  }
}
