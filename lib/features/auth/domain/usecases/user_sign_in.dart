import 'package:blog_app_project/core/error/failures.dart';
import 'package:blog_app_project/core/usecase/usecase.dart';
import 'package:blog_app_project/features/auth/domain/entities/user.dart';
import 'package:blog_app_project/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<User, UserSignInParams> {
  final AuthRepository authRepository;
  const UserSignIn(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
