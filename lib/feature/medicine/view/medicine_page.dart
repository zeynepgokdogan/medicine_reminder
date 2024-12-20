// medicine_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final PageController _pageController = PageController(initialPage: 15);
  final int centerPage = 15;

  @override
  void initState() {
    super.initState();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      final medicineViewModel =
          Provider.of<MedicineViewModel>(context, listen: false);
      medicineViewModel.fetchAllMedicines(userId);
    } else {
      debugPrint("Kullanıcı oturum açmamış.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Pill Reminder',
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Consumer<MedicineViewModel>(
        builder: (context, medicineViewModel, child) {
          if (medicineViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (medicineViewModel.allMedicines.isEmpty) {
            return Center(
              child: Text(
                'Hiç ilaç eklenmemiş.',
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 30,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime.now().add(
                    Duration(days: index - centerPage),
                  );

                  List<MedicineModel> medicinesForDate =
                      medicineViewModel.getMedicinesForDate(currentDate);

                  Map<String, List<MedicineModel>> groupedMedicines =
                      medicineViewModel.groupMedicinesByTime(medicinesForDate);

                  return Column(
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          Text(
                            _formatDate(currentDate),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h),
                      Expanded(
                        child: groupedMedicines.values
                                .any((list) => list.isNotEmpty)
                            ? GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.h,
                                mainAxisSpacing: 16.w,
                                children: [
                                  CustomCard(
                                      title: 'Morning',
                                      icon: Icons.wb_sunny,
                                      items: groupedMedicines['Morning'] ?? []),
                                  CustomCard(
                                      title: 'Afternoon',
                                      icon: Icons.light_mode,
                                      items:
                                          groupedMedicines['Afternoon'] ?? []),
                                  CustomCard(
                                      title: 'Evening',
                                      icon: Icons.nights_stay,
                                      items: groupedMedicines['Evening'] ?? []),
                                  CustomCard(
                                      title: 'Night',
                                      icon: Icons.bedtime,
                                      items: groupedMedicines['Night'] ?? []),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Bu gün için hiç ilaç eklenmemiş.',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    if (DateUtils.isSameDay(date, today)) {
      return 'Today, ${DateFormat('d MMMM').format(date)}';
    }
    return DateFormat('d MMMM').format(date);
  }
}
