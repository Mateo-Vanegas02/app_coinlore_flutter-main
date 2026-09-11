class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (StatusCode: $statusCode)';
}

class ParseException implements Exception {
  final String message;

  ParseException(this.message);

  @override
  String toString() => 'ParseException: $message';
}
