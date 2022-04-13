import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';

//Widget for custom modal bottom sheet
class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: SizedBox(
        width: maxMobileSize,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: backgroundColor,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        ),
      ),
    ));
  }
}

Future memberFilter(
  BuildContext context, {
  required TextEditingController quarantineWardController,
  required TextEditingController quarantineBuildingController,
  required TextEditingController quarantineFloorController,
  required TextEditingController quarantineRoomController,
  required TextEditingController quarantineAtMinController,
  required TextEditingController quarantineAtMaxController,
  required TextEditingController quarantinedFinishExpectedAtController,
  required TextEditingController labelController,
  required TextEditingController healthStatusController,
  required TextEditingController testController,
  required List<KeyValue> quarantineWardList,
  required List<KeyValue> quarantineBuildingList,
  required List<KeyValue> quarantineFloorList,
  required List<KeyValue> quarantineRoomList,
  required void Function(
    List<KeyValue> quarantineWardList,
    List<KeyValue> quarantineBuildingList,
    List<KeyValue> quarantineFloorList,
    List<KeyValue> quarantineRoomList,
    bool search,
  )?
      onSubmit,
  bool useCustomBottomSheetMode = false,
}) {
  final buildingKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final floorKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final roomKey = GlobalKey<DropdownSearchState<KeyValue>>();
  // Using Wrap makes the bottom sheet height the height of the content.
  // Otherwise, the height will be half the height of the screen.
  final filterContent = StatefulBuilder(builder:
      (BuildContext context, StateSetter setState /*You can rename this!*/) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Center(
            child: Text(
              'Lọc dữ liệu',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        DropdownInput<KeyValue>(
          label: 'Khu cách ly',
          hint: 'Chọn khu cách ly',
          itemAsString: (KeyValue? u) => u!.name,
          itemValue: quarantineWardList,
          selectedItem: quarantineWardList.safeFirstWhere(
              (type) => type.id.toString() == quarantineWardController.text),
          onFind: quarantineWardList.isEmpty
              ? (String? filter) => fetchQuarantineWard({
                    'page_size': pageSizeMax,
                  })
              : null,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                quarantineWardController.text = "";
              } else {
                quarantineWardController.text = value.id.toString();
              }
              quarantineBuildingController.clear();
              quarantineFloorController.clear();
              quarantineRoomController.clear();
              quarantineBuildingList = [];
              quarantineFloorList = [];
              quarantineRoomList = [];
            });
            if (quarantineWardController.text != "") {
              fetchQuarantineBuilding({
                'quarantine_ward': quarantineWardController.text,
                'page_size': pageSizeMax,
              }).then((data) => setState(() {
                    quarantineBuildingList = data;
                    buildingKey.currentState?.openDropDownSearch();
                  }));
            }
          },
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          widgetKey: buildingKey,
          label: 'Tòa',
          hint: 'Chọn tòa',
          itemAsString: (KeyValue? u) => u!.name,
          itemValue: quarantineBuildingList,
          selectedItem: quarantineBuildingList.safeFirstWhere((type) =>
              type.id.toString() == quarantineBuildingController.text),
          onFind: quarantineBuildingList.isEmpty &&
                  quarantineWardController.text != ""
              ? (String? filter) => fetchQuarantineBuilding({
                    'quarantine_ward': quarantineWardController.text,
                    'page_size': pageSizeMax,
                    'search': filter
                  })
              : null,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                quarantineBuildingController.text = "";
              } else {
                quarantineBuildingController.text = value.id.toString();
              }
              quarantineFloorController.clear();
              quarantineRoomController.clear();
              quarantineFloorList = [];
              quarantineRoomList = [];
            });
            if (quarantineBuildingController.text != "") {
              fetchQuarantineFloor({
                'quarantine_building': quarantineBuildingController.text,
                'page_size': pageSizeMax,
              }).then((data) => setState(() {
                    quarantineFloorList = data;
                    floorKey.currentState?.openDropDownSearch();
                  }));
            }
          },
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          widgetKey: floorKey,
          label: 'Tầng',
          hint: 'Chọn tầng',
          itemAsString: (KeyValue? u) => u!.name,
          itemValue: quarantineFloorList,
          selectedItem: quarantineFloorList.safeFirstWhere(
              (type) => type.id.toString() == quarantineFloorController.text),
          onFind: quarantineFloorList.isEmpty &&
                  quarantineBuildingController.text != ""
              ? (String? filter) => fetchQuarantineFloor({
                    'quarantine_building':
                        quarantineBuildingController.text,
                    'page_size': pageSizeMax,
                    'search': filter
                  })
              : null,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                quarantineFloorController.text = "";
              } else {
                quarantineFloorController.text = value.id.toString();
              }
              quarantineRoomController.clear();
              quarantineRoomList = [];
            });
            if (quarantineFloorController.text != "") {
              fetchQuarantineRoom({
                'quarantine_floor': quarantineFloorController.text,
                'page_size': pageSizeMax,
              }).then((data) => setState(() {
                    quarantineRoomList = data;
                    roomKey.currentState?.openDropDownSearch();
                  }));
            }
          },
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          label: 'Phòng',
          hint: 'Chọn phòng',
          itemAsString: (KeyValue? u) => u!.name,
          itemValue: quarantineRoomList,
          selectedItem: quarantineRoomList.safeFirstWhere(
              (type) => type.id.toString() == quarantineRoomController.text),
          onFind:
              quarantineRoomList.isEmpty && quarantineFloorController.text != ""
                  ? (String? filter) => fetchQuarantineRoom({
                        'quarantine_floor': quarantineFloorController.text,
                        'page_size': pageSizeMax,
                        'search': filter
                      })
                  : null,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          onChanged: (value) {
            if (value == null) {
              quarantineRoomController.text = "";
            } else {
              quarantineRoomController.text = value.id.toString();
            }
          },
          showClearButton: true,
        ),
        NewDateRangeInput(
          label: 'Ngày bắt đầu cách ly',
          controllerStart: quarantineAtMinController,
          controllerEnd: quarantineAtMaxController,
          maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
          showClearButton: true,
        ),
        NewDateInput(
          label: 'Ngày dự kiến hoàn thành cách ly',
          controller: quarantinedFinishExpectedAtController,
          showClearButton: true,
        ),
        MultiDropdownInput<KeyValue>(
          label: 'Diện cách ly',
          hint: 'Chọn diện cách ly',
          itemValue: labelList,
          dropdownBuilder: customDropDown,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          selectedItems: labelController.text != ""
              ? (labelController.text
                  .split(',')
                  .map((e) =>
                      labelList.safeFirstWhere((result) => result.id == e)!)
                  .toList())
              : null,
          onChanged: (value) {
            if (value == null) {
              labelController.text = "";
            } else {
              labelController.text = value.map((e) => e.id).join(",");
            }
          },
        ),
        MultiDropdownInput<KeyValue>(
          label: 'Tình trạng sức khỏe',
          hint: 'Chọn tình trạng sức khỏe',
          itemValue: medDeclValueList,
          dropdownBuilder: customDropDown,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          selectedItems: healthStatusController.text != ""
              ? (healthStatusController.text
                  .split(',')
                  .map((e) => medDeclValueList
                      .safeFirstWhere((result) => result.id == e)!)
                  .toList())
              : null,
          onChanged: (value) {
            if (value == null) {
              healthStatusController.text = "";
            } else {
              healthStatusController.text = value.map((e) => e.id).join(",");
            }
          },
        ),
        MultiDropdownInput<KeyValue>(
          label: 'Kết quả xét nghiệm',
          hint: 'Chọn kết quả xét nghiệm',
          itemValue: testValueWithBoolList,
          dropdownBuilder: customDropDown,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          selectedItems: testController.text != ""
              ? (testController.text
                  .split(',')
                  .map((e) => testValueWithBoolList
                      .safeFirstWhere((result) => result.id == e)!)
                  .toList())
              : null,
          onChanged: (value) {
            if (value == null) {
              testController.text = "";
            } else {
              testController.text = value.map((e) => e.id).join(",");
            }
          },
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                  quarantineWardController.clear();
                  quarantineBuildingController.clear();
                  quarantineFloorController.clear();
                  quarantineRoomController.clear();
                  quarantineAtMinController.clear();
                  quarantineAtMaxController.clear();
                  quarantinedFinishExpectedAtController.clear();
                  labelController.clear();
                  onSubmit!(quarantineWardList, [], [], [], false);
                  Navigator.pop(context);
                },
                child: const Text("Đặt lại"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Respond to button press
                  onSubmit!(
                    quarantineWardList,
                    quarantineBuildingList,
                    quarantineFloorList,
                    quarantineRoomList,
                    true,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Tìm kiếm"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  });

  return !useCustomBottomSheetMode
      ? showBarModalBottomSheet(
          barrierColor: Colors.black54,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          useRootNavigator: !Responsive.isDesktopLayout(context),
          context: context,
          builder: (context) => filterContent,
        )
      : showCustomModalBottomSheet(
          context: context,
          builder: (context) => filterContent,
          containerWidget: (_, animation, child) => FloatingModal(
                child: child,
              ),
          expand: false);
}

Future testFilter(
  BuildContext context, {
  required TextEditingController userCodeController,
  required TextEditingController stateController,
  required TextEditingController typeController,
  required TextEditingController resultController,
  required TextEditingController createAtMinController,
  required TextEditingController createAtMaxController,
  required void Function()? onSubmit,
  bool useCustomBottomSheetMode = false,
}) {
  final filterContent = StatefulBuilder(builder:
      (BuildContext context, StateSetter setState /*You can rename this!*/) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Center(
            child: Text(
              'Lọc dữ liệu',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        DropdownInput<KeyValue>(
          label: 'Kỹ thuật xét nghiệm',
          hint: 'Chọn kỹ thuật xét nghiệm',
          itemValue: testTypeList,
          itemAsString: (KeyValue? u) => u!.name,
          maxHeight: 112,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: testTypeList
              .safeFirstWhere((type) => type.id == typeController.text),
          onChanged: (value) {
            if (value == null) {
              typeController.text = "";
            } else {
              typeController.text = value.id;
            }
          },
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          label: 'Trạng thái',
          hint: 'Chọn trạng thái',
          itemValue: testStateList,
          itemAsString: (KeyValue? u) => u!.name,
          maxHeight: 112,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: testStateList
              .safeFirstWhere((state) => state.id == stateController.text),
          onChanged: (value) {
            if (value == null) {
              stateController.text = "";
            } else {
              stateController.text = value.id;
            }
          },
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          label: 'Kết quả',
          hint: 'Chọn kết quả',
          itemValue: testValueList,
          itemAsString: (KeyValue? u) => u!.name,
          maxHeight: 168,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: testValueList
              .safeFirstWhere((result) => result.id == resultController.text),
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
          showClearButton: true,
        ),
        NewDateRangeInput(
          label: 'Ngày xét nghiệm',
          controllerStart: createAtMinController,
          controllerEnd: createAtMaxController,
          maxDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
          showClearButton: true,
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                  userCodeController.clear();
                  stateController.clear();
                  typeController.clear();
                  resultController.clear();
                  createAtMinController.clear();
                  createAtMaxController.clear();
                  onSubmit!();
                  Navigator.pop(context);
                },
                child: const Text("Đặt lại"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Respond to button press
                  onSubmit!();
                  Navigator.pop(context);
                },
                child: const Text("Tìm kiếm"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  });

  return !useCustomBottomSheetMode
      ? showBarModalBottomSheet(
          barrierColor: Colors.black54,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          useRootNavigator: !Responsive.isDesktopLayout(context),
          context: context,
          builder: (context) => filterContent,
        )
      : showCustomModalBottomSheet(
          context: context,
          builder: (context) => filterContent,
          containerWidget: (_, animation, child) => FloatingModal(
                child: child,
              ),
          expand: false);
}

Future quarantineFilter(
  BuildContext context, {
  required TextEditingController cityController,
  required TextEditingController districtController,
  required TextEditingController wardController,
  required TextEditingController mainManagerController,
  bool myQuarantine = false,
  required List<KeyValue> managerList,
  required List<KeyValue> cityList,
  required List<KeyValue> districtList,
  required List<KeyValue> wardList,
  required void Function(
    List<KeyValue> cityList,
    List<KeyValue> districtList,
    List<KeyValue> wardList,
    bool search,
  )?
      onSubmit,
  bool useCustomBottomSheetMode = false,
}) {
  final districtKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final wardKey = GlobalKey<DropdownSearchState<KeyValue>>();
  final filterContent = StatefulBuilder(builder:
      (BuildContext context, StateSetter setState /*You can rename this!*/) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Center(
            child: Text(
              'Lọc dữ liệu',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        DropdownInput<KeyValue>(
          label: 'Tỉnh/thành',
          hint: 'Tỉnh/thành',
          itemValue: cityList,
          selectedItem: cityList.safeFirstWhere(
              (type) => type.id.toString() == cityController.text),
          onFind: cityList.isEmpty
              ? (String? filter) => fetchCity({'country_code': 'VNM'})
              : null,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                cityController.text = "";
              } else {
                cityController.text = value.id.toString();
              }
              districtController.clear();
              wardController.clear();
              districtList = [];
              wardList = [];
            });
            if (cityController.text != "") {
              fetchDistrict({'city_id': cityController.text})
                  .then((data) => setState(() {
                        districtList = data;
                        districtKey.currentState?.openDropDownSearch();
                      }));
            }
          },
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          showSearchBox: true,
          mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
              ? Mode.DIALOG
              : Mode.BOTTOM_SHEET,
          maxHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              100,
          popupTitle: 'Tỉnh/thành',
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          widgetKey: districtKey,
          label: 'Quận/huyện',
          hint: 'Quận/huyện',
          itemValue: districtList,
          selectedItem: districtList.safeFirstWhere(
              (type) => type.id.toString() == districtController.text),
          onFind: districtList.isEmpty && cityController.text != ""
              ? (String? filter) =>
                  fetchDistrict({'city_id': cityController.text})
              : null,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                districtController.text = "";
              } else {
                districtController.text = value.id.toString();
              }
              wardController.clear();
              wardList = [];
            });
            if (districtController.text != "") {
              fetchWard({'district_id': districtController.text})
                  .then((data) => setState(() {
                        wardList = data;
                        wardKey.currentState?.openDropDownSearch();
                      }));
            }
          },
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          showSearchBox: true,
          mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
              ? Mode.DIALOG
              : Mode.BOTTOM_SHEET,
          maxHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              100,
          popupTitle: 'Quận/huyện',
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
          widgetKey: wardKey,
          label: 'Phường/xã',
          hint: 'Phường/xã',
          itemValue: wardList,
          selectedItem: wardList.safeFirstWhere(
              (type) => type.id.toString() == wardController.text),
          onFind: wardList.isEmpty && districtController.text != ""
              ? (String? filter) =>
                  fetchWard({'district_id': districtController.text})
              : null,
          onChanged: (value) {
            setState(() {
              if (value == null) {
                wardController.text = "";
              } else {
                wardController.text = value.id.toString();
              }
            });
          },
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          itemAsString: (KeyValue? u) => u!.name,
          showSearchBox: true,
          mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
              ? Mode.DIALOG
              : Mode.BOTTOM_SHEET,
          maxHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              100,
          popupTitle: 'Phường/xã',
          showClearButton: true,
        ),
        DropdownInput<KeyValue>(
            label: 'Người quản lý',
            hint: 'Chọn người quản lý',
            itemValue: managerList,
            selectedItem: managerList.safeFirstWhere(
                (type) => type.id == mainManagerController.text),
            onFind: managerList.isEmpty
                ? (String? filter) =>
                    fetchNotMemberList({'role_name_list': 'MANAGER'})
                : null,
            onChanged: (value) {
              if (value == null) {
                mainManagerController.text = "";
              } else {
                mainManagerController.text = value.id.toString();
              }
            },
            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
            itemAsString: (KeyValue? u) => u!.name,
            showSearchBox: true,
            mode: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                ? Mode.DIALOG
                : Mode.BOTTOM_SHEET,
            maxHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                100,
            popupTitle: 'Quản lý'),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     ListTileTheme(
        //       contentPadding: const EdgeInsets.only(left: 8),
        //       child: CheckboxListTile(
        //         title: const Text("Quản lý bởi tôi"),
        //         controlAffinity: ListTileControlAffinity.leading,
        //         value: myQuarantine,
        //         onChanged: (bool? value) {
        //           myQuarantine = value!;
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                  cityController.clear();
                  districtController.clear();
                  wardController.clear();
                  mainManagerController.clear();
                  onSubmit!(cityList, [], [], false);
                  Navigator.pop(context);
                },
                child: const Text("Đặt lại"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Respond to button press
                  onSubmit!(
                    cityList,
                    districtList,
                    wardList,
                    true,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Tìm kiếm"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  });

  return !useCustomBottomSheetMode
      ? showBarModalBottomSheet(
          barrierColor: Colors.black54,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          useRootNavigator: !Responsive.isDesktopLayout(context),
          context: context,
          builder: (context) => filterContent,
        )
      : showCustomModalBottomSheet(
          context: context,
          builder: (context) => filterContent,
          containerWidget: (_, animation, child) => FloatingModal(
                child: child,
              ),
          expand: false);
}
