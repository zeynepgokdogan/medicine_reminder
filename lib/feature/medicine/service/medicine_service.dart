import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';

class MedicineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveMedicine(MedicineModel medicine) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Kullanıcı oturumu açık değil. Lütfen giriş yapın.');
      }

      String userId = currentUser.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .add(medicine.toMap());

      debugPrint('İlaç bilgisi başarıyla kaydedildi. Kullanıcı ID: $userId');
    } on FirebaseException catch (e) {
      debugPrint('Firestore hatası: ${e.message}');
      throw Exception(
          'İlaç bilgisi kaydedilirken bir hata oluştu. Lütfen tekrar deneyin.');
    } on Exception catch (e) {
      debugPrint('Bilinmeyen hata: $e');
      throw Exception('Bir hata oluştu: ${e.toString()}');
    }
  }
}
