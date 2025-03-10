// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final bool underlined;
  final TextStyle? textStyle;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomTextbutton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.underlined = false,
    this.textStyle,
    this.padding,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final bool enable = onPressed != null;
    final style =
        textStyle ??
        TextStyle(
          color:
              enable
                  ? (textColor ?? Theme.of(context).primaryColor)
                  : Colors.grey,
          fontSize: fontSize,
          decoration:
              underlined ? TextDecoration.underline : TextDecoration.none,
        );

    return TextButton(
      style: TextButton.styleFrom(padding: padding ?? const EdgeInsets.all(8)),
      onPressed: onPressed,
      child: Text(text, style: style),
    );
  }
}
