import 'package:intl/intl.dart';

extension IterableX<T> on Iterable<T> {
  T? safeFirstWhere(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}

dynamic prepareDataForm(dynamic data) {
  data.removeWhere((key, value) => key == "" || value == "");
  data.removeWhere((key, value) => value == null);
  return data;
}

String parseDateToDateTimeWithTimeZone(String date) {
  DateTime parseDate = new DateFormat("dd/MM/yyyy").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
