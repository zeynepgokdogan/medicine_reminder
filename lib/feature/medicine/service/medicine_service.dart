import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

      debugPrint(
          'İlaç bilgisi başarıyla kaydedildi. Kullanıcı ID: $userId');
    } on FirebaseException catch (e) {
      debugPrint('Firestore hatası: ${e.message}');
      throw Exception(
          'İlaç bilgisi kaydedilirken bir hata oluştu. Lütfen tekrar deneyin.');
    } on Exception catch (e) {
      debugPrint('Bilinmeyen hata: $e');
      throw Exception('Bir hata oluştu: ${e.toString()}');
    }
  }

  Future<List<MedicineModel>> getAllMedicines(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) =>
                MedicineModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('İlaç verisi bulunamadı.');
      }
    } on FirebaseException catch (e) {
      debugPrint('Firestore hatası: ${e.message}');
      throw Exception(
          'İlaç verisi alınırken bir hata oluştu. Lütfen tekrar deneyin.');
    } on Exception catch (e) {
      debugPrint('Bilinmeyen hata: $e');
      throw Exception('Bir hata oluştu: ${e.toString()}');
    }
  }

  Future<void> fetchUserMedicines(String userId) async {
    try {
      final userMedicines = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .get();

      for (var doc in userMedicines.docs) {
        debugPrint(
            "İlaç: ${doc['medicationName']}, Alım Zamanı: ${doc['reminderTimes']}");
      }
    } on FirebaseException catch (e) {
      debugPrint('Firestore hatası: ${e.message}');
      throw Exception(
          'İlaç verileri alınırken bir hata oluştu. Lütfen tekrar deneyin.');
    } on Exception catch (e) {
      debugPrint('Bilinmeyen hata: $e');
      throw Exception('Bir hata oluştu: ${e.toString()}');
    }
  }
}
