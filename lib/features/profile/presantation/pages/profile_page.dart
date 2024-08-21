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

  @override
  void initState() {
    super.initState();
    user = supabase.auth.currentUser!;
    _fetchUserName();
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

  @override
  void dispose() {
    _nameChangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.edit)),
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
