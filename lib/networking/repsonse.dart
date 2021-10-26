// cre: https://ichi.pro/vi/flutter-xu-ly-cac-lenh-goi-api-mang-cua-ban-nhu-mot-ong-chu-158964374994071

class Response<T> {
  Status status;
  late T data;
  late String message;

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
