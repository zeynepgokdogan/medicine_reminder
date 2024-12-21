import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/add_medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_button.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';
import 'package:provider/provider.dart';
import 'selection_time.dart';

class SelectionDay extends StatefulWidget {
  final String pillName;

  const SelectionDay({
    super.key,
    required this.pillName,
  });

  @override
  State<SelectionDay> createState() => _SelectionDayState();
}

class _SelectionDayState extends State<SelectionDay> {
  final List<bool> _selectedDays = List.generate(7, (_) => false);

  String _getDayName(int index) {
    const List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const MedicineText(
              text: 'Select the days!',
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDays[index] = !_selectedDays[index];
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.h),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedDays[index]
                              ? Colors.green.shade100
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedDays[index]
                                ? Colors.black
                                : Colors.grey,
                            width: 2.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getDayName(index),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedDays[index]
                                  ? Colors.green.shade900
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            MedicineButton(
              onPressed: () {
                final selectedWeekDays = _selectedDays
                    .asMap()
                    .entries
                    .where((entry) => entry.value) // true olanları filtrele
                    .map((entry) => WeekDays.values[
                        entry.key]) // İndeksleri WeekDays enum'una çevir
                    .toList();

                Provider.of<AddMedicineViewmodel>(context, listen: false)
                    .setFrequencyDetails(
                        selectedWeekDays); // WeekDays listesi gönderiliyor
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionTime(
                      frequency: 1,
                      pillName: widget.pillName,
                    ),
                  ),
                );
              },
              text: 'Next',
            ),
          ],
        ),
      ),
    );
  }
}
