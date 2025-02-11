// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/navigation/custom_navigation_bar.dart';
import 'package:medicine_reminder/core/service/firebase_messaging_service.dart';
void logIn(
  TextEditingController mailController,
  TextEditingController passwordController,
  BuildContext context,
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final String? userId = userCredential.user?.uid;

    if (userId != null) {
      final FirebaseMessagingService firebaseMessagingService =
          FirebaseMessagingService();
      await firebaseMessagingService.initializeFCMToken(userId);
      firebaseMessagingService.listenToTokenRefresh(userId);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
    );

    debugPrint('Giriş yapan kullanıcı UID: $userId');
  } on FirebaseAuthException catch (e) {
    handleFirebaseAuthError(e, context);
  } catch (e) {
    debugPrint('Bilinmeyen hata: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void handleFirebaseAuthError(FirebaseAuthException e, BuildContext context) {
  String errorMessage;
  switch (e.code) {
    case 'user-not-found':
      errorMessage = "Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.";
      break;
    case 'wrong-password':
      errorMessage = "Girdiğiniz şifre hatalı. Lütfen tekrar deneyin.";
      break;
    case 'invalid-email':
      errorMessage = "Geçersiz bir e-posta adresi girdiniz.";
      break;
    case 'user-disabled':
      errorMessage = "Bu kullanıcı hesabı devre dışı bırakılmış.";
      break;
    default:
      errorMessage = "Kullanıcı bulunamadı.";
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
