import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color color;
  final TextInputType keyboardType;
  final String? Function(String?)?
      validator; // Dışarıdan alınan validator fonksiyonu

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.color = AppColors.primaryColor,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator, // Opsiyonel validator parametresi
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(60.0),
          border: Border.all(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.3),
            width: 3.0,
          ),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator, // Kullanıcının gönderdiği doğrulama fonksiyonu
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            prefixIcon: _getPrefixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }

  Icon? _getPrefixIcon() {
    if (hintText.contains('E-posta')) {
      return Icon(Icons.email_outlined, color: color);
    } else if (hintText.contains('Şifre')) {
      return Icon(Icons.lock_outline, color: color);
    } else if (hintText.contains('İsim') || hintText.contains('isim')) {
      return Icon(Icons.person_outline, color: color);
    }
    return null;
  }
}
