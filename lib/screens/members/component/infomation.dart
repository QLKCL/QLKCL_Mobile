import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

Widget infomation(CustomUser personalData, Member quarantineData) {
  return Column(
    children: [
      Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 800),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            "Thông tin cá nhân",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              textField(
                title: "Trạng thái tài khoản",
                content: personalData.status == "WAITING"
                    ? "Chờ xét duyệt"
                    : personalData.status == "AVAILABLE"
                        ? "Đang cách ly"
                        : personalData.status == "REFUSE"
                            ? "Từ chối"
                            : personalData.status == "LEAVE" &&
                                    quarantineData.quarantinedStatus ==
                                        "HOSPITALIZE"
                                ? "Chuyển viện"
                                : personalData.status == "LEAVE" &&
                                        quarantineData.quarantinedStatus ==
                                            "COMPLETED"
                                    ? "Đã hoàn thành cách ly"
                                    : "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Phòng hiện tại",
                content: (quarantineData.quarantineRoom != null
                        ? "${quarantineData.quarantineRoom['name']}, "
                        : "") +
                    (quarantineData.quarantineFloor != null
                        ? "${quarantineData.quarantineFloor['name']}, "
                        : "") +
                    (quarantineData.quarantineBuilding != null
                        ? "${quarantineData.quarantineBuilding['name']}, "
                        : "") +
                    (quarantineData.quarantineWard != null
                        ? "${quarantineData.quarantineWard?.name}"
                        : ""),
                textColor: primaryText,
              ),
              textField(
                title: "Diện cách ly",
                content: labelList
                    .safeFirstWhere(
                        (label) => label.id == quarantineData.label)!
                    .name,
                textColor: primaryText,
              ),
              textField(
                title: "Lý do cách ly",
                content: quarantineData.quarantineReason ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Tình trạng bệnh hiện tại",
                content: quarantineData.positiveTestNow != null
                    ? testValueWithBoolList
                        .safeFirstWhere((result) =>
                            result.id ==
                            quarantineData.positiveTestNow
                                ?.toString()
                                .capitalize())
                        ?.name
                    : "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Tình trạng sức khỏe",
                content: quarantineData.healthStatus != null
                    ? medDeclValueList
                        .safeFirstWhere((result) =>
                            result.id == quarantineData.healthStatus)
                        ?.name
                    : "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Ngày nhiễm bệnh",
                content: quarantineData.firstPositiveTestDate != null
                    ? DateFormat("dd/MM/yyyy").format(
                        DateTime.parse(quarantineData.firstPositiveTestDate!)
                            .toLocal())
                    : "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Cán bộ chăm sóc",
                content: quarantineData.careStaff != null
                    ? quarantineData.careStaff?.name
                    : "Không có",
                textColor: primaryText,
              ),
              textField(
                title: "Bệnh nền",
                content: quarantineData.backgroundDisease != null
                    ? quarantineData.backgroundDisease
                            .toString()
                            .split(',')
                            .map((e) => backgroundDiseaseList
                                .safeFirstWhere(
                                    (result) => result.id == int.parse(e))!
                                .name)
                            .join(", ") +
                        (quarantineData.backgroundDiseaseNote != null
                            ? ", ${quarantineData.backgroundDiseaseNote}"
                            : "")
                    : quarantineData.backgroundDiseaseNote ?? "Không rõ",
                textColor: primaryText,
              ),
              textField(
                title: "Số mũi vaccine",
                content: quarantineData.numberOfVaccineDoses,
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
