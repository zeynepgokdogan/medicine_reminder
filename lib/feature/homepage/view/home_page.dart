import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/login/view/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _signOut() {
    // Çıkış yapma işlemini burada gerçekleştir
    // Örneğin, Firebase Auth kullanıyorsanız:
    // await FirebaseAuth.instance.signOut();

    // Login sayfasına yönlendirme (rota kullanmadan)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Bir önceki sayfaya geri dön
          },
        ),
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Çıkış yap ikonu
            onPressed: _signOut, // Çıkış yapma fonksiyonu çağrılır
          ),
        ],
      ),
      body: Center(
        child: const Text("Home Page Content"),
      ),
    );
  }
}

