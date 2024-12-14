import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/profilepage/view/medicine_page.dart';
import 'package:medicine_reminder/feature/profilepage/view/profile_page.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _pageIndex = 1;

  final _pages = [
    const MedicinePage(), 
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        currentIndex: _pageIndex,
        unselectedItemColor: Colors.white60, 
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_rounded, size: 40),
            label: 'İLAÇLAR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40),
            label: 'PROFİL',
          ),
        ],
      ),
    );
  }
}