import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool? isObscureText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.isObscureText,
    this.textInputType,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: textInputType,
      obscureText: isObscureText ?? false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[500],
        ),
        focusColor: Colors.black,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: .5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFa8dadc),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFa8dadc),
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFa8dadc),
          ),
        ),
      ),
    );
  }
}
