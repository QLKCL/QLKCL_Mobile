import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

extension IterableX<T> on Iterable<T> {
  T? safeFirstWhere(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}

dynamic prepareDataForm(dynamic data,
    {List<String> exceptionField = const []}) {
  data.removeWhere((key, value) =>
      ((key == "" || value == "") && (!exceptionField.contains(key))));
  data.removeWhere(
      (key, value) => (value == null) && (!exceptionField.contains(key)));
  return data;
}

String parseDateToDateTimeWithTimeZone(String date) {
  String outputDate = "";
  if (date != "") {
    DateTime parseDate = new DateFormat("dd/MM/yyyy").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    outputDate = outputFormat.format(inputDate);
  }
  return outputDate;
}

extension Target on Object {
  bool isAndroidPlatform() {
    try {
      return Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  bool isIOSPlatform() {
    try {
      return Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  bool isLinuxPlatform() {
    try {
      return Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  bool isWindowsPlatform() {
    try {
      return Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  bool isMacOSPlatform() {
    try {
      return Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  bool isWebPlatform() {
    return kIsWeb;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  // This isMobileScreen, isTablet, isDesktop helep us later
  static bool isMobileScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTabletScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktopScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
