import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final BorderRadiusGeometry? borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.height,
    this.width,
    this.padding,
    this.elevation = 4,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white,
      elevation: elevation,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}
