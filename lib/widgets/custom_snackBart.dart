// ignore_for_file: file_names
import 'package:flutter/material.dart';

SnackBar customSnackBar({
  required String message,
  Color backgroundColor = Colors.red,
  IconData? icon,
}) {
  return SnackBar(
    backgroundColor: backgroundColor,
    content: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(message)),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
}
