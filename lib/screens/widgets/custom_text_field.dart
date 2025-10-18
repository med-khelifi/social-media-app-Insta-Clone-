import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.label, this.hint});
  final String label;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
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
