import 'package:blog_app_project/core/error/failures.dart';
import 'package:blog_app_project/core/usecase/usecase.dart';
import 'package:blog_app_project/features/auth/domain/entities/user.dart';
import 'package:blog_app_project/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  const CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
