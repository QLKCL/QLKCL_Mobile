import 'package:flutter/material.dart';
import 'package:qlkcl/theme/app_theme.dart';
import 'package:websafe_svg/websafe_svg.dart';

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
        margin: const EdgeInsets.only(left: 16),
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
        onTap: onTap,
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
        onTap: onTap,
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

class TestNoResult extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final String gender;
  final String birthday;
  final String id;
  final String time;
  const TestNoResult(
      {required this.onTap,
      required this.name,
      required this.gender,
      required this.birthday,
      required this.id,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // contentPadding: EdgeInsets.all(16),
        onTap: onTap,
        title: Container(
          padding: EdgeInsets.only(top: 8),
          child: Text.rich(
            TextSpan(
              // style: TextStyle(
              //   fontSize: 17,
              // ),
              children: [
                TextSpan(
                  text: name + " ",
                  style: Theme.of(context).textTheme.headline6,
                ),
                WidgetSpan(
                  child: WebsafeSvg.asset("assets/svg/male.svg"),
                ),
              ],
            ),
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Wrap(
            direction: Axis.vertical, // make sure to set this
            spacing: 4, // set your spacing
            children: [
              Text(
                birthday,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.qr_code,
                        color: CustomColors.disableText,
                      ),
                    ),
                    TextSpan(
                      text: " " + id,
                    )
                  ],
                ),
              ),
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
                      text: " Chưa có kết quả (" + time + ")",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        isThreeLine: true,
        leading: SizedBox(
          height: 56,
          width: 56,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/no-avatar.png"),
              ),
              Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: WebsafeSvg.asset("assets/svg/binh_thuong.svg"),
                ),
                // RawMaterialButton(
                //           onPressed: () {},
                //           elevation: 2.0,
                //           fillColor: CustomColors.white,
                //           child: WebsafeSvg.asset("assets/svg/binh_thuong.svg"),
                //           shape: CircleBorder(),
                //         ),
              ),
            ],
          ),
        ),
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

class Member extends StatefulWidget {
  final bool longPressEnabled;

  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String id;
  final String name;
  final String gender;
  final String birthday;
  final String room;
  final String lastTestResult;
  final String lastTestTime;
  const Member(
      {required this.onTap,
      required this.onLongPress,
      required this.id,
      required this.name,
      required this.gender,
      required this.birthday,
      required this.room,
      required this.lastTestResult,
      required this.lastTestTime,
      required this.longPressEnabled});

  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<Member> {
  bool _selected = false;

  action() {
    if (widget.longPressEnabled) {
      return Checkbox(
        value: _selected,
        onChanged: (newValue) {
          setState(() {
            _selected = newValue!;
          });
          widget.onLongPress();
        },
      );
    } else {
      return GestureDetector(
        child: Icon(
          Icons.more_vert,
        ),
        onTap: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: ListTile(
          onTap: () {
            if (widget.longPressEnabled) {
              setState(() {
                _selected = !_selected;
              });
              widget.onLongPress();
            } else {
              widget.onTap();
            }
          },
          onLongPress: () {
            setState(() {
              _selected = !_selected;
            });
            widget.onLongPress();
          },
          title: Container(
            padding: EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.name + " ",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  WidgetSpan(
                    child: WebsafeSvg.asset("assets/svg/male.svg"),
                  ),
                ],
              ),
            ),
          ),
          subtitle: Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Wrap(
              direction: Axis.vertical, // make sure to set this
              spacing: 4, // set your spacing
              children: [
                Text(
                  widget.birthday,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.place_outlined,
                          color: CustomColors.disableText,
                        ),
                      ),
                      TextSpan(
                        text: " " + widget.room,
                      )
                    ],
                  ),
                ),
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
                        text: " " +
                            widget.lastTestResult +
                            " (" +
                            widget.lastTestTime +
                            ")",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          isThreeLine: true,
          leading: SizedBox(
            height: 56,
            width: 56,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/no-avatar.png"),
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: WebsafeSvg.asset("assets/svg/binh_thuong.svg"),
                  ),
                ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[action()],
          ),
        ),
        // decoration: _selected
        //     ? new BoxDecoration(
        //         color: Colors.black38,
        //         border: new Border.all(color: Colors.black))
        //     : new BoxDecoration(),
      ),
    );
  }
}

// Building,room card
class QuarantineRelatedCard extends StatelessWidget {
  // final VoidCallback onTap;
  final String id;
  final String name;
  final int numOfMem;
  final int maxMem;
  const QuarantineRelatedCard(
      // {required this.onTap,
      {required this.id,
      required this.name,
      required this.numOfMem,
      required this.maxMem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //onTap: onTap,
        title: Text(name),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.groups_rounded,
                      color: CustomColors.disableText,
                    ),
                  ),
                  TextSpan(
                    text: " Đang cách ly " + '$numOfMem' + '/$maxMem',
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
