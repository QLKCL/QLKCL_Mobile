import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/models/member.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:intl/intl.dart';

class HealthInformation extends StatelessWidget {
  const HealthInformation({
    Key? key,
    required this.personalData,
    required this.quarantineData,
    required this.healthData,
  }) : super(key: key);
  final CustomUser personalData;
  final Member quarantineData;
  final HealthInfo healthData;

  @override
  Widget build(BuildContext context) {
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
                      ? "${testValueWithBoolList.safeFirstWhere((result) => result.id == quarantineData.positiveTestNow?.toString().capitalize())?.name}"
                      : "Không rõ",
                  extraContent: quarantineData.lastTested != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(quarantineData.lastTested).toLocal())})"
                      : "",
                  textColor: quarantineData.positiveTestNow != null
                      ? (quarantineData.positiveTestNow
                                  ?.toString()
                                  .capitalize() ==
                              "True"
                          ? error
                          : success)
                      : primaryText,
                ),
                textField(
                  title: "Tình trạng sức khỏe",
                  content: quarantineData.healthStatus != null
                      ? medDeclValueList
                          .safeFirstWhere((result) =>
                              result.id == quarantineData.healthStatus)
                          ?.name
                      : "Không rõ",
                  extraContent: quarantineData.lastHealthStatusTime != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(quarantineData.lastHealthStatusTime!).toLocal())})"
                      : "",
                  textColor: quarantineData.healthStatus != null
                      ? (quarantineData.healthStatus == "SERIOUS"
                          ? error
                          : quarantineData.healthStatus == "UNWELL"
                              ? warning
                              : success)
                      : primaryText,
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
                  title: "Nhịp tim (lần/phút)",
                  content: healthData.heartbeat != null
                      ? healthData.heartbeat!.data
                      : "Không rõ",
                  extraContent: healthData.heartbeat != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.heartbeat!.updatedAt.toLocal())})"
                      : "",
                  textColor: healthData.heartbeat != null &&
                          (int.parse(healthData.heartbeat!.data) < 50 ||
                              int.parse(healthData.heartbeat!.data) > 100) &&
                          quarantineData.lastHealthStatusTime != null &&
                          (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                  .toString() ==
                              healthData.heartbeat!.updatedAt.toString())
                      ? error
                      : primaryText,
                ),
                textField(
                  title: "Nhiệt độ cơ thể (\u00B0C)",
                  content: healthData.temperature != null
                      ? healthData.temperature!.data
                      : "Không rõ",
                  extraContent: healthData.temperature != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.temperature!.updatedAt.toLocal())})"
                      : "",
                  textColor: healthData.temperature != null &&
                          (double.parse(healthData.temperature!.data) < 36 ||
                              double.parse(healthData.temperature!.data) >
                                  37.6) &&
                          quarantineData.lastHealthStatusTime != null &&
                          (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                  .toString() ==
                              healthData.temperature!.updatedAt.toString())
                      ? ((double.parse(healthData.temperature!.data) - 36)
                                      .abs() <
                                  1 &&
                              (double.parse(healthData.temperature!.data) -
                                          37.6)
                                      .abs() <
                                  1)
                          ? warning
                          : error
                      : primaryText,
                ),
                textField(
                  title: "Nồng độ oxi trong máu (spO2) (%)",
                  content: healthData.spo2 != null
                      ? healthData.spo2!.data
                      : "Không rõ",
                  extraContent: healthData.spo2 != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.spo2!.updatedAt.toLocal())})"
                      : "",
                  textColor: healthData.spo2 != null &&
                          int.parse(healthData.spo2!.data) <= 97 &&
                          quarantineData.lastHealthStatusTime != null &&
                          (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                  .toString() ==
                              healthData.spo2!.updatedAt.toString())
                      ? int.parse(healthData.spo2!.data) < 94
                          ? error
                          : warning
                      : primaryText,
                ),
                textField(
                  title: "Nhịp thở (lần/phút)",
                  content: healthData.breathing != null
                      ? healthData.breathing!.data
                      : "Không rõ",
                  extraContent: healthData.breathing != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.breathing!.updatedAt.toLocal())})"
                      : "",
                  textColor: healthData.breathing != null &&
                          (int.parse(healthData.breathing!.data) < 16 ||
                              int.parse(healthData.breathing!.data) > 20) &&
                          quarantineData.lastHealthStatusTime != null &&
                          (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                  .toString() ==
                              healthData.breathing!.updatedAt.toString())
                      ? (int.parse(healthData.breathing!.data) < 12 ||
                              int.parse(healthData.breathing!.data) > 28)
                          ? error
                          : warning
                      : primaryText,
                ),
                textField(
                  title: "Huyết áp (mmHg)",
                  content: (healthData.bloodPressureMax != null &&
                          healthData.bloodPressureMin != null)
                      ? "${healthData.bloodPressureMax!.data}/${healthData.bloodPressureMin!.data}"
                      : "Không rõ",
                  extraContent: healthData.bloodPressureMin != null
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.bloodPressureMin!.updatedAt.toLocal())})"
                      : "",
                  textColor: ((healthData.bloodPressureMax != null && (int.parse(healthData.bloodPressureMax!.data) < 90 || int.parse(healthData.bloodPressureMax!.data) > 119)) ||
                              (healthData.bloodPressureMin != null &&
                                  (int.parse(healthData.bloodPressureMin!.data) < 60 ||
                                      int.parse(healthData.bloodPressureMin!.data) >
                                          79))) &&
                          (quarantineData.lastHealthStatusTime != null &&
                                  (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                          .toString() ==
                                      healthData.bloodPressureMax!.updatedAt
                                          .toString()) ||
                              quarantineData.lastHealthStatusTime != null &&
                                  (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                          .toString() ==
                                      healthData.bloodPressureMin!.updatedAt
                                          .toString()))
                      ? (int.parse(healthData.bloodPressureMax!.data) <= 89 ||
                              int.parse(healthData.bloodPressureMax!.data) >= 140 ||
                              int.parse(healthData.bloodPressureMin!.data) <= 59 ||
                              int.parse(healthData.bloodPressureMin!.data) >= 90)
                          ? error
                          : warning
                      : primaryText,
                ),
                textField(
                  title: "Triệu chứng nghi nhiễm",
                  content: (healthData.mainSymptoms != null &&
                          healthData.mainSymptoms!.data.isNotEmpty)
                      ? healthData.mainSymptoms!.data
                          .split(',')
                          .map((e) => symptomMainList
                              .safeFirstWhere(
                                  (result) => result.id == int.parse(e))!
                              .name)
                          .join(", ")
                      : "Không rõ",
                  extraContent: (healthData.mainSymptoms != null &&
                          healthData.mainSymptoms!.data.isNotEmpty)
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.mainSymptoms!.updatedAt.toLocal())})"
                      : "",
                  textColor: (healthData.mainSymptoms != null &&
                              healthData.mainSymptoms!.data.isNotEmpty) &&
                          quarantineData.lastHealthStatusTime != null &&
                          (DateTime.parse(quarantineData.lastHealthStatusTime!)
                                  .toString() ==
                              healthData.mainSymptoms!.updatedAt.toString())
                      ? error
                      : primaryText,
                ),
                textField(
                  title: "Triệu chứng khác",
                  content: (healthData.extraSymptoms != null &&
                          healthData.extraSymptoms!.data.isNotEmpty)
                      ? healthData.extraSymptoms!.data
                              .split(',')
                              .map((e) => symptomExtraList
                                  .safeFirstWhere(
                                      (result) => result.id == int.parse(e))!
                                  .name)
                              .join(", ") +
                          ((healthData.otherSymptoms != null &&
                                  healthData.otherSymptoms!.data.isNotEmpty)
                              ? ", ${healthData.otherSymptoms!.data}"
                              : "")
                      : (healthData.otherSymptoms != null &&
                              healthData.otherSymptoms!.data.isNotEmpty)
                          ? healthData.otherSymptoms!.data
                          : "Không rõ",
                  extraContent: (healthData.extraSymptoms != null &&
                          healthData.extraSymptoms!.data.isNotEmpty)
                      ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.extraSymptoms!.updatedAt.toLocal())})"
                      : (healthData.otherSymptoms != null &&
                              healthData.otherSymptoms!.data.isNotEmpty)
                          ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData.otherSymptoms!.updatedAt.toLocal())})"
                          : "",
                  textColor: ((healthData.extraSymptoms != null &&
                                  healthData.extraSymptoms!.data.isNotEmpty) ||
                              (healthData.otherSymptoms != null &&
                                  healthData.otherSymptoms!.data.isNotEmpty)) &&
                          (quarantineData.lastHealthStatusTime != null &&
                                  (DateTime.parse(quarantineData
                                              .lastHealthStatusTime!)
                                          .toString() ==
                                      healthData.extraSymptoms!.updatedAt
                                          .toString()) ||
                              quarantineData.lastHealthStatusTime != null &&
                                  (DateTime.parse(quarantineData
                                              .lastHealthStatusTime!)
                                          .toString() ==
                                      healthData.otherSymptoms!.updatedAt
                                          .toString()))
                      ? warning
                      : primaryText,
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
                      : (personalData.status == "AVAILABLE" &&
                              quarantineData.quarantinedStatus ==
                                  "HOSPITALIZE_WAITING")
                          ? "Đang cách ly & Chờ chuyển viện"
                          : personalData.status == "AVAILABLE"
                              ? "Đang cách ly"
                              : personalData.status == "REFUSE"
                                  ? "Đã từ chối"
                                  : (personalData.status == "LEAVE" &&
                                          quarantineData.quarantinedStatus ==
                                              "HOSPITALIZE")
                                      ? "Đã chuyển viện"
                                      : (personalData.status == "LEAVE" &&
                                              quarantineData
                                                      .quarantinedStatus ==
                                                  "COMPLETED")
                                          ? "Đã hoàn thành cách ly"
                                          : "Không rõ",
                  textColor: primaryText,
                ),
                textField(
                  title: "Nơi cách ly",
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
                      : "Không rõ",
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
}
