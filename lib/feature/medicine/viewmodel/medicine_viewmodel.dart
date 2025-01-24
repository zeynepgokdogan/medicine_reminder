import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/service/medicine_service.dart';

class MedicineViewModel extends ChangeNotifier {
  final MedicineService _medicineService = MedicineService();

  // State variables
  String medicationName = '-';
  int dosage = 1;
  FrequencyType frequencyType = FrequencyType.daily;
  List<WeekDays>? frequencyDetails;
  List<TimeOfDay> reminderTimes = [];
  DateTime startDate = DateTime.now();
  int? repeatIntervalInDays;
  bool _isLoading = false;
  List<MedicineModel> _allMedicines = [];

  // Getters
  bool get isLoading => _isLoading;
  List<MedicineModel> get allMedicines => _allMedicines;

  // Setters with notifyListeners
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

  // Save medicine to database
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

  // Fetch all medicines for a user
  Future<void> fetchAllMedicines(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _allMedicines = await _medicineService.getAllMedicines(userId);
    } catch (e) {
      debugPrint('Error fetching medicines: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get medicines for a specific date
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

  // Delete a medicine
  Future<void> deleteMedicine(String medicineId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('Error: No user is logged in.');
        return;
      }

      final String userId = currentUser.uid;
      await _medicineService.deleteMedicine(userId, medicineId);

      _allMedicines.removeWhere((medicine) => medicine.id == medicineId);

      debugPrint('Medicine successfully deleted: $medicineId');
    } catch (e) {
      debugPrint('Error deleting medicine: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Group medicines by time of day
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
