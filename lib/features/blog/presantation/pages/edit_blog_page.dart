import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBlogPage extends StatefulWidget {
  final String blogId;
  const EditBlogPage({super.key, required this.blogId});

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchBlogDetails();
  }

  Future<void> _fetchBlogDetails() async {
    final response = await supabase
        .from('blogs')
        .select('*')
        .eq('id', widget.blogId)
        .single();

    setState(() {
      _titleController.text = response['title'];
      _contentController.text = response['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: () async {
                  await supabase.from('blogs').update({
                    'title': _titleController.text,
                    'content': _contentController.text,
                  }).eq('id', widget.blogId);

                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
