class LikeModel {
  final String userId;
  final String blogId;

  LikeModel({
    required this.userId,
    required this.blogId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'blog_id': blogId,
    };
  }
}
