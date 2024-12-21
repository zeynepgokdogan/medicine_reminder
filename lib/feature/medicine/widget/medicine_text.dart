import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MedicineText extends StatelessWidget {
  final String text;
  final double? textSize;

  const MedicineText({
    super.key,
    required this.text,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: textSize ?? 25.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}