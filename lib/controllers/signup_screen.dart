import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';

class SignupScreenController {
  SignupScreenController();
  void dispose() {}
  void init() {}
  void goToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.login);
  }
}
