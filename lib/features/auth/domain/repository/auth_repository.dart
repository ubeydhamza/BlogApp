import 'package:fpdart/fpdart.dart';
import 'package:blog_app_project/core/error/failures.dart';

//interface repostory
abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
