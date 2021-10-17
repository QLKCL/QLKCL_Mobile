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
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: icon,
            ),
            Expanded(
              flex: 3,
              child: ListTile(
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
                  )),
            ),
            Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      ),
    );
  }
}

class InfoMemberHomePage extends StatelessWidget {
  final Color color;
  final String title;
  final String newCase;
  final String totalCase;
  const InfoMemberHomePage(
      {required this.color,
      required this.title,
      required this.newCase,
      required this.totalCase});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Card(
        color: color,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.white),
              ),
              subtitle: Text(
                "+" + newCase,
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.white),
              ),
            ),
            Text(
              totalCase,
              style: TextStyle(color: CustomColors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
