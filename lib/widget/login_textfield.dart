import 'package:flutter/material.dart';
import 'package:telegram/color.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final String title;
  final TextEditingController controller;

  const LoginTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 5),
          child: Text(
            title,
            style: const TextStyle(
              color: ColorThemes.black,
              fontSize: 18,
            ),
          ),
        ),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            filled: true,
            fillColor: ColorThemes.background,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.5),
              borderSide: const BorderSide(color: ColorThemes.gray),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.5),
                borderSide: const BorderSide(color: ColorThemes.black)
            ),
          ),
        )
      ],
    );
  }
}