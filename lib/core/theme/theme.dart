import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get lightTheme => ThemeData(
        fontFamily: 'Roboto', // Yazı tipi ailesi
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal), 
          bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal), 
          bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal), 
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), 
        ),
      );
}
