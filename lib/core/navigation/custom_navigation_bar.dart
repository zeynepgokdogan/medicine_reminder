import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/view/medicine_page.dart';
import 'package:medicine_reminder/feature/profilepage/view/profile_page.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.medical_services_rounded,
      'label': 'İLAÇLAR',
      'page': const MedicinePage()
    },
    {'icon': Icons.person, 'label': 'PROFİL', 'page': const ProfilePage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _navItems.map((item) => item['page'] as Widget).toList(),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 25.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 63, 121, 130),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical:12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      _navItems[index]['icon'],
                      size: 22.sp,
                      color: isSelected ? Colors.white : Colors.white,
                    ),
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          _navItems[index]['label'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
