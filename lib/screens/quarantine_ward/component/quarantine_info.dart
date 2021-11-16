import 'package:flutter/material.dart';
import 'package:qlkcl/models/quarantine.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'carousel.dart';
import 'carousel_building.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../quarantine_management/building_list_screen.dart';

class QuarantineInfo extends StatefulWidget {
  final Quarantine quarantineInfo;
  final int? numOfMem;
  const QuarantineInfo({Key? key, required this.quarantineInfo, this.numOfMem})
      : super(key: key);

  @override
  _QuarantineInfoState createState() => _QuarantineInfoState();
}

class _QuarantineInfoState extends State<QuarantineInfo> {
  Widget buildInformation(BuildContext context, IconData icon, String info) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 14,
          ),
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
          Carousel(),
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
                        widget.quarantineInfo.address != null
                            ? widget.quarantineInfo.address.toString() +
                                ', ' +
                                widget.quarantineInfo.ward['name'] +
                                ', ' +
                                widget.quarantineInfo.district['name'] +
                                ', ' +
                                widget.quarantineInfo.city['name']
                            : widget.quarantineInfo.ward['name'] +
                                ', ' +
                                widget.quarantineInfo.district['name'] +
                                ', ' +
                                widget.quarantineInfo.city['name'],
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Số điện thoại không tồn tại.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                      icon: WebsafeSvg.asset("assets/svg/Phone.svg"),
                    ),
                    IconButton(
                        iconSize: 38,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Ứng dụng chưa hỗ trợ chức năng này.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: WebsafeSvg.asset("assets/svg/Location.svg"))
                  ],
                ),
              ],
            ),
          ),
          //Building list
          Container(
            margin: EdgeInsets.only(left: 23, right: 23, top: 21, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách tòa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, BuildingListScreen.routeName);
                  },
                  child: Text('Xem tất cả'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(CustomColors.primary),
                  ),
                )
              ],
            ),
          ),
          CarouselBuilding(),
          //Information
          Container(
            width: MediaQuery.of(context).size.width * 1,
            margin: EdgeInsets.only(left: 23, right: 23, top: 20, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
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
                    Icons.history,
                    ' Thời gian cách ly: ' +
                        widget.quarantineInfo.quarantineTime.toString()),
                buildInformation(
                    context, Icons.groups_rounded, ' Đang cách ly: ' + widget.numOfMem.toString()),
                // ' Đang cách ly: ${thisQuarantine.numOfMem}'),
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
                          ? widget.quarantineInfo.address! +
                              ', ' +
                              widget.quarantineInfo.ward['name'] +
                              ', ' +
                              widget.quarantineInfo.district['name'] +
                              ', ' +
                              widget.quarantineInfo.city['name']
                          : widget.quarantineInfo.ward['name'] +
                              ', ' +
                              widget.quarantineInfo.district['name'] +
                              ', ' +
                              widget.quarantineInfo.city['name']),
                ),

                buildInformation(
                    context,
                    Icons.phone,
                    'Số điện thoại: ' +
                        (widget.quarantineInfo.phoneNumber != null
                            ? widget.quarantineInfo.phoneNumber!
                            : 'Chưa có')),

                buildInformation(context, Icons.email_outlined,
                    'Email: ' + widget.quarantineInfo.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
