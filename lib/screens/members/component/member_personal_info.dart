import 'package:flutter/material.dart';
import 'package:qlkcl/components/date_input.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/components/input.dart';
import 'package:qlkcl/theme/app_theme.dart';

class MemberPersonalInfo extends StatelessWidget {
  final TabController tabController;
  const MemberPersonalInfo({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final birthdayController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Input(
            label: 'Mã số',
            enabled: false,
          ),
          Input(
            label: 'Họ và tên',
            required: true,
            textCapitalization: TextCapitalization.words,
          ),
          Input(
            label: 'Số điện thoại',
            required: true,
            type: TextInputType.phone,
          ),
          Input(
            label: 'Email',
            type: TextInputType.emailAddress,
          ),
          Input(
            label: 'Số CMND/CCCD',
            required: true,
            type: TextInputType.number,
          ),
          DropdownInput(
            label: 'Quốc tịch',
            hint: 'Quốc tịch',
            required: true,
            itemValue: ['Việt Nam', 'Lào', 'Trung Quốc', 'Campuchia'],
          ),
          DropdownInput(
            label: 'Giới tính',
            hint: 'Chọn giới tính',
            required: true,
            itemValue: ['Nam', 'Nữ'],
            maxHeight: 112,
          ),
          DateInput(
            label: 'Ngày sinh',
            required: true,
            controller: birthdayController,
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
          Input(
            label: 'Số nhà, Đường, Thôn/Xóm/Ấp',
            required: true,
          ),
          Input(
            label: 'Mã số BHXH/Thẻ BHYT',
          ),
          Input(
            label: 'Số Hộ chiếu',
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                tabController.animateTo(1);
              },
              child: Text(
                'Tiếp theo',
                style: TextStyle(color: CustomColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
