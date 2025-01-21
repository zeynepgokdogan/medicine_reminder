import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Kullanıcıdan bildirim izni isteme
  Future<void> requestPermission() async {
    final notificationSettings = await _firebaseMessaging.requestPermission(
      provisional: true,
    );

    print('Bildirim izni durumu: ${notificationSettings.authorizationStatus}');
  }

  // Token alma
  Future<void> initializeFCMToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
  }

  // Token güncellemelerini dinleme
  void listenToTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Yeni FCM Token: $newToken');
      // Yeni token'i sunucunuza gönderebilirsiniz
    });
  }
  // Bildirimleri dinleme
void listenToMessages() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Yeni bildirim alındı: ${message.notification?.title}, ${message.notification?.body}');
    // Burada bir dialog, snackbar veya başka bir işlem gösterebilirsiniz
  });
}

}
