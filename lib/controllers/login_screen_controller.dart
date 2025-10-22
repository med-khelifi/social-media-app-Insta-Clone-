import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';

class LoginScreenController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return Strings.pleaseEnterEmail;
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return Strings.pleaseEnterValidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return Strings.pleaseEnterPassword;
    if (value.length < 6) return Strings.passwordMustBeAbove6;
    return null;
  }

  void goToSignupScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.signup);
  }
}
