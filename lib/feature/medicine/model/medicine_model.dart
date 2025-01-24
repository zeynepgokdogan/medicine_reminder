import 'package:flutter/material.dart';

enum FrequencyType { daily, daysOfWeek, custom }

enum WeekDays { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class MedicineModel {
  final String? id; 
  final String medicationName;
  final int dosage;
  final FrequencyType frequencyType;
  final List<WeekDays>? frequencyDetails;
  final List<TimeOfDay>? reminderTimes;
  final DateTime startDate;
  final int? repeatIntervalInDays;

  MedicineModel({
    this.id, 
    required this.medicationName,
    required this.dosage,
    required this.frequencyType,
    this.frequencyDetails,
    this.reminderTimes,
    required this.startDate,
    this.repeatIntervalInDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequencyType': frequencyType.toString(),
      'frequencyDetails': frequencyDetails?.map((e) => e.toString()).toList(),
      'reminderTimes': reminderTimes
          ?.map((time) => {'hour': time.hour, 'minute': time.minute})
          .toList(),
      'startDate': startDate.toIso8601String(),
      'repeatIntervalInDays': repeatIntervalInDays,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MedicineModel(
      id: id,
      medicationName: map['medicationName'] ?? '',
      dosage: map['dosage'] ?? 0,
      frequencyType: FrequencyType.values.firstWhere(
          (e) => e.toString() == map['frequencyType'],
          orElse: () => FrequencyType.daily),
      frequencyDetails: (map['frequencyDetails'] as List?)
          ?.map((e) => WeekDays.values.firstWhere(
                (day) => day.toString() == e,
              ))
          .toList(),
      reminderTimes: (map['reminderTimes'] as List?)
          ?.map((time) => TimeOfDay(hour: time['hour'], minute: time['minute']))
          .toList(),
      startDate: DateTime.parse(map['startDate']),
      repeatIntervalInDays: map['repeatIntervalInDays'],
    );
  }
}
