import 'package:blog/components/text_format.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;
  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: PoppinsText(
          text: text,
          color: Colors.grey[400],
          letterSpacing: 2,
        ),
      ),
    );
  }
}
