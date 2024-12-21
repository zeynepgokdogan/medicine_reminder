import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';

class SelectionDate extends StatefulWidget {
  final Function(int) onDaySelected;
  final int initialDay;

  const SelectionDate({
    super.key,
    required this.onDaySelected,
    this.initialDay = 1, 
  });

  @override
  State<SelectionDate> createState() => _SelectionDateState();
}

class _SelectionDateState extends State<SelectionDate> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const MedicineText(text: 'How many days apart should you take?'),
           SizedBox(height: 30.h),
          SizedBox(
            height: 150.h,
            child: CupertinoPicker(
              itemExtent: 40.h,
              scrollController: FixedExtentScrollController(
                initialItem: _selectedDay - 1,
              ),
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedDay = index + 1;
                });
                widget.onDaySelected(_selectedDay);
              },
              children: List<Widget>.generate(14, (int index) {
                return Center(
                  child: Text(
                    '${index + 1}',
                    style:  TextStyle(fontSize: 25.sp),
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
