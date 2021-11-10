class Response {
  final bool success;
  final String message;
  final dynamic data;

  Response({required this.success, this.message = "", this.data});
}
