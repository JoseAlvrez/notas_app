// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? text; // Texto actual a mostrar
  final String label;
  final bool obscureText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final int? maxLines;
  final int? maxLength;
  final Color? hintColor;
  final Color? fillColor;
  final Color iconColor;

  const CustomTextField({
    Key? key,
    this.text,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.onChanged,
    this.errorText,
    this.maxLines,
    this.maxLength,
    this.hintColor,
    this.fillColor,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  String? _oldText;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controller con el texto que venga
    _controller = TextEditingController(text: widget.text ?? '');
    _oldText = widget.text;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el texto externo cambió, actualizamos el _controller
    if (_oldText != widget.text) {
      _controller.text = widget.text ?? '';
      _oldText = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = widget.obscureText ? 1 : (widget.maxLines ?? 1);
    return TextFormField(
      controller: _controller,
      obscureText: widget.obscureText,
      maxLines: effectiveMaxLines,
      maxLength: widget.maxLength,
      onChanged: (value) {
        // Avisamos al bloc que el texto cambió
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.label,
        hintStyle: TextStyle(color: widget.hintColor ?? Colors.grey),
        errorText: widget.errorText,
        prefixIcon:
            widget.icon != null
                ? Icon(widget.icon, color: widget.iconColor)
                : null,
        filled: true,
        fillColor: widget.fillColor ?? Colors.grey[200],
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
