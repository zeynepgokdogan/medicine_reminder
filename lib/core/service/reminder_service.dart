// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_reminder/core/service/firebase_messaging_service.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  Future<void> sendMedicineReminders(String userId) async {
    final now = tz.TZDateTime.now(tz.local);
    print("Şu anki zaman: ${now.hour}:${now.minute}");

    try {
      final userMedicines = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .get();

      for (var doc in userMedicines.docs) {
        final reminderTimes = doc['reminderTimes'] ?? [];
        final medicationName = doc['medicationName'] ?? 'İlaç';

        final startDateStr = doc['startDate'];
        if (startDateStr != null) {
          final startDate = DateTime.parse(startDateStr);
          if (startDate.isAfter(now)) {
            print("Bu ilaç henüz başlamadı: $medicationName");
            continue;
          }
        }

        for (var time in reminderTimes) {
          final reminderTime = DateTime(now.year, now.month, now.day, 
                                        time['hour'], time['minute']);
          final difference = now.difference(reminderTime).inMinutes;

          if (difference.abs() <= 1) { 
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            final token = userDoc['fcmToken'];

            if (token != null) {
              print("Bildirim gönderilecek token: $token");
              await FirebaseMessagingService().sendNotification(
                "İlaç Hatırlatma",
                "$medicationName ilacını alma zamanı!",
                token,
              );
            } else {
              print('FCM Token bulunamadı!');
            }
          }
        }
      }
    } catch (e) {
      print("Bir hata oluştu: $e");
    }
  }
}
