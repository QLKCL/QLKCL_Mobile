class Response {
  final Status status;
  final String message;
  final dynamic data;

  Response({required this.status, this.message = "", this.data});
}

enum Status {
  success,
  warning,
  error,
}

class FilterResponse<T> {
  final int currentPage;
  final int totalPages;
  final int totalRows;
  final List<T> data;

  FilterResponse({
    this.data = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalRows = 0,
  });
}
