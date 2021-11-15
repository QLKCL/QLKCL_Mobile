extension IterableX<T> on Iterable<T> {
  T? safeFirstWhere(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}

dynamic prepareDataForm(dynamic data){
  data.removeWhere((key, value) => key == "" || value == "");
  data.removeWhere((key, value) => value == null);
  return data;
}