import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import '../quarantine_detail_screen.dart';

class QuarantineItem extends StatefulWidget {
  final String id;
  final String name;
  final String manager;
  final int currentMem;

  const QuarantineItem({
    required this.id,
    required this.name,
    required this.manager,
    required this. currentMem,
  });

  @override
  State<QuarantineItem> createState() => _QuarantineItemState();
}

class _QuarantineItemState extends State<QuarantineItem> {
  late Future<int> numOfMem;
  void selectQuarantine(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => QuarantineDetailScreen(
          id: this.widget.id,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
            child: InkWell(
              onTap: () => selectQuarantine(context),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image container
                    Container(
                      height: 96,
                      width: 105,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/QuarantineWard.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    //text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.primaryText),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //subtitle and icon
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: CustomColors.primaryText,
                              ),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.groups_rounded,
                                    size: 16,
                                    color: CustomColors.disableText,
                                  ),
                                ),
                                TextSpan(
                                  text: " Đang cách ly: " +
                                     widget.currentMem.toString() ,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: CustomColors.primaryText,
                              ),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.account_box_outlined,
                                    size: 16,
                                    color: CustomColors.disableText,
                                  ),
                                ),
                                TextSpan(
                                  text: " Quản lý: " + widget.manager,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
          );
  
  }
}
