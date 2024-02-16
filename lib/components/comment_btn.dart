import 'package:flutter/material.dart';

class CommentBtn extends StatelessWidget {
  final Function()? onTap;
  const CommentBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/comments.png',
        width: 30,
      ),
    );
  }
}
