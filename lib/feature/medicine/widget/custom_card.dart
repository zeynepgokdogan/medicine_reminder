import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<MedicineModel> items;

  const CustomCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: AppColors.grey,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final medicine = items[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SvgPicture.asset(
                          'lib/assets/pill_2.svg',
                          // ignore: deprecated_member_use
                          color: Colors.white,
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        medicine.medicationName,
                        style: TextStyle(
                            fontSize: 10.sp, color: AppColors.secondaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
