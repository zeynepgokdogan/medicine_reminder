import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomFloatingButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: const Icon(Icons.add),
    );
  }
}