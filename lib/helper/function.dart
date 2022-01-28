import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  bool isAndroid() {
    try {
      return Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  bool isIOS() {
    try {
      return Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  bool isLinux() {
    try {
      return Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  bool isWindows() {
    try {
      return Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  bool isMacOS() {
    try {
      return Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  bool isWeb() {
    return kIsWeb;
  }
}
