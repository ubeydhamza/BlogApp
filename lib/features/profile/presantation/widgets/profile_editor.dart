import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileEditor extends StatelessWidget {
  final TextEditingController controller;
  const ProfileEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 300,
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        controller: controller,
      ),
    );
  }
}
