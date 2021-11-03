import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/theme/app_theme.dart';
import '../../components/input.dart';
import '../../components/dropdown_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'component/circle_button.dart';

class NewQuarantine extends StatefulWidget {
  static const String routeName = "/quarantine-list/add";
  //final VoidCallback addNewQuarantine;
  //NewQuarantine(this.addNewQuarantine);

  @override
  _NewQuarantineState createState() => _NewQuarantineState();
}

class _NewQuarantineState extends State<StatefulWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];

  final appBar = AppBar(
    title: Text('Thêm khu cách ly'),
    centerTitle: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        // margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Thông tin chung',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              child: Input(
                label: 'Tên đầy đủ',
                hint: 'Tên đầy đủ',
                required: true,
              ),
            ),
            DropdownInput(
              label: 'Quốc gia',
              hint: 'Quốc gia',
              required: true,
              itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
            ),
            DropdownInput(
              label: 'Tỉnh/thành',
              hint: 'Tỉnh/thành',
              required: true,
              itemValue: ['TP. Hồ Chí Minh', 'Đà Nẵng', 'Hà Nội', 'Bình Dương'],
            ),
            DropdownInput(
              label: 'Quận/huyện',
              hint: 'Quận/huyện',
              required: true,
              itemValue: ['Gò Vấp', 'Quận 1', 'Quận 2', 'Quận 3'],
            ),
            DropdownInput(
              label: 'Phường/xã',
              hint: 'Phường/xã',
              required: true,
              itemValue: ['1', '2', '3', '4'],
            ),
            DropdownInput(
              label: 'Cơ sở cách ly',
              hint: 'Cơ sở cách ly',
              required: true,
              itemValue: ['Tập trung', 'Tư nhân'],
            ),
            Input(
              label: 'Thời gian cách ly (ngày)',
              hint: 'Thời gian cách ly',
              required: true,
              type: TextInputType.number,
            ),
            Input(
              label: 'Người quản lý',
              hint: 'Người quản lý',
            ),
            Input(
              label: 'Điện thoại liên hệ',
              hint: 'Điện thoại liên hệ',
              //required: true,
              type: TextInputType.number,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 15),
              child: Text(
                'Thêm ảnh',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            //Add picture
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
                    height: 250,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: GridView.builder(
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
                                        setState(() {
                                          
                                        });
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
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(241, 36),
                ),
                onPressed: () {},
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
