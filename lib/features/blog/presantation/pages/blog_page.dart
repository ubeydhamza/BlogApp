import 'package:blog_app_project/core/common/widgets/loader.dart';
import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/core/utils/show_snackbar.dart';
import 'package:blog_app_project/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_project/features/blog/domain/entities/blog.dart';
import 'package:blog_app_project/features/blog/presantation/bloc/blog_bloc.dart';
import 'package:blog_app_project/features/blog/presantation/pages/add_new_blog_page.dart';
import 'package:blog_app_project/features/blog/presantation/widgets/blog_card.dart';
import 'package:blog_app_project/features/profile/presantation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final supabase = Supabase.instance.client;
  late final User user;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchQuery = ""; // Clear search query when toggling
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    user = supabase.auth.currentUser!;
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Blog> _filteredBlogs(List<Blog> blogs) {
    if (_searchQuery.isEmpty) {
      return blogs;
    } else {
      return blogs.where((blog) {
        return blog.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: _updateSearchQuery,
              )
            : const Text('Blog App'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const ProfilePage(),
                    ),
                  );
                },
                child: const Text('Profile'),
              ),
              PopupMenuItem(
                onTap: () {
                  Navigator.push(context, AddNewBlogPage.route());
                },
                child: const Text('Add Blogs'),
              ),
              PopupMenuItem(
                onTap: () {
                  _logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            final filteredBlogs = _filteredBlogs(state.blogs);
            if (filteredBlogs.isEmpty) {
              return Center(
                child: Text(
                  'No blogs found.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: filteredBlogs.length,
              itemBuilder: (context, index) {
                final blog = filteredBlogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 2 == 0 ? AppPallete.ubeyd4 : AppPallete.ubeyd5,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}








// import 'package:blog_app_project/core/common/widgets/loader.dart';
// import 'package:blog_app_project/core/theme/app_pallete.dart';
// import 'package:blog_app_project/core/utils/show_snackbar.dart';
// import 'package:blog_app_project/features/auth/presentation/pages/login_page.dart';
// import 'package:blog_app_project/features/blog/presantation/bloc/blog_bloc.dart';
// import 'package:blog_app_project/features/blog/presantation/pages/add_new_blog_page.dart';
// import 'package:blog_app_project/features/blog/presantation/widgets/blog_card.dart';
// import 'package:blog_app_project/features/profile/presantation/pages/profile_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // Main class'taki User logged ise fonksiyonunda bu class'ı çağır.

// class BlogPage extends StatefulWidget {
//   static route() => MaterialPageRoute(builder: (context) => const BlogPage());
//   const BlogPage({super.key});

//   @override
//   State<BlogPage> createState() => _BlogPageState();
// }

// class _BlogPageState extends State<BlogPage> {
//   final supabase = Supabase.instance.client;
//   late final User user;

//   Future<void> _logout() async {
//     await supabase.auth.signOut(); // Kullanıcı çıkışı

//     // Çıkış yaptıktan sonra giriş sayfasına yönlendirin
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<BlogBloc>().add(BlogFetchAllBlogs());
//     user = supabase.auth.currentUser!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(centerTitle: true, title: const Text('Blog App'), actions: [
//         PopupMenuButton(
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => const ProfilePage(),
//                   ),
//                 );
//               },
//               child: const Text('Profile'),
//             ),
//             PopupMenuItem(
//               onTap: () {
//                 Navigator.push(context, AddNewBlogPage.route());
//               },
//               child: const Text('Add Blogs'),
//             ),
//             PopupMenuItem(
//               onTap: () {
//                 _logout();
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//         // IconButton(
//         //   onPressed: () {
//         //     Navigator.push(context, AddNewBlogPage.route());
//         //   },
//         //   icon: const Icon(
//         //     CupertinoIcons.add_circled,
//         //   ),
//         // ),
//       ]),
//       body: BlocConsumer<BlogBloc, BlogState>(
//         listener: (context, state) {
//           if (state is BlogFailure) {
//             showSnackBar(context, state.error);
//           }
//         },
//         builder: (context, state) {
//           if (state is BlogLoading) {
//             return const Loader();
//           }
//           if (state is BlogDisplaySuccess) {
//             return ListView.builder(
//               itemCount: state.blogs.length,
//               itemBuilder: (context, index) {
//                 final blog = state.blogs[index];
//                 return BlogCard(
//                     blog: blog,
//                     color:
//                         index % 2 == 0 ? AppPallete.ubeyd4 : AppPallete.ubeyd5
//                     // ? AppPallete.ubeydBlack
//                     // : index % 3 == 2
//                     //     ? AppPallete.ubeyd2
//                     //     : AppPallete.ubeyd3,
//                     );
//               },
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
