import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.onSuffixIconPressed, this.validator,
  });
  final String label;
  final String? hint;
  final VoidCallback? onSuffixIconPressed;
  final bool? isPassword;
  final String? Function(String?)? validator ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        suffixIcon: isPassword ?? false
            ? IconButton(
                onPressed: isPassword ?? false ? onSuffixIconPressed : null,
                icon: Icon(Icons.visibility_off),
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
