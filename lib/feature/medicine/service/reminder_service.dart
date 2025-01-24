import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ReminderService {
  Future<void> sendMedicineReminders(String userId) async {
    final now = DateTime.now();
    final userMedicines = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medicines')
        .get();

    for (var doc in userMedicines.docs) {
      final reminderTimes = doc['reminderTimes'];
      final medicationName = doc['medicationName'];

      for (var time in reminderTimes) {
        if (time['hour'] == now.hour && time['minute'] == now.minute) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          final token = userDoc['fcmToken'];

          await FirebaseMessaging.instance.sendMessage(
            to: token,
            data: {
              'title': "İlaç Hatırlatma",
              'body': "$medicationName ilacını alma zamanı!",
            },
          );
        }
      }
    }
  }
}
