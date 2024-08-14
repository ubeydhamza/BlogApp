import 'package:blog_app_project/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccesType, Params> {
  Future<Either<Failure, SuccesType>> call(Params params);
}

class NoParams {}
