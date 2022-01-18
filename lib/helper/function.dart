import 'package:intl/intl.dart';

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
