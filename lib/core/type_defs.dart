import 'package:devsocy/core/failure.dart';
import 'package:fpdart/fpdart.dart';

// Template of <Failure, T>
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
