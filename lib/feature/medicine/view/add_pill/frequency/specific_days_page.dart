import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import '../selection/selection_day.dart';

class SpecificDaysPage extends StatelessWidget {
  final String pillName;

  const SpecificDaysPage({
    super.key,
    required this.pillName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SelectionDay(
                pillName: pillName,
              ),
            ),
             SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
