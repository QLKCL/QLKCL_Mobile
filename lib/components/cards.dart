import 'package:flutter/material.dart';
import 'package:qlkcl/config/app_theme.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/screens/quarantine_ward/quarantine_detail_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:intl/intl.dart';

class MedicalDeclarationCard extends StatelessWidget {
  final VoidCallback onTap;
  final String code;
  final String time;
  final String status;
  final Widget? menus;
  const MedicalDeclarationCard(
      {required this.onTap,
      required this.code,
      required this.time,
      required this.status,
      this.menus});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mã tờ khai: " + code,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.primaryText),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " Thời gian: " + time,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.description_outlined,
                                size: 16,
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
                ),
                menus ?? Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final VoidCallback onTap;
  final String code;
  final String time;
  final String status;
  final Widget? menus;
  const TestCard(
      {required this.onTap,
      required this.code,
      required this.time,
      required this.status,
      this.menus});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mã phiếu: " + code,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.primaryText),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " Thời gian: " + time,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.description_outlined,
                                size: 16,
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
                ),
                menus ?? Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestNoResultCard extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final String gender;
  final String birthday;
  final String code;
  final String time;
  final String healthStatus;
  final Widget? menus;
  final String? image;
  const TestNoResultCard({
    required this.onTap,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.code,
    required this.time,
    this.healthStatus = "NORMAL",
    this.menus,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      'Default/no_avatar',
    ];
    if (image != null && image != "") {
      imageList = image!.split(',');
    }
    return Card(
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  width: 56,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            cloudinary.getImage(imageList[0]).toString()),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: healthStatus == "SERIOUS"
                              ? WebsafeSvg.asset("assets/svg/duong_tinh.svg")
                              : healthStatus == "UNWELL"
                                  ? WebsafeSvg.asset("assets/svg/nghi_ngo.svg")
                                  : WebsafeSvg.asset(
                                      "assets/svg/binh_thuong.svg"),
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
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: name + " ",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.primaryText),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: gender == "MALE"
                                  ? Icon(
                                      Icons.male,
                                      color: HexColor("#00BBD3"),
                                    )
                                  : Icon(
                                      Icons.female,
                                      color: HexColor("#FF4181"),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        birthday,
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.disableText,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.qr_code,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " " + code,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " " +
                                  DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(time).toLocal()),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                menus ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberCard extends StatefulWidget {
  final bool? longPressEnabled;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String name;
  final String gender;
  final String birthday;
  final String? room;
  final bool? lastTestResult;
  final String? lastTestTime;
  final String healthStatus;
  final Widget? menus;
  final String? image;
  final bool isThreeLine;
  const MemberCard({
    required this.onTap,
    this.onLongPress,
    required this.name,
    required this.gender,
    required this.birthday,
    this.room,
    this.lastTestResult,
    this.lastTestTime,
    this.longPressEnabled,
    required this.healthStatus,
    this.menus,
    this.image,
    this.isThreeLine = true,
  });

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool _selected = false;
  List<String> imageList = [
    'Default/no_avatar',
  ];

  action() {
    if (widget.longPressEnabled != null && widget.longPressEnabled == true) {
      return Checkbox(
        value: _selected,
        onChanged: (newValue) {
          setState(() {
            _selected = newValue!;
          });
          widget.onLongPress!();
        },
      );
    } else {
      return widget.menus ?? Container();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.image != null && widget.image != "") {
      imageList = widget.image!.split(',');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: () {
            if (widget.longPressEnabled != null &&
                widget.longPressEnabled == true) {
              setState(() {
                _selected = !_selected;
              });
              widget.onLongPress!();
            } else {
              widget.onTap();
            }
          },
          onLongPress: () {
            if (widget.longPressEnabled != null) {
              setState(() {
                _selected = !_selected;
              });
              widget.onLongPress!();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  width: 56,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            cloudinary.getImage(imageList[0]).toString()),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: widget.healthStatus == "SERIOUS"
                              ? WebsafeSvg.asset("assets/svg/duong_tinh.svg")
                              : widget.healthStatus == "UNWELL"
                                  ? WebsafeSvg.asset("assets/svg/nghi_ngo.svg")
                                  : WebsafeSvg.asset(
                                      "assets/svg/binh_thuong.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.name + " ",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.primaryText),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: widget.gender == "MALE"
                                  ? Icon(
                                      Icons.male,
                                      color: HexColor("#00BBD3"),
                                    )
                                  : Icon(
                                      Icons.female,
                                      color: HexColor("#FF4181"),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.birthday,
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.disableText,
                        ),
                      ),
                      if (widget.room != null)
                        SizedBox(
                          height: 4,
                        ),
                      if (widget.room != null)
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: CustomColors.disableText,
                            ),
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.place_outlined,
                                  size: 16,
                                  color: CustomColors.disableText,
                                ),
                              ),
                              TextSpan(
                                text: " " + widget.room!,
                              )
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " " +
                                  (widget.lastTestResult != null
                                      ? (widget.lastTestResult!
                                          ? "Dương tính"
                                          : "Âm tính")
                                      : "Chưa có kết quả xét nghiệm") +
                                  (widget.lastTestTime != null
                                      ? " (" +
                                          DateFormat("dd/MM/yyyy HH:mm:ss")
                                              .format(DateTime.parse(
                                                      widget.lastTestTime!)
                                                  .toLocal()) +
                                          ")"
                                      : ""),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widget.menus != null ? action() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Building,room card
class QuarantineRelatedCard extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final int numOfMem;
  final int maxMem;
  final Widget? menus;
  const QuarantineRelatedCard(
      {required this.onTap,
      required this.name,
      required this.numOfMem,
      required this.maxMem,
      this.menus});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(name),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.groups_rounded,
                  size: 20,
                  color: CustomColors.disableText,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  " Đang cách ly " + '$numOfMem' + '/$maxMem',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        isThreeLine: false,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[menus ?? Container()],
        ),
      ),
    );
  }
}

class QuarantineItem extends StatefulWidget {
  final String id;
  final String name;
  final String manager;
  final int currentMem;
  final String? address;
  final Widget? menus;
  final String? image;

  const QuarantineItem({
    required this.id,
    required this.name,
    required this.manager,
    required this.currentMem,
    this.menus,
    this.address,
    this.image,
  });

  @override
  State<QuarantineItem> createState() => _QuarantineItemState();
}

class _QuarantineItemState extends State<QuarantineItem> {
  late Future<int> numOfMem;
  List<String> imageList = [
    'Default/no_image_available',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.image != null && widget.image != "") {
      imageList = widget.image!.split(',');
    }
  }

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
                  child: Image.network(
                      cloudinary.getImage(imageList[0]).toString(),
                      fit: BoxFit.cover),
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
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.primaryText),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //subtitle and icon
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: CustomColors.disableText,
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
                                widget.currentMem.toString(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: CustomColors.disableText,
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
                      height: 4,
                    ),
                    if (widget.address != null)
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.place_outlined,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " " + widget.address!,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              widget.menus ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class QuarantineHome extends StatelessWidget {
  final String name;
  final String manager;
  final String address;
  final String room;
  final String phone;
  final String quarantineAt;
  final int quarantineTime;

  const QuarantineHome({
    required this.name,
    required this.manager,
    required this.address,
    required this.room,
    required this.phone,
    required this.quarantineAt,
    required this.quarantineTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.primaryText),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //subtitle and icon
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.phone,
                              size: 16,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                            text: " Liên hệ: " + phone,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
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
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.date_range_outlined,
                              size: 16,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                              text: " Bắt đầu cách ly: " +
                                  DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(quarantineAt))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.event_available_outlined,
                              size: 16,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                              text: " Dự kiến hoàn thành cách ly: " +
                                  DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(quarantineAt).add(
                                          Duration(days: quarantineTime)))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.maps_home_work_outlined,
                              size: 16,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                            text: " " + room,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.place_outlined,
                              size: 16,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                            text: " " + address,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String description;
  final String time;
  final bool status;
  final Widget? menus;
  const NotificationCard({
    this.onTap,
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.primaryText),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " " + time + " ",
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                status ? Icons.done_all : null,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            color: status
                                ? CustomColors.disableText
                                : CustomColors.primaryText),
                      )
                    ],
                  ),
                ),
                menus ?? Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VaccineDoseCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String vaccine;
  final String time;
  final Widget? menus;
  const VaccineDoseCard({
    this.onTap,
    required this.time,
    required this.vaccine,
    this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vaccine,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.primaryText),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: CustomColors.disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.history,
                                size: 16,
                                color: CustomColors.disableText,
                              ),
                            ),
                            TextSpan(
                              text: " Thời gian: " + time,
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      // Text.rich(
                      //   TextSpan(
                      //     style: TextStyle(
                      //       color: CustomColors.disableText,
                      //     ),
                      //     children: [
                      //       WidgetSpan(
                      //         alignment: PlaceholderAlignment.middle,
                      //         child: Icon(
                      //           Icons.description_outlined,
                      //           size: 16,
                      //           color: CustomColors.disableText,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: " Nơi tiêm: " ,
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                menus ?? Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
