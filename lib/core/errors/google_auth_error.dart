class GoogleAuthException implements Exception {
  final String message;
  final bool isCancelled;

  GoogleAuthException({
    required this.message,
    this.isCancelled = false,
  });
}