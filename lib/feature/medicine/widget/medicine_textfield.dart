// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';

class MedicineTextfield extends StatelessWidget {
  final String hintText;
  final Color color;
  final TextEditingController controller;

  const MedicineTextfield({
    super.key,
    required this.hintText,
    this.color = AppColors.secondaryColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(12.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          filled: true,
          fillColor:AppColors.grey,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color.withOpacity(0.3.w),
              width: 2.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color.withOpacity(0.3.w),
              width: 3.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color,
              width: 3.w,
            ),
          ),
          contentPadding: EdgeInsets.all(16.h),
        ),
      ),
    );
  }
}
