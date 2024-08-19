import 'dart:io';

import 'package:blog_app_project/core/error/exceptions.dart';
import 'package:blog_app_project/core/error/failures.dart';
import 'package:blog_app_project/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app_project/features/blog/data/models/blog_model.dart';
import 'package:blog_app_project/features/blog/domain/entities/blog.dart';
import 'package:blog_app_project/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  const BlogRepositoryImpl(this.blogRemoteDataSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: 'imageUrl',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imgUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imgUrl,
      );
      final uplodedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uplodedBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> gelAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
