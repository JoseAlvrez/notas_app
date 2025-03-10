import 'package:flutter/material.dart';
import 'package:notas_app/widgets/custom_textButton.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget contect;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool showPrimaryButton;
  final bool showSecondaryButton;

  const CustomDialog({
    super.key,
    required this.title,
    required this.contect,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.showSecondaryButton = true,
    this.showPrimaryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: contect,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        if (showSecondaryButton && secondaryButtonText != null)
          CustomTextbutton(
            text: secondaryButtonText!,
            onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
            textColor: Colors.blue,
          ),
        if (showPrimaryButton && primaryButtonText != null)
          CustomTextbutton(
            text: primaryButtonText!,
            onPressed: onPrimaryPressed,
            textColor: Colors.blue,
          ),
      ],
    );
  }
}
