import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/filters.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/utils/constant.dart';

Future<Response?> memberRequarantined(
  BuildContext context, {
  required List<KeyValue> quarantineWardList,
  bool useCustomBottomSheetMode = false,
}) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController quarantineWardController =
      TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController quarantineReasonController =
      TextEditingController();
  final TextEditingController firstPositiveTestDateController =
      TextEditingController();
  bool isPositiveTestedBefore = false;

  // Using Wrap makes the bottom sheet height the height of the content.
  // Otherwise, the height will be half the height of the screen.
  final filterContent = StatefulBuilder(
    builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'Đăng ký tái cách ly',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DropdownInput<KeyValue>(
                        label: 'Khu cách ly',
                        hint: 'Chọn khu cách ly',
                        itemAsString: (KeyValue? u) => u!.name,
                        required: true,
                        itemValue: quarantineWardList,
                        selectedItem: quarantineWardList.safeFirstWhere(
                            (type) =>
                                type.id.toString() ==
                                quarantineWardController.text),
                        onFind: quarantineWardList.isEmpty
                            ? (String? filter) => fetchQuarantineWard({
                                  'page_size': pageSizeMax,
                                })
                            : null,
                        compareFn: (item, selectedItem) =>
                            item?.id == selectedItem?.id,
                        onChanged: (value) {
                          setState(() {
                            if (value == null) {
                              quarantineWardController.text = "";
                            } else {
                              quarantineWardController.text =
                                  value.id.toString();
                            }
                          });
                        },
                      ),
                      DropdownInput<KeyValue>(
                        label: 'Diện cách ly',
                        hint: 'Chọn diện cách ly',
                        itemValue: labelList,
                        required: true,
                        compareFn: (item, selectedItem) =>
                            item?.id == selectedItem?.id,
                        itemAsString: (KeyValue? u) => u!.name,
                        onChanged: (value) {
                          if (value == null) {
                            labelController.text = "";
                          } else {
                            labelController.text = value.id.toString();
                          }
                          setState(() {});
                        },
                      ),
                      if (labelController.text == "F0")
                        NewDateInput(
                          label: 'Ngày nhiễm bệnh',
                          controller: firstPositiveTestDateController,
                          defaultTime: "07:00",
                        ),
                      Input(
                        label: 'Lý do cách ly',
                        controller: quarantineReasonController,
                        maxLines: 3,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTileTheme(
                            contentPadding: const EdgeInsets.only(left: 8),
                            child: CheckboxListTile(
                              title: const Text("Đã từng nhiễm COVID-19"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isPositiveTestedBefore,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPositiveTestedBefore = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  final CancelFunc cancel = showLoading();
                                  memberCallRequarantine({
                                    'quarantine_ward_id':
                                        quarantineWardController.text,
                                    'label': labelController.text,
                                    "positive_tested_before":
                                        isPositiveTestedBefore,
                                    "quarantine_reason":
                                        quarantineReasonController.text,
                                    "first_positive_test_date":
                                        firstPositiveTestDateController.text,
                                  }).then((value) {
                                    cancel();
                                    showNotification(value);
                                    Navigator.of(context).pop(value);
                                  });
                                }
                              },
                              child: const Text("Đăng ký"),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  return !useCustomBottomSheetMode
      ? showBarModalBottomSheet<Response>(
          barrierColor: Colors.black54,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          useRootNavigator: !Responsive.isDesktopLayout(context),
          context: context,
          builder: (context) => filterContent,
        )
      : showCustomModalBottomSheet<Response>(
          context: context,
          builder: (context) => filterContent,
          containerWidget: (_, animation, child) => FloatingModal(
                child: child,
              ),
          expand: false);
}
