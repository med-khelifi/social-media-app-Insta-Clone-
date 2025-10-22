import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/user.dart';

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

  // Validation
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

  // Navigate to Login Screen
  void goToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesNames.login);
  }

  // Signup Function
  Future<void> signup(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      UserModel userData = UserModel(
        uid: uid,
        username: username,
        email: email,
        bio: '',
        profileImageUrl: '',
        followers: [],
        following: [],
      );
      await FirebaseFirestore.instance
          .collection(FirebaseSettings.usersCollection)
          .doc(uid)
          .set(userData.toMap());

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(Strings.signupSuccessful)));
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
