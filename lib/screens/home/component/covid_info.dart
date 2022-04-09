import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCovid extends StatelessWidget {
  final Color color;
  final String title;
  final String newCase;
  final String totalCase;
  const InfoCovid(
      {required this.color,
      required this.title,
      required this.newCase,
      required this.totalCase});

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(color: white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "+ $newCase",
              textAlign: TextAlign.center,
              style: TextStyle(color: white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              totalCase,
              style: TextStyle(color: white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCovidHomePage extends StatelessWidget {
  final String increaseConfirmed;
  final String confirmed;
  final String increaseDeaths;
  final String deaths;
  final String increaseRecovered;
  final String recovered;
  final String increaseActived;
  final String actived;
  final String lastUpdate;

  const InfoCovidHomePage({
    this.increaseConfirmed = "0",
    this.confirmed = "0",
    this.increaseDeaths = "0",
    this.deaths = "0",
    this.increaseRecovered = "0",
    this.recovered = "0",
    this.increaseActived = "0",
    this.actived = "0",
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

    final screenWidth = MediaQuery.of(context).size.width - 16;
    final crossAxisCount = screenWidth >= minDesktopSize ? 4 : 2;
    final width = screenWidth / crossAxisCount;
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
                    text: 'Dữ liệu Covid-19',
                    style: TextStyle(color: primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://covid19.ncsc.gov.vn/dulieu');
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
