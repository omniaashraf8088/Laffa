import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class BaseRepository {
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call);
}
