import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/core/utils/calculate_reading_time.dart';
import 'package:blog_app_project/features/blog/presantation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:blog_app_project/features/blog/domain/entities/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    Key? key,
    required this.blog,
    required this.color,
  }) : super(key: key);

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late final String userId;
  late final SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    userId = Supabase.instance.client.auth.currentUser!.id;
    supabase = Supabase.instance.client;
    _checkIfLiked();
    _fetchLikesCount();
  }

  Future<void> _likeBlog(String blogId) async {
    // Yeni beğeni ekleme
    await supabase.from('likes').insert({
      'user_id': userId,
      'blog_id': blogId,
    });

    // Blogun beğeni sayısını güncelleyin
    final blogResponse = await supabase
        .from('blogs')
        .select('likes_count')
        .eq('id', blogId)
        .single();
    final currentLikesCount = blogResponse['likes_count'] as int? ?? 0;
    await supabase
        .from('blogs')
        .update({'likes_count': currentLikesCount + 1}).eq('id', blogId);
  }

  Future<void> _unlikeBlog(String blogId) async {
    // Beğeniyi kaldırma
    await supabase
        .from('likes')
        .delete()
        .eq('user_id', userId)
        .eq('blog_id', blogId);

    // Blogun beğeni sayısını güncelleyin
    final blogResponse = await supabase
        .from('blogs')
        .select('likes_count')
        .eq('id', blogId)
        .single();
    final currentLikesCount = blogResponse['likes_count'] as int? ?? 0;
    await supabase
        .from('blogs')
        .update({'likes_count': currentLikesCount - 1}).eq('id', blogId);
  }

  Future<int> _getLikesCount(String blogId) async {
    final response = await supabase
        .from('blogs')
        .select('likes_count')
        .eq('id', blogId)
        .single();
    return response['likes_count'] ?? 0;
  }

  int _likesCount = 0;
  bool _isLiked = false;

  Future<void> _checkIfLiked() async {
    final response = await supabase
        .from('likes')
        .select('id')
        .eq('user_id', userId)
        .eq('blog_id', widget.blog.id)
        .single()
        .maybeSingle();
    setState(() {
      _isLiked = response != null;
    });
  }

  Future<void> _fetchLikesCount() async {
    final count = await _getLikesCount(widget.blog.id);
    setState(() {
      _likesCount = count;
    });
  }

  Future<void> _toggleLike() async {
    if (_isLiked) {
      // Beğeniyi kaldır
      await _unlikeBlog(widget.blog.id);
      setState(() {
        _likesCount -= 1;
        _isLiked = false;
      });
    } else {
      // Beğeni ekle
      await _likeBlog(widget.blog.id);
      setState(() {
        _likesCount += 1;
        _isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(widget.blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  widget.blog.title,
                  style: const TextStyle(
                    color: AppPallete.ubeyd3,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${calculateReadinTime(widget.blog.content)} min',
                  style: const TextStyle(color: AppPallete.ubeyd3),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text(
                      '$_likesCount',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
