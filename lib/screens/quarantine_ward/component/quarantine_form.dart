import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/validation.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/screens/quarantine_ward/add_quarantine_screen.dart';
import 'package:qlkcl/screens/quarantine_ward/component/circle_button.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:qlkcl/utils/data_form.dart';

class QuarantineForm extends StatefulWidget {
  final Permission? mode;
  final Quarantine? quarantineInfo;

  const QuarantineForm(
      {Key? key, this.quarantineInfo, this.mode = Permission.add})
      : super(key: key);

  @override
  _QuarantineFormState createState() => _QuarantineFormState();
}

class _QuarantineFormState extends State<QuarantineForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  //Input Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final wardController = TextEditingController();
  final addressController = TextEditingController();
  final typeController = TextEditingController();
  final emailController = TextEditingController();
  final quarantineTimeController = TextEditingController();
  final managerController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final statusController = TextEditingController();

  //Image Picker
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];

  //Submit
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      if (widget.mode == Permission.add) {
        final newQuarantineResponse =
            await createQuarantine(createQuarantineDataForm(
          email: emailController.text,
          fullName: nameController.text,
          country: "VNM",
          city: "1",
          district: "1",
          ward: "1",
          status: statusController.text,
          quarantineTime: int.parse(quarantineTimeController.text),
          mainManager: "1",
          address: addressController.text,
          type: typeController.text,
        ));
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(newQuarantineResponse.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quarantineInfo != null) {
      nameController.text = widget.quarantineInfo?.fullName ?? "";
      countryController.text = (widget.quarantineInfo?.country != null
          ? widget.quarantineInfo?.country.name
          : "")!;
      cityController.text = (widget.quarantineInfo?.city != null
          ? widget.quarantineInfo?.city.name
          : "")!;

      districtController.text = (widget.quarantineInfo?.city != null
          ? widget.quarantineInfo?.district.name
          : "")!;

      wardController.text = (widget.quarantineInfo?.ward != null
          ? widget.quarantineInfo?.ward.name
          : "")!;
      addressController.text = widget.quarantineInfo?.address ?? "";
      typeController.text = widget.quarantineInfo?.type ?? "";
      statusController.text = widget.quarantineInfo?.status ?? "Đang hoạt động";
      emailController.text = widget.quarantineInfo?.email ?? "";
      quarantineTimeController.text =
          widget.quarantineInfo?.quarantineTime.toString() ?? "";
      managerController.text = widget.quarantineInfo?.mainManager != null
          ? widget.quarantineInfo?.mainManager['full_name']
          : "";
      phoneNumberController.text = widget.quarantineInfo?.phoneNumber ?? "";
    }

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                'Thông tin chung',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Input(
              label: 'Tên đầy đủ',
              required: true,
              controller: nameController,
            ),
            DropdownInput(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
              selectedItem:
                  widget.mode == Permission.add ? null : countryController.text,
              //countryController.text,
            ),
            DropdownInput(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: true,
              itemValue: ['TP. Hồ Chí Minh', 'Đà Nẵng', 'Hà Nội', 'Bình Dương'],
              selectedItem:
                  widget.mode == Permission.add ? null : cityController.text,
            ),
            DropdownInput(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: true,
              itemValue: ['Gò Vấp', 'Quận 1', 'Quận 2', 'Quận 3'],
              selectedItem: widget.mode == Permission.add
                  ? null
                  : districtController.text,
            ),
            DropdownInput(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: true,
              itemValue: ['1', '2', '3', '4'],
              selectedItem:
                  widget.mode == Permission.add ? null : wardController.text,
            ),
            Input(
              label: 'Địa chỉ',
              controller: addressController,
            ),

            DropdownInput(
              label: 'Cơ sở cách ly',
              hint: 'Cơ sở cách ly',
              itemValue: ['Tập trung', 'Tư nhân'],
              selectedItem:
                  widget.mode == Permission.add ? null : typeController.text,
            ),

            DropdownInput(
              label: 'Trạng thái',
              hint: 'Trạng thái',
              required: true,
              itemValue: ['Đang hoạt động', 'Khóa', 'Không rõ'],
              selectedItem:
                  widget.mode == Permission.add ? null : statusController.text,
            ),

            Input(
              label: 'Thời gian cách ly (ngày)',
              hint: 'Thời gian cách ly',
              required: true,
              type: TextInputType.number,
              validatorFunction: quarantineTimeValidator,
              controller: quarantineTimeController,
            ),

            DropdownInput(
              label: 'Người quản lý',
              hint: 'Người quản lý',
              required: true,
              itemValue: ['1', '2'],
              selectedItem:
                  widget.mode == Permission.add ? null : managerController.text,
            ),
            Input(
              label: 'Điện thoại liên lạc',
              hint: 'Điện thoại liên lạc',
              type: TextInputType.phone,
              validatorFunction: phoneNullableValidator,
              controller: phoneNumberController,
            ),
            Input(
              label: 'Email',
              hint: 'Email liên lạc',
              required: true,
              controller: emailController,
              validatorFunction: emailValidator,
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Thêm ảnh',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: DottedBorder(
                padding: EdgeInsets.all(0),
                color: CustomColors.primary,
                strokeWidth: 1,
                child: OutlinedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size.infinite),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: CustomColors.primary,
                        width: 1.0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  onPressed: () {
                    selectImages();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Thêm ảnh'),
                    ],
                  ),
                ),
              ),
            ),

            //Selected pictures display
            _imageFileList.isEmpty
                ? Center(
                    heightFactor: 5,
                    child: Text('Chưa có hình nào được chọn'),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(8, 12, 8, 12),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(File(_imageFileList[index].path),
                                    fit: BoxFit.cover),
                                Positioned(
                                  right: -0.05,
                                  top: -0.05,
                                  child: CircleButton(
                                      onTap: () {
                                        _imageFileList.removeAt(index);
                                        setState(() {});
                                      },
                                      iconData: Icons.close),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: _imageFileList.length,
                      ),
                    ),
                  ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(
                  'Tạo',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }
}
