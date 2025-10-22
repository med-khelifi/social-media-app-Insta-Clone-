import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';

class SignupScreenController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return Strings.pleaseEnterUsername;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return Strings.pleaseEnterPassword;
    if (value.length < 6) return Strings.passwordMustBeAbove6;
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return Strings.pleaseEnterEmail;
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return Strings.pleaseEnterValidEmail;
    }
    return null;
  }

  void goToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.login);
  }
}
