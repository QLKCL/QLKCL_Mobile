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
        onTap: () {},
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
      width: 128,
      height: 128,
      child: Card(
        color: color,
        margin: EdgeInsets.all(5),
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

class InfoCovidHomePage extends StatelessWidget {
  final String increaseConfirmed;
  final String confirmed;
  final String increaseDeaths;
  final String deaths;
  final String increaseRecovered;
  final String recovered;
  final String lastUpdate;

  const InfoCovidHomePage(
      {this.increaseConfirmed: "0",
      this.confirmed: "0",
      this.increaseDeaths: "0",
      this.deaths: "0",
      this.increaseRecovered: "0",
      this.recovered: "0",
      this.lastUpdate: "HH:mm, dd/MM/yyyy"});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: InfoCovid(
                color: CustomColors.warning,
                title: "Nhiễm bệnh",
                newCase: increaseConfirmed,
                totalCase: confirmed,
              ),
            ),
            Expanded(
              flex: 3,
              child: InfoCovid(
                color: CustomColors.error,
                title: "Tử vong",
                newCase: increaseDeaths,
                totalCase: deaths,
              ),
            ),
            Expanded(
              flex: 3,
              child: InfoCovid(
                color: CustomColors.success,
                title: "Bình phục",
                newCase: increaseRecovered,
                totalCase: recovered,
              ),
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Text(
          "Cập nhật: " + lastUpdate,
          textAlign: TextAlign.left,
        ),
      )
    ]);
  }
}

class MedicalDeclaration extends StatelessWidget {
  final VoidCallback onTap;
  final String id;
  final String time;
  final String status;
  const MedicalDeclaration(
      {required this.onTap,
      required this.id,
      required this.time,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Text("Mã tờ khai: " + id),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.history,
                      color: CustomColors.disableText,
                    ),
                  ),
                  TextSpan(
                    text: " Thời gian: " + time,
                  )
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.description_outlined,
                      color: CustomColors.disableText,
                    ),
                  ),
                  TextSpan(
                    text: " Tình trạng: " + status,
                  )
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.more_vert,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class Test extends StatelessWidget {
  final VoidCallback onTap;
  final String id;
  final String time;
  final String status;
  const Test(
      {required this.onTap,
      required this.id,
      required this.time,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Text("Mã phiếu: " + id),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.history,
                      color: CustomColors.disableText,
                    ),
                  ),
                  TextSpan(
                    text: " Thời gian: " + time,
                  )
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.description_outlined,
                      color: CustomColors.disableText,
                    ),
                  ),
                  TextSpan(
                    text: " Kết quả: " + status,
                  )
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.more_vert,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
