
import 'package:flutter/material.dart';
import 'package:qlkcl/theme/app_theme.dart';

class InfoManagerHomePage extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String title;
  final String subtitle;
  const InfoManagerHomePage(
      {required this.onTap,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 17,
            ),
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.groups_rounded,
                  color: CustomColors.disableText,
                ),
              ),
              TextSpan(
                text: " " + subtitle,
              )
            ],
          ),
        ),
        leading: icon,
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
