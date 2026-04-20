/// Tarmoq xatosi — internet yo'q yoki timeout
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Internet aloqasi yo'q"]);

  @override
  String toString() => 'NetworkException: $message';
}

/// API xatosi — server noto'g'ri javob qaytardi
class ApiException implements Exception {
  final String message;
  ApiException([this.message = 'Server xatosi']);

  @override
  String toString() => 'ApiException: $message';
}
