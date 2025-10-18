import 'package:flutter/material.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/screens/signup_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    RoutesNames.login: (context) => LoginScreen(),
    RoutesNames.signup: (context) => SignupScreen(),
  };
}



class RoutesNames {
  static const String login = '/login';
  static const String signup = '/signup';
}