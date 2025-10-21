import 'package:firebase_auth/firebase_auth.dart';
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
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: usernameController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((UserCredential userCredential) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, RoutesNames.home);
          })
          .onError((error, stackTrace) {
            ScaffoldMessenger.of(
              // ignore: use_build_context_synchronously
              context,
            ).showSnackBar(SnackBar(content: Text(error.toString())));
          });
    }
  }
}
