import 'package:blog/components/text_format.dart';
import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String nameSection;
  final Function()? onPressed;
  const TextBox({
    super.key,
    required this.text,
    required this.nameSection,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(1, 20, 20, 0),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PoppinsText(
                text: nameSection,
                color: Colors.grey[500],
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[500],
                  )),
            ],
          ),
          PoppinsText(text: text),
        ],
      ),
    );
  }
}
