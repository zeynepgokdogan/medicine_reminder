// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'local_notification_service.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_io.dart' as auth_io;

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  Future<String> getOAuthToken() async {
    final jsonString =
        await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    final accountCredentials = auth.ServiceAccountCredentials.fromJson(jsonMap);

    final authClient = await auth_io.clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    return authClient.credentials.accessToken.data;
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
    const String projectId = "medicinereminder-1f080";
    const String url =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    final String oAuthToken = await getOAuthToken();

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
          'Authorization': 'Bearer $oAuthToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("✅ Bildirim başarıyla gönderildi!");
      } else {
        print("❌ Bildirim gönderme başarısız: ${response.statusCode}");
        print("📩 Sunucu yanıtı: ${response.body}");
      }
    } catch (e) {
      print("🚨 Hata: $e");
    }
  }
}
