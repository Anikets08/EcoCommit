import 'package:ecocommit/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild({
    super.key,
    required this.hintText,
    required this.type,
    required this.controller,
    this.autofillHint = const [],
  });

  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  final List<String> autofillHint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHint,
      keyboardType: type,
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomColors.kGreen.withOpacity(0.08),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: CustomColors.kGreen,
            width: 2.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
