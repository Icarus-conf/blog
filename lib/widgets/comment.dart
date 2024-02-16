import 'package:blog/components/text_format.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String comment;
  final String user;
  final String createdAt;
  const Comment({
    super.key,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFced4da),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PoppinsText(text: comment),
          Row(
            children: [
              PoppinsText(
                text: user,
                color: Colors.grey[500],
              ),
              PoppinsText(
                text: ' ~ ',
                color: Colors.grey[500],
              ),
              PoppinsText(
                text: createdAt,
                color: Colors.grey[500],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
