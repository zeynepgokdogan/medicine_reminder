import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/homepage/model/home_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeModel> getHomeModel(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      //debugPrint('Fetched Firestore Data: ${userDoc.data()}');

      if (userDoc.exists && userDoc.data() != null) {
        return HomeModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        debugPrint('User profile not found for userId: $userId');
        throw Exception('User profile not found');
      }
    } catch (e) {
      debugPrint('Error in getUserProfile: $e');
      rethrow;
    }
  }
}