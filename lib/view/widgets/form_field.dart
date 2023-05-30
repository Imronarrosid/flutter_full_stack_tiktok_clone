import 'package:flutter/material.dart';
import 'package:tiktok_clone/constans.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;

  const CustomFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.prefixIcon,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          labelStyle: const TextStyle(fontSize: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: borderColorFocus,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: borderColor,
            ),
          )),
      obscureText: obscureText,
    );
  }
}
