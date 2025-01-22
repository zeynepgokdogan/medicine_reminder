import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  // Kullanıcıdan bildirim izni isteme
  Future<void> requestPermission() async {
    final notificationSettings = await _firebaseMessaging.requestPermission(
      provisional: true,
    );

    print('Bildirim izni durumu: ${notificationSettings.authorizationStatus}');
  }

  // Token alma ve veritabanına kaydetme
  Future<void> initializeFCMToken(String userId) async {
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await saveTokenToDatabase(fcmToken, userId); // Token'i kaydet
      print('FCM Token alındı ve kaydedildi: $fcmToken');
    }
  }

  // Token güncellemelerini dinleme
  void listenToTokenRefresh(String userId) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('Yeni FCM Token: $newToken');
      await saveTokenToDatabase(newToken, userId); // Yeni token'i kaydet
    });
  }

  // Bildirimleri dinleme
  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Yeni bildirim alındı: ${message.notification?.title}, ${message.notification?.body}');
      
      // Gelen mesajı yerel bildirim olarak göster
      _localNotificationService.scheduleNotification(
        message.notification?.title ?? 'Başlık yok',
        message.notification?.body ?? 'Mesaj yok',
        DateTime.now().add(Duration(seconds: 5)), // 5 saniye sonra göster
      );
    });
  }

  // Token'i Firestore veritabanına kaydetme
  Future<void> saveTokenToDatabase(String token, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
      print('Token başarıyla kaydedildi.');
    } catch (e) {
      print('Token kaydedilirken bir hata oluştu: $e');
    }
  }

  // Bildirim gönderme
  Future<void> sendNotification(String token, String title, String body) async {
    try {
      await FirebaseMessaging.instance.sendMessage(
        to: token,
        data: {
          'title': title,
          'body': body,
        },
      );
      print('Bildirim gönderildi: $title - $body');
    } catch (e) {
      print('Bildirim gönderilirken bir hata oluştu: $e');
    }
  }
}
