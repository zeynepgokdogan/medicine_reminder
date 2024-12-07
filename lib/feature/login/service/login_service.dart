// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void logIn(
  TextEditingController mailController,
  TextEditingController passwordController,
  BuildContext context,
) async {
  try {
    // Kullanıcı giriş yapıyor
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Giriş başarılı, UID alınıyor
    final String? userId = userCredential.user?.uid;
    debugPrint('Giriş yapan kullanıcı UID: $userId');

    // Kullanıcıya başarılı giriş mesajı gösteriliyor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Başarıyla giriş yapıldı!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );

    // UID ile başka işlemler yapabilirsiniz, örneğin Firestore'dan veri çekmek
    if (userId != null) {
      // Örnek: Firestore'dan veri çekme
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        debugPrint('Kullanıcı bilgisi: ${userDoc.data()}');
      } else {
        debugPrint('Kullanıcı bilgisi bulunamadı.');
      }
    }
  } on FirebaseAuthException catch (e) {
    // Firebase özel hatalarını işleyin
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = "Kullanıcı bulunamadı.";
        break;
      case 'wrong-password':
        errorMessage = "Yanlış şifre.";
        break;
      default:
        errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
    }

    // Hata mesajı gösteriliyor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    // Genel hataları yakalayın
    debugPrint('Bilinmeyen hata: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Bilinmeyen bir hata oluştu!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
