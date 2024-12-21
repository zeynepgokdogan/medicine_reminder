// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/service/medicine_service.dart';

class AddMedicineViewmodel extends ChangeNotifier {
  final MedicineService _medicineService = MedicineService();
  String medicationName = '-';
  int dosage = 1;
  FrequencyType frequencyType = FrequencyType.daily;
  List<WeekDays>? frequencyDetails;
  List<TimeOfDay> reminderTimes = [];
  DateTime startDate = DateTime.now();
  int? repeatIntervalInDays;

  Future<void> saveMedicine(BuildContext context) async {
    try {
      MedicineModel medicine = MedicineModel(
        medicationName: medicationName.isNotEmpty ? medicationName : "-",
        dosage: dosage > 0 ? dosage : 1,
        frequencyType: frequencyType,
        frequencyDetails: frequencyDetails,
        reminderTimes: reminderTimes,
        startDate: startDate,
        repeatIntervalInDays: repeatIntervalInDays,
      );
      debugPrint("Kaydedilen Model: ${medicine.toMap()}");
      await _medicineService.saveMedicine(medicine);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlaç başarıyla kaydedildi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

  void setMedicationName(String value) {
    medicationName = value;
    debugPrint("Medication Name: $medicationName");
    notifyListeners();
  }

  void setDosage(int value) {
    dosage = value;
    debugPrint("Dosage: $dosage");
    notifyListeners();
  }

  void setFrequencyType(FrequencyType type) {
    frequencyType = type;

    if (type == FrequencyType.daily) {
      frequencyDetails = null;
      repeatIntervalInDays = null;
    } else if (type == FrequencyType.daysOfWeek) {
      repeatIntervalInDays = null;
    } else if (type == FrequencyType.custom) {
      frequencyDetails = null;
    }

    debugPrint("Frequency Type: $frequencyType");
    notifyListeners();
  }

  void setFrequencyDetails(List<WeekDays> days) {
    frequencyDetails = days;
    debugPrint("Frequency Details: $frequencyDetails");
    notifyListeners();
  }

  void setReminderTimes(List<TimeOfDay> times) {
    reminderTimes = times;
    debugPrint(
      "Reminder Times: ${reminderTimes.map((t) => '${t.hour}:${t.minute}').toList()}",
    );
    notifyListeners();
  }

  void setRepeatIntervalInDays(int? interval) {
    repeatIntervalInDays = interval;
    debugPrint("Repeat Interval in Days: $repeatIntervalInDays");
    notifyListeners();
  }
}
