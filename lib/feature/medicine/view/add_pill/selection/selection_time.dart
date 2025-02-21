import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/auth/auth_page.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_button.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';
import 'package:provider/provider.dart';

class SelectionTime extends StatefulWidget {
  final int frequency;
  final String pillName;

  const SelectionTime({
    super.key,
    required this.frequency,
    required this.pillName,
  });

  @override
  State<SelectionTime> createState() => _SelectionTimeState();
}

class _SelectionTimeState extends State<SelectionTime> {
  late List<DateTime> _selectedTimes;

  @override
  void initState() {
    super.initState();
    _selectedTimes = List.generate(
      widget.frequency,
      (_) => DateTime.now(),
    );
  }

  void _onTimeChanged(int index, DateTime time) {
    setState(() {
      _selectedTimes[index] = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MedicineText(
                text: 'Her doz için bir saat seçin!',
                textSize: 24.sp,
              ),
              const Divider(),
              SizedBox(height: 20.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.frequency,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}. Doz ->',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: AppColors.secondaryColor,
                            ),
                            child: SizedBox(
                              height: 90.h,
                              width: 150.w,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                use24hFormat: true,
                                initialDateTime: _selectedTimes[index],
                                onDateTimeChanged: (DateTime newTime) {
                                  _onTimeChanged(index, newTime);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40.h,),
              MedicineButton(
                onPressed: () async {
                  Provider.of<MedicineViewModel>(context, listen: false)
                      .setReminderTimes(
                    _selectedTimes
                        .map((dateTime) => TimeOfDay(
                              hour: dateTime.hour,
                              minute: dateTime.minute,
                            ))
                        .toList(),
                  );
                  await Provider.of<MedicineViewModel>(context,
                          listen: false)
                      .saveMedicine(context);

                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                },
                text: 'KAYDET',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
