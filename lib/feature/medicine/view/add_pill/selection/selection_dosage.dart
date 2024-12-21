import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';

class SelectionDosage extends StatefulWidget {
  final Function(int) onDosageSelected;
  final int initialDosage;

  const SelectionDosage({
    super.key,
    required this.onDosageSelected,
    this.initialDosage = 1,
  });

  @override
  State<SelectionDosage> createState() => _SelectionDosageState();
}

class _SelectionDosageState extends State<SelectionDosage> {
  late int _selectedDosage;

  @override
  void initState() {
    super.initState();
    _selectedDosage = widget.initialDosage;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const MedicineText(text: 'How many times do you take it in a day?'),
          SizedBox(height: 6.h),
          SizedBox(
            height: 150.h,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: _selectedDosage - 1,
              ),
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedDosage = index + 1;
                });
                widget.onDosageSelected(_selectedDosage);
              },
              children: List<Widget>.generate(3, (int index) {
                return Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(fontSize: 25.sp),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
