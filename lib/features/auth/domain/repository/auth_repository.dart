import 'package:blog_app_project/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blog_app_project/core/error/failures.dart';

//interface repostory
abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
