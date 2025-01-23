// medicine_viewmodel.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/service/medicine_service.dart';

class MedicineViewModel extends ChangeNotifier {

  final MedicineService _medicineService = MedicineService();
  bool _isLoading = false;
  List<MedicineModel> _allMedicines = [];

  bool get isLoading => _isLoading;
  List<MedicineModel> get allMedicines => _allMedicines;

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
