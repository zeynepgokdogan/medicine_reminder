import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';

class MedicineButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color color;

  const MedicineButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      height: 40.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding:  EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
