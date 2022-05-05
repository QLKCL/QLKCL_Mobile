import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';

Widget personalInfomation(CustomUser personalData, Member quarantineData) {
  return Column(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Thông tin cá nhân",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 8,
              ),
              textField(
                title: "Mã định danh",
                content: personalData.code,
                textColor: primaryText,
              ),
              textField(
                title: "Họ và tên",
                content: personalData.fullName,
                textColor: primaryText,
              ),
              textField(
                title: "Số điện thoại",
                content: personalData.phoneNumber,
                textColor: primaryText,
              ),
              textField(
                title: "Email",
                content: personalData.email ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Số CMND/CCCD",
                content: personalData.identityNumber ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Giới tính",
                content: genderList
                    .safeFirstWhere(
                        (gender) => gender.id == personalData.gender)
                    ?.name,
                textColor: primaryText,
              ),
              textField(
                title: "Ngày sinh",
                content: personalData.birthday ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Địa chỉ lưu trú",
                content:
                    '${personalData.detailAddress != null ? "${personalData.detailAddress}, " : ""}${personalData.ward != null ? "${personalData.ward['name']}, " : ""}${personalData.district != null ? "${personalData.district['name']}, " : ""}${personalData.city != null ? "${personalData.city['name']}" : ""}',
                textColor: primaryText,
              ),
              textField(
                title: "Số BHYT/BHXH",
                content: personalData.healthInsuranceNumber ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Số hộ chiếu",
                content: personalData.passportNumber ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Nghề nghiệp",
                content: personalData.professional != null
                    ? personalData.professional['name']
                    : "Không rõ",
                textColor: primaryText,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      )
    ],
  );
}
