import 'package:blog_app_project/core/error/failures.dart';
import 'package:blog_app_project/core/usecase/usecase.dart';
import 'package:blog_app_project/features/blog/domain/entities/blog.dart';
import 'package:blog_app_project/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.gelAllBlogs();
  }
}
