import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';

class LoginContainer extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController? controller;

  const LoginContainer({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.secondaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.secondaryColor)),
          labelText: labelText,
        ),
      ),
    );
  }
}
