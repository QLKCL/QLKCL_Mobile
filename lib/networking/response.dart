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
