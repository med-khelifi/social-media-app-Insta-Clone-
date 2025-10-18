import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onPressed, required this.text});
  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      color: ColorsManager.blue,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
