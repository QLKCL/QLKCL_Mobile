import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:qlkcl/utils/constant.dart';

extension IterableX<T> on Iterable<T> {
  T? safeFirstWhere(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}

extension ListUtils<T> on List<T> {
  num sumBy(num f(T element)) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension DateUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

// Cre: https://gist.github.com/apgapg/84d855e41c0134a34ff8b2cf034ad249
/// converts [date] into into string format
/// Example:
/// * Positive:   (UK)   `2020-09-16T11:55:01.802248+00:00`
/// * Negative: (Canada) `2020-09-16T11:55:01.802248-08:00`
String formatISOTime(DateTime? dateTime) {
  var date = dateTime ?? DateTime.now();
  var duration = date.timeZoneOffset;

  /// If the user is in Canada the time zone is GMT-8 then the signal will need to be negative.
  /// Because we already get the minus from the hours in the string then we don't need to add it to the string.
  /// In the case the timezone is GMT-0 or higher then the sign will need to be positive.
  var timezoneSignal = !(duration.isNegative) ? '+' : '';
  var dateString = (date.toIso8601String() +
      "$timezoneSignal${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  return dateString;
}

dynamic prepareDataForm(dynamic data,
    {List<String> exceptionField = const []}) {
  data.removeWhere((key, value) =>
      ((key == "" || value == "") && (!exceptionField.contains(key))));
  data.removeWhere(
      (key, value) => (value == null) && (!exceptionField.contains(key)));
  return data;
}

String parseDateToDateTimeWithTimeZone(String date, {String? time}) {
  String outputDate = "";
  if (date != "") {
    DateTime parseDate = new DateFormat("dd/MM/yyyy").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    if (time != null) {
      int hour = int.parse(time.split(':').first);
      int minute = int.parse(time.split(':').last);
      inputDate = inputDate.copyWith(hour: hour, minute: minute);
    }
    inputDate = DateTime.parse(formatISOTime(inputDate));
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

  // https://stackoverflow.com/questions/6370690/media-queries-how-to-target-desktop-tablet-and-mobile

  // This isMobileLayout, isTabletLayout, isDesktopLayout helep us later
  static bool isMobileLayout(BuildContext context) =>
      MediaQuery.of(context).size.width < maxMobileSize;

  static bool isTabletLayout(BuildContext context) =>
      MediaQuery.of(context).size.width < maxTabletSize &&
      MediaQuery.of(context).size.width >= maxMobileSize;

  static bool isDesktopLayout(BuildContext context) =>
      MediaQuery.of(context).size.width >= maxTabletSize;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 768 then we consider it a desktop
    if (_size.width >= maxTabletSize) {
      return desktop;
    }
    // If width it less then 768 and more then 480 we consider it as tablet
    else if (_size.width >= maxMobileSize && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
