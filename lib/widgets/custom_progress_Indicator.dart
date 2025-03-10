// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const CustomProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}
