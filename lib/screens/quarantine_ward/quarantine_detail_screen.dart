// ignore_for_file: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qlkcl/screens/quarantine_ward/component/dummy_data.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:websafe_svg/websafe_svg.dart';
import './component/carousel.dart';
import './component/carousel_building.dart';
import './edit_quarantine_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../quarantine_management/building_list_screen.dart';

class QuarantineDetailScreen extends StatefulWidget {
  static const routeName = '/quarantine-details';

  @override
  _QuarantineDetailScreenState createState() => _QuarantineDetailScreenState();
}

class _QuarantineDetailScreenState extends State<QuarantineDetailScreen> {


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
    //Pass arguments
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final quarantineId = routeArgs['id'];
    final quarantineName = routeArgs['full_name'];
    final quarantineSelected = DUMMY_QUARANTINE.where((quarantine) {
      return quarantine.id.contains(quarantineId!);
    }).toList();
    final thisQuarantine = DUMMY_QUARANTINE
        .firstWhere((quarantine) => quarantine.id == quarantineId);

    //define appBar
    final appBar = AppBar(
      title: Text('Thông tin khu cách ly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, EditQuarantine.routeName);
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );

    //Config Screen
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
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
                          quarantineName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '${thisQuarantine.ward_id}, ${thisQuarantine.district_id}, ${thisQuarantine.city_id}',
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
                        onPressed: () async {
                          launch("tel://${thisQuarantine.phone_number}");
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
                      Navigator.pushNamed(
                          context, BuildingListScreen.routeName);
                    },
                    child: Text('Xem tất cả'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          CustomColors.primary),
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
                  buildInformation(context, Icons.history,
                      ' Thời gian cách ly: ${thisQuarantine.quarantine_time}'),
                  buildInformation(context, Icons.groups_rounded,
                      ' Đang cách ly: ${thisQuarantine.numOfMem}'),
                  buildInformation(context, Icons.account_box_outlined,
                      ' Quản lý: ${thisQuarantine.main_manager}'),
                  buildInformation(context, Icons.place_outlined,
                      ' Địa chỉ: ${thisQuarantine.ward_id}, ${thisQuarantine.district_id}, ${thisQuarantine.city_id}'),
                  buildInformation(context, Icons.phone,
                      ' Số điện thoại: ${thisQuarantine.phone_number}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
