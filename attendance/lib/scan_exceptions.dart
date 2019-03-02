class InvalidSessionException implements Exception {
  String cause;
  InvalidSessionException(this.cause);
}

class AlreadyScannedSessionException implements Exception {
  String cause;
  AlreadyScannedSessionException(this.cause);
}