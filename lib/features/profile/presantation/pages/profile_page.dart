import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/features/blog/data/models/blog_model.dart';
import 'package:blog_app_project/features/blog/presantation/pages/edit_blog_page.dart';
import 'package:blog_app_project/features/blog/presantation/widgets/blog_card.dart';
import 'package:blog_app_project/features/profile/presantation/widgets/profile_editor.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameChangeController = TextEditingController();
  bool _editMode = false;
  final supabase = Supabase.instance.client;
  late final User user;
  String? userName;
  List<BlogModel> userBlogs = [];

  @override
  void initState() {
    super.initState();
    user = supabase.auth.currentUser!;
    _fetchUserName();
    _fetchUserBlogs();
  }

  Future<void> _fetchUserName() async {
    final response = await supabase
        .from('profiles')
        .select('name')
        .eq('id', user.id)
        .single();

    setState(() {
      userName = response['name'] as String?;
    });
  }

  Future<void> _fetchUserBlogs() async {
    final response = await supabase
        .from('blogs')
        .select('*')
        .eq('poster_id',
            user.id) // 'author_id' kullanıcının bloglarını belirler
        .order('updated_at', ascending: false);

    setState(() {
      userBlogs = (response as List<dynamic>)
          .map((data) => BlogModel.fromjson(data as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _deleteBlog(String blogId) async {
    await supabase.from('blogs').delete().eq('id', blogId);

    // Silme işlemi sonrası blog listesini yeniden yükleyin
    setState(() {
      userBlogs.removeWhere((blog) => blog.id == blogId);
    });
  }

  Future<void> _showDeleteConfirmationDialog(String blogId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content: const Text('Bu blogu silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop(false); // İptal: false döner
              },
            ),
            TextButton(
              child: const Text('Sil'),
              onPressed: () {
                Navigator.of(context).pop(true); // Sil: true döner
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteBlog(blogId);
    }
  }

  @override
  void dispose() {
    _nameChangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profileImage.jpg'),
              maxRadius: 80,
              child: Align(
                alignment: Alignment.topCenter,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(padding: EdgeInsets.all(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _editMode
                    ? ProfileEditor(controller: _nameChangeController)
                    : Text(
                        userName ?? 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 25),
                      ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _editMode = !_editMode;
                    });
                  },
                  icon: const Icon(Icons.edit),
                  color: AppPallete.gradient3,
                ),
              ],
            ),
            if (_editMode == true)
              ElevatedButton(
                onPressed: () async {
                  final newUserName = _nameChangeController.text.trim();
                  final userId = user.id;
                  await supabase.from('profiles').update({
                    'name': newUserName,
                  }).eq('id', userId);
                  _fetchUserName();
                  _editMode = false; // Refresh the name after updating
                },
                child: const Text('Degistir'),
              ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
                    itemCount: userBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = userBlogs[index];
                      return SizedBox(
                        height: 200,
                        width: screenWidth,
                        child: Stack(children: [
                          BlogCard(
                            blog: blog,
                            color: AppPallete.ubeyd5,
                          ),
                          Positioned(
                              top: 10,
                              right: 8,
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: AppPallete.gradient3),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditBlogPage(blogId: blog.id),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: AppPallete.gradient1),
                                    onPressed: () async {
                                      await _showDeleteConfirmationDialog(
                                          blog.id);
                                    },
                                  ),
                                ],
                              ))
                        ]),
                      );
                    })),
          ],
        ));
  }
}



// import 'package:blog_app_project/features/profile/presantation/widgets/profile_editor.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _nameChangeController = TextEditingController();
//   bool _editMode = false;
//   final supabase = Supabase.instance.client;
//   late final User user;

//   Future<String?> getCurrentUserId() async {
//     final user = supabase.auth.currentUser;
//     return user?.id;
//   }

//   @override
//   void dispose() {
//     _nameChangeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Profile'),
//         ),
//         body: Column(
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             const CircleAvatar(
//               backgroundImage: AssetImage('assets/images/profileImage.jpg'),
//               maxRadius: 80,
//               child: Align(
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Padding(padding: EdgeInsets.all(15)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 _editMode
//                     ? ProfileEditor(controller: _nameChangeController)
//                     : Text(
//                         user.createdAt,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 25),
//                       ),
//                 IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _editMode = !_editMode;
//                       });
//                     },
//                     icon: const Icon(Icons.edit)),
//               ],
//             ),
//             if (_editMode == true)
//               ElevatedButton(
//                 onPressed: () async {
//                   final userName = _nameChangeController.text.trim();
//                   final userId = supabase.auth.currentUser!.id;
//                   await supabase.from('profiles').update({
//                     'name': userName,
//                   }).eq('id', userId);
//                 },
//                 child: const Text('Degistir'),
//               ),
//           ],
//         ));
//   }
// }
