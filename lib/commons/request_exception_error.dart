class RequestException extends Error {
  final String message;
  final int statusCode;

  RequestException(this.message, this.statusCode);

  @override
  String toString() {
    return 'RequestException{message: $message, statusCode: $statusCode}';
  }
}
