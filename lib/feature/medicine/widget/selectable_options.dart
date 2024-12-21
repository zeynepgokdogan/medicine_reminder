import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';

class SelectableOptions extends StatelessWidget {
  final List<String> options;
  final Function(String) onOptionSelected;

  const SelectableOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        ...options.map((option) {
          return GestureDetector(
            onTap: () => onOptionSelected(option),
            child: Padding(
              padding: EdgeInsets.all(5.h),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 6.w),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
