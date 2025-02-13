// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_notification_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  Future<Map<String, dynamic>> loadServiceAccount() async {
    final jsonString =
        await rootBundle.loadString('assets/service_account.json');
    return jsonDecode(jsonString);
  }

  Future<void> requestPermission() async {
    final notificationSettings = await _firebaseMessaging.requestPermission(
      provisional: true,
    );

    debugPrint(
        'Bildirim izni durumu: ${notificationSettings.authorizationStatus}');
  }

  Future<void> initializeFCMToken(String userId) async {
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await saveTokenToDatabase(fcmToken, userId);
      debugPrint('FCM Token alındı ve kaydedildi: $fcmToken');
    } else {
      debugPrint('FCM Token alınamadı!');
    }
  }

  void listenToTokenRefresh(String userId) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      debugPrint('Yeni FCM Token: $newToken');
      await saveTokenToDatabase(newToken, userId);
    }).onError((error) {
      debugPrint('FCM Token yenileme hatası: $error');
    });
  }

  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotificationService.scheduleNotification(
          notification.title ?? 'Başlık yok',
          notification.body ?? 'Mesaj yok',
          DateTime.now().add(const Duration(seconds: 5)),
        );
      }
    });
  }

  Future<void> saveTokenToDatabase(String token, String userId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'fcmToken': token});
      } else {
        await docRef.set({'fcmToken': token});
      }

      debugPrint('Token başarıyla kaydedildi.');
    } catch (e) {
      debugPrint('Token kaydedilirken bir hata oluştu: $e');
    }
  }

Future<void> sendNotification(String title, String body, String token) async {
  print("🔥 Firebase Bildirim Gönderme: $title - $body - $token");

  final serviceAccount = await loadServiceAccount();
  final clientEmail = serviceAccount['client_email'];
  final privateKey = serviceAccount['private_key'];

  final bearerToken = await createBearerToken(clientEmail, privateKey);

  final url =
      'https://fcm.googleapis.com/v1/projects/medicineReminder-1f080/messages:send';

  final message = {
    "message": {
      "token": token,
      "notification": {
        "title": title,
        "body": body,
      }
    }
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
      body: jsonEncode(message),
    );

    // HTTP isteğinin durumunu kontrol ediyoruz
    if (response.statusCode == 200) {
      print('✅ Bildirim başarıyla gönderildi.');
    } else {
      print('❌ Bildirim gönderme başarısız: ${response.statusCode}');
      print('📩 Sunucu yanıtı: ${response.body}');
    }
  } catch (e) {
    print('⚠️ Bildirim gönderiminde bir hata oluştu: $e');
  }
}
  Future<String> createBearerToken(
      String clientEmail, String privateKey) async {
    final now = DateTime.now();
    final exp = now.add(const Duration(hours: 1));

    final claims = JsonWebTokenClaims.fromJson({
      'iss': clientEmail,
      'sub': clientEmail,
      'aud': 'https://fcm.googleapis.com/',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': exp.millisecondsSinceEpoch ~/ 1000,
    });

    final builder = JsonWebSignatureBuilder()
      ..jsonContent = claims.toJson()
      ..addRecipient(
        JsonWebKey.fromPem(privateKey),
        algorithm: 'RS256',
      );

    final jws = builder.build();
    return jws.toCompactSerialization();
  }
}
