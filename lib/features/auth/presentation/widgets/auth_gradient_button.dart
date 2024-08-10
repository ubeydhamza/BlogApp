import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String butonText;
  final VoidCallback onTop;
  const AuthGradientButton(
      {super.key, required this.butonText, required this.onTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppPallete.gradient1, AppPallete.gradient2],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: onTop,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 50),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          butonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
