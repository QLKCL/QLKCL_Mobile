import 'package:flutter/material.dart';
import 'package:qlkcl/models/custom_user.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/member.dart';
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mã tờ khai: $code",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    cardLine(
                        icon: Icons.description_outlined,
                        title: "Tình trạng",
                        content: status),
                  ],
                ),
              ),
              menus ?? Container()
            ],
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mã phiếu: $code",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    cardLine(
                        icon: Icons.description_outlined,
                        title: "Kết quả",
                        content: status),
                  ],
                ),
              ),
              menus ?? Container()
            ],
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: white,
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
                      //           fillColor: white,
                      //           child: WebsafeSvg.asset("assets/svg/binh_thuong.svg"),
                      //           shape: CircleBorder(),
                      //         ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
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
                            text: "$name ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: primaryText),
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
                        color: disableText,
                      ),
                    ),
                    cardLine(icon: Icons.qr_code, content: code),
                    cardLine(
                        icon: Icons.history,
                        content: DateFormat("dd/MM/yyyy HH:mm:ss")
                            .format(DateTime.parse(time).toLocal())),
                  ],
                ),
              ),
              menus ?? Container(),
            ],
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
  final Widget? menus;
  final String? image;
  final bool isThreeLine;
  final FilterMember member;
  const MemberCard({
    required this.onTap,
    required this.member,
    this.onLongPress,
    this.longPressEnabled,
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

  Widget action() {
    if (widget.longPressEnabled ?? false) {
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (widget.longPressEnabled ?? false) {
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
          padding: const EdgeInsets.all(16),
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
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(100)),
                        child: widget.member.healthStatus == "SERIOUS"
                            ? WebsafeSvg.asset("assets/svg/duong_tinh.svg")
                            : widget.member.healthStatus == "UNWELL"
                                ? WebsafeSvg.asset("assets/svg/nghi_ngo.svg")
                                : WebsafeSvg.asset(
                                    "assets/svg/binh_thuong.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
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
                            text: "${widget.member.fullName} ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: primaryText),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: widget.member.gender == "MALE"
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
                      widget.member.birthday ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: disableText,
                      ),
                    ),
                    if (widget.member.quarantineLocationWithWard != null)
                      const SizedBox(
                        height: 4,
                      ),
                    if (widget.member.quarantineLocationWithWard != null)
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: disableText,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.place_outlined,
                                size: 16,
                                color: disableText,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " ${widget.member.quarantineLocationWithWard}",
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    cardLine(
                      icon: Icons.history,
                      content: widget.member.positiveTestNow != null
                          ? (widget.member.positiveTestNow!
                                  ? "Dương tính"
                                  : "Âm tính") +
                              (widget.member.lastTestedHadResult != null
                                  ? " (${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(widget.member.lastTestedHadResult!).toLocal())})"
                                  : "")
                          : "Chưa có kết quả xét nghiệm",
                    ),
                  ],
                ),
              ),
              if (widget.menus != null) action(),
            ],
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.groups_rounded,
                  size: 20,
                  color: disableText,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  " Đang cách ly $numOfMem/$maxMem",
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
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
    Navigator.of(context, rootNavigator: !Responsive.isDesktopLayout(context))
        .push(
      MaterialPageRoute(
        builder: (context) => QuarantineDetailScreen(
          id: widget.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => selectQuarantine(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image container
                  SizedBox(
                    height: 96,
                    width: 105,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                          cloudinary.getImage(imageList[0]).toString(),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
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
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: primaryText),
                        ),
                        cardLine(
                            icon: Icons.groups_rounded,
                            title: "Đang cách ly",
                            content: widget.currentMem.toString()),
                        cardLine(
                            icon: Icons.account_box_outlined,
                            title: "Quản lý",
                            content: widget.manager),
                        const SizedBox(
                          height: 4,
                        ),
                        if (widget.address != null)
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                color: disableText,
                              ),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: disableText,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${widget.address}",
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
        )
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String description;
  final String time;
  final bool status;
  final String? image;
  final String? url;
  final Widget? menus;
  const NotificationCard({
    this.onTap,
    required this.title,
    required this.description,
    required this.time,
    this.status = false,
    this.menus,
    this.image,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: disableText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.history,
                              size: 16,
                              color: disableText,
                            ),
                          ),
                          TextSpan(
                            text: " $time ",
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              status ? Icons.done_all : null,
                              size: 16,
                              color: disableText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (image != null)
                      const SizedBox(
                        height: 4,
                      ),
                    if (image != null)
                      Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const SizedBox();
                        },
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      description,
                      style:
                          TextStyle(color: status ? disableText : primaryText),
                    ),
                  ],
                ),
              ),
              menus ?? Container()
            ],
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    // Text.rich(
                    //   TextSpan(
                    //     style: TextStyle(
                    //       color: disableText,
                    //     ),
                    //     children: [
                    //       WidgetSpan(
                    //         alignment: PlaceholderAlignment.middle,
                    //         child: const Icon(
                    //           Icons.description_outlined,
                    //           size: 16,
                    //           color: disableText,
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
    );
  }
}

class DestinationHistoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String name;
  final String time;
  final String address;
  final String note;
  final Widget? menus;
  const DestinationHistoryCard({
    required this.name,
    this.onTap,
    required this.time,
    required this.address,
    this.note = "",
    this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    cardLine(
                        icon: Icons.location_on_outlined,
                        title: "Địa điểm",
                        content: address),
                    if (note != "")
                      cardLine(
                          icon: Icons.note_outlined,
                          title: "Ghi chú",
                          content: note),
                  ],
                ),
              ),
              menus ?? Container()
            ],
          ),
        ),
      ),
    );
  }
}

class QuarantineHistoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? endType;
  final String name;
  final String time;
  final String room;
  final String pademic;
  final String note;
  final Widget? menus;
  const QuarantineHistoryCard({
    this.endType,
    required this.name,
    this.onTap,
    required this.time,
    required this.room,
    required this.pademic,
    this.note = "",
    this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: primaryText),
                    ),
                    cardLine(
                        icon: Icons.medical_services_outlined,
                        title: "Tình trạng",
                        content: endType == "COMPLETED"
                            ? "Đã hoàn thành cách ly"
                            : endType == "CHANGE_ROOM"
                                ? "Đã chuyển phòng"
                                : endType == null
                                    ? "Đang cách ly"
                                    : endType == "HOSPITALIZE"
                                        ? "Đã chuyển viện"
                                        : "Không rõ"),
                    cardLine(
                        icon: Icons.history, title: "Thời gian", content: time),
                    cardLine(
                        icon: Icons.location_on_outlined,
                        title: "Đơn vị",
                        content: room),
                    cardLine(
                        icon: Icons.medical_services_outlined,
                        title: "Dịch bệnh",
                        content: pademic),
                    cardLine(
                        icon: Icons.note_outlined,
                        title: "Ghi chú",
                        content: note),
                  ],
                ),
              ),
              menus ?? Container()
            ],
          ),
        ),
      ),
    );
  }
}

Widget cardLine({
  IconData? icon,
  String? title,
  required String content,
  Color? textColor,
  double topPadding = 4,
}) {
  return Container(
    padding: EdgeInsets.only(top: topPadding),
    child: Text.rich(
      TextSpan(
        style: TextStyle(
          color: textColor ?? disableText,
        ),
        children: [
          if (icon != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                icon,
                size: 16,
                color: textColor ?? disableText,
              ),
            ),
          TextSpan(
            text: (icon != null ? " " : "") +
                (title != null ? "$title: $content" : content),
          )
        ],
      ),
    ),
  );
}

Widget textField({
  String? title,
  required String content,
  String? extraContent,
  Color? textColor,
  double topPadding = 4,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 2,
      ),
      Text(
        title != null ? "$title: " : "",
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 4,
      ),
      RichText(
        text: TextSpan(
          style: TextStyle(
            color: textColor ?? primaryText,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: content,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (extraContent != null && extraContent.isNotEmpty)
              TextSpan(
                text: " $extraContent",
              ),
          ],
        ),
      ),
      const Divider(
        // indent: 16,
        // endIndent: 16,
        thickness: 2,
      ),
    ],
  );
}

class ManagerCard extends StatefulWidget {
  final bool? longPressEnabled;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget? menus;
  final String? image;
  final bool isThreeLine;
  final FilterStaff manager;
  const ManagerCard({
    required this.onTap,
    required this.manager,
    this.onLongPress,
    this.longPressEnabled,
    this.menus,
    this.image,
    this.isThreeLine = true,
  });

  @override
  _ManagerCardState createState() => _ManagerCardState();
}

class _ManagerCardState extends State<ManagerCard> {
  bool _selected = false;
  List<String> imageList = [
    'Default/no_avatar',
  ];

  Widget action() {
    if (widget.longPressEnabled ?? false) {
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (widget.longPressEnabled ?? false) {
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
          padding: const EdgeInsets.all(16),
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
                  ],
                ),
              ),
              const SizedBox(
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
                            text: "${widget.manager.fullName} ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: primaryText),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: widget.manager.gender == "MALE"
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
                      widget.manager.birthday,
                      style: TextStyle(
                        fontSize: 12,
                        color: disableText,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: disableText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.place_outlined,
                              size: 16,
                              color: disableText,
                            ),
                          ),
                          TextSpan(
                            text: " ${widget.manager.quarantineWard.name}",
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              if (widget.menus != null) action(),
            ],
          ),
        ),
      ),
    );
  }
}
