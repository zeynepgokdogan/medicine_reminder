import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/homepage/view/home_page.dart';
import 'package:medicine_reminder/feature/login/view/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final String? userId = FirebaseAuth.instance.currentUser?.uid;

            if (userId != null) {
              debugPrint('User ID: $userId');
              return const HomePage();
            } else {
              return const Center(child: Text('Kullanıcı ID alınamadı!'));
            }
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
