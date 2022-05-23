import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/manager/list_all_manager_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'carousel.dart';
import 'carousel_building.dart';
import 'package:url_launcher/url_launcher.dart';

class QuarantineInfo extends StatefulWidget {
  final Quarantine quarantineInfo;
  const QuarantineInfo({
    Key? key,
    required this.quarantineInfo,
  }) : super(key: key);

  @override
  _QuarantineInfoState createState() => _QuarantineInfoState();
}

class _QuarantineInfoState extends State<QuarantineInfo> {
  late Future<dynamic> futureBuildingList;

  @override
  void initState() {
    super.initState();
    futureBuildingList = fetchBuildingList({
      'quarantine_ward': widget.quarantineInfo.id,
      'page_size': pageSizeMax,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Carousel(image: widget.quarantineInfo.image),
          const SizedBox(
            height: 10,
          ),
          //Name and icon
          Container(
            margin: const EdgeInsets.only(
              left: 23,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quarantineInfo.fullName,
                        //quarantineName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        (widget.quarantineInfo.address != null
                                ? "${widget.quarantineInfo.address}, "
                                : "") +
                            (widget.quarantineInfo.ward != null
                                ? "${widget.quarantineInfo.ward['name']}, "
                                : "") +
                            (widget.quarantineInfo.district != null
                                ? "${widget.quarantineInfo.district['name']}, "
                                : "") +
                            (widget.quarantineInfo.city != null
                                ? "${widget.quarantineInfo.city['name']}"
                                : ""),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Color.fromRGBO(138, 149, 158, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                //Button
                Row(
                  children: [
                    IconButton(
                      iconSize: 38,
                      onPressed: widget.quarantineInfo.phoneNumber != null
                          ? () async {
                              launch(
                                  "tel://${widget.quarantineInfo.phoneNumber}");
                            }
                          : () {
                              showNotification('Số điện thoại không tồn tại.',
                                  status: Status.error);
                            },
                      icon: WebsafeSvg.asset("assets/svg/Phone.svg"),
                    ),
                    IconButton(
                        iconSize: 38,
                        onPressed: (widget.quarantineInfo.latitude != null &&
                                widget.quarantineInfo.longitude != null)
                            ? () async {
                                final String googleUrl =
                                    'https://www.google.com/maps/search/?api=1&query=${widget.quarantineInfo.latitude},${widget.quarantineInfo.longitude}';
                                if (await canLaunch(googleUrl)) {
                                  await launch(googleUrl);
                                } else {
                                  showNotification('Không thể mở bản đồ.',
                                      status: Status.error);
                                }
                              }
                            : () {
                                showNotification('Không thể xác định vị trí.',
                                    status: Status.error);
                              },
                        icon: WebsafeSvg.asset("assets/svg/Location.svg"))
                  ],
                ),
              ],
            ),
          ),

          FutureBuilder<dynamic>(
            future: futureBuildingList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return CarouselBuilding(
                    data: snapshot.data,
                    currentQuarantine: widget.quarantineInfo,
                  );
                } else if (snapshot.hasError) {
                  return const Text('Snapshot has error');
                } else {
                  return const Text(
                    'Không có dữ liệu',
                    textAlign: TextAlign.center,
                  );
                }
              }
              return const SizedBox();
            },
          ),

          //Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: const Text(
                          'Thông tin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListAllManager(
                                currentQuarrantine: KeyValue(
                                    name: widget.quarantineInfo.fullName,
                                    id: widget.quarantineInfo.id),
                              ),
                            ),
                          );
                        },
                        child: const Text('Danh sách quản lý, cán bộ'),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(primary),
                        ),
                      )
                    ],
                  ),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.medical_services_outlined,
                      title: "Dịch bệnh cách ly",
                      content: widget.quarantineInfo.pandemic?.name ??
                          "Chưa có thông tin"),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.history,
                      title: "Thời gian cách ly",
                      content:
                          '${widget.quarantineInfo.pandemic?.quarantineTimeNotVac} ngày'),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.hotel_outlined,
                      title: "Tổng số giường",
                      content: '${widget.quarantineInfo.capacity} giường'),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.groups_outlined,
                      title: "Đang cách ly",
                      content: '${widget.quarantineInfo.currentMem} người'),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.account_box_outlined,
                      title: "Quản lý",
                      content:
                          '${widget.quarantineInfo.mainManager["full_name"]}'),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.place_outlined,
                      title: "Địa chỉ",
                      content:
                          '${widget.quarantineInfo.address != null ? "${widget.quarantineInfo.address}, " : ""}${widget.quarantineInfo.ward != null ? "${widget.quarantineInfo.ward['name']}, " : ""}${widget.quarantineInfo.district != null ? "${widget.quarantineInfo.district['name']}, " : ""}${widget.quarantineInfo.city != null ? "${widget.quarantineInfo.city['name']}" : ""}'),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.phone,
                      title: "Số điện thoại",
                      content: widget.quarantineInfo.phoneNumber ?? "Chưa có"),
                  cardLine(
                      topPadding: 8,
                      textColor: secondaryText,
                      icon: Icons.email_outlined,
                      title: "Email",
                      content: widget.quarantineInfo.email),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
