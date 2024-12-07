import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color color;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.color = Colors.blue,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter $hintText';
    }

    if (hintText == 'Enter email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }

    if (hintText.contains('password') && value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50, // Daha açık ton
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 3.0, // Border kalınlığı ayarlandı
          ),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: _validator,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            prefixIcon: _getPrefixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }

  Icon? _getPrefixIcon() {
    if (hintText.contains('email')) {
      return Icon(Icons.email_outlined, color: color);
    } else if (hintText.contains('password')) {
      return Icon(Icons.lock_outline, color: color);
    } else if (hintText.contains('name')) {
      return Icon(Icons.person_outline, color: color);
    }
    return null;
  }
}