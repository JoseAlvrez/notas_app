import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: isEnabled ? Colors.blue : Colors.grey,
          foregroundColor: Colors.white,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
