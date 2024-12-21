import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/add_pill_1.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_card.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_floating_button.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final PageController _pageController = PageController(initialPage: 30);
  final int centerPage = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Pill Reminder',
        backgroundColor: AppColors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime.now().add(
                    Duration(days: index - centerPage),
                  );
                  return Column(
                    children: [
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black,
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
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                size: 20, color: Colors.black),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: const [
                            CustomCard(
                              title: 'Morning',
                              icon: Icons.wb_sunny,
                              items: [],
                            ),
                            CustomCard(
                              title: 'Afternoon',
                              icon: Icons.light_mode,
                              items: [],
                            ),
                            CustomCard(
                              title: 'Evening',
                              icon: Icons.nights_stay,
                              items: [],
                            ),
                            CustomCard(
                              title: 'Night',
                              icon: Icons.bedtime,
                              items: [],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPill1(),
            ),
          );
        },
        backgroundColor: AppColors.grey,
      ),
    );
  }

  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    if (DateFormat('MM-dd').format(date) == DateFormat('MM-dd').format(today)) {
      return 'Today, ${DateFormat('d MMMM').format(date)} ';
    } else {
      return DateFormat('d MMMM').format(date);
    }
  }
}
