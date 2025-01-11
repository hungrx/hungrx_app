class ApiException implements Exception {
  final String message;
  final int? statusCode;

  // Fix 1: Remove duplicate parameters from constructor
  ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  final dynamic cause;

  NetworkException(this.message, this.cause);

  @override
  String toString() => 'NetworkException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

class UnknownException implements Exception {
  final String message;
  final dynamic cause;

  UnknownException(this.message, this.cause);

  @override
  String toString() => 'UnknownException: $message (Cause: $cause)';
}
