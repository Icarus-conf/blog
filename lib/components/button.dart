import 'package:blog/components/text_format.dart';
import 'package:flutter/material.dart';

class KButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  final Color? color;
  const KButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
  });
//
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onPressed: onPressed,
      child: PoppinsText(
        text: label,
        fontS: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
