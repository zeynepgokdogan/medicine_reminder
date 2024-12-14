// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/login/view/login_page.dart';
import 'package:medicine_reminder/feature/profilepage/model/profile_model.dart';
import 'package:medicine_reminder/feature/profilepage/service/profile_service.dart';

class ProfileViewmodel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  String? _name;
  String? _surname;
  bool _isLoading = true;

  String? get name => _name;
  String? get surname => _surname;
  bool get isLoading => _isLoading;

  Future<void> fetchProfileModel(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      ProfileModel profileModel = await _profileService.getProfileModel(userId);

      _name = profileModel.name;
      _surname = profileModel.surname;
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
