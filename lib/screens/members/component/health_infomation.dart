import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

Widget healthInfomation(
    CustomUser personalData, Member quarantineData, HealthInfo healthData) {
  return Column(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Thông tin sức khỏe",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 8,
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
                title: "Nhịp tim",
                content: healthData.heartbeat != null
                    ? "${healthData.heartbeat!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.heartbeat!.updatedAt.toLocal())})"
                    : "Không có",
                textColor: primaryText,
              ),
              textField(
                title: "Nhiệt độ cơ thể",
                content: healthData.temperature != null
                    ? "${healthData.temperature!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.temperature!.updatedAt.toLocal())})"
                    : "Không có",
                textColor: primaryText,
              ),
              textField(
                title: "Nồng độ oxi trong máu (SPO2)",
                content: healthData.spo2 != null
                    ? "${healthData.spo2!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.spo2!.updatedAt.toLocal())})"
                    : "Không có",
                textColor: primaryText,
              ),
              textField(
                title: "Nhịp thở",
                content: healthData.breathing != null
                    ? "${healthData.breathing!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.breathing!.updatedAt.toLocal())})"
                    : "Không có",
                textColor: primaryText,
              ),
              textField(
                title: "Huyết áp",
                content: healthData.bloodPressure != null
                    ? "${healthData.bloodPressure!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.bloodPressure!.updatedAt.toLocal())})"
                    : "Không có",
                textColor: primaryText,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Thông tin cách ly",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 8,
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
