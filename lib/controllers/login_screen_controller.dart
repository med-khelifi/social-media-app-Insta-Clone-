import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';

class LoginScreenController {
  late GlobalKey<FormState> formKey;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  LoginScreenController() {
    init();
  }

  void init() {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }

  void goToSignupScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.signup);
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterUsername;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterPassword;
    }
    if (value.length < 6) {
      return Strings.passwordMustBeAbove6;
    }
    return null;
  }

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Perform login logic here
    }
  }
}
