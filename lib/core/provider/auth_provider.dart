import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/controllers/login_screen_controller.dart';
import 'package:insta/controllers/signup_screen_controller.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/user.dart';

class AuthProviderState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  late final SignupScreenController signupController;
  late final LoginScreenController loginController;
  
  AuthProviderState() {
    loginController = LoginScreenController();
    signupController = SignupScreenController();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 🔹 LOGIN
  Future<void> login(BuildContext context) async {
    if (!loginController.formKey.currentState!.validate()) {
      return;
    }
    _setLoading(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginController.emailController.text.trim(),
        password: loginController.passwordController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesNames.home);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? Strings.loginFailed)),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 SIGNUP
  Future<void> signup(BuildContext context) async {
    if (!signupController.formKey.currentState!.validate()) {
      return;
    }

    _setLoading(true);
    try {
      final email = signupController.emailController.text.trim();
      final password = signupController.passwordController.text.trim();
      final username = signupController.usernameController.text.trim();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('Failed to create user: user is null');
      }

      final uid = userCredential.user!.uid;

      final userData = UserModel(
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? Strings.signupFailed)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      _setLoading(false);
    }
  }
}
