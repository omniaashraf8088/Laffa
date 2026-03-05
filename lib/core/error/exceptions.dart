class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({this.message = 'Server error', this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache error'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Network error'});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({this.message = 'Validation error'});

  @override
  String toString() => 'ValidationException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Unauthorized'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

class TenantException implements Exception {
  final String message;

  const TenantException({this.message = 'Tenant error'});

  @override
  String toString() => 'TenantException: $message';
}

class SubscriptionException implements Exception {
  final String message;

  const SubscriptionException({this.message = 'Subscription error'});

  @override
  String toString() => 'SubscriptionException: $message';
}

class ForbiddenException implements Exception {
  final String message;

  const ForbiddenException({this.message = 'Forbidden'});

  @override
  String toString() => 'ForbiddenException: $message';
}
