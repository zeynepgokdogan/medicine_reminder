import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/frequency/every_day_page.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/frequency/every_x_days_page.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/frequency/specific_days_page.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/add_medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/medicine/widget/custom_appbar.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';
import 'package:medicine_reminder/feature/medicine/widget/selectable_button.dart';
import 'package:provider/provider.dart';

class AddPill2 extends StatefulWidget {
  final String pillName;

  const AddPill2({super.key, required this.pillName});

  @override
  State<AddPill2> createState() => _AddPill2State();
}

class _AddPill2State extends State<AddPill2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MedicineText(text: 'How often do you take it?'),
              SelectableButton(
                onPressed: () {
                  Provider.of<AddMedicineViewmodel>(context, listen: false)
                      .setFrequencyType(FrequencyType.daily);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EveryDayPage(pillName: widget.pillName),
                    ),
                  );
                },
                text: 'Every day',
              ),
              SelectableButton(
                onPressed: () {
                  Provider.of<AddMedicineViewmodel>(context, listen: false)
                      .setFrequencyType(FrequencyType.daysOfWeek);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SpecificDaysPage(pillName: widget.pillName),
                    ),
                  );
                },
                text: 'Specific days of the week',
              ),
              SelectableButton(
                onPressed: () {
                  Provider.of<AddMedicineViewmodel>(context, listen: false)
                      .setFrequencyType(FrequencyType.custom);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EveryXDaysPage(pillName: widget.pillName),
                    ),
                  );
                },
                text: 'Every X days',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
