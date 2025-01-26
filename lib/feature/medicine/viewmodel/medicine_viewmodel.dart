// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/service/medicine_service.dart';

class MedicineViewModel extends ChangeNotifier {
  final MedicineService _medicineService = MedicineService();


  String medicationName = '-';
  int dosage = 1;
  FrequencyType frequencyType = FrequencyType.daily;
  List<WeekDays>? frequencyDetails;
  List<TimeOfDay> reminderTimes = [];
  DateTime startDate = DateTime.now();
  int? repeatIntervalInDays;
  bool _isLoading = false;
  List<MedicineModel> _allMedicines = [];


  bool get isLoading => _isLoading;
  List<MedicineModel> get allMedicines => _allMedicines;


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

Future<void> fetchUserMedicines() async {
  try {
    _isLoading = true;
    notifyListeners();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('Kullanıcı oturum açmamış.');
    }

    _allMedicines = await _medicineService.getAllMedicines(userId);
  } catch (e) {
    debugPrint('İlaçlar yüklenirken hata oluştu: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  List<MedicineModel> getMedicinesForDate(DateTime date) {
    return _allMedicines.where((medicine) {
      switch (medicine.frequencyType) {
        case FrequencyType.daily:
          return true;
        case FrequencyType.daysOfWeek:
          if (medicine.frequencyDetails != null) {
            return medicine.frequencyDetails!
                .contains(WeekDays.values[date.weekday - 1]);
          }
          return false;
        case FrequencyType.custom:
          if (medicine.repeatIntervalInDays != null) {
            int daysSinceStart = date.difference(medicine.startDate).inDays;
            return daysSinceStart >= 0 &&
                daysSinceStart % medicine.repeatIntervalInDays! == 0;
          }
          return false;
      }
    }).toList();
  }

  Future<void> deleteMedicineById(String medicineId, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('Kullanıcı oturumu açık değil.');
      }

      await _medicineService.deleteMedicine(userId, medicineId);

      _allMedicines.removeWhere((medicine) => medicine.id == medicineId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlaç başarıyla silindi.')),
      );
    } catch (e) {
      debugPrint('İlaç silinirken hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlaç silinirken hata oluştu.')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Map<String, List<MedicineModel>> groupMedicinesByTime(
      List<MedicineModel> medicines) {
    Map<String, List<MedicineModel>> groupedMedicines = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Night': []
    };
    for (var medicine in medicines) {
      if (medicine.reminderTimes != null &&
          medicine.reminderTimes!.isNotEmpty) {
        for (var time in medicine.reminderTimes!) {
          if (time.hour >= 6 && time.hour < 12) {
            groupedMedicines['Morning']!.add(medicine);
          } else if (time.hour >= 12 && time.hour < 17) {
            groupedMedicines['Afternoon']!.add(medicine);
          } else if (time.hour >= 17 && time.hour < 21) {
            groupedMedicines['Evening']!.add(medicine);
          } else {
            groupedMedicines['Night']!.add(medicine);
          }
        }
      } else {
        groupedMedicines['Morning']!.add(medicine);
      }
    }
    return groupedMedicines;
  }
}
