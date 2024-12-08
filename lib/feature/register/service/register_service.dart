// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser(UserModel user, String password) async {
    try {
      print('Registering user...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      print('User registered with ID: ${userCredential.user!.uid}');
      final String userId = userCredential.user!.uid;

      user.id = userId;

      print('Writing user data to Firestore...');
      await _firestore.collection('users').doc(userId).set({
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
      });

      print('User data written to Firestore successfully.');
      return userId;
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Failed to register user: $e');
    }
  }
}
