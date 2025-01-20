import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Token al
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Gelen mesajları dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Gelen Mesaj: ${message.notification?.title}");
    });
  }
}
