import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color = ColorsManager.blue,
  });
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      color: color,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
