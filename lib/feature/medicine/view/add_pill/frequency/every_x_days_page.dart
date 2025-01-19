import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/selection/selection_date.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/selection/selection_time.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/add_medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_button.dart';
import 'package:provider/provider.dart';

class EveryXDaysPage extends StatefulWidget {
  final String pillName;

  const EveryXDaysPage({
    super.key,
    required this.pillName,
  });

  @override
  State<EveryXDaysPage> createState() => _EveryXDaysPageState();
}

class _EveryXDaysPageState extends State<EveryXDaysPage> {
  int _selectedFrequency = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectionDate(
            initialDay: _selectedFrequency,
            onDaySelected: (int day) {
              setState(() {
                _selectedFrequency = day;
              });
            },
          ),
           SizedBox(
            height: 30.h,
          ),
          MedicineButton(
            onPressed: () {
              Provider.of<AddMedicineViewmodel>(context, listen: false)
                  .setRepeatIntervalInDays(_selectedFrequency);
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
            text: 'İlerle',
          ),
        ],
      ),
    );
  }
}
