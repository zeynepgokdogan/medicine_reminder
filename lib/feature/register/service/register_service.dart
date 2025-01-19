// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser(UserModel user, String password) async {
    try {
      print('Kullanıcı kaydoluyor...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      print('Kullanıcı ID ile kaydedildi: ${userCredential.user!.uid}');
      final String userId = userCredential.user!.uid;

      user.id = userId;

      print('Kullanıcı verileri Firestore a yazılıyor...');
      await _firestore.collection('users').doc(userId).set({
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
      });

      print('Kullanıcı verileri Firestore a başarıyla yazıldı.');
      return userId;
    } catch (e) {
      print('Kayıt sırasında hata oluştu: $e');
      throw Exception('kullanıcı kaydedilemedi: $e');
    }
  }
}
