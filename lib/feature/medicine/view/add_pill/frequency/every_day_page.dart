import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/selection/selection_dosage.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/selection/selection_time.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/add_medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_button.dart';
import 'package:provider/provider.dart';

class EveryDayPage extends StatefulWidget {
  final String pillName;

  const EveryDayPage({super.key, required this.pillName});

  @override
  State<EveryDayPage> createState() => _EveryDayPageState();
}

class _EveryDayPageState extends State<EveryDayPage> {
  int _selectedFrequency = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectionDosage(
                initialDosage: _selectedFrequency,
                onDosageSelected: (int dosage) {
                  setState(() {
                    _selectedFrequency = dosage;
                  });
                },
              ),
               SizedBox(height: 24.h),
              MedicineButton(
                onPressed: () {
                   Provider.of<AddMedicineViewmodel>(context, listen: false).setDosage(_selectedFrequency);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectionTime(
                        frequency: _selectedFrequency,
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
      ),
    );
  }
}
