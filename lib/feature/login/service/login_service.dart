import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/homepage/view/home_page.dart';

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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );

    debugPrint('Giriş yapan kullanıcı UID: ${userCredential.user?.uid}');
  } on FirebaseAuthException catch (e) {
    debugPrint('Firebase Hata Kodu: ${e.code}');

    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = "Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.";
      debugPrint('Firebase Hata Kodu: ${e.code}');
    } else if (e.code == 'wrong-password') {
      errorMessage = "Girdiğiniz şifre hatalı. Lütfen tekrar deneyin.";
      debugPrint('Firebase Hata Kodu: ${e.code}');
    } else if (e.code == 'invalid-email') {
      errorMessage = "Geçersiz bir e-posta adresi girdiniz.";
      debugPrint('Firebase Hata Kodu: ${e.code}');
    } else if (e.code == 'user-disabled') {
      errorMessage = "Bu kullanıcı hesabı devre dışı bırakılmış.";
    } else {
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