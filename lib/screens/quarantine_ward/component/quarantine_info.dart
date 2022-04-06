import 'package:flutter/material.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:qlkcl/networking/response.dart';
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
    futureBuildingList =
        fetchBuildingList({'quarantine_ward': widget.quarantineInfo.id});
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  Widget buildInformation(BuildContext context, IconData icon, String info) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                icon,
                size: 16,
                color: CustomColors.secondaryText,
              ),
            ),
            TextSpan(
              text: info,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Carousel(image: widget.quarantineInfo.image),
          SizedBox(
            height: 10,
          ),
          //Name and icon
          Container(
            margin: EdgeInsets.only(
              left: 23,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //Name
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quarantineInfo.fullName,
                        //quarantineName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
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
                        style: TextStyle(
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
                              launch("tel://" +
                                  widget.quarantineInfo.phoneNumber.toString());
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
                                String googleUrl =
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
                  return Text('Snapshot has error');
                } else {
                  return Text(
                    'Không có dữ liệu',
                    textAlign: TextAlign.center,
                  );
                }
              }
              return Container();
            },
          ),

          //Information
          Container(
            width: MediaQuery.of(context).size.width * 1,
            margin: EdgeInsets.only(left: 23, right: 23, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text(
                    'Thông tin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                buildInformation(
                    context,
                    Icons.medical_services_outlined,
                    ' Dịch bệnh cách ly: ' +
                        (widget.quarantineInfo.pandemic?.name ??
                            "Chưa có thông tin")),
                buildInformation(
                    context,
                    Icons.history,
                    ' Thời gian cách ly: ' +
                        widget.quarantineInfo.quarantineTime.toString() +
                        ' ngày'),
                buildInformation(
                    context,
                    Icons.hotel_outlined,
                    ' Tổng số giường: ' +
                        widget.quarantineInfo.capacity.toString() +
                        ' giường'),
                buildInformation(
                    context,
                    Icons.groups_outlined,
                    ' Đang cách ly: ' +
                        widget.quarantineInfo.currentMem.toString() +
                        ' người'),
                buildInformation(
                    context,
                    Icons.account_box_outlined,
                    ' Quản lý: ' +
                        widget.quarantineInfo.mainManager["full_name"]),
                buildInformation(
                  context,
                  Icons.place_outlined,
                  ' Địa chỉ: ' +
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
                ),
                buildInformation(
                    context,
                    Icons.phone,
                    ' Số điện thoại: ' +
                        (widget.quarantineInfo.phoneNumber != null
                            ? widget.quarantineInfo.phoneNumber!
                            : 'Chưa có')),
                buildInformation(context, Icons.email_outlined,
                    ' Email: ' + widget.quarantineInfo.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
