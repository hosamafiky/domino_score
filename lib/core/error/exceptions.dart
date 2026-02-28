class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = 'Validation error']);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Not found']);
}
