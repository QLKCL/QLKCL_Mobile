import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qlkcl/components/cards.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';

//cre: https://stackoverflow.com/questions/60647071/how-to-get-build-and-version-number-of-flutter-web-app
class AppInfo extends StatefulWidget {
  const AppInfo({
    Key? key,
  }) : super(key: key);

  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  String version = "Unknown";

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    if (kIsWeb) {
      version = "${WebVersionInfo.version}+${WebVersionInfo.buildNumber}";
    } else {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        version = "${info.version}+${info.buildNumber}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin ứng dụng"),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              textField(
                title: "Tên ứng dụng",
                content: "Quản lý khu cách ly",
                textColor: primaryText,
              ),
              textField(
                title: "Phiên bản",
                content: version,
                textColor: primaryText,
              ),
              textField(
                title: "Tác giả",
                content: "Trung Sơn, Bá Tiến, Thanh Tân (ĐHBK-HCM)",
                textColor: primaryText,
              ),
              textField(
                title: "Ngày phát hành",
                content: "20/05/2022",
                textColor: primaryText,
              ),
              textField(
                title: "Liên hệ",
                content: "lesonlhld@gmail.com",
                textColor: primaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
