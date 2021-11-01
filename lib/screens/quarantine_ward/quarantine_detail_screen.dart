// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qlkcl/screens/quarantine_ward/component/dummy_data.dart';
import 'package:websafe_svg/websafe_svg.dart';
import './component/carousel.dart';

class QuarantineDetailScreen extends StatefulWidget {
  static const routeName = '/quarantine-details';

  @override
  _QuarantineDetailScreenState createState() => _QuarantineDetailScreenState();
}

class _QuarantineDetailScreenState extends State<QuarantineDetailScreen> {
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

    //define appBar
    final appBar = AppBar(
      title: Text(quarantineName!),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.edit),
        ),
      ],
    );

    //Config Screen
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(children: [
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
                        quarantineName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Bình Dương, Dĩ An, Đông Hòa',
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
                      onPressed: () {},
                      icon: WebsafeSvg.asset("assets/svg/Phone.svg"),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(color: Colors.amber),
                    //   child: SizedBox(
                    //     width: 8,
                    //   ),
                    // ),
                    IconButton(
                        iconSize: 38,
                        onPressed: () {},
                        icon: WebsafeSvg.asset("assets/svg/Location.svg"))
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
