import 'package:flutter/material.dart';
import 'package:qlkcl/theme/app_theme.dart';
// import 'package:websafe_svg/websafe_svg.dart';

import '../quarantine_detail_screen.dart';

class QuarantineItem extends StatelessWidget {
  //final VoidCallback onTap;
  final String id;
  final String name;
  final int numberOfMem;
  final String manager;

  const QuarantineItem({
    //required this.onTap,
    required this.id,
    required this.name,
    required this.numberOfMem,
    required this.manager,
  });
  void selectQuarantine(BuildContext context) {
    Navigator.of(context,rootNavigator: true).pushNamed(
      QuarantineDetailScreen.routeName,
      arguments: {
        'id': id,
        'full_name': name,
      },

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
                      name,
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
                            text: " Đang cách ly: " + numberOfMem.toString(),
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
                            text: " Quản lý: " + manager,
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
