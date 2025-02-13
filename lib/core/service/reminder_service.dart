import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:medicine_reminder/core/service/firebase_messaging_service.dart';

class ReminderService {
  Future<void> sendMedicineReminders(String userId) async {
    // 🔥 Firebase başlatılmadıysa başlat
    if (Firebase.apps.isEmpty) {
      print("🔴 Firebase initialize ediliyor...");
      await Firebase.initializeApp();
    }

    // 📌 Zaman dilimlerini başlat
    tz.initializeTimeZones();
    final location =
        tz.getLocation('Europe/Istanbul'); // Türkiye saat dilimini al
    final now = tz.TZDateTime.now(location); // Şu anki zaman
    print("🕒 Şu anki zaman: ${now.hour}:${now.minute}");

    try {
      // Firestore'dan kullanıcının ilaçlarını çek
      final userMedicinesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .get();

      print(
          "📌 Firestore'dan çekilen ilaç sayısı: ${userMedicinesSnapshot.docs.length}");

      if (userMedicinesSnapshot.docs.isEmpty) {
        print("⚠️ Kullanıcının kayıtlı ilacı yok!");
        return;
      }

      for (var doc in userMedicinesSnapshot.docs) {
        final data = doc.data();
        if (data == null) continue;

        final List<dynamic> reminderTimesRaw = data['reminderTimes'] ?? [];
        List<Map<String, dynamic>> reminderTimes =
            reminderTimesRaw.map((e) => Map<String, dynamic>.from(e)).toList();
        for (var time in reminderTimes) {
          if (!time.containsKey('hour') || !time.containsKey('minute')) {
            print("⚠️ Hatalı zaman formatı: $time");
            continue;
          }

          // Şu anki zamanın saat ve dakikasını al
          final currentHour = now.hour;
          final currentMinute = now.minute;

          // Hatırlatma zamanının saat ve dakikasını al
          final reminderHour = time['hour'];
          final reminderMinute = time['minute'];

          // Hatırlatma zamanının şu anki zamana göre geçip geçmediğini kontrol et
          if (reminderHour < currentHour ||
              (reminderHour == currentHour && reminderMinute < currentMinute)) {
            print(
                "⚠️ Hatırlatma saati geçmiş: ${reminderHour}:${reminderMinute}");
            continue;
          }

          // Eğer hatırlatma saati çok yakınsa (5 dakika içinde)
          final differenceMinutes = (reminderHour - currentHour) * 60 +
              (reminderMinute - currentMinute);

          if (differenceMinutes <= 5) {
            print("📢 Bildirim zamanı geldi! Bildirim gönderilecek!");

            // Kullanıcının FCM token'ını al
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            final token = userDoc.data()?['fcmToken'];

            if (token != null && token.isNotEmpty) {
              print("✅ Bildirim gönderilecek: Kullanıcı Token: $token");

              // Bildirimi basit hale getirin
              await FirebaseMessagingService().sendNotification(
                "İlaç Hatırlatma", // Başlık
                "İlaç zamanı geldi!", // Mesaj
                token,
              );
            } else {
              print(
                  "⚠️ Kullanıcının FCM Token'ı yok, bildirim gönderilemiyor!");
            }
          } else {
            print("⏳ Hatırlatma saati için çok zaman var.");
          }
        }
      }
    } catch (e) {
      print("🚨 Firestore'dan veri çekerken hata oluştu: $e");
    }
  }
}
