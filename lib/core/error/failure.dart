import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred', super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed', super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code,
  });
}

class TenantFailure extends Failure {
  const TenantFailure({super.message = 'Tenant operation failed', super.code});
}

class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    super.message = 'Subscription expired or inactive',
    super.code,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Insufficient permissions',
    super.code,
  });
}
