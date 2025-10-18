import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';

class LoginScreenController {
  LoginScreenController();
  void dispose() {}
  void init() {}
  void goToSignupScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.signup);
  }
}
