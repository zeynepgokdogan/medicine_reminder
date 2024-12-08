import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../service/register_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterService _authService = RegisterService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = UserModel(
        id: '',
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      _userId = await _authService.registerUser(user, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}