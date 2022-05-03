import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class InfoCovid extends StatelessWidget {
  final Color color;
  final String title;
  final int newCase;
  final int totalCase;
  const InfoCovid(
      {required this.color,
      required this.title,
      required this.newCase,
      required this.totalCase});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###,###');
    return SizedBox(
      // width: 128,
      height: 128,
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: white, fontSize: 18),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              newCase > 0
                  ? "+ ${formatter.format(newCase)}"
                  : newCase < 0
                      ? "- ${formatter.format(-newCase)}"
                      : "0",
              textAlign: TextAlign.center,
              style: TextStyle(color: white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              formatter.format(totalCase),
              style: TextStyle(color: white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCovidHomePage extends StatelessWidget {
  final int increaseConfirmed;
  final int confirmed;
  final int increaseDeaths;
  final int deaths;
  final int increaseRecovered;
  final int recovered;
  final int increaseActived;
  final int actived;
  final String lastUpdate;

  const InfoCovidHomePage({
    this.increaseConfirmed = 0,
    this.confirmed = 0,
    this.increaseDeaths = 0,
    this.deaths = 0,
    this.increaseRecovered = 0,
    this.recovered = 0,
    this.increaseActived = 0,
    this.actived = 0,
    this.lastUpdate = "dd/MM/yyyy HH:mm:ss",
  });

  @override
  Widget build(BuildContext context) {
    final List<InfoCovid> listInfo = [
      InfoCovid(
        color: warning,
        title: "Nhiễm bệnh",
        newCase: increaseConfirmed,
        totalCase: confirmed,
      ),
      InfoCovid(
        color: disableText,
        title: "Tử vong",
        newCase: increaseDeaths,
        totalCase: deaths,
      ),
      InfoCovid(
        color: success,
        title: "Bình phục",
        newCase: increaseRecovered,
        totalCase: recovered,
      ),
      InfoCovid(
        color: error,
        title: "Đang điều trị",
        newCase: increaseActived,
        totalCase: actived,
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width - 64;
    final crossAxisCount = screenWidth >= maxMobileSize ? 4 : 2;
    final width =
        ((screenWidth >= maxTabletSize) ? (screenWidth - 230) : screenWidth) /
            crossAxisCount;
    const cellHeight = 148;
    final aspectRatio = width / cellHeight;

    return Column(
      children: <Widget>[
        ResponsiveGridView.builder(
          padding: const EdgeInsets.only(top: 8),
          gridDelegate: ResponsiveGridDelegate(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            maxCrossAxisExtent: width,
            minCrossAxisExtent: width < maxMobileSize ? width : maxMobileSize,
            childAspectRatio: aspectRatio,
          ),
          itemCount: listInfo.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return listInfo[index];
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              "Cập nhật: $lastUpdate",
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Nguồn: ',
                    style: TextStyle(color: primaryText),
                  ),
                  TextSpan(
                    text: 'Thanhnien.vn',
                    style: TextStyle(color: primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://thanhnien.vn');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
