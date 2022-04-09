import 'package:flutter/material.dart';
import 'package:qlkcl/components/dropdown_field.dart';
import 'package:qlkcl/screens/home/component/charts.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/helper/function.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/screens/members/list_all_member_screen.dart';
import 'package:qlkcl/screens/test/list_test_no_result_screen.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:intl/intl.dart';

class InfoManagerHomePage extends StatelessWidget {
  final int totalUsers;
  final int availableSlots;
  final int activeUsers;
  final int waitingUsers;
  final int suspectedUsers;
  final int needTestUsers;
  final int canFinishUsers;
  final int waitingTests;
  final int positiveUsers;
  final int hospitalizedUsers;
  final List<KeyValue> numberIn;
  final List<KeyValue> numberOut;
  final List<KeyValue> hospitalize;
  final TextEditingController quarantineWardController;
  final VoidCallback refresh;
  final List<KeyValue> quarantineWardList;
  final int role;
  const InfoManagerHomePage({
    this.totalUsers = 0,
    this.availableSlots = 0,
    this.activeUsers = 0,
    this.waitingUsers = 0,
    this.suspectedUsers = 0,
    this.needTestUsers = 0,
    this.canFinishUsers = 0,
    this.waitingTests = 0,
    this.positiveUsers = 0,
    this.hospitalizedUsers = 0,
    this.numberIn = const [],
    this.numberOut = const [],
    this.hospitalize = const [],
    required this.quarantineWardController,
    required this.refresh,
    this.quarantineWardList = const [],
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    List<InfoManagerHomeCard> listTest = [
      InfoManagerHomeCard(
        title: "Tổng số người cách ly",
        subtitle: totalUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/total.svg"),
        onTap: () {},
        iconSuffix: false,
      ),
      InfoManagerHomeCard(
        title: "Số giường trống",
        subtitle: availableSlots.toString(),
        icon: WebsafeSvg.asset("assets/svg/giuong_trong.svg"),
        onTap: () {},
        iconSuffix: false,
      ),
      InfoManagerHomeCard(
        title: "Đang cách ly",
        subtitle: activeUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/dang_cach_ly.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(builder: (context) => ListAllMember()));
        },
      ),
      InfoManagerHomeCard(
        title: "Xét nghiệm cần cập nhật",
        subtitle: waitingTests.toString(),
        icon: WebsafeSvg.asset("assets/svg/xet_nghiem_cap_nhat.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .pushNamed(ListTestNoResult.routeName);
        },
      ),
      InfoManagerHomeCard(
        title: "Chờ xét duyệt",
        subtitle: waitingUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/cho_xet_duyet.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 1)));
        },
      ),
      InfoManagerHomeCard(
        title: "Nghi nhiễm",
        subtitle: suspectedUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/nghi_nhiem.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 2)));
        },
      ),
      InfoManagerHomeCard(
        title: "Tới hạn xét nghiệm",
        subtitle: needTestUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/toi_han_xet_nghiem.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 3)));
        },
      ),
      InfoManagerHomeCard(
        title: "Sắp hoàn thành cách ly",
        subtitle: canFinishUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/sap_hoan_thanh_cach_ly.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 6)));
        },
      ),
      InfoManagerHomeCard(
        title: "Dương tính",
        subtitle: positiveUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/covid.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 5)));
        },
      ),
      InfoManagerHomeCard(
        title: "Chuyển viện điều trị",
        subtitle: hospitalizedUsers.toString(),
        icon: WebsafeSvg.asset("assets/svg/dieu_tri.svg"),
        onTap: () {
          Navigator.of(context,
                  rootNavigator: !Responsive.isDesktopLayout(context))
              .push(MaterialPageRoute(
                  builder: (context) => ListAllMember(tab: 9)));
        },
      ),
    ];

    var _screenWidth = MediaQuery.of(context).size.width - 16;
    var _crossAxisCount = _screenWidth <= maxMobileSize
        ? 1
        : _screenWidth >= minDesktopSize
            ? (_screenWidth - 230) ~/ (maxMobileSize - 64)
            : _screenWidth ~/ (maxMobileSize - 32);
    var _width = _screenWidth / _crossAxisCount;
    var cellHeight = 128;
    var _aspectRatio = _width / cellHeight;

    return Column(
      children: [
        ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
          rowCrossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dữ liệu tổng hợp (${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now())})",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            if (role < 3)
              ResponsiveRowColumnItem(
                rowFlex: 6,
                rowFit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  width: _width < maxMobileSize ? _width + 100 : maxMobileSize,
                  child: DropdownInput<KeyValue>(
                    label: 'Khu cách ly',
                    hint: 'Chọn khu cách ly',
                    itemAsString: (KeyValue? u) => u!.name,
                    itemValue:
                        [KeyValue(name: "Tất cả", id: "")] + quarantineWardList,
                    selectedItem: quarantineWardController.text == ""
                        ? KeyValue(name: "Tất cả", id: "")
                        : quarantineWardList.safeFirstWhere((type) =>
                            type.id.toString() ==
                            quarantineWardController.text),
                    onFind: quarantineWardList.isEmpty
                        ? (String? filter) => fetchQuarantineWard({
                              "page_size": pageSizeMax,
                              "search": filter,
                            })
                        : null,
                    compareFn: (item, selectedItem) =>
                        item?.id == selectedItem?.id,
                    onChanged: (value) {
                      if (value == null) {
                        quarantineWardController.text = "";
                      } else {
                        quarantineWardController.text = value.id.toString();
                      }
                      refresh();
                    },
                    maxHeight: 400,
                    showSearchBox: true,
                  ),
                ),
              ),
          ],
        ),
        if (ResponsiveWrapper.of(context).isLargerThan(MOBILE))
          ResponsiveGridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            gridDelegate: ResponsiveGridDelegate(
              maxCrossAxisExtent: _width,
              minCrossAxisExtent:
                  _width < maxMobileSize ? _width : maxMobileSize,
              childAspectRatio: _aspectRatio,
            ),
            itemCount: listTest.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return listTest[index];
            },
          ),
        if (!ResponsiveWrapper.of(context).isLargerThan(MOBILE))
          ...listTest.map(
            (e) => e,
          ),
        Container(
          height: 400,
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InOutChart(
                  inData: numberIn,
                  outData: numberOut,
                  hospitalizeData: hospitalize),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoManagerHomeCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String title;
  final String subtitle;
  final bool iconSuffix;
  const InfoManagerHomeCard({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSuffix = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Responsive.isDesktopLayout(context)
          ? const EdgeInsets.fromLTRB(8, 8, 2, 0)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 8,
              ),

              //text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.primaryText),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.disableText,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.groups_rounded,
                              size: 22,
                              color: CustomColors.disableText,
                            ),
                          ),
                          TextSpan(
                            text: " " + subtitle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (iconSuffix)
                Icon(
                  Icons.keyboard_arrow_right,
                  color: CustomColors.disableText,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
