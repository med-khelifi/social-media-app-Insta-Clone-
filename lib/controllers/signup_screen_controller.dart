import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';

class SignupScreenController {
  late GlobalKey<FormState> formKey;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emailController;

  SignupScreenController() {
    init();
  }
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  void init() {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  void goToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.login);
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterEmail;
    }
    final v = value.trim();
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(v)) {
      return Strings.pleaseEnterValidEmail;
    }
    return null;
  }

  void signup(BuildContext context) {
    if (formKey.currentState!.validate()) {
      var email = emailController.text.trim();
      var password = passwordController.text.trim();
      print(  " ------------------------------------------------------------- email : "  + email  );
      print(  " ------------------------------------------------------------- password : "  + password  );
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(Strings.signupSuccessful)));
          })
          .onError((error, stackTrace) {
            print( " ------------------------------------------------------------- error : "  + error.toString()  );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.toString())));
          });
    }
  }
}
