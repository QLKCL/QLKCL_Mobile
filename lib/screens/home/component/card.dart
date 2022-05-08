import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';

class QuarantineHome extends StatelessWidget {
  final String name;
  final String manager;
  final String address;
  final String room;
  final String phone;
  final String? quarantineAt;
  final String? quarantineFinishExpect;

  const QuarantineHome({
    required this.name,
    required this.manager,
    required this.address,
    required this.room,
    required this.phone,
    required this.quarantineAt,
    required this.quarantineFinishExpect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Thông tin cách ly",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.phone,
                      title: "Liên hệ",
                      content: phone,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.account_box_outlined,
                      title: "Quản lý",
                      content: manager,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.date_range_outlined,
                      title: "Bắt đầu cách ly",
                      content: quarantineAt != null
                          ? DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(quarantineAt!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.date_range_outlined,
                      title: "Dự kiến hoàn thành cách ly",
                      content: quarantineFinishExpect != null
                          ? DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(quarantineFinishExpect!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.maps_home_work_outlined,
                      title: "Phòng cách ly",
                      content: room,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.place_outlined,
                      title: "Địa chỉ",
                      content: address,
                      textColor: primaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthStatus extends StatelessWidget {
  final String healthStatus;
  final bool? positiveTestNow;
  final String? lastTestedHadResult;
  final String? numberOfVaccineDoses;
  final HealthInfo? healthData;

  const HealthStatus({
    required this.healthStatus,
    required this.positiveTestNow,
    required this.lastTestedHadResult,
    required this.numberOfVaccineDoses,
    this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> listHealthData() {
      return (healthData != null)
          ? [
              cardLine(
                topPadding: 8,
                title: "Nhịp tim",
                content: healthData!.heartbeat != null
                    ? "${healthData!.heartbeat!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.heartbeat!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Nhiệt độ cơ thể",
                content: healthData!.temperature != null
                    ? "${healthData!.temperature!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.temperature!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Nồng độ oxi trong máu (SPO2)",
                content: healthData!.spo2 != null
                    ? "${healthData!.spo2!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.spo2!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Nhịp thở",
                content: healthData!.breathing != null
                    ? "${healthData!.breathing!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.breathing!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Huyết áp",
                content: healthData!.bloodPressure != null
                    ? "${healthData!.bloodPressure!.data} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.bloodPressure!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Triệu chứng nghi nhiễm",
                content: (healthData!.mainSymptoms != null &&
                        healthData!.mainSymptoms!.data.isNotEmpty)
                    ? "${healthData!.mainSymptoms!.data.split(',').map((e) => symptomMainList.safeFirstWhere((result) => result.id == int.parse(e))!.name).join(", ")} (${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.mainSymptoms!.updatedAt.toLocal())})"
                    : "Không rõ",
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Triệu chứng khác",
                content: (healthData!.mainSymptoms != null &&
                        healthData!.mainSymptoms!.data.isNotEmpty)
                    ? "${(healthData!.extraSymptoms != null && healthData!.extraSymptoms!.data.isNotEmpty) ? healthData!.extraSymptoms!.data.split(',').map((e) => symptomExtraList.safeFirstWhere((result) => result.id == int.parse(e))!.name).join(", ") + ((healthData!.otherSymptoms != null && healthData!.otherSymptoms!.data.isNotEmpty) ? ", ${healthData!.otherSymptoms!.data}" : "") : (healthData!.otherSymptoms != null && healthData!.otherSymptoms!.data.isNotEmpty) ? healthData!.otherSymptoms!.data : ""} (${(healthData!.extraSymptoms != null && healthData!.extraSymptoms!.data.isNotEmpty) ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.extraSymptoms!.updatedAt.toLocal())})" : (healthData!.otherSymptoms != null && healthData!.otherSymptoms!.data.isNotEmpty) ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.otherSymptoms!.updatedAt.toLocal())})" : ""})"
                    : "Không rõ",
                textColor: primaryText,
              ),
            ]
          : const [];
    }

    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Thông tin sức khỏe",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    cardLine(
                      topPadding: 8,
                      title: "Sức khỏe",
                      content: healthStatus == "SERIOUS"
                          ? "Nguy hiểm"
                          : (healthStatus == "UNWELL"
                              ? "Nghi nhiễm"
                              : "Bình thường"),
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      title: "Xét nghiệm",
                      content: positiveTestNow != null
                          ? ((positiveTestNow == false
                                  ? "Âm tính"
                                  : "Dương tính") +
                              (lastTestedHadResult != null
                                  ? " (${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(lastTestedHadResult!).toLocal())})"
                                  : ""))
                          : "Chưa có kết quả xét nghiệm",
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      title: "Số mũi vaccine",
                      content: numberOfVaccineDoses != null &&
                              numberOfVaccineDoses != ""
                          ? "$numberOfVaccineDoses mũi"
                          : "Chưa có dữ liệu",
                      textColor: primaryText,
                    ),
                    ...listHealthData(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuarantineFinishCertification extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String? quarantineAt;
  final String? quarantineFinishAt;
  final String? quarantineReason;

  const QuarantineFinishCertification({
    required this.name,
    required this.address,
    required this.phone,
    this.quarantineAt,
    this.quarantineFinishAt,
    this.quarantineReason,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Đã hoàn thành cách ly",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.maps_home_work_outlined,
                      title: "Khu cách ly",
                      content: name,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.phone,
                      title: "Liên hệ",
                      content: phone,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.place_outlined,
                      title: "Địa chỉ",
                      content: address,
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.date_range_outlined,
                      title: "Bắt đầu cách ly",
                      content: quarantineAt != null
                          ? DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(quarantineAt!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.date_range_outlined,
                      title: "Hoàn thành cách ly",
                      content: quarantineFinishAt != null
                          ? DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(quarantineFinishAt!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    cardLine(
                      topPadding: 8,
                      icon: Icons.date_range_outlined,
                      title: "Lý do cách ly",
                      content: quarantineReason ?? "Chưa rõ",
                      textColor: primaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
