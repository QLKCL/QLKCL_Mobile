import 'package:flutter/material.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/app_theme.dart';

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
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.phone,
                      title: "Liên hệ",
                      content: phone,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.account_box_outlined,
                      title: "Quản lý",
                      content: manager,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.date_range_outlined,
                      title: "Bắt đầu cách ly",
                      content: quarantineAt != null
                          ? DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(quarantineAt!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.date_range_outlined,
                      title: "Dự kiến hoàn thành cách ly",
                      content: quarantineFinishExpect != null
                          ? DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(quarantineFinishExpect!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.maps_home_work_outlined,
                      title: "Phòng cách ly",
                      content: room,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
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

  const HealthStatus({
    required this.healthStatus,
    required this.positiveTestNow,
    required this.lastTestedHadResult,
    required this.numberOfVaccineDoses,
  });

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.history,
                      title: "Sức khỏe",
                      content: healthStatus == "SERIOUS"
                          ? "Nguy hiểm"
                          : (healthStatus == "UNWELL"
                              ? "Nghi nhiễm"
                              : "Bình thường"),
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.description_outlined,
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
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.vaccines_outlined,
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

  const QuarantineFinishCertification({
    required this.name,
    required this.address,
    required this.phone,
    required this.quarantineAt,
    required this.quarantineFinishAt,
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
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.maps_home_work_outlined,
                      title: "Khu cách ly",
                      content: name,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.phone,
                      title: "Liên hệ",
                      content: phone,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.place_outlined,
                      title: "Địa chỉ",
                      content: address,
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.date_range_outlined,
                      title: "Bắt đầu cách ly",
                      content: quarantineAt != null
                          ? DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(quarantineAt!).toLocal())
                          : "Chưa có",
                      textColor: primaryText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cardLine(
                      icon: Icons.date_range_outlined,
                      title: "Hoàn thành cách ly",
                      content: quarantineFinishAt != null
                          ? DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(quarantineFinishAt!).toLocal())
                          : "Chưa có",
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
