class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException(
      {required this.message, required this.prefix, required this.url});
}

class BadRequestException extends AppException {
  BadRequestException({
    String? message,
    String? url,
    this.errorCode,
  }) : super(message: message!, prefix: "Bad Request", url: url!);
  String? errorCode;

  @override
  String toString() =>
      'BadRequestException( message: $message, prefix: $prefix, url: $url, errorCode: $errorCode )';
}

class FetchDataException extends AppException {
  FetchDataException({String? message, String? url})
      : super(message: message!, prefix: "Unable to Process Data", url: url!);

  @override
  String toString() =>
      'FetchDataException(message: $message, prefix: $prefix, url: $url )';
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException({String? message, String? url})
      : super(message: message!, prefix: "Api Not Responding", url: url!);

  @override
  String toString() =>
      'ApiNotRespondingException(message: $message, prefix: $prefix, url: $url )';
}

class UnAutthorizedException extends AppException {
  UnAutthorizedException({String? message, String? url})
      : super(message: message!, prefix: "UnAuthorized request", url: url!);

  @override
  String toString() =>
      'UnAutthorizedException(message: $message, prefix: $prefix, url: $url )';
}

class UnProcessableException extends AppException {
  UnProcessableException({String? message, String? url})
      : super(message: message!, prefix: "UnProcessable request", url: url!);

  @override
  String toString() =>
      'UnProcessableException(message: $message, prefix: $prefix, url: $url )';
}
