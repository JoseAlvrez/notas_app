import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Color iconColor;
  final int? maxLines;
  final Color? hintColor;
  final Color? fillColor;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.onChanged,
    this.errorText,
    this.iconColor = Colors.blue,
    this.maxLines,
    this.hintColor,
    this.fillColor,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = obscureText ? 1 : (maxLines ?? 1);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLines: effectiveMaxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        hintText: label,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey),
        labelText: null,
        errorText: errorText,
        prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
        filled: true,
        fillColor: fillColor ?? Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
    );
  }
}
