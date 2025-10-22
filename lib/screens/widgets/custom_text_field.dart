import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.onSuffixIconPressed,
    this.validator,
    this.controller,
    this.showPassword = false,
  });
  final String label;
  final String? hint;
  final VoidCallback? onSuffixIconPressed;
  final bool isPassword;
  final bool showPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: !showPassword && isPassword,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                onPressed: isPassword ? onSuffixIconPressed : null,
                icon: showPassword
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
              )
            : null,
        label: Text(label),
        hintText: hint ?? "",
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 45, 46, 47),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 45, 46, 47),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 45, 46, 47),
            width: 2,
          ),
        ),
      ),
    );
  }
}
