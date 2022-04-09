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
              style: TextStyle(color: CustomColors.white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "+ " + newCase,
              textAlign: TextAlign.center,
              style: TextStyle(color: CustomColors.white),
            ),
            const SizedBox(
              height: 8,
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
    List<InfoCovid> listInfo = [
      InfoCovid(
        color: CustomColors.warning,
        title: "Nhiễm bệnh",
        newCase: increaseConfirmed,
        totalCase: confirmed,
      ),
      InfoCovid(
        color: CustomColors.disableText,
        title: "Tử vong",
        newCase: increaseDeaths,
        totalCase: deaths,
      ),
      InfoCovid(
        color: CustomColors.success,
        title: "Bình phục",
        newCase: increaseRecovered,
        totalCase: recovered,
      ),
      InfoCovid(
        color: CustomColors.error,
        title: "Đang điều trị",
        newCase: increaseActived,
        totalCase: actived,
      ),
    ];

    var _screenWidth = MediaQuery.of(context).size.width - 16;
    var _crossAxisCount = _screenWidth >= minDesktopSize ? 4 : 2;
    var _width = _screenWidth / _crossAxisCount;
    var cellHeight = 148;
    var _aspectRatio = _width / cellHeight;

    return Column(children: <Widget>[
      ResponsiveGridView.builder(
        padding: const EdgeInsets.only(top: 8),
        gridDelegate: ResponsiveGridDelegate(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          maxCrossAxisExtent: _width,
          minCrossAxisExtent: _width < maxMobileSize ? _width : maxMobileSize,
          childAspectRatio: _aspectRatio,
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
      Container(
        child: Row(
          children: [
            Text(
              "Cập nhật: " + lastUpdate,
              textAlign: TextAlign.left,
            ),
            Spacer(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Nguồn: ',
                    style: TextStyle(color: CustomColors.primaryText),
                  ),
                  TextSpan(
                    text: 'Dữ liệu Covid-19',
                    style: TextStyle(color: CustomColors.primary),
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
      ),
    ]);
  }
}
