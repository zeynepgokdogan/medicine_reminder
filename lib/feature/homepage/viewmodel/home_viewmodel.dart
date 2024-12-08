// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/homepage/model/home_model.dart';
import 'package:medicine_reminder/feature/homepage/service/home_service.dart';
import 'package:medicine_reminder/feature/login/view/login_page.dart';

class HomeViewmodel extends ChangeNotifier {
  final HomeService _homeService = HomeService();
  String? _name;
  bool _isLoading = true;

  String? get name => _name;
  bool get isLoading => _isLoading;

  Future<void> fetchHomeModel(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      HomeModel homeModel = await _homeService.getHomeModel(userId);

      _name = homeModel.name;
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Hata durumunda mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-out failed: $e')),
      );
    }
  }
}
