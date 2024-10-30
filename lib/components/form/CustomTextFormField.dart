import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isMultiline;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: isMultiline ? 10 : 1,
      controller: controller,
      obscureText: obscureText,
      maxLines: isMultiline ? null : 1,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
