import 'dart:developer' as developer;

import 'exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure handleException(Exception exception) {
    _logError(exception);

    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is ValidationException) {
      return ValidationFailure(message: exception.message);
    }
    if (exception is UnauthorizedException) {
      return const UnauthorizedFailure();
    }

    return ServerFailure(message: exception.toString());
  }

  static String getUserFriendlyMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return 'Something went wrong. Please try again later.';
      case CacheFailure():
        return 'Could not load saved data.';
      case NetworkFailure():
        return 'No internet connection. Please check your network.';
      case ValidationFailure():
        return failure.message;
      case UnauthorizedFailure():
        return 'Session expired. Please sign in again.';
      default:
        return 'An unexpected error occurred.';
    }
  }

  static void _logError(Exception exception) {
    developer.log(
      'ErrorHandler: ${exception.runtimeType}',
      error: exception,
      name: 'Laffa.ErrorHandler',
    );
  }
}
