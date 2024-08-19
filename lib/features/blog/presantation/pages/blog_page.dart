import 'package:blog_app_project/core/common/widgets/loader.dart';
import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/core/utils/show_snackbar.dart';
import 'package:blog_app_project/features/blog/presantation/bloc/blog_bloc.dart';
import 'package:blog_app_project/features/blog/presantation/pages/add_new_blog_page.dart';
import 'package:blog_app_project/features/blog/presantation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Main class'taki User logged ise fonksiyonunda bu class'ı çağır.

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog App Finitoo'), actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          icon: const Icon(
            CupertinoIcons.add_circled,
          ),
        ),
      ]),
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
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                    blog: blog,
                    color:
                        index % 2 == 0 ? AppPallete.ubeyd4 : AppPallete.ubeyd5
                    // ? AppPallete.ubeydBlack
                    // : index % 3 == 2
                    //     ? AppPallete.ubeyd2
                    //     : AppPallete.ubeyd3, //
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
