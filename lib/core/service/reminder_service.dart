import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:medicine_reminder/core/service/firebase_messaging_service.dart';

class ReminderService {
  Future<void> sendMedicineReminders(String userId) async {
    if (Firebase.apps.isEmpty) {
      print("🔴 Firebase initialize ediliyor...");
      await Firebase.initializeApp();
    }


    tz.initializeTimeZones(); // ✅ Timezone başlat
    final now = tz.TZDateTime.from(DateTime.now(), tz.local);

    print("🕒 Şu anki zaman: ${now.hour}:${now.minute}");

    try {
      final userMedicines = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .get();


          
      print("📌 Firestore'dan çekilen ilaç sayısı: ${userMedicines.docs.length}");

      if (userMedicines.docs.isEmpty) {
        print("⚠️ Kullanıcının kayıtlı ilacı yok!");
        return;
      }

      for (var doc in userMedicines.docs) {
        final reminderTimes = doc['reminderTimes'] ?? [];
        final medicationName = doc['medicationName'] ?? 'İlaç';

        print("💊 İlaç: $medicationName, Hatırlatma Saatleri: $reminderTimes");

        for (var time in reminderTimes) {
          final reminderTime = DateTime(
              now.year, now.month, now.day, time['hour'], time['minute']);
          final difference = now.difference(reminderTime).inMinutes;

          print("🕒 Şu anki saat: ${now.hour}:${now.minute}, Hatırlatma saati: ${reminderTime.hour}:${reminderTime.minute}, Fark: $difference dk");

          if (difference.abs() <= 1) {
            print("📢 Bildirim zamanı geldi! Bildirim gönderilecek!");
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            final token = userDoc['fcmToken'];

            if (token != null) {
              print("✅ Bildirim gönderilecek: $medicationName - Kullanıcı Token: $token");
              await FirebaseMessagingService().sendNotification(
                "İlaç Hatırlatma",
                "$medicationName ilacını alma zamanı!",
                token,
              );
            } else {
              print("⚠️ Kullanıcının FCM Token'ı yok, bildirim gönderilemiyor!");
            }
          }
        }
      }
    } catch (e) {
      print("🚨 Firestore'dan veri çekerken hata oluştu: $e");
    }
  }
}
