import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/medical_declaration.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';

class QuarantineHome extends StatelessWidget {
  final String room;
  final String? quarantineAt;
  final String? quarantineFinishExpect;
  final String status;

  const QuarantineHome({
    required this.room,
    this.quarantineAt,
    this.quarantineFinishExpect,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: MediaQuery.of(context).size.width > minDesktopSize
          ? const EdgeInsets.fromLTRB(16, 8, 8, 0)
          : null,
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
                      status,
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthStatus extends StatelessWidget {
  final String healthStatus;
  final bool? positiveTestNow;
  final String? lastHealthStatusTime;
  final String? lastTestedHadResult;
  final String? numberOfVaccineDoses;
  final HealthInfo? healthData;

  const HealthStatus({
    required this.healthStatus,
    required this.lastHealthStatusTime,
    required this.positiveTestNow,
    required this.lastTestedHadResult,
    required this.numberOfVaccineDoses,
    this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: MediaQuery.of(context).size.width > minDesktopSize
          ? const EdgeInsets.fromLTRB(8, 8, 16, 0)
          : null,
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
                            ? "Không tốt"
                            : "Bình thường"),
                    extraContent: lastHealthStatusTime != null
                        ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(lastHealthStatusTime!).toLocal())})"
                        : "",
                    contentColor: lastHealthStatusTime != null
                        ? (healthStatus == "SERIOUS"
                            ? error
                            : healthStatus == "UNWELL"
                                ? warning
                                : success)
                        : primaryText,
                    textColor: primaryText,
                  ),
                  cardLine(
                    topPadding: 8,
                    title: "Xét nghiệm",
                    content: positiveTestNow != null
                        ? positiveTestNow == false
                            ? "Âm tính"
                            : "Dương tính"
                        : "Chưa có kết quả xét nghiệm",
                    extraContent: (positiveTestNow != null &&
                            lastTestedHadResult != null)
                        ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(lastTestedHadResult!).toLocal())})"
                        : "",
                    contentColor: positiveTestNow != null
                        ? (positiveTestNow?.toString().capitalize() == "True"
                            ? error
                            : success)
                        : primaryText,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthStatusData extends StatelessWidget {
  final String healthStatus;
  final bool? positiveTestNow;
  final String? lastHealthStatusTime;
  final String? lastTestedHadResult;
  final String? numberOfVaccineDoses;
  final HealthInfo? healthData;

  const HealthStatusData({
    required this.healthStatus,
    required this.lastHealthStatusTime,
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
                title: "Triệu chứng nghi nhiễm",
                content: (healthData!.mainSymptoms != null &&
                        healthData!.mainSymptoms!.data.isNotEmpty)
                    ? healthData!.mainSymptoms!.data
                        .split(',')
                        .map((e) => symptomMainList
                            .safeFirstWhere(
                                (result) => result.id == int.parse(e))!
                            .name)
                        .join(", ")
                    : "Không có",
                extraContent: (healthData!.mainSymptoms != null &&
                        healthData!.mainSymptoms!.data.isNotEmpty)
                    ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.mainSymptoms!.updatedAt.toLocal())})"
                    : "",
                contentColor: (healthData!.mainSymptoms != null &&
                            healthData!.mainSymptoms!.data.isNotEmpty) &&
                        lastHealthStatusTime != null &&
                        (DateTime.parse(lastHealthStatusTime!).toString() ==
                            healthData!.mainSymptoms!.updatedAt.toString())
                    ? error
                    : primaryText,
                textColor: primaryText,
              ),
              cardLine(
                topPadding: 8,
                title: "Triệu chứng khác",
                content: (healthData!.extraSymptoms != null &&
                        healthData!.extraSymptoms!.data.isNotEmpty)
                    ? (healthData!.extraSymptoms != null &&
                            healthData!.extraSymptoms!.data.isNotEmpty)
                        ? healthData!.extraSymptoms!.data
                                .split(',')
                                .map((e) => symptomExtraList
                                    .safeFirstWhere(
                                        (result) => result.id == int.parse(e))!
                                    .name)
                                .join(", ") +
                            ((healthData!.otherSymptoms != null &&
                                    healthData!.otherSymptoms!.data.isNotEmpty)
                                ? ", ${healthData!.otherSymptoms!.data}"
                                : "")
                        : (healthData!.otherSymptoms != null &&
                                healthData!.otherSymptoms!.data.isNotEmpty)
                            ? healthData!.otherSymptoms!.data
                            : ""
                    : "Không có",
                extraContent: (healthData!.extraSymptoms != null &&
                        healthData!.extraSymptoms!.data.isNotEmpty)
                    ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.extraSymptoms!.updatedAt.toLocal())})"
                    : (healthData!.otherSymptoms != null &&
                            healthData!.otherSymptoms!.data.isNotEmpty)
                        ? "(${DateFormat("dd/MM/yyyy HH:mm:ss").format(healthData!.otherSymptoms!.updatedAt.toLocal())})"
                        : "",
                contentColor: ((healthData!.extraSymptoms != null &&
                                healthData!.extraSymptoms!.data.isNotEmpty) ||
                            (healthData!.otherSymptoms != null &&
                                healthData!.otherSymptoms!.data.isNotEmpty)) &&
                        (lastHealthStatusTime != null &&
                                (DateTime.parse(lastHealthStatusTime!)
                                        .toString() ==
                                    healthData!.extraSymptoms!.updatedAt
                                        .toString()) ||
                            lastHealthStatusTime != null &&
                                (DateTime.parse(lastHealthStatusTime!)
                                        .toString() ==
                                    healthData!.otherSymptoms!.updatedAt
                                        .toString()))
                    ? warning
                    : primaryText,
                textColor: primaryText,
              ),
            ]
          : const [];
    }

    final List<HealthIndex> listCardHealthData = (healthData != null)
        ? [
            HealthIndex(
              title: 'Nhịp tim',
              data: healthData!.heartbeat != null
                  ? healthData!.heartbeat!.data
                  : "--",
              unit: 'lần/phút',
              time: healthData!.heartbeat?.updatedAt,
              color: healthData!.heartbeat != null &&
                      (double.parse(healthData!.heartbeat!.data) < 50 ||
                          double.parse(healthData!.heartbeat!.data) > 100) &&
                      lastHealthStatusTime != null &&
                      (DateTime.parse(lastHealthStatusTime!).toString() ==
                          healthData!.heartbeat!.updatedAt.toString())
                  ? error
                  : secondaryText,
            ),
            HealthIndex(
              title: 'Nhiệt độ cơ thể',
              data: healthData!.temperature != null
                  ? healthData!.temperature!.data
                  : "--",
              unit: '\u00B0C',
              time: healthData!.temperature?.updatedAt,
              color: healthData!.temperature != null &&
                      (double.parse(healthData!.temperature!.data) < 36 ||
                          double.parse(healthData!.temperature!.data) > 37.6) &&
                      lastHealthStatusTime != null &&
                      (DateTime.parse(lastHealthStatusTime!).toString() ==
                          healthData!.temperature!.updatedAt.toString())
                  ? (double.parse(healthData!.temperature!.data) < 35 ||
                          double.parse(healthData!.temperature!.data) > 38.6)
                      ? error
                      : warning
                  : secondaryText,
            ),
            HealthIndex(
              title: 'spO2',
              data: healthData!.spo2 != null
                  ? double.parse(healthData!.spo2!.data).toInt().toString()
                  : "--",
              unit: '%',
              time: healthData!.spo2?.updatedAt,
              color: healthData!.spo2 != null &&
                      double.parse(healthData!.spo2!.data) <= 97 &&
                      lastHealthStatusTime != null &&
                      (DateTime.parse(lastHealthStatusTime!).toString() ==
                          healthData!.spo2!.updatedAt.toString())
                  ? double.parse(healthData!.spo2!.data) < 94
                      ? error
                      : warning
                  : secondaryText,
            ),
            HealthIndex(
              title: 'Nhịp thở',
              data: healthData!.breathing != null
                  ? healthData!.breathing!.data
                  : "--",
              unit: 'lần/phút',
              time: healthData!.breathing?.updatedAt,
              color: healthData!.breathing != null &&
                      (double.parse(healthData!.breathing!.data) < 16 ||
                          double.parse(healthData!.breathing!.data) > 20) &&
                      lastHealthStatusTime != null &&
                      (DateTime.parse(lastHealthStatusTime!).toString() ==
                          healthData!.breathing!.updatedAt.toString())
                  ? (double.parse(healthData!.breathing!.data) < 12 ||
                          double.parse(healthData!.breathing!.data) > 28)
                      ? error
                      : warning
                  : secondaryText,
            ),
            HealthIndex(
              title: 'Huyết áp',
              data: (healthData!.bloodPressureMax?.data != null &&
                      healthData!.bloodPressureMin?.data != null)
                  ? "${healthData!.bloodPressureMax!.data}/${healthData!.bloodPressureMin!.data}"
                  : "--",
              unit: 'mmHg',
              time: healthData!.bloodPressureMin?.updatedAt,
              color: ((healthData!.bloodPressureMax != null &&
                              (double.parse(healthData!.bloodPressureMax!.data) < 90 ||
                                  double.parse(healthData!.bloodPressureMax!.data) >
                                      119)) ||
                          (healthData!.bloodPressureMin != null &&
                              (double.parse(healthData!.bloodPressureMin!.data) < 60 ||
                                  double.parse(healthData!.bloodPressureMin!.data) >
                                      79))) &&
                      (lastHealthStatusTime != null &&
                              (DateTime.parse(lastHealthStatusTime!).toString() ==
                                  healthData!.bloodPressureMax!.updatedAt
                                      .toString()) ||
                          lastHealthStatusTime != null &&
                              (DateTime.parse(lastHealthStatusTime!).toString() ==
                                  healthData!.bloodPressureMin!.updatedAt
                                      .toString()))
                  ? (double.parse(healthData!.bloodPressureMax!.data) <= 89 ||
                          double.parse(healthData!.bloodPressureMax!.data) >= 140 ||
                          double.parse(healthData!.bloodPressureMin!.data) <= 59 ||
                          double.parse(healthData!.bloodPressureMin!.data) >= 90)
                      ? error
                      : warning
                  : secondaryText,
            ),
          ]
        : const [];

    final screenWidth = MediaQuery.of(context).size.width - 16;
    final crossAxisCount = screenWidth <= maxMobileSize
        ? 1
        : screenWidth <= maxTabletSize
            ? 2
            : screenWidth >= minDesktopSize
                ? (screenWidth - 230) ~/ (maxMobileSize - 156)
                : screenWidth ~/ (maxMobileSize - 32);
    final width = screenWidth / crossAxisCount;
    const cellHeight = 148;
    final aspectRatio = width / cellHeight;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!ResponsiveWrapper.of(context).isSmallerThan(MOBILE))
                    ResponsiveGridView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      gridDelegate: ResponsiveGridDelegate(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        maxCrossAxisExtent: width,
                        minCrossAxisExtent:
                            width < maxMobileSize ? width : maxMobileSize,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: listCardHealthData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return listCardHealthData[index];
                      },
                    ),
                  if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE))
                    ...listCardHealthData.map(
                      (e) => e,
                    ),
                  ...listHealthData(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthIndex extends StatelessWidget {
  const HealthIndex({
    Key? key,
    required this.title,
    required this.data,
    required this.unit,
    this.time,
    this.color,
  }) : super(key: key);

  final String title;
  final String data;
  final DateTime? time;
  final String unit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Responsive.isDesktopLayout(context)
          ? const EdgeInsets.fromLTRB(0, 8, 0, 0)
          : const EdgeInsets.only(bottom: 8),
      // margin: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
            color: color ?? success,
            width: 3,
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryText,
                        ),
                        children: [
                          TextSpan(
                            text: data,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: color,
                            ),
                          ),
                          TextSpan(
                            text: " $unit",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (time != null)
                      Text(
                        DateFormat("dd/MM/yyyy HH:mm").format(time!.toLocal()),
                        style: TextStyle(fontSize: 13, color: disableText),
                      )
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
  final String? quarantineAt;
  final String? quarantineFinishAt;

  const QuarantineFinishCertification({
    required this.name,
    this.quarantineAt,
    this.quarantineFinishAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: MediaQuery.of(context).size.width > minDesktopSize
          ? const EdgeInsets.fromLTRB(8, 8, 8, 0)
          : null,
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
                    icon: Icons.maps_home_work_outlined,
                    title: "Khu cách ly",
                    content: name,
                    textColor: primaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Hospitalization extends StatelessWidget {
  final String? quarantineAt;
  final String? hospitalizeAt;
  final String? hospitalName;

  const Hospitalization({
    required this.quarantineAt,
    required this.hospitalizeAt,
    required this.hospitalName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: MediaQuery.of(context).size.width > minDesktopSize
          ? const EdgeInsets.fromLTRB(8, 8, 8, 0)
          : null,
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
                      "Đã chuyển viện",
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
                    icon: Icons.local_hospital_outlined,
                    title: "Bệnh viện tiếp nhận",
                    content: hospitalName ?? "Chưa rõ",
                    textColor: primaryText,
                  ),
                  cardLine(
                    topPadding: 8,
                    icon: Icons.date_range_outlined,
                    title: "Thời gian tiếp nhận",
                    content: hospitalizeAt != null
                        ? DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(hospitalizeAt!).toLocal())
                        : "Chưa có",
                    textColor: primaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
